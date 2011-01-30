// MatrixCtrlPpg.cpp : Implementation of the CMatrixCtrlPropPage property page class.

#include "stdafx.h"
#include "MatrixCtrl.h"
#include "MatrixCtrlPpg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


IMPLEMENT_DYNCREATE(CMatrixCtrlPropPage, COlePropertyPage)


/////////////////////////////////////////////////////////////////////////////
// Message map

BEGIN_MESSAGE_MAP(CMatrixCtrlPropPage, COlePropertyPage)
	//{{AFX_MSG_MAP(CMatrixCtrlPropPage)
	// NOTE - ClassWizard will add and remove message map entries
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Initialize class factory and guid

IMPLEMENT_OLECREATE_EX(CMatrixCtrlPropPage, "MATRIXCTRL.MatrixCtrlPropPage.1",
	0x94f47777, 0x2b0b, 0x497a, 0x94, 0x1e, 0, 0xa, 0xba, 0x58, 0x46, 0xd7)


/////////////////////////////////////////////////////////////////////////////
// CMatrixCtrlPropPage::CMatrixCtrlPropPageFactory::UpdateRegistry -
// Adds or removes system registry entries for CMatrixCtrlPropPage

BOOL CMatrixCtrlPropPage::CMatrixCtrlPropPageFactory::UpdateRegistry(BOOL bRegister)
{
	if (bRegister)
		return AfxOleRegisterPropertyPageClass(AfxGetInstanceHandle(),
			m_clsid, IDS_MATRIXCTRL_PPG);
	else
		return AfxOleUnregisterClass(m_clsid, NULL);
}


/////////////////////////////////////////////////////////////////////////////
// CMatrixCtrlPropPage::CMatrixCtrlPropPage - Constructor

CMatrixCtrlPropPage::CMatrixCtrlPropPage() :
	COlePropertyPage(IDD, IDS_MATRIXCTRL_PPG_CAPTION)
{
	//{{AFX_DATA_INIT(CMatrixCtrlPropPage)
	// NOTE: ClassWizard will add member initialization here
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA_INIT
}


/////////////////////////////////////////////////////////////////////////////
// CMatrixCtrlPropPage::DoDataExchange - Moves data between page and properties

void CMatrixCtrlPropPage::DoDataExchange(CDataExchange* pDX)
{
	//{{AFX_DATA_MAP(CMatrixCtrlPropPage)
	// NOTE: ClassWizard will add DDP, DDX, and DDV calls here
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA_MAP
	DDP_PostProcessing(pDX);
}


/////////////////////////////////////////////////////////////////////////////
// CMatrixCtrlPropPage message handlers
