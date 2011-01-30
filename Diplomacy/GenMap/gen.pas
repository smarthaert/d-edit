Type
  TPoint = Record
    X,Y : Word;
  End;

Var
  Map : Array [1..20,1..20] of byte;
  N : LongInt;
  G : Array [1..5000] of Record
    X,Y : Word;
  End;

Function Pusto( X,Y:Word ):Boolean;
Begin
  If ((X<1) Or (X>20) Or (Y<1) Or (Y>20)) then Begin
    Pusto:=false;
    exit;
  End;
  Pusto:=(Map[X,Y]=0);
End;

Var I,J,Q:Integer;
Begin
  Randomize;
  {}
  G[1].X := 1;
  G[1].Y := 1;
  N:=1;
  {}
  For I:=1 to 20 do begin
    For J:=1 to N do begin
      Map[G[J].X,G[J].Y]:=1;
      G[J].Used := false;
    end;
    {}
    Q := Random(N)+1;
    If Pusto(G[Q].X+1,G[Q].Y) then begin inc(N); G[N].X:=G[Q].X+1; G[N].Y:=G[Q].Y; end;
    If Pusto(G[Q].X,G[Q].Y+1) then begin inc(N); G[N].X:=G[Q].X;   G[N].Y:=G[Q].Y+1; end;
    If Pusto(G[Q].X-1,G[Q].Y) then begin inc(N); G[N].X:=G[Q].X-1; G[N].Y:=G[Q].Y; end;
    If Pusto(G[Q].X,G[Q].Y-1) then begin inc(N); G[N].X:=G[Q].X;   G[N].Y:=G[Q].Y-1; end;
    G[Q]:=G[N];
    dec(N);
  end;
  {}
  For I:=1 to 20 do begin
    For J:=1 to 20 do begin
      if Map[I,J]=1 then
        write('#')
      else
        write('_');
    end;
    writeln;
  end;
End.