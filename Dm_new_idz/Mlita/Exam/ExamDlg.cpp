// ExamDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Exam.h"
#include "ExamDlg.h"
#include "graph.h"
#include "MSFlexGrid.h"
#include "AlhoritmsDlg.h"
#include "SearchDlg.h"
#include "PathDlg.h"
#include "FloydDlg.h"
#include "KraskalDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif
CString CaptionText="Exam message";
/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CExamDlg dialog

CExamDlg::CExamDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CExamDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CExamDlg)
	m_Positive = FALSE;
	m_Oriented = FALSE;
	m_Linked = FALSE;
	m_Priced = FALSE;
	m_Cycled = FALSE;
	m_Edges = 0;
	m_Tops = 0;
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CExamDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CExamDlg)
	DDX_Control(pDX, IDC_Alhoritms, m_Alhoritms);
	DDX_Control(pDX, IDC_EDIT2, m_EdgesCtrl);
	DDX_Control(pDX, IDC_EDIT, m_EditBtn);
	DDX_Control(pDX, IDC_GRAPHCTRLCTRL1, m_GraphCtrl);
	DDX_Check(pDX, IDC_CHECK2, m_Positive);
	DDX_Check(pDX, IDC_CHECK3, m_Oriented);
	DDX_Check(pDX, IDC_CHECK4, m_Linked);
	DDX_Check(pDX, IDC_CHECK6, m_Priced);
	DDX_Check(pDX, IDC_CHECK7, m_Cycled);
	DDX_Text(pDX, IDC_EDIT2, m_Edges);
	DDX_Text(pDX, IDC_EDIT3, m_Tops);
	DDX_Control(pDX, IDC_MSFLEXGRID1, m_Grid);
	DDX_Control(pDX, IDC_MSFLEXGRID2, m_PriceGrid);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CExamDlg, CDialog)
	//{{AFX_MSG_MAP(CExamDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_WM_CLOSE()
	ON_COMMAND(ID_HELP_ABOUT, OnHelpAbout)
	ON_BN_CLICKED(IDC_BUTTON2, OnGenerate)
	ON_BN_CLICKED(IDC_EDIT, OnEdit)
	ON_BN_CLICKED(IDC_CHECK4, OnLinked)
	ON_BN_CLICKED(IDC_CHECK7, OnCycled)
	ON_BN_CLICKED(IDC_Alhoritms, OnAlhoritms)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CExamDlg message handlers

BOOL CExamDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	m_Current = NULL;
	RefreshControls();
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CExamDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CExamDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CExamDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CExamDlg::OnClose() 
{
	delete m_Current;
	CDialog::OnClose();
}

void CExamDlg::OnHelpAbout() 
{
	CAboutDlg Dlg;
	Dlg.DoModal();
}

void CExamDlg::ShowGraph()
{
	if (m_Current && !m_Current->m_error)
	{
		m_GraphCtrl.SetTops(m_Current->GetTops());
		for (int i=1; i<=m_Current->GetTops(); i++)
		{
			char Text[10];
			sprintf(Text,"%d",i);
			m_Grid.SetTextMatrix(0,i,Text);
			m_Grid.SetTextMatrix(i,0,Text);
			m_PriceGrid.SetTextMatrix(0,i,Text);
			m_PriceGrid.SetTextMatrix(i,0,Text);
			for (int j=1; j<=m_Current->GetTops(); j++)
			{
				if (m_Current->IsLinked(i,j)) m_Grid.SetTextMatrix(i,j,"1"); else m_Grid.SetTextMatrix(i,j,"0");
				if (m_Current->IsLinked(i,j)) m_GraphCtrl.SetEdge(i,j);
				if (m_Current->GetPrice(i,j)==LARGECOST) sprintf(Text,"---"); else sprintf(Text,"%d",m_Current->GetPrice(i,j));
				m_PriceGrid.SetTextMatrix(i,j,Text);
			}
		}
	}
	else
	{
//		m_Info = "ads";
	}
}


