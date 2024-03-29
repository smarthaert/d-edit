Uses CRT,DOS,IOTools;

{$M $4000,0,0 }

{$F+}
Var Old_Timer : Procedure;

Const
  AllOK     : Boolean = True;
  Server_CS : Word = 0;
  Server_IP : Word = 0;
  Temp_CS   : Word = 0;
  Temp_IP   : Word = 0;
  Time      : LongInt = 0;
  TimeLim   : LongInt = 1;

{ ---=== �����饭�� �� ���୥�� ����� ===--- }
 Procedure Server; Assembler;
   Asm
     Mov  AX,4C00h
     Int  21h
   End;

{ ---=== ���� ��ࠡ��稪 ⠩��� ===--- }
 Procedure New_Timer; Interrupt;
   Begin
     Asm PushF End;
     Old_Timer;
     If (((Time = TimeLim) Or (Port[$60] = 41)) And AllOK) then
       Begin
         Asm
          { ����㦠�� ���� ���設� �⥪� � ES:[DI] }
           Mov  AX,SS
           Mov  ES,AX
           Mov  DI,SP
          { �����塞 ���� }
           Mov  CX,Server_CS
           Mov  DX,Server_IP
           Mov  AX,ES:[DI+20]
           Mov  BX,ES:[DI+18]
           Mov  ES:[DI+20],CX
           Mov  ES:[DI+18],DX
          { ���������� ���� ���� }
           Mov  Temp_CS,AX
           Mov  Temp_IP,BX
         End;
         Writeln;
         Writeln('[Timer]: �����襭�� ࠡ��� :');
         Writeln('���� ���� ������ : ',Temp_CS,':',Temp_IP);
         Writeln('���� ���� ������ : ',Server_CS,':',Server_IP);
         Writeln;
         AllOK:=False;
       End;
     Inc(Time);
     TextColor(11);
     Write(#13,Time,' -> ',TimeLim);
     TextColor(7);
   End;
{$F-}

{ --=== ��⠭���� ������ ⠩��� ===-- }
Procedure SetNewTimer;
  Begin
   { ��⠭���� ��楤��� Server }
    Server_CS:=Seg(Server);
    Server_IP:=Ofs(Server);
    Writeln('[Timer]: Server ',Server_CS,':',Server_IP);
   { ���� ��ࠡ��稪 ���뢠��� }
    GetIntVec($08,@Old_Timer);
    SetIntVec($08,Addr(New_Timer));
  End;

Procedure ExecProg( Mode:Byte; ProgName,InFile,OutFile:String );
  Begin
    Writeln('EXECUTE ',Mode,' ',ProgName,' ',InFile,' ',OutFile);
    Case Mode of
      0:
        Begin
          Writeln('����⠥� � ��������ன/��ᯫ��� (���᮫�� ०��)');
          If FSearch('COMMAND.COM',GetEnv('PATH'))='' then
            Writeln('Cann''t find COMMAND.COM! PATH = ',GetEnv('PATH'));
          Writeln('[Exec]: ',FSearch('COMMAND.COM',GetEnv('PATH'))+' /C '+
            ProgName+' < '+InFile+' > '+OutFile);
          Exec(FSearch('COMMAND.COM',GetEnv('PATH')),' /C '+
            ProgName+' < '+InFile+' > '+OutFile);
        End;
      1:
        Begin
          Writeln('����⠥� � 䠩����');
          Exec(ProgName,'');
        End;
    End;
End;

{ --=== ����⠭������� ⠩��� ===-- }
Procedure RestoreTimer;
  Begin
    SetIntVec($08,Addr(Old_Timer));
  End;

{ --=== ���࠭���� १���⮢ ===-- }
Procedure SaveResults;
  Var T:Text;
  Begin
    Writeln('[Timer]: �����뢠� TimerOK.TXT ...');
    Writeln('[Timer]: DosError & DosExitCode');
    Assign(T,'TimerOK.TXT');
    Rewrite(T);
    Writeln(T,DosError);
    Writeln(T,DosExitCode);
    Close(T);
  End;

{ --=== �᭮���� �ணࠬ�� ===-- }
Begin
  TextColor(7); Writeln(#13#10'---=== T I M E R  2 0 0 0 ===---'#13#10);
  If ParamCount = 5 then
    Begin
      TimeLim := Trunc( Str2Int(ParamStr(5))*18.2 ) + 1;
      SetNewTimer;  { ��⠭���� ������ ⠩��� }
     { - ����� �ணࠬ�� - }
      ExecProg(Str2Int(ParamStr(1)){<mode>}, ParamStr(2){<progname>},
               ParamStr(3){<infile>}, ParamStr(4){<outfile>});
      RestoreTimer; { ����⠭������� ⠩��� }
      If AllOK then SaveResults; { ���࠭���� १���⮢ � "TimerOK.txt" }
    End
  Else
    Begin
      Writeln('TIMER <mode> <progname> <infile> <outfile> <timelimit>');
      Writeln('<mode>: 0 - ���᮫�� ०��');
      Writeln('        1 - ������� ०��');
      Writeln('<progname> - ��� 䠩�� �ணࠬ�� (����� ����)');
      Writeln('<timelimit> - ��࠭�祭�� � ᥪ㭤�� �� ࠡ��� �ணࠬ��');
      Writeln('H����� "~" ��� �०���६������ ��室� �� �ணࠬ��');
    End;
  TextColor(7); Writeln(#13#10);
End.