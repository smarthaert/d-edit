// KraskalDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Exam.h"
#include "KraskalDlg.h"
#include "Graph.h"
#include "Stack.h"
#include "Alhoritms.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CKraskalDlg dialog

extern CString CaptionText;

CKraskalDlg::CKraskalDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CKraskalDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CKraskalDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CKraskalDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CKraskalDlg)
	DDX_Control(pDX, IDC_TreeCtrl, m_TreeCtrl);
	DDX_Control(pDX, IDC_GraphCtrl, m_GraphCtrl);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CKraskalDlg, CDialog)
	//{{AFX_MSG_MAP(CKraskalDlg)
	ON_BN_CLICKED(IDC_Start, OnStart)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CKraskalDlg message handlers

void CKraskalDlg::OnStart() 
{
	if (!(Graph->GetStyle() & Gr_Linked))
	{
		MessageBox("Graph must be linked",CaptionText,MB_OK);
		return;
	}
	MessageBox("Kraskal Alhoritm is not realized",CaptionText,MB_OK);
	return;
	while (m_TreeCtrl.GetCount()>0) m_TreeCtrl.DeleteString(0);
	CStack* Stack=new CStack;
	Kraskal(Graph,Stack);
	ShowTree(Graph,Stack);
	delete Stack;
}

void CKraskalDlg::ShowTree(CGraph* Graph,CStack* Stack)
{
	m_GraphCtrl.SetTops(Graph->GetTops());
	int v=Stack->Pop();
	int u=0;
	while (!Stack->IsEmpty())
	{
		u=Stack->Pop();
		m_GraphCtrl.SetEdge(u,v);
		v=u;
	}
}
