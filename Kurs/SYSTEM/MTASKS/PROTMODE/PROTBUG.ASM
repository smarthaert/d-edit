Debug Macro
; �� �맮�� : AX = �८�ࠧ㥬�� �᫮, SI = ���� ��ப� � १���⮬
; �८�ࠧ������ (���� 4-ࠧ�來�� 16-�筮� �᫮)
	Push AX
	Push BX
	Push CX
	Push DX
	Push AX
	And  AX,0F000h
	Shr  AX,12	
	Mov  BX,Offset TblHex
	XLAT
	Mov  [SI],AL
	Pop  AX
	Push AX
	And  AX,00F00h
	Shr  AX,8
	Inc  SI
	XLAT
	Mov  [SI],AL
	Pop  AX
	Push AX
	And  AX,000F0h
	Shr  AX,4
	Inc  SI
	XLAT
	Mov  [SI],AL
	Pop  AX
	Push AX   
	And  AX,0000Fh
	Inc  SI
	XLAT
	Mov  [SI],AL
	Pop  AX
	Pop  DX
	Pop  CX
	Pop  BX
	Pop  AX
	EndM