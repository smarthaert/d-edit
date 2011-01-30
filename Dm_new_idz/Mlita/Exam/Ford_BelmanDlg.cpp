// Ford_BelmanDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Exam.h"
#include "Ford_BelmanDlg.h"
#include "Alhoritms.h"
#include "Graph.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CFord_BelmanDlg dialog

extern CString CaptionText;

CFord_BelmanDlg::CFord_BelmanDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CFord_BelmanDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CFord_BelmanDlg)
	m_Destination = 0;
	m_Price = _T("");
	m_Source = 0;
	//}}AFX_DATA_INIT
}


void CFord_BelmanDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CFord_BelmanDlg)
	DDX_Control(pDX, IDC_Path, m_PathCtrl);
	DDX_Control(pDX, IDC_A, m_ACtrl);
	DDX_Text(pDX, IDC_Destination, m_Destination);
	DDX_Text(pDX, IDC_Price, m_Price);
	DDX_Text(pDX, IDC_Source, m_Source);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CFord_BelmanDlg, CDialog)
	//{{AFX_MSG_MAP(CFord_BelmanDlg)
	ON_BN_CLICKED(IDC_Start, OnStart)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFord_BelmanDlg message handlers

void CFord_BelmanDlg::OnStart() 
{
	MessageBox("Ford-Belman is not realized",CaptionText,MB_OK);
	return;
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
	CStack* PathStack=new CStack;
	int* A=new int[Tops*Tops];
	Ford_Belman(Graph,PathStack,A,m_Source,m_Destination,Price);
	m_ACtrl.SetCols(Tops+1);
	m_ACtrl.SetRows(Tops+1);
	for (int i=1; i<=Tops; i++) 
	{
		Text.Format("%d",i);
		m_ACtrl.SetTextMatrix(0,i,Text);
		m_ACtrl.SetTextMatrix(i,0,Text);
		m_ACtrl.SetColWidth(i,320);
	}
	m_ACtrl.SetColWidth(0,300);
	for (i=1; i<=Tops; i++)
	{
		for (int j=1; j<=Tops; j++)
		{
			if (A[(i-1)*Tops+j-1]==LARGE) Text="---"; else Text.Format("%d",A[(i-1)*Tops+j-1]);
			m_ACtrl.SetTextMatrix(i,j,Text);
		}
	}
	m_Price.Format("%d",Price);
	while (!PathStack->IsEmpty())
	{
		Text.Format("%d",PathStack->Pop());
		m_PathCtrl.AddString(Text);
	}
	delete PathStack;
	delete []A;

}
