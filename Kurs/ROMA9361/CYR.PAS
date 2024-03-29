{**************************************************************************}
{                                                                          }
{        ����䨪��� Borland's Turbo Vision for Borland Pascal 7.0        }
{        (C) ���堭�� ������,1993                                          }
{        �.������,480004,�.������᪮�� 25,5                                }
{        ⥫(voice/data/fax) 8-(3272)-39-17-04,8-(3272)-28-38-80           }
{        e-mail:  madi@aebexc.alma-ata.su                                  }
{                                                                          }
{        � �⫨稥 �� ��㣨� ��⮤�� ��� �뤥����� ��㡮����             }
{        ॠ����樨, ����⮩ �ᯮ�짮�����, ����⪠���� ࠡ�⮩          }
{        ����� � ᯨ᮪ unit�� Cyr, ��⠢�� �� App.Run CyrPatch.        }
{        � ��砥 �ᯮ�짮����� STDDLG,MSGBOX,EDITORS ����� ��ॢ���      }
{        ᮮ�饭�� �� ���᪨� ��� ��㣮� ��ਫ��� ��.                  }
{**************************************************************************}
{     �ਬ�� �ᯮ�짮�����:                                                }
{     uses Driver,Cyr,App;                                                 }
{     const                                                                }
{      cmFind = 101;                                                       }
{      cmReplace = 102;                                                    }
{      cmSearchAgain = 103;                                                }
{     type PApp=^TApp;                                                     }
{          TApp=object(TApplication)                                       }
{           constructor Init;                                              }
{           procedure InitMenuBar;virtual;                                 }
{          end;                                                            }
{     constructor TApp.Init;                                               }
{     begin                                                                }
{          inherited Init;                                                 }
{          CyrPatch;                                                       }
{     end;                                                                 }
{     procedure TApp.InitMenuBar;                                          }
{     var                                                                  }
{          R: TRect;                                                       }
{     begin                                                                }
{          GetExtent(R);                                                   }
{          R.B.Y := R.A.Y + 1;                                             }
{          MenuBar := New(PMenuBar, Init(R, NewMenu(                       }
{          NewSubMenu('~�~���', hcNoContext, NewMenu(                     }
{            NewItem('~�~���...', '', kbNoKey, cmFind, hcNoContext,       }
{            NewItem('~�~�������...', '', kbNoKey, cmReplace, hcNoContext, }
{            NewItem('~�~த������', '', kbNoKey,cmSearchAgain,hcNoContext,}
{            nil)))),                                                      }
{          nil)))));                                                       }
{      end;                                                                }
{      begin                                                               }
{         TApp.Init;                                                       }
{         TApp.Run;                                                        }
{         TApp.Done;                                                       }
{      end.                                                                }
{                                                                          }
{**************************************************************************}

{$F+}

unit Cyr;

interface

uses Drivers;

procedure CyrPatch;

implementation

type CharFunc=function(KeyCode:Word):char;
     WordFunc=function(Ch:char):Word;
     UpCaseFunc=function(Ch:char):char;

function SubGetAltChar(KeyCode:word):char;
begin
    case KeyCode of
      kbAltQ:SubGetAltChar:='�';
      kbAltW:SubGetAltChar:='�';
      kbAltE:SubGetAltChar:='�';
      kbAltR:SubGetAltChar:='�';
      kbAltT:SubGetAltChar:='�';
      kbAltY:SubGetAltChar:='�';
      kbAltU:SubGetAltChar:='�';
      kbAltI:SubGetAltChar:='�';
      kbAltO:SubGetAltChar:='�';
      kbAltP:SubGetAltChar:='�';
      $1a00 :SubGetAltChar:='�';
      $1b00 :SubGetAltChar:='�';
      kbAltA:SubGetAltChar:='�';
      kbAltS:SubGetAltChar:='�';
      kbAltD:SubGetAltChar:='�';
      kbAltF:SubGetAltChar:='�';
      kbAltG:SubGetAltChar:='�';
      kbAltH:SubGetAltChar:='�';
      kbAltJ:SubGetAltChar:='�';
      kbAltK:SubGetAltChar:='�';
      kbAltL:SubGetAltChar:='�';
      $2700 :SubGetAltChar:='�';
      $2800 :SubGetAltChar:='�';
      kbAltZ:SubGetAltChar:='�';
      kbAltX:SubGetAltChar:='�';
      kbAltC:SubGetAltChar:='�';
      kbAltV:SubGetAltChar:='�';
      kbAltB:SubGetAltChar:='�';
      kbAltN:SubGetAltChar:='�';
      kbAltM:SubGetAltChar:='�';
      $3300 :SubGetAltChar:='�';
      $3400 :SubGetAltChar:='�';
      $3500 :SubGetAltChar:='�';
      else  SubGetAltChar:=#0
    end;
