; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CMlitaDlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "Mlita.h"

ClassCount=4
Class1=CMlitaApp
Class2=CMlitaDlg
Class3=CAboutDlg

ResourceCount=8
Resource1=IDD_ABOUTBOX
Resource2=IDR_MAINFRAME
Resource3=IDD_MLITA_DIALOG
Resource4=IDD_GENERATION
Resource5=IDD_MLITA_DIALOG (English (U.S.))
Resource6=IDD_DIALOG1
Class4=CGenerationDlg
Resource7=IDD_ABOUTBOX (English (U.S.))
Resource8=Graph

[CLS:CMlitaApp]
Type=0
HeaderFile=Mlita.h
ImplementationFile=Mlita.cpp
Filter=N

[CLS:CMlitaDlg]
Type=0
HeaderFile=MlitaDlg.h
ImplementationFile=MlitaDlg.cpp
Filter=D
BaseClass=CDialog
VirtualFilter=dWC
LastObject=CMlitaDlg

[CLS:CAboutDlg]
Type=0
HeaderFile=MlitaDlg.h
ImplementationFile=MlitaDlg.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308352
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889
Class=CAboutDlg


[DLG:IDD_MLITA_DIALOG]
Type=1
ControlCount=3
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_STATIC,static,1342308352
Class=CMlitaDlg

[DLG:IDD_MLITA_DIALOG (English (U.S.))]
Type=1
Class=CMlitaDlg
ControlCount=4
Control1=IDC_BUTTON1,button,1342242816
Control2=IDC_GRAPHCTRLCTRL1,{80B7CC80-F4C3-4EAC-8174-FD1F64D50227},1342242816
Control3=IDC_DATAGRID1,{CDE57A43-8B86-11D0-B3C6-00A0C90AEA82},1342242816
Control4=IDC_MSFLEXGRID1,{6262D3A0-531B-11CF-91F6-C2863C385E30},1342242816

[DLG:IDD_ABOUTBOX (English (U.S.))]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_GENERATION]
Type=1
Class=CGenerationDlg
ControlCount=17
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_STATIC,button,1342177287
Control4=IDC_CHECK2,button,1342242819
Control5=IDC_CHECK3,button,1342242819
Control6=IDC_CHECK4,button,1342242819
Control7=IDC_CHECK5,button,1342242819
Control8=IDC_CHECK6,button,1342242819
Control9=IDC_STATIC,button,1342177287
Control10=IDC_STATIC,static,1342308352
Control11=IDC_STATIC,static,1342308352
Control12=IDC_STATIC,static,1342308352
Control13=IDC_STATIC,static,1342308352
Control14=IDC_EDIT1,edit,1350631552
Control15=IDC_EDIT2,edit,1350631552
Control16=IDC_EDIT3,edit,1350631552
Control17=IDC_EDIT4,edit,1350631552

[CLS:CGenerationDlg]
Type=0
HeaderFile=GenerationDlg.h
ImplementationFile=GenerationDlg.cpp
BaseClass=CDialog
Filter=D
LastObject=CGenerationDlg
VirtualFilter=dWC

[DLG:IDD_DIALOG1]
Type=1
Class=?
ControlCount=3
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_RICHEDIT1,RICHEDIT,1350631552

[MNU:Graph]
Type=1
Class=?
Command1=ID_NEWGRAF_MANUAL
Command2=ID_NEWGRAF_GENERATE
Command3=ID_GRAF_LOAD
Command4=ID_GRAF_SAVE
Command5=ID_GRAF_EXIT
Command6=ID_EDITGRAF
CommandCount=6

