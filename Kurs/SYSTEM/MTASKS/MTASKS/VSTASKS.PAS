{*******************************}
{*         Модуль простого     *}
{*  многопроцессного монитора  *}
{*          VSTasks v 1.01     *}
{*   для Turbo Pascal ver 7.0  *}
{* (c) Copyright VVSsoft Group *}
{*******************************}
{$F+$S-}

{  v.1.01  ---  по сравнению с версией 1.0 исправлен выход из процесса- }
{               процедуры по достижению  END. В предыдущей версии нужно }
{               было обязательно перед END-ом ставить  HaltCurrentTask, }
{               иначе  система "висла".  Теперь  при  достижении  конца }
{               процесса-процедуры автоматом процесс закрывается ...    }
{                                                                       }
{                               (c) VVSsoft Group.  Кононов Владимир.   }

Unit VSTasks;

interface {--------------------------------------------}

Type

 PTaskRec =^TTaskRec;  { ---- описатель процесса -----}
 TTaskRec =
  record
   NumProc  : word;        { уникальный номер процесса }
   Next     : PTaskRec;    { следующий описатель процесса }
   OrignSP,                { значение SP для возврата }
   OrignSS  : word;        { значение SS для возврата }
   Stack    : pointer;     { указатель на стек процесса }
   SSize    : word;        { размер стека процесса }
  end;

Const

  CountTask   : word = 0;       { всего зарегистрированно процессов }
  PCurTask    : PTaskRec = Nil; { указатель на текущую выполняемую задачу }
  HeadStack   : PTaskRec = Nil; { указатель на голову стека }
  UniNumber   : word = 1;       { уникальный номер для создаваемого процесса }
  CurTask     : word = 0;       { номер текущего процесса }

{----------------- коды ошибок регистрации процесса --------------}

  vstMemoryLow       = 1;   { нет памяти для создания стека процесса }
  vstEmptyStackTask  = 2;   { нет зарегистрированных процессов }
  vstMAXLimitProc    = 3;   { слишком много процессов }

Var
  TaskError     : byte;     { последняя ошибка }


procedure StartTasks;
{--- запуск процессов на выполнение ---}

procedure SwithTasks; far;
{--- переключение между задачами ---}

function RegisterTask(TaskPoint : pointer; SizeStack: word): word;
{--- регистрация задачи если - 0, то ошибка в переменной TaskError ---}
{--- возвращает номер зарегистрированного процесса ---}

procedure HaltCurrentTask;
{--- снятие текущей задачи ---}

procedure HaltAllTasks;
{--- снятие всех задач ---}

implementation
{----------------------------------------------------------------}

Var
    OriginalSS,                { адрес оригинального стека программы     }
    OriginalSP     : word;     { указатель оригинального стека программы }
    PDopPoint      : PTaskRec; { дополнительный указатель }

{------- переопределенные функции для работы с BASMом ---------}

function mMemAvail: word;
Var M: longint;
    T: record
        L,H: word;
       end;
begin
 M:=MaxAvail;
 If M>$FFFF then mMemAvail:=$FFFF
  else
   begin
    Move(M,T,SizeOf(longint));
    mMemAvail:=T.L;
   end;
end;

function mGetMem(S:word): pointer;
Var P:pointer;
begin
 GetMem(P,S);
 mGetMem:=P;
end;

procedure mFreeMem(P: pointer;S: word);
Var D: pointer;
begin
 D:=P;
 FreeMem(P,S);
end;

procedure StartTasks; assembler;
{ --- запуск процессов на выполнение --- }
asm
                 PUSH BP
                 PUSH DI
                 PUSH SI
                 PUSH DS
                 PUSH ES
                 LEA  DI, @ExitPoint
                 PUSH CS
                 PUSH DI
                 MOV  OriginalSS, SS
                 MOV  OriginalSP, SP
                 MOV  AX, CountTask
                 XOR  BX, BX
                 CMP  AX, BX
                 JE   @Exit
                 MOV  DI, HeadStack.word[0]
                 MOV  ES, HeadStack.word[2]
                 MOV  AX, ES:[DI]
                 MOV  CurTask, AX
                 MOV  PCurTask.word[0], DI
                 MOV  PCurTask.word[2], ES
                 CLI
                 MOV  SS, ES:[DI+8]
                 MOV  SP, ES:[DI+6]
                 STI
                 POP  BP
                 POP  ES
                 POP  DS
                 RETF
 @Exit:          POP  AX
                 POP  AX
                 MOV  AL, vstEmptyStackTask
                 MOV  TaskError, AL
 @ExitPoint:     POP  ES
                 POP  DS
                 POP  SI
                 POP  DI
                 POP  BP
