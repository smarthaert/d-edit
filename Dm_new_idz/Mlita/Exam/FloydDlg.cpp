// FloydDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Exam.h"
#include "FloydDlg.h"
#include "Graph.h"
#include "Query.h"
#include "Alhoritms.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CFloydDlg dialog
extern CString CaptionText;

CFloydDlg::CFloydDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CFloydDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CFloydDlg)
	m_Destination = 0;
	m_Price = _T("");
	m_Source = 0;
	//}}AFX_DATA_INIT
}


void CFloydDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CFloydDlg)
	DDX_Control(pDX, IDC_Path, m_PathCtrl);
	DDX_Text(pDX, IDC_Destination, m_Destination);
	DDX_Control(pDX, IDC_H, m_HCtrl);
	DDX_Text(pDX, IDC_Price, m_Price);
	DDX_Text(pDX, IDC_Source, m_Source);
	DDX_Control(pDX, IDC_T, m_TCtrl);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CFloydDlg, CDialog)
	//{{AFX_MSG_MAP(CFloydDlg)
	ON_BN_CLICKED(IDC_Start, OnStart)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFloydDlg message handlers

void CFloydDlg::OnStart() 
{
	int Price=0;
	CString Text;
	UpdateData();
	int Tops=Graph->GetTops();
 	if (m_Source<1 || m_Source>Tops || m_Destination <1 || m_Destination > Tops)
	{
		MessageBox("Wrong parameter!",CaptionText,MB_OK);
		return;
	}
	while (m_PathCtrl.GetCount()>0) m_PathCtrl.DeleteString(0);

	CQuery* PathQuery=new CQuery;
	int* T = new int[Tops*Tops];
	int* H = new int[Tops*Tops];
	Floyd(Graph,PathQuery, T, H, m_Source,m_Destination,Price);

	while (!PathQuery->IsEmpty())
	{
		Text.Format("%d",PathQuery->Pop());
		m_PathCtrl.AddString(Text);
	}
	m_TCtrl.SetCols(Tops+1);
	m_TCtrl.SetRows(Tops+1);
	m_HCtrl.SetCols(Tops+1);
	m_HCtrl.SetRows(Tops+1);
	
	for (int i=1; i<=Tops; i++) 
	{
		Text.Format("%d",i);
		m_HCtrl.SetTextMatrix(0,i,Text);
		m_HCtrl.SetTextMatrix(i,0,Text);
		m_TCtrl.SetTextMatrix(0,i,Text);
		m_TCtrl.SetTextMatrix(i,0,Text);
		m_HCtrl.SetColWidth(i,320);
		m_TCtrl.SetColWidth(i,320);
	}
	m_HCtrl.SetColWidth(0,300);
	m_TCtrl.SetColWidth(0,300);
	for (i=1; i<=Tops; i++)
	{
		for (int j=1; j<=Tops; j++)
		{
			Text.Format("%d",H[(i-1)*Tops+j-1]);
			m_HCtrl.SetTextMatrix(i,j,Text);
			Text.Format("%d",T[(i-1)*Tops+j-1]);
			m_TCtrl.SetTextMatrix(i,j,Text);
		}
	}
	m_Price.Format("%d",Price);
	delete []H;
	delete []T;
	delete PathQuery;
	UpdateData(0);
}
