(******************************************************
 LFB demo by Vadim Bodrov, 1998
 This example demonstarates how to use LFB video modes
 from the Borland Pascal.
*******************************************************)

 {$G+,N-,D-,L-,B-,R-,O-,F+,S-,A+,E-,P-,Q-,T+,V-,X+,I-}

 {$IFNDEF DPMI}
 ============================================================================
                                  WARNING !!!
    THIS PROGRAM MUST BE COMPILED FOR DOS PROTECTED MODE (DPMI16) ONLY!!!
 ============================================================================
 {$ENDIF}

uses DPMIPro, VBEPro;
var
  i: Longint;
begin
 {init VBE}
 if not InitVBE then
 begin
   Writeln('Failed initialize VESA/VBE..');
   exit;
 end;

 {view VBE info}
 Writeln('VESA/VBE version ', Hi(vpVBEVersion), '.',
         Lo(vpVBEVersion), ' with ', vpVBEMem, 'K video memory.');
 Writeln('OEM string: ', vpOEMString);
 Writeln('Press enter to continue...');
 Readln;

 {set SVGA LFB mode 640x480x256}
 if SetVBEMode($4101) then
 begin
   {fill LFB memory with random colored pixels directly}
   for i := 0 to 640 * 480 -1 do
     PutByte32(FarPtr(LFBSEG, i), Random(256));
   {wait for a key}
   Readln;

   {clear video page using blue color}
   ClearPage256Lin(1);
   {wait for a key}
   Readln;

   {restore text mode};
   SetTextMode;
 end;
end.