end;
function SubGetAltCode(Ch:char):word;
begin
    case Ch of
     '�':SubGetAltCode:= kbAltQ;
     '�':SubGetAltCode:= kbAltW;
     '�':SubGetAltCode:= kbAltE;
     '�':SubGetAltCode:= kbAltR;
     '�':SubGetAltCode:= kbAltT;
     '�':SubGetAltCode:= kbAltY;
     '�':SubGetAltCode:= kbAltU;
     '�':SubGetAltCode:= kbAltI;
     '�':SubGetAltCode:= kbAltO;
     '�':SubGetAltCode:= kbAltP;
     '�':SubGetAltCode:= $1a00 ;
     '�':SubGetAltCode:= $1b00 ;
     '�':SubGetAltCode:= kbAltA;
     '�':SubGetAltCode:= kbAltS;
     '�':SubGetAltCode:= kbAltD;
     '�':SubGetAltCode:= kbAltF;
     '�':SubGetAltCode:= kbAltG;
     '�':SubGetAltCode:= kbAltH;
     '�':SubGetAltCode:= kbAltJ;
     '�':SubGetAltCode:= kbAltK;
     '�':SubGetAltCode:= kbAltL;
     '�':SubGetAltCode:= $2700 ;
     '�':SubGetAltCode:= $2800 ;
     '�':SubGetAltCode:= kbAltZ;
     '�':SubGetAltCode:= kbAltX;
     '�':SubGetAltCode:= kbAltC;
     '�':SubGetAltCode:= kbAltV;
     '�':SubGetAltCode:= kbAltB;
     '�':SubGetAltCode:= kbAltN;
     '�':SubGetAltCode:= kbAltM;
     '�':SubGetAltCode:= $3300 ;
     '�':SubGetAltCode:= $3400 ;
     '�':SubGetAltCode:= $3500 ;
      else  SubGetAltCode:=0;
    end;
end;


procedure CyrPatch;
var
  fp:CharFunc;{� C ⠪�� ����⮢ �� �뫮 ��}
  fs:CharFunc;
  wfp:WordFunc;
  wfs:WordFunc;
  cfs:UpCaseFunc;
  cfp:UpCaseFunc;
  c:char;
label lb,_upcase,_32,_ex,_rus,_rus2,_end;{�����騥 �ணࠬ����� �� ������
                                          �ਬ����� goto,jmp}
begin
   fp:=GetAltChar;
   fs:=SubGetAltChar;
   asm
       push es
       push ds
       les di,fp
       lds si,fs
       mov ax,0eah
       mov es:[di],ax
       mov es:[di+1],si
       mov ax,ds
       mov es:[di+3],ax
       pop ds
       pop es
   end;

   wfp:=GetAltCode;
   wfs:=SubGetAltCode;
   asm {� �ਭ樯� �� ����� ᮯ⨬���஢���}
       push es
       push ds
       les di,wfp
       lds si,wfs
       mov ax,0eah
       mov es:[di],ax
       mov es:[di+1],si
       mov ax,ds
       mov es:[di+3],ax
       pop ds
       pop es
   end;
  lb:
   c:=UpCase(c);
   asm
       push es
       lea bx,cs:lb
       add bx,5
       les di,cs:[bx]
       lea si,_upcase
       mov ax,0eah
       mov es:[di],ax
       mov es:[di+1],si
       mov ax,cs
       mov es:[di+3],ax
       pop es
       jmp _end;
   _upcase:
       mov bx,sp
       mov al,ss:[bx+4]
       cmp al,'a'
       jb  _ex
       cmp al,'z'
       ja  _rus
   _32:sub al,32d
       retf 2
  _rus:cmp al,'�'
       jb _ex
       cmp al,'�'
       ja _rus2
       jmp _32
 _rus2:cmp al,'�'
       jb _ex
       cmp al,'�'
       ja _ex
       sub al,80d
  _ex: retf 2
  _end:
 end;
end;
end.
{http://www.warsh.com - ������⥪� �ணࠬ���� - http://bp.da.ru}
{����� 100 ��室�����, ����� �������� ���᪮� ���㬥��樨, �� ����?}
{������, ��ᬮ���! ���筮� �������樨!}
