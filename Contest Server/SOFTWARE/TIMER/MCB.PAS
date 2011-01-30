{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                     Memory Control Block Unit                     ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }
Unit MCB;

Interface

{ ---=== Memory Control Block ===--- }
 Type
   PMCB = ^TMCB;
   TMCB = Record
     Signature : Char; { 'M'-valid 'Z'-last block }
     OwnerID   : Word; { CS of owner }
     SizeParam : Word; { Size in paragraphs }
     Reserved  : Array [0..2] of Byte;
     OwnerName : Array [0..7] of Char;
   End;

{ ---=== Show MCB List to standart output ===--- }
 Procedure Show_MCB_List; Far;

{ ---=== Free memory in MCB ===--- }
 Procedure Free_Memory( Owner_Code_Seg:Word ); Far;

{ ---=== Free memory of program ===--- }
 Procedure Free_Program_Memory( ProgName:String ); Far;

Implementation

 Var MCB_Ptr : PMCB;
     MCB_Seg : Word;
     
 Procedure Set_MCB_Root; Assembler;
   Asm
     Mov AH,52h
     Int 21h
     Mov AX,Word Ptr ES:[BX-2]
     Mov MCB_Seg,AX
   End;

 Procedure Show_MCB_List;
   Var Temp:String[8]; I:Byte;
   Begin
     Set_MCB_Root;
     Repeat
       MCB_Ptr:=Ptr(MCB_Seg,0);
       With MCB_Ptr^ do
         Begin
           Temp:=OwnerName;
           I:=Pos(#00,Temp);
           If I > 0 then Temp[0]:=Chr(I-1);
           For I:=1 to Length(Temp) do Temp[I]:=UpCase(Temp[I]);
           Writeln(Signature,' ',OwnerID:5,' ',SizeParam:5,' ',Temp,'<|>');
         End;
       MCB_Seg:=MCB_Seg+MCB_Ptr^.SizeParam+1;
     Until MCB_Ptr^.Signature <> 'M';
   End;

 Procedure Free_Memory( Owner_Code_Seg:Word ); Assembler;
   Asm
     Mov ES,Owner_Code_Seg
     Mov AH,49h
     Int 21h
   End;

 Procedure Free_Program_Memory( ProgName:String );
   Var Temp:String[8]; I:Byte;
   Begin
     Set_MCB_Root;
     Repeat
       MCB_Ptr:=Ptr(MCB_Seg,0);
       With MCB_Ptr^ do
         Begin
           Temp:=OwnerName;
           I:=Pos(#00,Temp);
           If I > 0 then Temp[0]:=Chr(I-1);
           For I:=1 to Length(Temp) do Temp[I]:=UpCase(Temp[I]);
           If Temp = ProgName then
             Begin
               Free_Memory(MemW[OwnerID:$02C]);
               Free_Memory(OwnerID);
               Writeln('Free program ',ProgName,' memory !');
               Break;
             End;
         End;
       MCB_Seg:=MCB_Seg+MCB_Ptr^.SizeParam+1;
     Until MCB_Ptr^.Signature <> 'M';
   End;

End.