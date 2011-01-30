; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CKraskalDlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "Exam.h"

ClassCount=10
Class1=CExamApp
Class2=CExamDlg
Class3=CAboutDlg

ResourceCount=11
Resource1=IDD_ABOUTBOX
Resource2=IDR_MAINFRAME
Resource3=IDD_EXAM_DIALOG
Resource4=IDD_EXAM_DIALOG (English (U.S.))
Resource5=IDD_SearchDlg
Class4=CPropertiesDlg
Class5=cmodaless
Resource6=IDD_FloydDlg
Class6=CAlhoritmsDlg
Resource7=IDD_ABOUTBOX (English (U.S.))
Class7=CSearchDlg
Resource8=IDD_PathDlg
Class8=CPathDlg
Resource9=IDD_AlhoritmDlg
Class9=CFloydDlg
Resource10=IDR_MENU1
Class10=CKraskalDlg
Resource11=IDD_KraskalDlg

[CLS:CExamApp]
Type=0
HeaderFile=Exam.h
ImplementationFile=Exam.cpp
Filter=N

[CLS:CExamDlg]
Type=0
HeaderFile=ExamDlg.h
ImplementationFile=ExamDlg.cpp
Filter=D
LastObject=CExamDlg
BaseClass=CDialog
VirtualFilter=dWC

[CLS:CAboutDlg]
Type=0
HeaderFile=ExamDlg.h
ImplementationFile=ExamDlg.cpp
Filter=D
LastObject=CAboutDlg

[DLG:IDD_ABOUTBOX]
Type=1
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308352
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889
Class=CAboutDlg


[DLG:IDD_EXAM_DIALOG]
Type=1
ControlCount=3
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_STATIC,static,1342308352
Class=CExamDlg

[DLG:IDD_EXAM_DIALOG (English (U.S.))]
Type=1
Class=CExamDlg
ControlCount=17
Control1=IDC_CHECK2,button,1342242819
Control2=IDC_CHECK3,button,1342242819
Control3=IDC_CHECK4,button,1342242819
Control4=IDC_CHECK6,button,1342242819
Control5=IDC_Tops,edit,1350639744
Control6=IDC_STATIC,static,1342308352
Control7=IDC_STATIC,static,1342308352
Control8=IDC_Edges,edit,1350639744
Control9=IDC_BUTTON2,button,1342242816
Control10=IDC_CHECK7,button,1342242819
Control11=IDC_EDIT,button,1476460544
Control12=IDC_MSFLEXGRID1,{6262D3A0-531B-11CF-91F6-C2863C385E30},1342242816
Control13=IDC_GRAPHCTRLCTRL1,{80B7CC80-F4C3-4EAC-8174-FD1F64D50227},1342242816
Control14=IDC_STATIC,static,1342308352
Control15=IDC_MSFLEXGRID2,{6262D3A0-531B-11CF-91F6-C2863C385E30},1342242816
Control16=IDC_Alhoritms,button,1342242816
Control17=IDC_STATIC,static,1342308352

[DLG:IDD_ABOUTBOX (English (U.S.))]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[CLS:CPropertiesDlg]
Type=0
HeaderFile=PropertiesDlg.h
ImplementationFile=PropertiesDlg.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=CPropertiesDlg

[MNU:IDR_MENU1]
Type=1
Class=?
Command1=ID_VIEW_SHOWPROPERTIESWINDOW
Command2=ID_HELP_ABOUT
CommandCount=2

[CLS:cmodaless]
Type=0
HeaderFile=cmodaless.h
ImplementationFile=cmodaless.cpp
BaseClass=CDialog
Filter=D
LastObject=cmodaless

[DLG:IDD_AlhoritmDlg]
Type=1
Class=CAlhoritmsDlg
ControlCount=8
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_Search_Deep,button,1342177289
Control4=IDC_Search_Width,button,1342177289
Control5=IDC_Dejikstra,button,1342177289
Control6=IDC_Floyd,button,1342177289
Control7=IDC_Kraskal,button,1342177289
Control8=IDC_Form_Belman,button,1342177289

[CLS:CAlhoritmsDlg]
Type=0
HeaderFile=AlhoritmsDlg.h
ImplementationFile=AlhoritmsDlg.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=CAlhoritmsDlg

[DLG:IDD_SearchDlg]
Type=1
Class=CSearchDlg
ControlCount=8
Control1=IDC_Start,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_Status,listbox,1352728833
Control4=IDC_StatusCaption,static,1342308352
Control5=IDC_STATIC,static,1342308352
Control6=IDC_Source,edit,1350631552
Control7=IDC_Labels,listbox,1352728833
Control8=IDC_STATIC,static,1342308352

[CLS:CSearchDlg]
Type=0
HeaderFile=SearchDlg.h
ImplementationFile=SearchDlg.cpp
BaseClass=CDialog
Filter=D
LastObject=CSearchDlg
VirtualFilter=dWC

[DLG:IDD_PathDlg]
Type=1
Class=CPathDlg
ControlCount=16
Control1=IDC_Start,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_STATIC,static,1342308352
Control4=IDC_Source,edit,1350631552
Control5=IDC_STATIC,static,1342308352
Control6=IDC_Destination,edit,1350631552
Control7=IDC_Path,listbox,1352728833
Control8=IDC_StatusCaption,static,1342308352
Control9=IDC_X,listbox,1352728833
Control10=IDC_STATIC,static,1342308353
Control11=IDC_H,listbox,1352728833
Control12=IDC_T,listbox,1352728833
Control13=IDC_STATIC,static,1342308353
Control14=IDC_STATIC,static,1342308353
Control15=IDC_STATIC,static,1342308352
Control16=IDC_Price,static,1342308352

[CLS:CPathDlg]
Type=0
HeaderFile=PathDlg.h
ImplementationFile=PathDlg.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=IDC_Destination

[DLG:IDD_FloydDlg]
Type=1
Class=CFloydDlg
ControlCount=12
Control1=IDC_Start,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_H,{6262D3A0-531B-11CF-91F6-C2863C385E30},1342242816
Control4=IDC_STATIC,static,1342308352
Control5=IDC_Source,edit,1350631552
Control6=IDC_STATIC,static,1342308352
Control7=IDC_Destination,edit,1350631552
Control8=IDC_STATIC,static,1342308352
Control9=IDC_Price,static,1342308352
Control10=IDC_Path,listbox,1352728833
Control11=IDC_StatusCaption,static,1342308352
Control12=IDC_T,{6262D3A0-531B-11CF-91F6-C2863C385E30},1342242816

[CLS:CFloydDlg]
Type=0
HeaderFile=FloydDlg.h
ImplementationFile=FloydDlg.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC

[DLG:IDD_KraskalDlg]
Type=1
Class=CKraskalDlg
ControlCount=6
Control1=IDC_Start,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_GraphCtrl,{80B7CC80-F4C3-4EAC-8174-FD1F64D50227},1342242816
Control4=IDC_STATIC,static,1342308352
Control5=IDC_STATIC,static,1342308352
Control6=IDC_TreeCtrl,listbox,1352728833

[CLS:CKraskalDlg]
Type=0
HeaderFile=KraskalDlg.h
ImplementationFile=KraskalDlg.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC

