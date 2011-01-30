.386
Text   Segment 'Code' Use16
       Assume CS:Text,DS:Data
Data   Segment
Sum    DD   0
Data   Ends
Begin: Mov  AX,Data
       Mov  DS,AX
; Основной фрагмент программы
       Mov  EAX,0FF000000h
       Mov  EBX,64h
       Mov  CL,0Ah
       Shld EBX,EAX,CL       		
       BSF  EAX,EBX
       BSR  EDX,EBX   
       Mov  DWORD PTR SUM,EBX
; Завершение программы
       Mov  AX,4C00h
       Int  21h
Text   Ends
End    Begin   