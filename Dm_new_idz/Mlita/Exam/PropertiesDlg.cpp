// PropertiesDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Exam.h"
#include "PropertiesDlg.h"
#include "Graph.h"
#include "graphctrl.h"
#include "ExamDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPropertiesDlg dialog


CPropertiesDlg::CPropertiesDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CPropertiesDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CPropertiesDlg)
	m_Positive = FALSE;
	m_Oriented = FALSE;
	m_Linked = FALSE;
	m_Price = FALSE;
	m_Cycled = FALSE;
	m_Tops = 0;
	m_Edges = 0;
	m_Text = _T("");
	//}}AFX_DATA_INIT
}


void CPropertiesDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPropertiesDlg)
	DDX_Control(pDX, IDC_RICHEDIT1, m_TextCtrl);
	DDX_Check(pDX, IDC_CHECK1, m_Positive);
	DDX_Check(pDX, IDC_CHECK2, m_Oriented);
	DDX_Check(pDX, IDC_CHECK3, m_Linked);
	DDX_Check(pDX, IDC_CHECK4, m_Price);
	DDX_Check(pDX, IDC_CHECK5, m_Cycled);
	DDX_Text(pDX, IDC_EDIT1, m_Tops);
	DDX_Text(pDX, IDC_EDIT2, m_Edges);
	DDX_Text(pDX, IDC_RICHEDIT1, m_Text);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CPropertiesDlg, CDialog)
	//{{AFX_MSG_MAP(CPropertiesDlg)
	ON_BN_CLICKED(IDC_BUTTON1, OnGenerate)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPropertiesDlg message handlers
int FormStyle(bool a, bool b, bool c, bool d, bool e)
{
	int Style = 0;
	if (a) Style = Style | Gr_Positive;
	if (b) Style = Style | Gr_Oriented;
	if (c) Style = Style | Gr_Linked;
	if (d) Style = Style | Gr_Price;
	if (e) Style = Style | Gr_Cycled;
	return Style;
}

void CPropertiesDlg::OnGenerate() 
{
//  Data Checking!!!!!!!!!!!!!!! not realized
	m_Text="";
	UpdateData();
	if (MessageBox("No checking!","System Notification",MB_OKCANCEL | MB_ICONWARNING)==IDCANCEL) return;
	Add("Checking passed!\n");
	int Style=0;
	Style=FormStyle(m_Positive,m_Oriented,m_Linked,m_Price,m_Cycled);
	delete h_main->m_Current;
	h_main->m_Current = new CGraph(m_Tops,m_Edges,Style);
	h_main->ShowGraph();
}

void CPropertiesDlg::Add(CString Text)
{
	m_Text=m_Text+Text;
	UpdateData();
}
