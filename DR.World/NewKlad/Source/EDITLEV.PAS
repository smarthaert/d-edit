Uses CRT,Video;

Var pole:array[1..30,1..18] of byte;
    key,key2:char;
    XCursor,YCursor,ColGold,ColAnt:byte;
    levelfile:string;
procedure savepole(FileName:string);
var F:File;
Begin
     Assign(F,FileName);
     Rewrite(F,1);
     BlockWrite(F,pole,Sizeof(pole));
     Close(F);
End;
procedure loadpole(FileName:string);
var F:File;
    i,j:byte;
Begin
     Assign(F,FileName);
     Reset(F,1);
     BlockRead(F,pole,Sizeof(pole));
     Close(F);
     ColGold:=0;
     ColAnt:=0;
     for i:=1 to 30 do
     for j:=1 to 18 do
         Case pole[i,j] of
         3:Inc(ColGold);
         6,7:Inc(ColAnt);
         End;
End;
function msklet(xc,yc:byte):boolean;
Begin
     case pole[xc,yc] of
     2:msklet:=false;
     3:if ColGold<=1 then msklet:=false else
          Begin
               Dec(ColGold);
               msklet:=true;
          End;
     6,7:
         Begin
              Dec(ColAnt);
         End;
     else
     msklet:=true;
     end;
End;
procedure showpole;
var i,j:byte;
Begin
     for i:=1 to 30 do
     for j:=1 to 18 do
         showpoleklet(i,j,pole[i,j]);
End;
procedure SetHero;
var i,j:byte;
Begin
     for i:=1 to 30 do
     for j:=1 to 18 do
     Begin
         if pole[i,j]=2 then pole[i,j]:=0;
         if pole[i,j]=5 then pole[i,j]:=4;
     End;
     if pole[XCursor,YCursor]=4 then pole[XCursor,YCursor]:=5 else pole[XCursor,YCursor]:=2;
     showpole;
End;
procedure clearpole;
var i,j:byte;
Begin
     for i:=1 to 30 do
     for j:=1 to 18 do
         pole[i,j]:=0;
     for i:=1 to 30 do
         pole[i,18]:=1;
     pole[1,17]:=2;
     pole[30,17]:=3;
     ColGold:=1;
End;
Begin
     if paramCount=1 then
     Begin
     if paramstr(1)='/N' then
     Begin
          LevelFile:='NEW.LEV';
          clearpole;
     End
     else
     Begin
          LevelFile:=Paramstr(1);
          loadpole(LevelFile);
     End;
     InitVideo;
     showpole;
     XCursor:=1;
     YCursor:=1;
     showcursor(XCursor,YCursor);
     repeat
     key:=readkey;
     showpoleklet(Xcursor,YCursor,Pole[Xcursor,YCursor]);
     case key of
     #0:
        begin
             key2:=readkey;
             case key2 of
             #72:if YCursor>1 then Dec(YCursor);
             #80:if YCursor<18 then Inc(YCursor);
             #75:if XCursor>1 then Dec(XCursor);
             #77:if XCursor<30 then Inc(XCursor);
             End;
        end;
     'k','K':if msklet(XCursor,YCursor) then pole[XCursor,YCursor]:=1;
     'i','I':if msklet(XCursor,YCursor) then pole[XCursor,YCursor]:=19;
     'p','P':if msklet(XCursor,YCursor) then pole[XCursor,YCursor]:=0;
     's','S':if msklet(XCursor,YCursor) then pole[XCursor,YCursor]:=4;
     'g','G':if msklet(XCursor,YCursor)and (ColGold<255) then
     Begin
          pole[XCursor,YCursor]:=3;
          Inc(ColGold);
     End;
     'a','A':if msklet(XCursor,YCursor)and (ColAnt<255) then
     Begin
          if pole[XCursor,YCursor]=4 then pole[XCursor,YCursor]:=7 else pole[XCursor,YCursor]:=6;
          Inc(ColAnt);
     End;
     'h','H':if msklet(XCursor,YCursor) then SetHero;
     end;
     showpoleklet(Xcursor,YCursor,Pole[Xcursor,YCursor]);
     showcursor(Xcursor,YCursor);
     until key=#27;
     savepole(LevelFile);
     DoneVideo;
     end;
End.