end;

procedure SwithTasks; assembler;
{ --- переключение между задачами --- }
asm
                 PUSH DS
                 PUSH ES
                 PUSH BP
                 MOV  AX, SEG @Data
                 MOV  DS, AX
                 MOV  ES, PCurTask.word[2]
                 MOV  DI, PCurTask.word[0]
                 MOV  ES:[DI+8], SS
                 MOV  ES:[DI+6], SP
                 MOV  BX, ES:[DI+4]
                 MOV  SI, ES:[DI+2]
                 MOV  ES, BX
                 XOR  AX, AX
                 CMP  BX, AX
                 JNE  @Next
                 CMP  SI, AX
                 JNE  @Next
                 MOV  ES, HeadStack.word[2]
                 MOV  SI, HeadStack.word[0]
 @Next:          MOV  PCurTask.word[2], ES
                 MOV  PCurTask.word[0], SI
                 MOV  AX, ES:[SI]
                 MOV  CurTask, AX
                 CLI
                 MOV  SS, ES:[SI+8]
                 MOV  SP, ES:[SI+6]
                 STI
                 POP  BP
                 POP  ES
                 POP  DS
end;

function RegisterTask(TaskPoint: pointer; SizeStack: word): word; assembler;
{ --- регистрация задачи --- }
{ если вощзвращен 0, то ошибка в переменной TaskError }
asm
                 XOR  AX, AX
                 NOT  AX
                 CMP  AX, UniNumber
                 JE   @TooManyProc
                 CALL mMemAvail
                 MOV  BX, SizeStack
                 CMP  AX, BX
                 JB   @LowMem
                 PUSH BX
                 CALL mGetMem
                 PUSH DX
                 PUSH AX
                 CALL mMemAvail
                 MOV  CX, TYPE TTaskRec
                 CMP  AX, CX
                 JB   @LowMemAndFree
                 PUSH CX
                 CALL mGetMem
                 PUSH ES
                 MOV  ES, DX
                 MOV  DI, AX
                 MOV  AX, UniNumber
                 MOV  ES:[DI], AX
                 INC  AX
                 MOV  UniNumber, AX
                 MOV  BX, HeadStack.word[0]
                 MOV  CX, HeadStack.word[2]
                 MOV  ES:[DI+2], BX
                 MOV  ES:[DI+4], CX
                 POP  CX
                 POP  AX
                 MOV  ES:[DI+10], AX
                 MOV  BX, SizeStack
                 MOV  ES:[DI+14], BX
                 ADD  AX, BX
                 JNC  @NotCorrect
                 XOR  AX, AX
                 NOT  AX
 @NotCorrect:    SUB  AX, $01
                 POP  BX
                 MOV  ES:[DI+12], BX
                 MOV  ES:[DI+8], BX
                 PUSH ES
                 MOV  ES, CX
                 MOV  CX, TaskPoint.WORD[0]
                 MOV  DX, TaskPoint.WORD[2]
                 PUSH BP
                 CLI
                 MOV  SI, SS
                 MOV  BP, SP
                 MOV  SS, BX
                 MOV  SP, AX
                 MOV  BX,SEG    HaltCurrentTask
                 MOV  AX,OFFSet HaltCurrentTask
                 PUSH BX
                 PUSH AX
                 PUSH DX
                 PUSH CX
                 PUSH DS
                 PUSH ES
                 MOV  DX, SP
                 ADD  DX, $02
                 PUSH DX
                 MOV  CX, SP
                 MOV  SS, SI
                 MOV  SP, BP
                 STI
                 POP  BP
                 MOV  AX, ES
                 POP  ES
                 MOV  ES:[DI+6], CX
                 PUSH ES
                 MOV  ES, AX
                 POP  AX
                 MOV  HeadStack.WORD[0], DI
                 MOV  HeadStack.WORD[2], AX
                 MOV  AX, CountTask
                 INC  AX
                 MOV  CountTask, AX
                 MOV  AX, UniNumber
                 DEC  AX
                 JMP  @Exit
 @TooManyProc:   MOV  AL, vstMAXLimitProc
                 MOV  TaskError, AL
                 JMP  @ErrExit
 @LowMemAndFree: MOV  BX, SizeStack
                 PUSH BX
                 CALL mFreeMem
 @LowMem:        MOV  AL, vstMemoryLow
                 MOV  TaskError, AL
 @ErrExit:       XOR  AX, AX
 @Exit:
end;

