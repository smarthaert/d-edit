{$IFDEF Windows}
  !! ERROR - This unit is not compatible with Windows !!
{$ENDIF}

{$S-,R-,V-,I-,B-,F+}

{$IFNDEF Ver40}
  {$R-,O+,A-}
{$ENDIF}

{$I TPDEFINE.INC}

{$IFDEF Heap6}           {!!.12}
  {$UNDEF FastDispose}   {!!.12}
{$ENDIF}                 {!!.12}

{*********************************************************}
{*                    TPSORT.PAS 5.21                    *}
{*     Copyright (c) TurboPower Software 1987, 1992.     *}
{* Portions Copyright (c) Sunny Hill Software 1985, 1986 *}
{*     and used under license to TurboPower Software     *}
{*                 All rights reserved.                  *}
{*********************************************************}

unit TpSort;
  {-Perform an in-memory sort of up to 65535 elements of any type}

interface

const
  MaxElements = 65535;       {Absolute maximum number of elements to be sorted}
type
  SortStatus =
  (SortSuccess,              {Successful sort}
    SortOutOfMemory,         {Insufficient memory}
    SortTooManyElements      {Attempt to sort more elements than requested}
    );

var
  ElementsSorted : Word;     {Actual number of elements sorted}

function PutElement(var X) : Boolean;
  {-Put a sort element into the sort array}

function GetElement(var X) : Boolean;
  {-Get next element from the sorted array}

function Sort(Elements : Word; {Maximum number of elements to sort}
              ElementSize : Word; {Size of each element, 0 for strings}
              GetElements : Pointer; {Pointer to function to load elements}
              LessFunc : Pointer; {Pointer to function to compare two elements}
              PutElements : Pointer {Pointer to function to return sorted elements}
              ) : SortStatus; {Status of sort}
  {-Sort a group of elements}

  {==========================================================================}

implementation

const
  MaxElementNum = 65534;     {MaxElements-1}

type
  SortPage = array[0..4095] of Pointer;
  SortPointers = array[0..15] of ^SortPage;
  MarkRec =
    record
      Marker : Pointer;
      FreeBuf : Pointer;
      OldFreePtr : Pointer;  {!!.11}
      BufSize : Word;
    end;

