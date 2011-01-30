// PropertiesDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Graph.h"
#include "PropertiesDlg.h"

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
	m_Priced = FALSE;
	m_Tops = _T("");
	m_Edges = _T("");
	//}}AFX_DATA_INIT
}


void CPropertiesDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPropertiesDlg)
	DDX_Check(pDX, IDC_CHECK1, m_Positive);
	DDX_Check(pDX, IDC_CHECK2, m_Oriented);
	DDX_Check(pDX, IDC_CHECK3, m_Linked);
	DDX_Check(pDX, IDC_CHECK4, m_Priced);
	DDX_Text(pDX, IDC_EDIT1, m_Tops);
	DDX_Text(pDX, IDC_EDIT2, m_Edges);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CPropertiesDlg, CDialog)
	//{{AFX_MSG_MAP(CPropertiesDlg)
	ON_BN_CLICKED(IDC_BUTTON1, OnGenerate)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPropertiesDlg message handlers

BOOL CPropertiesDlg::OnInitDialog() 
{
	CDialog::OnInitDialog();	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CPropertiesDlg::OnGenerate() 
{
//  Data Checking!!!!!!!!!!!!!!! not realized
	if (MessageBox("No checking!","System Notification",MB_OKCANCEL | MB_ICONWARNING)==IDCANCEL) return;

}
