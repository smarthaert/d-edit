// GenerationDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Mlita.h"
#include "GenerationDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CGenerationDlg dialog


CGenerationDlg::CGenerationDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CGenerationDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CGenerationDlg)
	m_Tops = 0;
	m_Edges = 0;
	m_Bounds = FALSE;
	m_Oriented = FALSE;
	m_Fluidized = FALSE;
	m_Positive = FALSE;
	m_HasCycles = FALSE;
	//}}AFX_DATA_INIT
}


void CGenerationDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CGenerationDlg)
	DDX_Text(pDX, IDC_EDIT1, m_Tops);
	DDV_MinMaxUInt(pDX, m_Tops, 1, 10);
	DDX_Text(pDX, IDC_EDIT2, m_Edges);
	DDX_Check(pDX, IDC_CHECK2, m_Bounds);
	DDX_Check(pDX, IDC_CHECK3, m_Oriented);
	DDX_Check(pDX, IDC_CHECK4, m_Fluidized);
	DDX_Check(pDX, IDC_CHECK5, m_Positive);
	DDX_Check(pDX, IDC_CHECK6, m_HasCycles);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CGenerationDlg, CDialog)
	//{{AFX_MSG_MAP(CGenerationDlg)
		// NOTE: the ClassWizard will add message map macros here
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CGenerationDlg message handlers
