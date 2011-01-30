{**************************************************************************}
{                                                                          }
{        Руссификатор Borland's Turbo Vision for Borland Pascal 7.0        }
{        (C) Сатханов Данияр,1993                                          }
{        г.Алматы,480004,у.Чайковского 25,5                                }
{        тел(voice/data/fax) 8-(3272)-39-17-04,8-(3272)-28-38-80           }
{        e-mail:  madi@aebexc.alma-ata.su                                  }
{                                                                          }
{        В отличие от других методов этот выделяется грубостью             }
{        реализации, простотой использования, безотказной работой          }
{        Внесите в список unitов Cyr, вставьте до App.Run CyrPatch.        }
{        В случае использования STDDLG,MSGBOX,EDITORS можно перевести      }
{        сообщения на русский или другой кириличный язык.                  }
{**************************************************************************}
{     Пример использования:                                                }
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
{          NewSubMenu('~П~оиск', hcNoContext, NewMenu(                     }
{            NewItem('~Н~айти...', '', kbNoKey, cmFind, hcNoContext,       }
{            NewItem('~З~аменить...', '', kbNoKey, cmReplace, hcNoContext, }
{            NewItem('~П~родолжить', '', kbNoKey,cmSearchAgain,hcNoContext,}
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
      kbAltQ:SubGetAltChar:='Й';
      kbAltW:SubGetAltChar:='Ц';
      kbAltE:SubGetAltChar:='У';
      kbAltR:SubGetAltChar:='К';
      kbAltT:SubGetAltChar:='Е';
      kbAltY:SubGetAltChar:='Н';
      kbAltU:SubGetAltChar:='Г';
      kbAltI:SubGetAltChar:='Ш';
      kbAltO:SubGetAltChar:='Щ';
      kbAltP:SubGetAltChar:='З';
      $1a00 :SubGetAltChar:='Х';
      $1b00 :SubGetAltChar:='Ъ';
      kbAltA:SubGetAltChar:='Ф';
      kbAltS:SubGetAltChar:='Ы';
      kbAltD:SubGetAltChar:='В';
      kbAltF:SubGetAltChar:='А';
      kbAltG:SubGetAltChar:='П';
      kbAltH:SubGetAltChar:='Р';
      kbAltJ:SubGetAltChar:='О';
      kbAltK:SubGetAltChar:='Л';
      kbAltL:SubGetAltChar:='Д';
      $2700 :SubGetAltChar:='Ж';
      $2800 :SubGetAltChar:='Э';
      kbAltZ:SubGetAltChar:='Я';
      kbAltX:SubGetAltChar:='Ч';
      kbAltC:SubGetAltChar:='С';
      kbAltV:SubGetAltChar:='М';
      kbAltB:SubGetAltChar:='И';
      kbAltN:SubGetAltChar:='Т';
      kbAltM:SubGetAltChar:='Ь';
      $3300 :SubGetAltChar:='Б';
      $3400 :SubGetAltChar:='Ю';
      $3500 :SubGetAltChar:='Ё';
      else  SubGetAltChar:=#0
    end;
end;
function SubGetAltCode(Ch:char):word;
begin
    case Ch of
     'Й':SubGetAltCode:= kbAltQ;
     'Ц':SubGetAltCode:= kbAltW;
     'У':SubGetAltCode:= kbAltE;
     'К':SubGetAltCode:= kbAltR;
     'Е':SubGetAltCode:= kbAltT;
     'Н':SubGetAltCode:= kbAltY;
     'Г':SubGetAltCode:= kbAltU;
     'Ш':SubGetAltCode:= kbAltI;
     'Щ':SubGetAltCode:= kbAltO;
     'З':SubGetAltCode:= kbAltP;
     'Х':SubGetAltCode:= $1a00 ;
     'Ъ':SubGetAltCode:= $1b00 ;
     'Ф':SubGetAltCode:= kbAltA;
     'Ы':SubGetAltCode:= kbAltS;
     'В':SubGetAltCode:= kbAltD;
     'А':SubGetAltCode:= kbAltF;
     'П':SubGetAltCode:= kbAltG;
     'Р':SubGetAltCode:= kbAltH;
     'О':SubGetAltCode:= kbAltJ;
     'Л':SubGetAltCode:= kbAltK;
     'Д':SubGetAltCode:= kbAltL;
     'Ж':SubGetAltCode:= $2700 ;
     'Э':SubGetAltCode:= $2800 ;
     'Я':SubGetAltCode:= kbAltZ;
     'Ч':SubGetAltCode:= kbAltX;
     'С':SubGetAltCode:= kbAltC;
     'М':SubGetAltCode:= kbAltV;
     'И':SubGetAltCode:= kbAltB;
     'Т':SubGetAltCode:= kbAltN;
     'Ь':SubGetAltCode:= kbAltM;
     'Б':SubGetAltCode:= $3300 ;
     'Ю':SubGetAltCode:= $3400 ;
     'Ё':SubGetAltCode:= $3500 ;
      else  SubGetAltCode:=0;
    end;
end;


procedure CyrPatch;
var
  fp:CharFunc;{в C таких извратов не было бы}
  fs:CharFunc;
  wfp:WordFunc;
  wfs:WordFunc;
  cfs:UpCaseFunc;
  cfp:UpCaseFunc;
  c:char;
label lb,_upcase,_32,_ex,_rus,_rus2,_end;{настоящие программисты не боятся
                                          применять goto,jmp}
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
   asm {В принципе это можно соптимизировать}
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
  _rus:cmp al,'а'
       jb _ex
       cmp al,'п'
       ja _rus2
       jmp _32
 _rus2:cmp al,'р'
       jb _ex
       cmp al,'я'
       ja _ex
       sub al,80d
  _ex: retf 2
  _end:
 end;
end;
end.
{http://www.warsh.com - Библиотека программиста - http://bp.da.ru}
{Более 100 исходников, более гигабайта русской документации, не верите?}
{Зайдите, посмотрите! Удачной компиляции!}