procedure HaltCurrentTask; assembler;
{ --- снятие текущей задачи --- }
asm
                 MOV  AX, SEG @Data
                 MOV  ES, PCurTask.word[2]
                 MOV  DI, PCurTask.word[0]
                 XOR  AX, AX
                 MOV  PDopPoint.word[0], AX
                 MOV  PDopPoint.word[2], AX
                 MOV  AX, ES
                 MOV  DX, HeadStack.word[2]
                 MOV  BX, HeadStack.word[0]
 @Loop:          CMP  DX, AX
                 JNE  @NextProc
                 CMP  BX, DI
                 JNE  @NextProc
                 JMP  @DelProcess
 @NextProc:      MOV  ES, DX
                 MOV  SI, BX
                 MOV  PDopPoint.word[0], BX
                 MOV  PDopPoint.word[2], DX
                 MOV  DX, ES:[SI+4]
                 MOV  BX, ES:[SI+2]
                 JMP  @Loop
 @DelProcess:    MOV  ES, AX
                 MOV  BX, ES:[DI+2]
                 MOV  PCurTask.word[0], BX
                 MOV  DX, ES:[DI+4]
                 MOV  PCurTask.word[2], DX
                 XOR  CX, CX
                 CMP  CX, PDopPoint.word[0]
                 JNE  @NotNil
                 CMP  CX, PDopPoint.word[2]
                 JNE  @NotNil
                 MOV  HeadStack.word[0], BX
                 MOV  HeadStack.word[2], DX
                 JMP  @FreeMem
 @NotNil:        PUSH ES
                 PUSH DI
                 MOV  ES, PDopPoint.word[2]
                 MOV  DI, PDopPoint.word[0]
                 MOV  ES:[DI+2], BX
                 MOV  ES:[DI+4], DX
                 POP  DI
                 POP  ES
 @FreeMem:       CLI
                 MOV  SS, OriginalSS
                 MOV  SP, OriginalSP
                 STI
                 MOV  DX, ES:[DI+12]
                 MOV  BX, ES:[DI+10]
                 MOV  CX, ES:[DI+14]
                 PUSH ES
                 PUSH DI
                 PUSH DX
                 PUSH BX
                 PUSH CX
                 CALL mFreeMem
                 POP  DI
                 POP  ES
                 MOV  CX, TYPE TTaskRec
                 PUSH ES
                 PUSH DI
                 PUSH CX
                 CALL mFreeMem
                 XOR  AX, AX
                 MOV  CurTask, AX
                 MOV  AX, CountTask
                 DEC  AX
                 MOV  CountTask, AX
                 JZ   @Exit
                 MOV  ES, PCurTask.word[2]
                 MOV  DI, PCurTask.word[0]
                 MOV  BX, ES
                 XOR  AX, AX
                 CMP  AX, BX
                 JNE  @SetProcess
                 CMP  AX, DI
                 JNE  @SetProcess
                 MOV  ES, HeadStack.word[2]
                 MOV  DI, HeadStack.word[0]
                 MOV  PCurTask.word[2], ES
                 MOV  PCurTask.word[0], DI
 @SetProcess:    MOV  AX, ES:[DI]
                 MOV  CurTask, AX
                 CLI
                 MOV  SS, ES:[DI+8]
                 MOV  SP, ES:[DI+6]
                 STI
                 POP  BP
                 POP  ES
                 POP  DS
 @Exit:
end;

procedure HaltAllTasks; assembler;
{ --- снятие всех задач --- }
asm
                 MOV  AX, SEG @Data
                 MOV  DS, AX
                 XOR  AX, AX
                 MOV  PCurTask.word[0], AX
                 MOV  PCurTask.word[2], AX
                 CLI
                 MOV  SS, OriginalSS
                 MOV  SP, OriginalSP
                 STI
 @Loop:          XOR  AX, AX
                 CMP  AX, CountTask
                 JE   @StackEmpty
                 MOV  ES, HeadStack.word[2]
                 MOV  DI, HeadStack.word[0]
                 MOV  DX, ES:[DI+4]
                 MOV  BX, ES:[DI+2]
                 MOV  HeadStack.word[2], DX
                 MOV  HeadStack.word[0], BX
                 MOV  AX, ES:[DI+12]
                 MOV  CX, ES:[DI+10]
                 PUSH ES
                 PUSH DI
                 PUSH AX
                 PUSH CX
                 MOV  AX, ES:[DI+14]
                 PUSH AX
                 CALL mFreeMem
                 MOV  AX, TYPE TTaskRec
                 PUSH AX
                 CALL mFreeMem
                 MOV  AX, CountTask
                 DEC  AX
                 MOV  CountTask, AX
                 JMP  @Loop
 @StackEmpty:    MOV  CurTask, AX
end;

end.

