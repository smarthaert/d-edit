{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �                  Roman International Explorer                  � � }
{ � �                            TEXTCONV                            � � }
{ � �                 Generated at 14:06:50 29.03.99                 � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }
Uses CRT,TextMode;

{$I-}

{ = = = �｀� � 蹍������ = = = }
 Procedure Runtime_Error( Message:String );
   Begin
     TextColor(15);
     Writeln;
     Writeln('Runtime Error : ',Message);
     Writeln;
     Halt(1);
   End;

{ = = = ���〓 � �����爛 = = = }
 Type Dictionary_Word = Record
        Word,New_Word:String;
      End;

{ = = = ���瓱祠 ���� � �����爛 = = = }
 Const Max_Words = 65535 div SizeOf(Dictionary_Word);

{ = = = ��瘁│ �����瑙 = = = }
 Type
   TDictionary = Array [1..Max_Words] of Dictionary_Word;
   PDictionary = ^TDictionary;

{ = = = �┓� �����爛� = = = }
 Const
   dtNoCaseSensitive = 0;
   dtCaseSensitive   = 1;
   dtStyle           = 2;
   dtMinType         = 0;
   dtMaxType         = dtStyle;
   Dictionary_Types : Array [dtMinType..dtMaxType] of String =
     ('No Case Sensitive','Case Sensitive','Style');

{ = = = �����瑕 = = = }
 Type
   Dictionary = Object
     Words:Word;
     List:PDictionary;
     Dictionary_Type:Byte;
     Constructor Init( _Dictionary_Type:Byte );
     Destructor Done;
     Procedure Add_Word( _Word,New_Word:String );
     Function Translate_String( Str:String ):String;
   End;

   Constructor Dictionary.Init( _Dictionary_Type:Byte );
     Begin
       Words:=0;
       Dictionary_Type:=_Dictionary_Type;
       New(List);
     End;

   Destructor Dictionary.Done;
     Begin
       Dispose(List);
     End;

   Procedure Dictionary.Add_Word( _Word,New_Word:String );
     Var I,J:Word;
     Begin
       Inc(Words);
       If Words > Max_Words then Runtime_Error('Too many words !');
       If Dictionary_Type <> dtStyle then
         Begin
           List^[Words].Word:=_Word;
           List^[Words].New_Word:=New_Word;
         End
       Else
         Begin
           I:=0;
           Repeat
             Inc(I);
           Until ((Length(List^[I].Word)>Length(_Word)) Or (I=Words));
           For J:=(Words-1) downto I do List^[J+1]:=List^[J];
           List^[I].Word:=_Word;
           List^[I].New_Word:=New_Word;
         End;
     End;

   Function Dictionary.Translate_String( Str:String ):String;
     Var S,D:String; W:Word; I,J:Byte; Flag,Case_Sensitive:Boolean;
     Begin
       Case Dictionary_Type of
         dtCaseSensitive: Case_Sensitive:=True;
       Else
         Case_Sensitive:=False;
       End;
      { ���キ錺� �瓮 ����� }
       D:=Str;
       For W:=1 to Words do
         With List^[W] do
           Begin
             S:=D; D:='';
            { ���ガ錺� ､�� ���〓 � �矗��� }
             For I:=1 to Length(S) do
               Begin
                 Flag:=True;
                 If Case_Sensitive then
                   Begin { �ィ�痰� �礫� ��Й���モ瘴 }
                     For J:=1 to Length(Word) do
                       If ((S[I+J-1]<>Word[J]) Or
                          ((I+J-1)>Length(S))) then
                         Begin Flag:=False; Break; End;
                   End
                 Else
                   Begin { �ィ�痰� �礫� �� ��Й���モ瘴 }
                     For J:=1 to Length(Word) do
                       If ((UpCase(S[I+J-1])<>UpCase(Word[J])) Or
                          ((I+J-1)>Length(S))) then
                         Begin Flag:=False; Break; End;
                   End;
                 If Flag then
                   Begin
                     D:=D+New_Word;
                     I:=I+Length(Word)-1;
                   End
                 Else
                   D:=D+S[I];
               End;
           End;
       Translate_String:=D;
     End;

{ = = = �ムア�� �矗��� = = = }
 Const NewStr = #13#10;

{ = = = �襤�� �矗��� = = = }
 Procedure Out( Color:Byte; S:String );
   Begin
     TextColor(Color);
     Write(S);
   End;

{ = = = �襤�� �矗��� ��竍���覓� �▲���� = = = }
 Procedure Random_Out( S:String );
   Var I:Byte;
   Begin
     For I:=1 to Length(S) do Out(Random(7)+9,S[I]);
   End;

{ = = = ��痰�→� = = = }
 Procedure Poster;
   Begin
     Out(7,NewStr+NewStr);
     Random_Out(' >>> Text Conventor by Roman International <<<');
     Out(7,NewStr+NewStr);
   End;

{ = = = �甅�↓�� 蹍������ = = = }
Var S1,S2:String; D,I,O:Text; C:LongInt; Dict:Dictionary; Temp:Byte;
Begin
  Randomize;
  Poster;
  If ParamCount = 3 then
    Begin
     { ���珮И� �����瑙 }
      Out(10,' Open Dictionary : '); Out(11,ParamStr(3)+NewStr);
      Assign(D,ParamStr(3));
      Reset(D);
      If IOResult<>0 then Runtime_Error('Cann''t open Dictionary !');
      Readln(D,Temp);
      If ((IOResult<>0) Or (Temp<dtMinType) Or (Temp>dtMaxType)) then
        Runtime_Error('Error Dictionary Type !');
      Dict.Init(Temp);
      Out(13,NewStr+'  Dictionary Style = '+Dictionary_Types[Temp]+NewStr+NewStr);
      Repeat
        Readln(D,S1);
        If Dict.Dictionary_Type <> dtStyle then
          Begin
            Readln(D,S2);
            Dict.Add_Word(S1,S2);
          End
        Else
          Dict.Add_Word(S1,S1);
        Out(9,'  '+AsString(Dict.Words)); Out(12,' Words'+#13);
      Until EOF(D);
      Close(D);
      Out(7,NewStr+NewStr);
     { �ムア�� �オ痰� }
      Out(10,' Input Text : '); Out(11,ParamStr(1)+NewStr);
      Out(10,' Output Text : '); Out(11,ParamStr(2)+NewStr+NewStr);
      Assign(I,ParamStr(1)); Reset(I);
      If IOResult<>0 then Runtime_Error('Cann''t open Input Text !');
      Assign(O,ParamStr(2)); Rewrite(O);
      If IOResult<>0 then Runtime_Error('Cann''t create Output Text !');
      C:=0;
      Repeat
        Inc(C);
        Out(9,'  '+AsString(C)); Out(12,' Strings'+#13);
        Readln(I,S1);
        Writeln(O,Dict.Translate_String(S1));
      Until EOF(I);
      Close(I); Close(O);
      Out(15,NewStr+NewStr+'   All done !');
      Dict.Done;
    End
  Else
    Begin
      Out(15,'    TEXTCONV  ');
      Out(14,'<');
      Out(13,'Input');
      Out(14,'> <');
      Out(13,'Output');
      Out(14,'> <');
      Out(13,'Dictionary');
      Out(14,'>');
    End;
  Out(7,NewStr+NewStr);
End.