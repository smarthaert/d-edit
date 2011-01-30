uses ncolor,my3d2,fix,fade,filters;

const text:array [1..4] of string
          =('200 gouraud-shaded Polygons',
            '200 phong-shaded Polygons',
            '200 gouraud-shaded Polygons plus fullscreen-antialiasing',
            '200 texture-mapped Polygons');

Procedure CalcPal(Shades,Colors:word; n:word);

Function Hoch(R:Real; N:Word):Real;

Var I:Integer;
    T:Real;

Begin
     T:=1;
     If N>0 Then
        For I:=1 To N Do
            T:=T*R;
     Hoch:=T;
End;

Var I,II:Integer;
    OldPal:TPal;
    T:Real;

Begin
     fillscreen(0);
     dumpscreen;
     GetPalette(OldPal);
     For I:=0 To Colors-1 Do
         For II:=0 To Shades-1 Do
             Begin
                  T:=cos(II/(Shades*2)*pi);
                  SetPal(I*Shades+Shades-1-II,
                    Round((OldPal[I,0] Shr 3)*Hoch(t,0)+   {Dunkel}
                          (OldPal[I,0] Shr 1)*Hoch(t,1)+   {Mittel}
                          (OldPal[I,0] Shr 1)*Hoch(t,N)),  {Highlight}
                    Round((OldPal[I,1] Shr 3)*Hoch(t,0)+   {Dunkel}
                          (OldPal[I,1] Shr 1)*Hoch(t,1)+   {Mittel}
                          (OldPal[I,1] Shr 1)*Hoch(t,N)),  {Highlight}
                    Round((OldPal[I,2] Shr 3)*Hoch(t,0)+   {Dunkel}
                          (OldPal[I,2] Shr 1)*Hoch(t,1)+   {Mittel}
                          (OldPal[I,2] Shr 1)*Hoch(t,N))); {Highlight}
             End;
End;

var o:tobject;
    typ,i:integer;

begin
     initgraphmode;
     loadobject('torus.mo2',o);
     cam.z:=real2fix(-70);
     for typ:=1 to 4 do
         begin
              case typ of
                   1:begin
                          o.nofshades:=128;
                          o.nofcolors:=2;
                          for i:=0 to o.noffaces-1 do
                              o.faces^[i].shading:=gouraud;
                          setpal(0,55,55,55);
                          setpal(1,55,55,0);
                          calcpal(o.nofshades,o.nofcolors,5);
                     end;
                   2:begin
                          o.nofshades:=128;
                          o.nofcolors:=2;
                          for i:=0 to o.noffaces-1 do
                              o.faces^[i].shading:=phong;
                          setpal(0,55,55,55);
                          setpal(1,55,55,0);
                          calcpal(o.nofshades,o.nofcolors,200);
                     end;
                    3:begin
                          o.nofshades:=128;
                          o.nofcolors:=1;
                          for i:=0 to o.noffaces-1 do
                              begin
                                   o.faces^[i].col:=0;
                                   o.faces^[i].shading:=gouraud;
                              end;
                          setpal(0,0,0,55);
                          calcpal(o.nofshades,o.nofcolors,5);
                          antilevel:=3;
                     end;
                   4:begin
                          for i:=0 to o.noffaces-1 do
                              o.faces^[i].mapping:=lineartexture;
                          fillscreen(0);
                          dumpscreen;
                          setpalette(o.textures^[o.faces^[0].texture].palette);
                     end;
              end;
              repeat
                    nokey;
                    fillscreen(0);
                    rotateobject(o,1,1,1);
                    drawobject(o);
                    if typ=3 then antialias(1,1,318,198);{}
                    outtext((320-strlen(text[typ])) shr 1,180,text[typ],255);
                    waitretrace;
                    dumpscreen;
              until key;
         end;
     freeobject(o);
     inittextmode;
end.