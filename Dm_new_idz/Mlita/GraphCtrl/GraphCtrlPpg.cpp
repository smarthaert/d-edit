// GraphCtrlPpg.cpp : Implementation of the CGraphCtrlPropPage property page class.

#include "stdafx.h"
#include "GraphCtrl.h"
#include "GraphCtrlPpg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


IMPLEMENT_DYNCREATE(CGraphCtrlPropPage, COlePropertyPage)


/////////////////////////////////////////////////////////////////////////////
// Message map

BEGIN_MESSAGE_MAP(CGraphCtrlPropPage, COlePropertyPage)
	//{{AFX_MSG_MAP(CGraphCtrlPropPage)
	// NOTE - ClassWizard will add and remove message map entries
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Initialize class factory and guid

IMPLEMENT_OLECREATE_EX(CGraphCtrlPropPage, "GRAPHCTRL.GraphCtrlPropPage.1",
	0xa7d216c7, 0x4f58, 0x4609, 0xac, 0xfd, 0xa7, 0x7e, 0x5, 0xe4, 0x52, 0xc5)


/////////////////////////////////////////////////////////////////////////////
// CGraphCtrlPropPage::CGraphCtrlPropPageFactory::UpdateRegistry -
// Adds or removes system registry entries for CGraphCtrlPropPage

BOOL CGraphCtrlPropPage::CGraphCtrlPropPageFactory::UpdateRegistry(BOOL bRegister)
{
	if (bRegister)
		return AfxOleRegisterPropertyPageClass(AfxGetInstanceHandle(),
			m_clsid, IDS_GRAPHCTRL_PPG);
	else
		return AfxOleUnregisterClass(m_clsid, NULL);
}


/////////////////////////////////////////////////////////////////////////////
// CGraphCtrlPropPage::CGraphCtrlPropPage - Constructor

CGraphCtrlPropPage::CGraphCtrlPropPage() :
	COlePropertyPage(IDD, IDS_GRAPHCTRL_PPG_CAPTION)
{
	//{{AFX_DATA_INIT(CGraphCtrlPropPage)
	// NOTE: ClassWizard will add member initialization here
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA_INIT
}


/////////////////////////////////////////////////////////////////////////////
// CGraphCtrlPropPage::DoDataExchange - Moves data between page and properties

void CGraphCtrlPropPage::DoDataExchange(CDataExchange* pDX)
{
	//{{AFX_DATA_MAP(CGraphCtrlPropPage)
	// NOTE: ClassWizard will add DDP, DDX, and DDV calls here
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA_MAP
	DDP_PostProcessing(pDX);
}


/////////////////////////////////////////////////////////////////////////////
// CGraphCtrlPropPage message handlers
