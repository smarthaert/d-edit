{This is Public Domain, it may be distributed as long as you don't take
paid for it.

{Coded by Bj”rn Hallstr”m [bjorn@comports.com]}


Program Calendar;

Uses Crt;

Const Jan = 31;
      Feb = 28;
      Mar = 31;
      Apr = 30;
      May = 31;
      Jun = 30;
      Jul = 31;
      Aug = 31;
      Sep = 30;
      Oct = 31;
      Nov = 30;
      Dec = 31;
      Leap = 366 MOD 7;
      Normal = 365 MOD 7;

Type Monthtype = Record
                   Number : Byte;
                   MName  : String;
                 End;

Var Monthdata           : Array[1..12] Of Monthtype;
    Startday, TotalDays,
    NumDays : Word;

Var month,year:word;

Procedure GetMonthData;
Begin
  Monthdata[1].Number:=31;
  Monthdata[1].MName:='Jan';
  Monthdata[2].Number:=28;
  Monthdata[2].MName:='Feb';
  Monthdata[3].Number:=31;
  Monthdata[3].MName:='Mar';
  Monthdata[4].Number:=30;
  Monthdata[4].MName:='Apr';
  Monthdata[5].Number:=31;
  Monthdata[5].MName:='May';
  Monthdata[6].Number:=30;
  Monthdata[6].MName:='Jun';
  Monthdata[7].Number:=31;
  Monthdata[7].MName:='Jul';
  Monthdata[8].Number:=31;
  Monthdata[8].MName:='Aug';
  Monthdata[9].Number:=30;
  Monthdata[9].MName:='Sep';
  Monthdata[10].Number:=31;
  Monthdata[10].MName:='Oct';
  Monthdata[11].Number:=30;
  Monthdata[11].MName:='Nov';
  Monthdata[12].Number:=31;
  Monthdata[12].MName:='Dec';
End;

Function IsLeapYear(n:Word):Boolean;
Begin
  If (N MOD 4 = 0) AND (N MOD 100 <> 0) OR (N MOD 400 = 0) Then
    IsLeapYear:=True
  Else IsLeapYear:=False;
End;

Function GetInput (Prompt:String; min,max:Word):Word;
Var Value:Word;
Begin
  Repeat
    GotoXY(1,1);
    Write(Prompt);
    Read(value)
  Until (Value>=min) And (value<=max);
  GetInput := Value
END;

{ ====================== COMPUTEMONTH ========================
      Computes the first day and the total days in a month.
  ============================================================
}
Procedure ComputeMonth(Year, Month:word);
Var i : Word;
Begin
   {Calculate total number of days (NumDays) since 1/1/1899.
    Start with whole years:}
   NumDays := 0;
   For I := 1899 To Year - 1 Do
   Begin
     If IsLeapYear(I) Then          {If year is leap, add}
       Inc(NumDays, Leap)           {366 MOD 7.}
     Else                           {If normal year, add}
       Inc(NumDays, Normal);        {365 MOD 7.}
   End;

   {Next, add in days from whole months}
   For I := 1 To Month - 1 Do
     Inc(NumDays, MonthData[I].Number);


   {Set the number of days in the requested month}
   TotalDays := MonthData[Month].Number;

   {Compensate if requested year is a leap year}
   If IsLeapYear(Year) Then
   Begin
     {If after February, add one to total days}
     IF Month > 2 Then Inc(NumDays)
      {If February, add one to the month's days:}
     Else If Month = 2 Then
       Inc(TotalDays, 1);
   End;

   {1/1/1899 was a Sunday, so calculating "NumDays MOD 7"
    gives the day of week (Sunday = 0, Monday = 1, Tuesday = 2,
    and so on) for the first day of the input month}
    StartDay := NumDays Mod 7
End;

Procedure PrintCalendar(Year, Month:word);
Var Header : String;
    I      : Byte;
Begin
   {Compute starting day (Su M Tu ...) and total days
    for the month}
   ComputeMonth(Year, Month);
   ClrScr;

   {Write header}
   WriteLn('  ',Year,', ',Monthdata[month].Mname);
   WriteLn;
   WriteLn('Su    M   Tu    W   Th    F   Sa');
   WriteLn;

   {Recalculate and write tab to the first day
    of the month (Su M Tu ...)}
   GotoXY(5*Startday+1,4);

   {Print out the days of the month}
   For I := 1 To TotalDays Do
   Begin
     If i<10 Then Write(' ',I,'   ');
     If i>9 Then Write(I,'   ');

    {Advance to the next line when the cursor
     is past column 32}
    IF WhereX > 32 THEN WriteLn;
  End;
End;

Begin
  GetMonthData;
  ClrScr;
  year:=Getinput('Enter a year (1899-2099):',1899,2099);
  ClrScr;
  month:=Getinput('Enter a month (1-12):',1,12);
  PrintCalendar(year,month);
End.