var
  StPt : ^SortPointers;      {Pointer to sort array}
  Pages : Integer;           {Number of sort pages allocated}
  Status : SortStatus;       {Status of sort operation}
  Size : Word;               {Size of each sort element, 0 if strings}
  MaxIndex : Word;           {Maximum index of element to be sorted in this run}
  Index : Word;              {Actual index of last element to be sorted}
  OnHeap : Boolean;          {True if elements allocated on heap}
  PivotSize : Word;          {Size of swapping area}
  Pivot : Pointer;           {Points to temporary element for the pivot element}
  UserLess : Pointer;        {Points to user-defined less function}
  HeapMark : MarkRec;        {Used to restore heap when done}

  function SortPointer(Elnum : Word) : Pointer;
    {-Return the sort pointer for element elnum}
  inline(
    $58/                     {pop ax              ;get element number}
    $89/$C3/                 {mov bx,ax           ;save in bx}
    $B1/$0A/                 {mov cl,10}
    $D3/$E8/                 {shr ax,cl}
    $25/$FC/$FF/             {and ax,$FFFC        ;ax has 4*page number}
    $C4/$3E/>StPt/           {les di,[>stpt]      ;es:di points to array of page pointers}
    $01/$C7/                 {add di,ax           ;di points to sort page}
    $26/                     {es:}
    $C4/$3D/                 {les di,[di]         ;es:di points to base of page}
    $81/$E3/$FF/$0F/         {and bx,$0FFF        ;bx has index within sort page}
    $D1/$E3/                 {shl bx,1}
    $D1/$E3/                 {shl bx,1            ;bx has byte offset within sort page}
    $01/$DF/                 {add di,bx           ;add to base offset of page}
    $26/                     {es:}
    $8B/$05/                 {mov ax,[di]         ;ax has low word of pointer}
    $26/                     {es:}
    $8B/$55/$02);            {mov dx,[di+2]       ;dx has high word of pointer}

  procedure SetPointer(p : Pointer; Elnum : Word);
    {-Set the pointer for Elnum to p}
  inline(
    $58/                     {pop ax              ;get element number}
    $89/$C3/                 {mov bx,ax           ;save in bx}
    $B1/$0A/                 {mov cl,10}
    $D3/$E8/                 {shr ax,cl}
    $25/$FC/$FF/             {and ax,$FFFC        ;ax has 4*page number}
    $C4/$3E/>StPt/           {les di,[>stpt]      ;es:di points to array of page pointers}
    $01/$C7/                 {add di,ax           ;di points to sort page}
    $26/                     {es:}
    $C4/$3D/                 {les di,[di]         ;es:di points to base of page}
    $81/$E3/$FF/$0F/         {and bx,$0FFF        ;bx has index within sort page}
    $D1/$E3/                 {shl bx,1}
    $D1/$E3/                 {shl bx,1            ;bx has byte offset within sort page}
    $01/$DF/                 {add di,bx           ;add to base offset of page}
    $58/                     {pop ax              ;get the pointer from stack}
    $5A/                     {pop dx}
    $26/                     {es:}
    $89/$05/                 {mov [di],ax         ;ax has low word of pointer}
    $26/                     {es:}
    $89/$55/$02);            {mov [di+2],dx       ;dx has high word of pointer}

  procedure MarkFL(var HeapMark : MarkRec);
    {-Mark the current top of heap and buffer the free list}
  begin
    with HeapMark do begin
      {$IFNDEF Heap6}                                            {!!.11}
      if Ofs(FreePtr^) = 0 then
        {Free list is empty}
        FreeBuf := nil
      else begin
        {Buffer the free list}
        BufSize := LongInt(65536)-Ofs(FreePtr^);
        {Allow for possibility of free list growth}              {!!.11}
        if BufSize < $FFF8 then                                  {!!.11}
          inc(BufSize, 8);                                       {!!.11}
        GetMem(FreeBuf, BufSize);
        if FreeBuf <> nil then begin                             {!!.11}
          OldFreePtr := FreePtr;                                 {!!.11}
          Move(FreePtr^, FreeBuf^, LongInt(65536)-Ofs(FreePtr^));{!!.11}
        end;                                                     {!!.11}
      end;
      {$ENDIF}                                                   {!!.11}
      {Mark the top of the heap}
      Mark(Marker);
    end;
  end;

  procedure ReleaseFL(HeapMark : MarkRec);
    {-Release the heap at heap mark and restore the free list}
  begin
    with HeapMark do begin
      {Release from the marker}
      Release(Marker);
      {$IFNDEF Heap6}
      if FreeBuf <> nil then begin
        {Reset FreePtr}
        FreePtr := OldFreePtr;                                 {!!.11}
        {Restore free list}
        Move(FreeBuf^, FreePtr^, LongInt(65536)-Ofs(FreePtr^));{!!.11}
        {Dispose of the free list buffer}
        FreeMem(FreeBuf, BufSize);
      end;
      {$ENDIF}
    end;
  end;

  function HeapFunc(Size : Word) : Integer;
    {-Return nil pointer if insufficient memory}
  begin
    {$IFDEF Heap6}       {!!.11}
    if Size = 0 then     {!!.11}
      HeapFunc := 2      {!!.11}
    else                 {!!.11}
    {$ENDIF}             {!!.11}
      HeapFunc := 1;
  end;

  function PutElement(var X) : Boolean;
    {-Put a sort element into the sort array}
  var
    Len : Word;
    p : Pointer;
  begin
    if Index <= MaxIndex then begin
      {Space available in the sort array}

      if OnHeap then begin
        {Get heap space for the element}
        if Size = 0 then
          Len := Succ(Byte(X))
        else
          Len := Size;
        GetMem(p, Len);

        if p = nil then begin
          {Insufficient memory}
          PutElement := False;
          Status := SortOutOfMemory;
          Exit;
        end else begin
          Move(X, p^, Len);
          SetPointer(p, Index);
        end;

      end else
        {Store the element in the sort array}
        SetPointer(Pointer(X), Index);

      Inc(Index);
      PutElement := True;

    end else begin
      {No more space for elements}
      PutElement := False;
      Status := SortTooManyElements;
    end;

  end;

  function GetElement(var X) : Boolean;
    {-Get next element from the sorted array}
  var
    p : Pointer;
    Len : Word;
  begin
    if Index < MaxIndex then begin

      p := SortPointer(Index);

      if OnHeap then begin
        {Get element from heap}
        if Size = 0 then
          Len := Succ(Byte(p^))
        else
          Len := Size;
        Move(p^, X, Len);
      end else
        {Return element from sort array directly}
        Move(p, X, Size);

      GetElement := True;
      Inc(Index);

    end else
      GetElement := False;
  end;

  function ULess(var X, Y) : Boolean;
    {-Call the user routine to perform element comparison}
  inline($FF/$1E/>UserLess); {CALL DWORD PTR [>UserLess]}

  function LessThanPivot(I : Word) : Boolean;
    {-Return true if Key[I]<Pivot}
  var
    p : Pointer;
  begin
    p := SortPointer(I);
    if OnHeap then
      LessThanPivot := ULess(p^, Pivot^)
    else
      LessThanPivot := ULess(p, Pivot^);
  end;

  function PivotLessThan(I : Word) : Boolean;
    {-Return true if Pivot<Key[I]}
  var
    p : Pointer;
  begin
    p := SortPointer(I);
    if OnHeap then
      PivotLessThan := ULess(Pivot^, p^)
    else
      PivotLessThan := ULess(Pivot^, p);
  end;

  procedure GetPivot(L, R : Word);
    {-Load the pivot element}
  var
    p : Pointer;
    Len : Word;
  begin
    {Use a random pivot index to help with pre-sorted arrays}
    p := SortPointer(L+Random(R-L));

    if OnHeap then begin
      if Size = 0 then
        Len := Succ(Byte(p^))
      else
        Len := Size;
      Move(p^, Pivot^, Len);
    end else
      Move(p, Pivot^, Size);
  end;

  procedure QuickSort(L, R : Word);
    {-Non-recursive QuickSort per N. Wirth's "Algorithms and Data Structures"}
  const
    StackSize = 20;
  type
    Stack = array[1..StackSize] of Word;
  var
    Lstack : Stack;          {Pending partitions, left edge}
    Rstack : Stack;          {Pending partitions, right edge}
    StackP : Integer;        {Stack pointer}
    Pl : Word;               {Left edge within partition}
    Pr : Word;               {Right edge within partition}
    Tmp : Pointer;           {Temporary pointer used during swapping}
  begin
    {Initialize the stack}
    StackP := 1;
    Lstack[1] := L;
    Rstack[1] := R;

    {Repeatedly take top partition from stack}
    repeat

      {Pop the stack}
      L := Lstack[StackP];
      R := Rstack[StackP];
      Dec(StackP);

      {Sort current partition}
      repeat

        {Load the pivot element}
        GetPivot(L, R);
        Pl := L;
        Pr := R;

        {Swap items in sort order around the pivot index}
        repeat
          while LessThanPivot(Pl) do
            Inc(Pl);
          while PivotLessThan(Pr) do
            Dec(Pr);
          if Pl <= Pr then begin
            if Pl <> Pr then begin
              {Swap the two elements}
              Tmp := SortPointer(Pl);
              SetPointer(SortPointer(Pr), Pl);
              SetPointer(Tmp, Pr);
            end;
            if Pl < 65535 then
              Inc(Pl);
            if Pr > 0 then
              Dec(Pr);
          end;
        until Pl > Pr;

        {Decide which partition to sort next}
        if (Pr-L) < (R-Pl) then begin
          {Left partition is bigger}
          if Pl < R then begin
            {Stack the request for sorting right partition}
            Inc(StackP);
            Lstack[StackP] := Pl;
            Rstack[StackP] := R;
          end;
          {Continue sorting left partition}
          R := Pr;
        end else begin
          {Right partition is bigger}
          if L < Pr then begin
            {Stack the request for sorting left partition}
            Inc(StackP);
            Lstack[StackP] := L;
            Rstack[StackP] := Pr;
          end;
          {Continue sorting right partition}
          L := Pl;
        end;

      until L >= R;

    until StackP <= 0;
  end;

  function Sort(Elements : Word;
                ElementSize : Word;
                GetElements : Pointer;
                LessFunc : Pointer;
                PutElements : Pointer
                ) : SortStatus;
    {-Sort a group of elements}
  label
    ExitPoint;
  var
    p : Pointer;
    Pg : Integer;
    I : Word;
    SaveHeapError : Pointer;

    procedure CallGetElements;
      {-Call the user routine to get all the elements}
    inline($FF/$5E/<GetElements); {CALL DWORD PTR [BP+<GetElements]}

    procedure CallPutElements;
      {-Call the user routine to return the sorted elements}
    inline($FF/$5E/<PutElements); {CALL DWORD PTR [BP+<PutElements]}

  begin
    {Presume success of sorts}
    Status := SortSuccess;
    ElementsSorted := 0;

    {Take over heap error control}
    SaveHeapError := HeapError;
    HeapError := @HeapFunc;

    {Store hidden globals}
    Size := ElementSize;
    OnHeap := (Size = 0) or (Size > 4);
    UserLess := LessFunc;

    {Check the number of elements}
    if (Elements = 0) or (Elements > MaxElements) then
      Elements := MaxElements;
    MaxIndex := Pred(Elements);
    Index := 0;

    {$IFDEF FastDispose}
      {Mark the heap position for later release}
      MarkFL(HeapMark);
    {$ENDIF}

    {Get space for the pivot element}
    if Size = 0 then
      PivotSize := 256
    else
      PivotSize := Size;
    GetMem(Pivot, PivotSize);
    if Pivot = nil then begin
      Status := SortOutOfMemory;
      goto ExitPoint;
    end;

    {How many sort pages are needed?}
    Pages := Elements div 4096;
    if Elements mod 4096 <> 0 then
      Inc(Pages);

    {Get the sort pointer array and initialize it}
    GetMem(StPt, Pages*SizeOf(Pointer));
    if StPt = nil then begin
      Status := SortOutOfMemory;
      goto ExitPoint;
    end;
    {Get the pages and initialize them}
    for Pg := 0 to Pred(Pages) do begin
      GetMem(StPt^[Pg], 4096*SizeOf(Pointer));
      if StPt^[Pg] = nil then begin
        Status := SortOutOfMemory;
        goto ExitPoint;
      end;
      FillChar(StPt^[Pg]^, 4096*SizeOf(Pointer), 0);
    end;

    {Load the sort pointer array via user-supplied routine}
    CallGetElements;

    if Status = SortSuccess then begin
      ElementsSorted := Index;

      if Index > 0 then
        {Sort the array}
        QuickSort(0, Pred(Index));

      {Pass back the sorted array via user-supplied routine}
      if Status = SortSuccess then begin
        MaxIndex := Index;
        Index := 0;
        CallPutElements;
      end;
    end;

    {$IFDEF FastDispose}
     {Free up heap space we used}
      ReleaseFL(HeapMark);
    {$ELSE}
      for Pg := Pred(Pages) downto 0 do begin
        if OnHeap then
          {Free space allocated for elements}
          for I := 4095 downto 0 do begin
            P := StPt^[Pg]^[I];
            if P <> nil then
              if Size = 0 then
                FreeMem(P, succ(byte(P^)))
              else
                FreeMem(P, Size);
          end;
        {Free the page}
        FreeMem(StPt^[Pg], 4096*SizeOf(Pointer));
      end;
      {Free the sort page array}
      FreeMem(StPt, Pages*SizeOf(Pointer));
      {Free the pivot element}
      FreeMem(Pivot, PivotSize);
    {$ENDIF}

ExitPoint:
    {Restore heap error control}
    HeapError := SaveHeapError;

    {Return status}
    Sort := Status;

  end;

end.