int FormStyle(BOOL a, BOOL b, BOOL c, BOOL d, BOOL e)
{
	int Style = 0;
	if (a) Style = Style | Gr_Positive;
	if (b) Style = Style | Gr_Oriented;
	if (c) Style = Style | Gr_Linked;
	if (d) Style = Style | Gr_Price;
	if (e) Style = Style | Gr_Cycled;
	return Style;
}

void CExamDlg::OnGenerate() 
{
	UpdateData();
	m_GraphCtrl.SetTops(0);
	delete m_Current;
	m_Current=NULL;
	m_EditBtn.EnableWindow(FALSE);
	if (m_Edges > (m_Tops*m_Tops-m_Tops)/2)
	{
		MessageBox("Error Edges count bigger that max count",CaptionText,MB_OK);
		return;
	}
	if (m_Linked && m_Edges < m_Tops-1)
	{
		MessageBox("Error this graph cant be linked!",CaptionText,MB_OK);
		return;
	}
	if (!m_Cycled && m_Edges > m_Tops-1)
	{
		MessageBox("Error this graph must be cycled!",CaptionText,MB_OK);
		return;
	}
	m_Grid.SetCols(m_Tops+1);
	m_Grid.SetRows(m_Tops+1);
	for (unsigned int i=0; i<=m_Tops; i++) m_Grid.SetColWidth(i,300);
	int Style=0;
	Style=FormStyle(m_Positive,m_Oriented,m_Linked,m_Priced,m_Cycled);
	m_PriceGrid.SetCols(m_Tops+1);
	m_PriceGrid.SetRows(m_Tops+1);
   	for (i=0; i<=m_Tops; i++) m_PriceGrid.SetColWidth(i,320);
	m_Current = new CGraph(m_Tops,m_Edges,Style);
	ShowGraph();
	RefreshControls();
}


void CExamDlg::OnEdit() 
{
	
}

void CExamDlg::OnLinked() 
{
	RefreshControls();
}

void CExamDlg::OnCycled() 
{
	RefreshControls();	
}

void CExamDlg::RefreshControls()
{
	UpdateData();
	if (!m_Current) m_Alhoritms.EnableWindow(FALSE); else m_Alhoritms.EnableWindow(TRUE);
	if (m_Linked && !m_Cycled)
	{
		m_Edges=m_Tops-1;
		m_EdgesCtrl.EnableWindow(FALSE);
	}
	else m_EdgesCtrl.EnableWindow(TRUE);
	UpdateData(0);
}

void CExamDlg::OnAlhoritms() 
{
	if (m_Current->m_error) 
	{
		MessageBox("Generate correct graph first",CaptionText,MB_OK);
		return;
	}
	int AlhoritmID=-1;
	CAlhoritmsDlg Dlg;
	if (Dlg.DoModal()==IDOK)
	{
		switch (Dlg.AlhoritmID)
		{
		case 0:
			{
				Search(0);
				break;
			}
		case 1:
			{
				Search(1);
				break;
			}
		case 2:
			{
				Path();
				break;
			}
		case 3:
			{
				Floyd();
				break;
			}
		case 4:
			{
				Kraskal();
				break;
			}
		};
	}
}

void CExamDlg::Search(int ID)
{
	CSearchDlg Dlg;
	if (ID==0)
	{
		Dlg.m_StatusCaption = "Stack Status";
		Dlg.m_Caption = "Search into Deep";
	}
	else
	{
		Dlg.m_StatusCaption = "Query Status";
		Dlg.m_Caption="Search into Width";
	}
	Dlg.Graph = m_Current;
	Dlg.ID=ID;
	Dlg.DoModal();
}

void CExamDlg::Path()
{
	CPathDlg Dlg;
	Dlg.Graph=m_Current;
	Dlg.DoModal();
}

void CExamDlg::Floyd()
{
	CFloydDlg Dlg;
	Dlg.Graph=m_Current;
	Dlg.DoModal();
}

void CExamDlg::Kraskal()
{
	CKraskalDlg Dlg;
	Dlg.Graph = m_Current;
	Dlg.DoModal();
}
