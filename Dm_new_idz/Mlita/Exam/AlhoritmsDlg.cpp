// AlhoritmsDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Exam.h"
#include "AlhoritmsDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAlhoritmsDlg dialog


CAlhoritmsDlg::CAlhoritmsDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CAlhoritmsDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CAlhoritmsDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CAlhoritmsDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAlhoritmsDlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CAlhoritmsDlg, CDialog)
	//{{AFX_MSG_MAP(CAlhoritmsDlg)
	ON_WM_CANCELMODE()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CAlhoritmsDlg message handlers

BOOL CAlhoritmsDlg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	CheckDlgButton(IDC_Search_Deep,BST_CHECKED);	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}


void CAlhoritmsDlg::OnOK() 
{
	AlhoritmID=-1;
	for (int i=IDC_Search_Deep; i<=IDC_Form_Belman; i++)
	{
		if (IsDlgButtonChecked(i))
		{
			AlhoritmID=i-IDC_Search_Deep;
			break;
		}
	}
	
	CDialog::OnOK();
}
