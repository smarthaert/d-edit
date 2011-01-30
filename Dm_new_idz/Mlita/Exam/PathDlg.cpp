// PathDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Exam.h"
#include "PathDlg.h"
#include "Graph.h"
#include "Query.h"
#include "Alhoritms.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPathDlg dialog

extern CString CaptionText;

CPathDlg::CPathDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CPathDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CPathDlg)
	m_Destination = 0;
	m_Source = 0;
	m_Price = _T("");
	//}}AFX_DATA_INIT
}


void CPathDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPathDlg)
	DDX_Control(pDX, IDC_X, m_XCtrl);
	DDX_Control(pDX, IDC_T, m_TCtrl);
	DDX_Control(pDX, IDC_Path, m_PathCtrl);
	DDX_Control(pDX, IDC_H, m_HCtrl);
	DDX_Text(pDX, IDC_Destination, m_Destination);
	DDX_Text(pDX, IDC_Source, m_Source);
	DDX_Text(pDX, IDC_Price, m_Price);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CPathDlg, CDialog)
	//{{AFX_MSG_MAP(CPathDlg)
	ON_BN_CLICKED(IDC_Start, OnStart)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPathDlg message handlers

void CPathDlg::OnStart() 
{
	UpdateData();
	int Tops=Graph->GetTops();
	int Price;
	if (m_Source<1 || m_Source>Tops || m_Destination <1 || m_Destination > Tops)
	{
		MessageBox("Wrong parameter!",CaptionText,MB_OK);
		return;
	}
	while (m_PathCtrl.GetCount()>0) m_PathCtrl.DeleteString(0);
	while (m_XCtrl.GetCount()>0) m_XCtrl.DeleteString(0);
	while (m_HCtrl.GetCount()>0) m_HCtrl.DeleteString(0);
	while (m_TCtrl.GetCount()>0) m_TCtrl.DeleteString(0);

	int* X=new int[Graph->GetTops()];
	int* H=new int[Graph->GetTops()];
	int* T=new int[Graph->GetTops()];
	CStack* Path=new CStack;
	Dejikstra(Graph,Path,X,H,T,m_Source,m_Destination,Price);
	if (Price!=-1)
	{
		CString Text;
		while (!Path->IsEmpty())
		{
			Text.Format("%d",Path->Pop());
			m_PathCtrl.AddString(Text);
		}
		for (int i=0; i<Tops; i++) 
		{
			Text.Format("X[%d]=%d",i+1,X[i]);
			m_XCtrl.AddString(Text);
			Text.Format("H[%d]=%d",i+1,H[i]);
			m_HCtrl.AddString(Text);
			Text.Format("T[%d]=%d",i+1,T[i]);
			m_TCtrl.AddString(Text);
		}
		m_Price.Format("%d",Price);
	}
	else
	{
		m_PathCtrl.AddString("No Path");
		m_Price = "No path";
	}
	delete[] X;
	delete[] H;
	delete[] T;
	delete Path;
	UpdateData(0);
}
