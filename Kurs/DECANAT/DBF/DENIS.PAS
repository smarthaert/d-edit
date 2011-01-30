uses dbFile,Crt;
Var DF:TdbFile;

BEGIN
DF.Create('list.dbf',4096,NewField('FILENAME','C',20,0,
                          NewField('SIZE','N',9,0,nil)));
with DF do
Begin
  AppendBlank; WriteStr('EMM386.exe',1); WriteStr('1432',2);
  AppendBlank; WriteStr('Himem.sys',1);
  AppendBlank; WriteStr('command.com',1);
   AppendBlank; WriteStr('smartdrv.sys',1);
    AppendBlank; WriteStr('MsDos.sys',1);
    AppendBlank; WriteStr('IO.sys',1);
    AppendBlank; WriteStr('mouse.com',1);
    AppendBlank; WriteStr('WINA20.386',1);
    AppendBlank; WriteStr('VgaGA.com',1);
    AppendBlank; WriteStr('PUkbg.com',1);
 Done;
End;

END.