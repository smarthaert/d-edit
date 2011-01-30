{

 PCX grabbing unit for BGI graphics from TomySoftware Productions
 ================================================================

 Code written by Tomaz Solc

 Read the "readme.txt" file for instructions

 ================================================================

 You can download more pascal programs from my home page at

 http://www.geocities.com/siliconvalley/lab/2503

 ================================================================

}

Unit PCXGrab;

Interface

Procedure SavePCX(FN: String);

Implementation

Uses Graph;

{ Palette grabbing procedure }

Procedure GetPal(Color: Byte; Var Red, Green, Blue: Byte);
Var
   R, G, B: Byte;
Begin
   Asm
      MOV       DX,3C7h
      MOV       AL,COLOR
      OUT       DX,AL

      ADD       DX,2

      IN        AL,DX
      MOV       [R],AL
      IN        AL,DX
      MOV       [G],AL
      IN        AL,DX
      MOV       [B],AL
   End;
   Red:= R;
   Green:= G;
   Blue:= B;
End;

{ The main grabbing procedure }

Procedure SavePCX(FN: String);
Var F: File of Byte;
    a, b, c: Byte;
    n, m: Integer;

{ Procedure for writing a word value into a byte-type file }

Procedure Write2B(d: Word);
Begin
     a:= d AND $00ff;
     b:= d SHR 8;

     Write(F, a, b);
End;

Begin
     Assign(F, FN);
     Rewrite(F);

     a:= 10;             Write(F, a);    { Manufacterer }
     a:= 5;              Write(F, a);    { Version      }
     a:= 1;              Write(F, a);    { Encoding     }
     a:= 8;              Write(F, a);    { Bits per pix }
     Write2B(0);                         { XMin         }
     Write2B(0);                         { YMin         }
     Write2B(GetMaxX);                   { XMax         }
     Write2B(GetMaxY);                   { YMax         }
     Write2B(300);                       { Horiz res.   }
     Write2B(300);                       { Vert res.    }

     a:= 0;

     For n:= 1 To 48 Do Write(F, a);     { 48b blank    }

     { These bytes are reserved for color palette setting,
       many programs do not use this, so we leave them blank }

     a:= 0;              Write(F, a);    { Reserved     }

     a:= 1;              Write(F, a);    { Color planes }
     Write2B(GetMaxX + 1);               { Bytes / line }
     Write2B(1);                         { Color / BW   }

     a:= 0;

     For n:= 1 To 58 Do Write(F, a);     { 58b blank    }

     For n:= 0 To GetMaxY Do             { Picture data }
     For m:= 0 To GetMaxX Do
     Begin
          a:= GetPixel(m, n);
          If (a AND $c0) = $c0 Then
          Begin
               b:= $c1;
               Write(F, b, a);
          End Else Write(F, a);
     End;
          
     a:= 12;             Write(F, a);    { Palette strt }

     For n:= 0 To 255 Do                 { Palette data }
     Begin
          GetPal(n, a, b, c);
          a:= a * 4;
          b:= b * 4;
          c:= c * 4;
          Write(F, a, b, c);
     End; 

     Close(F);                           { End          }
End;

Begin
End.