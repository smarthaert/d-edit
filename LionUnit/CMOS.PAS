
{  AT-class PCs contain a battery-powered real-time clock (RTC) and 64-bytes }
{  of low-power non-volatile CMOS memory. }

{  This memory contains a variety of information, including the current time }
{  and date, along with hardware configuration and a shut-down status byte }
{  (the shutdown byte is used in the mechanism which permits the AT to }
{  restart where it left off after issuing a processor reset to exit from }
{  protected mode). }

{  When you see the "Run Setup" prompt during POST it is usually because some }
{  hardware did not match the configuration record or because of some other }
{  problem with the CMOS RAM. }

{  Address Summary (detailed information follows) }
{  ������� ������������������������������������������ }
{  00H-0dH used by real-time clock }
{  0eH     POST diagnostics status byte }
{  0fH     shutdown status byte }
{  10H     diskette drive type      ����Ŀ }
{  11H     (reserved)                    � }
{  12H     hard disk types (if < 15)     � }
{  13H     (reserved)                    �� checksum-protected }
{  14H     equipment byte                �   configuration record }
{  15H-16H Base memory size              �   (addresses 10H-20H) }
{  17H-18H extended memory above 1M      � }
{  19H     hard disk C type (if > 15)    � }
{  1aH     hard disk D type (if > 15)    � }
{  1bH-20H (reserved)               ������ }
{  21H-2dH (reserved) }
{  2eH-2fH storage for  checksum of CMOS addresses 10H through 20H }
{  30H-31H extended memory above 1M }
{  32H     current century in BCD (e.g., 19H) }
{  33H     miscellaneous info. }
{  34H-3fH (reserved) }

{ ��Using CMOS Data�� }
{   To read a byte from CMOS, do an OUT 70H,addr followed by IN 71H.  To }
{   write a byte to CMOS, do an OUT 70H,addr followed by OUT 71H,value. }

{   Example: ;---------------- read what type of hard disk is installed }
{            mov     al,12H }
{            out     70H,al   ;select CMOS address 12H }
{            jmp     $+2      ;this forces a slight delay to settle things }
{            in      al,71H   ;AL now has drive type (0-15) }

{   Addresses 10H through 20H are protected by a checksum to be able to detect }
{   when the battery has died or invalid information has been written into the }
{   configuration record.  This a simple 16-bit sum of the protected bytes. }

{ ��CMOS Memory Layout Detail�� }
{   This layout applies to AT-class PC only.  PS/2 machines define some fields }
{   differently. }

