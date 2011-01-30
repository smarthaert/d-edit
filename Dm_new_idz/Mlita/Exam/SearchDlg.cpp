// SearchDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Exam.h"
#include "SearchDlg.h"
#include "Graph.h"
#include "Alhoritms.h"
#include "Stack.h"
#include "Query.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CSearchDlg dialog
extern CString CaptionText;

CSearchDlg::CSearchDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CSearchDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CSearchDlg)
	m_Source = 0;
	m_StatusCaption = _T("");
	//}}AFX_DATA_INIT
}


void CSearchDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CSearchDlg)
	DDX_Control(pDX, IDC_Labels, m_LabelsCtrl);
	DDX_Control(pDX, IDC_Status, m_StatusCtrl);
	DDX_Text(pDX, IDC_Source, m_Source);
	DDX_Text(pDX, IDC_StatusCaption, m_StatusCaption);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CSearchDlg, CDialog)
	//{{AFX_MSG_MAP(CSearchDlg)
	ON_BN_CLICKED(IDC_Start, OnStart)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSearchDlg message handlers

BOOL CSearchDlg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	SetWindowText(m_Caption);	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CSearchDlg::OnStart() 
{
	UpdateData();
	if (m_Source<1 || (m_Source > (unsigned int)Graph->GetTops())) 
	{
		MessageBox("Wrong parameter!",CaptionText,MB_OK);
		return;
	}
	while (m_StatusCtrl.GetCount()>0) m_StatusCtrl.DeleteString(0);
	while (m_LabelsCtrl.GetCount()>0) m_LabelsCtrl.DeleteString(0);
	int* X=new int[Graph->GetTops()];
	CQuery* Query = new CQuery;
    if (ID==0)
	{
		Search_Into_Deep(Graph,Query,X,m_Source);
	}
	else
	{
		Search_Into_Width(Graph,Query,X,m_Source);
	}
	CString Text;
	while (!Query->IsEmpty())
	{
		Text.Format("%d",Query->Pop());
		m_StatusCtrl.AddString(Text);
	}
	for (int i=0; i<Graph->GetTops(); i++) 
	{
		Text.Format("X[%d]=%d",i+1,X[i]);
		m_LabelsCtrl.AddString(Text);
	}
	delete Query;
	delete []X;

}
