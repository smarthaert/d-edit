; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CAboutDlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "Graph.h"

ClassCount=4
Class1=CGraphApp
Class2=CGraphDlg
Class3=CAboutDlg

ResourceCount=7
Resource1=IDD_ABOUTBOX
Resource2=IDR_MAINFRAME
Resource3=IDD_GRAPH_DIALOG
Resource4=IDD_ABOUTBOX (English (U.S.))
Resource5=IDD_PropertiesDlg
Class4=CPropertiesDlg
Resource6=IDD_GRAPH_DIALOG (English (U.S.))
Resource7=IDR_MENU1

[CLS:CGraphApp]
Type=0
HeaderFile=Graph.h
ImplementationFile=Graph.cpp
Filter=N

[CLS:CGraphDlg]
Type=0
HeaderFile=GraphDlg.h
ImplementationFile=GraphDlg.cpp
Filter=D
LastObject=ID_VIEW_SHOWPROPERTIESWINDOW
BaseClass=CDialog
VirtualFilter=dWC

[CLS:CAboutDlg]
Type=0
HeaderFile=GraphDlg.h
ImplementationFile=GraphDlg.cpp
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


[DLG:IDD_GRAPH_DIALOG]
Type=1
ControlCount=3
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_STATIC,static,1342308352
Class=CGraphDlg

[DLG:IDD_GRAPH_DIALOG (English (U.S.))]
Type=1
Class=CGraphDlg
ControlCount=0

[DLG:IDD_ABOUTBOX (English (U.S.))]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_PropertiesDlg]
Type=1
Class=CPropertiesDlg
ControlCount=9
Control1=IDC_CHECK1,button,1342242819
Control2=IDC_CHECK2,button,1342242819
Control3=IDC_CHECK3,button,1342242819
Control4=IDC_CHECK4,button,1342242819
Control5=IDC_EDIT1,edit,1350631552
Control6=IDC_STATIC,static,1342308352
Control7=IDC_STATIC,static,1342308352
Control8=IDC_EDIT2,edit,1350631552
Control9=IDC_BUTTON1,button,1342242816

[CLS:CPropertiesDlg]
Type=0
HeaderFile=PropertiesDlg.h
ImplementationFile=PropertiesDlg.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=ID_VIEW_SHOWPROPERTIESWINDOW

[MNU:IDR_MENU1]
Type=1
Class=?
Command1=ID_VIEW_SHOWPROPERTIESWINDOW
CommandCount=1