{ Addr Description }
{ ���� ����������������������������������������������������������������������� }
{  0   current second (real-time clock)�������������������������������������ͻ }
{  1   alarm second                    � All RTC quantities are stored in    � }
{  2   current minute                  � BCD-format as two decimal nibbles;  � }
{  3   alarm minute                    � e.g., 31 (decimal) is stored as 31H.� }
{  4   current hour                    �������������������������������������ͼ }
{  5   alarm hour                               ����������������������������Ŀ }
{  6   current day of week (1=Sunday)           � Note: For more info on the � }
{  7   current date of month                    � real-time clock, refer to  � }
{  8   current month                            � Motorolla MC146818 specs.  � }
{  9   current year  (final two digits; eg, 94) ������������������������������ }
{ ���  ����������������������������������������������������������������������� }
{ 0aH  RTC status register A }
{      �7�6�5�4�3�2�1�0� }
{      � �     �       � }
{      ���������������Ľ }
{       � ���ͼ �������� rate selector (set to 0110) }
{       �   ������������ 22-stage divider (set to 010) }
{       ���������������� Update in progress (UIP) flag.  0 means OK to read. }
{ ���  ����������������������������������������������������������������������� }
{ 0bH  RTC status register B }
{      �7�6�5�4�3�2�1�0� }
{      � � � � � � � � � }
{      ���������������ҽ }
{       � � � � � � � �� daylight savings enable.  0=standard time (set to 0) }
{       � � � � � � ���� 12 or 24-hr mode.  0=12-hr mode (is set to 1) }
{       � � � � � ������ BCD date mode. 1=binary, 0=BCD.  (is set to 0) }
{       � � � � �������� enable square wave. 1=turn on sqr wave. (set to 0) }
{       � � � ���������� enable update-ended interrupt.0 disables. (set to 0) }
{       � � ������������ enable alarm int. 0 disables (set to 0) See INT 1aH }
{       � �������������� enable periodic interrupt 0 disables (set to 0) }
{       ���������������� Update in progress (UIP) flag.  0 = OK to read CMOS. }
{ ���  ����������������������������������������������������������������������� }
{ 0cH  RTC status register C.  Read-only interrupt status bits. }
{ ���  ����������������������������������������������������������������������� }
{ 0dH  RTC status register D. Bit 7=1 when a CMOS-RAM is receiving power }
{                                  =0 to indicate a dead battery. }
{ ���  ����������������������������������������������������������������������� }
{ 0eH  POST diagnostics status byte }
{      �7�6�5�4�3�2�1�0� }
{      � � � � � � �0 0� }
{      ���������������Ľ }
{       � � � � � ������ Time is valid (After POST, 1 means it's not Feb 30) }
{       � � � � �������� Hard disk bad.  1 = can't boot from hard disk }
{       � � � ���������� RAM size error. 1 = POST found different RAM size }
{       � � ������������ Configuration record error.  1=different equipment }
{       � �������������� Checksum invalid.  1 = bad checksum in CMOS RAM }
{       ���������������� Power Lost.  1 = real-time clock battery died }
{ ���  ����������������������������������������������������������������������� }
{ 0fH  shutdown status byte }
{      This byte is read upon startup after CPU reset in order to determine if }
{      the reset was used as a way to get out of 80286 protected mode. }
{          0 = soft reset (Ctrl-Alt-Del) or unexpected shutdown.  Skip POST }
{          1 = shutdown after memory size is determined }
{          2 = shutdown after memory test is performed }
{          3 = shutdown after memory error (parity check 1 or 2) }
{          4 = shutdown with bootstrap loader request }
{          5 = shutdown with FAR JMP (restart int ctrlr and jmp to 0:[0467H]) }
{      6,7,8 = shutdown after passing a protected mode test }
{          9 = shutdown after performing block move.  See INT 15H 87H }
{        0aH = shutdown with FAR JMP (immediate jmp to address at 0:[0467H]) }
{ ���  ����������������������������������������������������������������������� }
{ 10H  diskette drive types }
{      �7�6�5�4�3�2�1�0� }
{      �       �       � }
{      ���������������Ľ }
{       �����ͼ ��������second diskette drive ��� 0000 = 0 = not installed }
{          ������������� first diskette drive ͼ   0001 = 1 = 360K drive }
{                                                   0010 = 2 = 1.2M drive }
{    For instance, 24H means drive A is 1.2M        0011 = 3 = 720K drive }
{                            drive B is 1.44M       0100 = 4 = 1.44M drive }
{ ���  ����������������������������������������������������������������������� }
{ 11H  reserved on �AT� }
{      PS/2 uses addresses 11H and 12H to identify the Hard Disk Types for }
{      the first and second hard disks (drives C: and D:), respectively. }
{ ���  ����������������������������������������������������������������������� }
{ 12H  hard disk drive type  (for drives C: and D:, when between 1 and 14) }
{      �7�6�5�4�3�2�1�0� }
{      �       �       � }
{      ���������������Ľ }
{       �����ͼ ��������second hard disk (drive D) ���0000 =not present }
{          ������������� first hard disk (drive C) ͼ  else =type ID (below) }
{                                                       1111 =use addr 19H/1aH }

{      See AT BIOS Hard Disk Types for a list of IBM BIOS-supported drives. }
{ ���  ����������������������������������������������������������������������� }
{ 13H  reserved }
{ ���  ����������������������������������������������������������������������� }
{ 14H  Equipment byte }
{      �7�6�5�4�3�2�1�0� }
{      �drv�dsp�0 0�7�d� }
{      ���������������Ľ }
{       �˼ �˼     � �� 1 = diskette drive(s) installed }
{        �   �      ���� 1 = 80287 math co-processor installed }
{        �   ����������� primary display 00 = none or EGA }
{        �                                01 = 40-clm CGA, EGA or VGA }
{        �                                10 = 80-clm CGA, EGA or VGA }
{        �                                11 = Monochrome }
{        ��������������� diskette drives-1 (00=1, 01=2, 10=3, 11=4) }
{ ���  ����������������������������������������������������������������������� }
{ 15H  Base memory (low byte)  ���� 0100H=256K, 0200H=512K, 0280H=640K }
{ 16H  Base memory (high byte)  ͼ }
{ 17H  extended memory above 1M (low byte)  ���� (in K bytes; 0-3c00H) }
{ 18H  extended memory (high byte)  ���������ͼ   See INT 15H 88H. }
{ ���  ����������������������������������������������������������������������� }
{ 19H  disk 0 (drive C:) hard disk type if (CMOS addr 12H & 0fH) is 0fH }
{ 1aH  disk 1 (drive D:) hard disk type if (CMOS addr 12H & f0H) is f0H }
{      (reserved on PS/2) }
{ ���  ����������������������������������������������������������������������� }
{ 1bH-2dH reserved }
{ ���  ����������������������������������������������������������������������� }
{ 2eH  checksum of CMOS addresses 10H through 20H  (high byte) }
{ 2fH                                              (low byte) }
{ ���  ����������������������������������������������������������������������� }
{ 30H  extended memory above 1M (low byte)  ���� (in K bytes; 0-3c00H) }
{ 31H  extended memory (high byte)  ���������ͼ   See INT 15H 88H. }
{ ���  ����������������������������������������������������������������������� }
{ 32H  century in BCD (e.g., 19H) }
{      PS/2 addresses 32H and 33H contain a CRC-style checksum of bytes 10H }
{           through 31H.  32H is the high byte, 33H is the low byte. }
{ ���  ����������������������������������������������������������������������� }
{ 33H  miscellaneous info.  Bit 7=IBM 128K memory option installed }
{                           Bit 6=used by "Setup" utility }
{ ���  ����������������������������������������������������������������������� }
{ 34H-3fH reserved.  Put your name here for everlasting amusement. }
{      PS/2 Date Century byte is at address 37H. }
{      PS/2 Password is contained in bytes 38H-3fH on Model 50.  To read or }
{           modify the password, trick IBM by using addresses 78H-7fH (these }
{           invalid address "wrap around" and map to 38h-3fh). }
Unit CMOS;

Interface

  Function Read_CMOS( Address:Byte ):Byte;

  Procedure Write_CMOS( Address,Value:Byte );

  Procedure Write_CMOS_Checksum;

Implementation

  Uses CRT;

  Function Read_CMOS( Address:Byte ):Byte; Assembler;
    Asm
      Mov AL,Address
      Out 70h,AL
      In  AL,71h
    End;

  Procedure Write_CMOS( Address,Value:Byte ); Assembler;
    Asm
      Mov AL,Address
      Out 70h,AL
      Mov AL,Value
      Out 71h,AL
    End;

  Procedure Write_CMOS_Checksum;
    Var Sum:Word; I:Byte;
    Begin
      Sum:=0;
      For I:=$10 to $20 do Sum:=Sum+Read_CMOS(I);
      Write_CMOS($2E,Lo(Sum));
      Write_CMOS($2F,Hi(Sum));
    End;

End.