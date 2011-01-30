program Huffman;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  PNode = ^Node;
  Node = record
    c : char;
    w : integer;
    l,r : PNode;
  end;

function Find( c:char ):PNode;
begin

end;

type
  Node = record
    c : string;
    w : integer;
    left, right : integer;
  end;

var
  s : string;
  i, j, Size : integer;
  c : char;
  a : array [#0..#255] of integer;
  n : array [1..1000] of Node;
  Swap : Node;
  x, y, xx, yy : integer;
begin
  // readln(s);
  s := 'This is test text for example!';


  fillchar(a,sizeof(a),0);
  for i := 1 to Length(s) do
    inc(a[s[i]]);
  Size := 0;
  for c := #0 to #255 do
    if a[c]<>0 then begin
      inc( Size );
      n[Size].c := c;
      n[Size].w := a[c];
      n[Size].left := 0;
      n[Size].right := 0;
    end;
  for i := 1 to Size do
    for j := i+1 to Size do
      if n[i].w < n[j].w then begin
        Swap := n[i];
        n[i] := n[j];
        n[j] := Swap;
      end;
  for i := 1 to Size do
    writeln(n[i].c,' ',n[i].w);
  for i := Size-1 downto 1 do begin
  end;
  Readln;
end.
