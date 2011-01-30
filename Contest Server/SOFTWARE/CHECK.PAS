{ …Õ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ—Õª }
{ ∫ ≥                  Roman International Explorer                  ≥ ∫ }
{ ∫ ≥                             CHECK                              ≥ ∫ }
{ ∫ ≥                 Generated at 14:06:50 29.03.99                 ≥ ∫ }
{ »ÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕœÕº }
Uses CRT;

{$I-}

{ = = = ë°Æ© ¢ è‡Æ£‡†¨¨• = = = }
 Procedure Runtime_Error( Message:String );
   Begin
     TextColor(15);
     Writeln;
     Writeln('Runtime Error : ',Message);
     Writeln;
     Halt(1);
   End;

{ = = = è•‡•¢Æ§ Á®·´† ¢ ·‚‡Æ™„ = = = }
 Function AsString( N:LongInt ):String;
   Var Temp:String;
   Begin
     Str(N,Temp);
     AsString:=Temp;
   End;

{ = = = ë´Æ¢Æ ¢ ë´Æ¢†‡• = = = }
 Type Dictionary_Word = Record
        Word:String;
      End;

{ = = = å†™·®„¨ ë´Æ¢ ¢ ë´Æ¢†‡• = = = }
 Const Max_Words = 65535 div SizeOf(Dictionary_Word);

{ = = = å†··®¢ ë´Æ¢†‡Ô = = = }
 Type
   TDictionary = Array [1..Max_Words] of Dictionary_Word;
   PDictionary = ^TDictionary;

{ = = = í®ØÎ ë´Æ¢†‡•© = = = }
 Const
   dtNoCaseSensitive = 0;
   dtCaseSensitive   = 1;
   dtMinType         = 0;
   dtMaxType         = dtCaseSensitive;
   Dictionary_Types : Array [dtMinType..dtMaxType] of String =
     ('No Case Sensitive','Case Sensitive');

{ = = = ë´Æ¢†‡Ï = = = }
 Type
   Dictionary = Object
     Words:Word;
     List:PDictionary;
     Dictionary_Type:Byte;
     Constructor Init( _Dictionary_Type:Byte );
     Destructor Done;
     Procedure Add_Word( _Word:String );
     Procedure Check_String( Str:String );
   End;

   Constructor Dictionary.Init( _Dictionary_Type:Byte );
     Begin
       Words:=0;
       Dictionary_Type:=_Dictionary_Type;
       New(List);
     End;

   Destructor Dictionary.Done;
     Begin
       Dispose(List);
     End;

   Procedure Dictionary.Add_Word( _Word:String );
     Var I,J:Word;
     Begin
       Inc(Words);
       If Words > Max_Words then Runtime_Error('Too many words !');
       List^[Words].Word:=_Word;
     End;

   Procedure Dictionary.Check_String( Str:String );
     Var S,D:String; W:Word; I,J:Byte; Flag,Case_Sensitive:Boolean;
     Begin
       Case Dictionary_Type of
         dtCaseSensitive: Case_Sensitive:=True;
       Else
         Case_Sensitive:=False;
       End;
      { àÈ•¨ Ç·• ë´Æ¢† }
       D:=Str;
       For W:=1 to Words do
         With List^[W] do
           Begin
             S:=D; D:='';
            { àÈ•¨ é§≠Æ ë´Æ¢Æ ¢ ë‚‡Æ™• }
             For I:=1 to Length(S) do
               Begin
                 Flag:=True;
                 If Case_Sensitive then
                   Begin { ê•£®·‚‡ Å„™¢ ê†ß´®Á†•‚·Ô }
                     For J:=1 to Length(Word) do
                       If ((S[I+J-1]<>Word[J]) Or
                          ((I+J-1)>Length(S))) then
                         Begin Flag:=False; Break; End;
                   End
                 Else
                   Begin { ê•£®·‚‡ Å„™¢ ç• ê†ß´®Á†•‚·Ô }
                     For J:=1 to Length(Word) do
                       If ((UpCase(S[I+J-1])<>UpCase(Word[J])) Or
                          ((I+J-1)>Length(S))) then
                         Begin Flag:=False; Break; End;
                   End;
                 If Flag then Runtime_Error('Illegal Instructions !');
               End;
           End;
     End;

{ = = = è•‡•¢Æ§ ë‚‡Æ™® = = = }
 Const NewStr = #13#10;

{ = = = ÇÎ¢Æ§ ë‚‡Æ™® = = = }
 Procedure Out( Color:Byte; S:String );
   Begin
     TextColor(Color);
     Write(S);
   End;

{ = = = ÇÎ¢Æ§ ë‚‡Æ™® ë´„Á†©≠Î¨® ñ¢•‚†¨® = = = }
 Procedure Random_Out( S:String );
   Var I:Byte;
   Begin
     For I:=1 to Length(S) do Out(Random(7)+9,S[I]);
   End;

{ = = = á†·‚†¢™† = = = }
 Procedure Poster;
   Begin
     Out(7,NewStr+NewStr);
     Random_Out(' >>> Check by Roman International <<<');
     Out(7,NewStr+NewStr);
   End;

{ = = = é·≠Æ¢≠†Ô è‡Æ£‡†¨¨† = = = }
Var S1,S2:String; D,I:Text; C:LongInt; Dict:Dictionary; Temp:Byte;
Begin
  Randomize;
  Poster;
  If ParamCount = 2 then
    Begin
     { á†£‡„ß™† ë´Æ¢†‡Ô }
      Out(10,' Open Dictionary : '); Out(11,ParamStr(2)+NewStr);
      Assign(D,ParamStr(2));
      Reset(D);
      If IOResult<>0 then Runtime_Error('Cann''t open Dictionary !');
      Readln(D,Temp);
      If ((IOResult<>0) Or (Temp<dtMinType) Or (Temp>dtMaxType)) then
        Runtime_Error('Error Dictionary Type !');
      Dict.Init(Temp);
      Out(13,NewStr+'  Dictionary Style = '+Dictionary_Types[Temp]+NewStr+NewStr);
      Repeat
        Readln(D,S1);
        Dict.Add_Word(S1);
        Out(9,'  '+AsString(Dict.Words)); Out(12,' Words'+#13);
      Until EOF(D);
      Close(D);
      Out(7,NewStr+NewStr);
     { è•‡•¢Æ§ í•™·‚† }
      Out(10,' Input Text : '); Out(11,ParamStr(1)+NewStr);
      Assign(I,ParamStr(1)); Reset(I);
      If IOResult<>0 then Runtime_Error('Cann''t open Input Text !');
      C:=0;
      Repeat
        Inc(C);
        Out(9,'  '+AsString(C)); Out(12,' Strings'+#13);
        Readln(I,S1);
        Dict.Check_String(S1);
      Until EOF(I);
      Close(I);
      Out(15,NewStr+NewStr+'   All done !');
      Dict.Done;
    End
  Else
    Begin
      Out(15,'    CHECK ');
      Out(14,'<');
      Out(13,'Input');
      Out(14,'> <');
      Out(13,'Dictionary');
      Out(14,'>');
    End;
  Out(7,NewStr+NewStr);
End.