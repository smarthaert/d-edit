// MatrixCtrlCtl.cpp : Implementation of the CMatrixCtrlCtrl ActiveX Control class.

#include "stdafx.h"
#include "MatrixCtrl.h"
#include "MatrixCtrlCtl.h"
#include "MatrixCtrlPpg.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


IMPLEMENT_DYNCREATE(CMatrixCtrlCtrl, COleControl)


/////////////////////////////////////////////////////////////////////////////
// Message map

BEGIN_MESSAGE_MAP(CMatrixCtrlCtrl, COleControl)
	//{{AFX_MSG_MAP(CMatrixCtrlCtrl)
	// NOTE - ClassWizard will add and remove message map entries
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG_MAP
	ON_OLEVERB(AFX_IDS_VERB_PROPERTIES, OnProperties)
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Dispatch map

BEGIN_DISPATCH_MAP(CMatrixCtrlCtrl, COleControl)
	//{{AFX_DISPATCH_MAP(CMatrixCtrlCtrl)
	DISP_PROPERTY_EX(CMatrixCtrlCtrl, "Tops", GetTops, SetTops, VT_I2)
	DISP_FUNCTION(CMatrixCtrlCtrl, "GetCell", GetCell, VT_I4, VTS_I2 VTS_I2)
	DISP_FUNCTION(CMatrixCtrlCtrl, "SetCell", SetCell, VT_EMPTY, VTS_I2 VTS_I2 VTS_I4)
	//}}AFX_DISPATCH_MAP
	DISP_FUNCTION_ID(CMatrixCtrlCtrl, "AboutBox", DISPID_ABOUTBOX, AboutBox, VT_EMPTY, VTS_NONE)
END_DISPATCH_MAP()


/////////////////////////////////////////////////////////////////////////////
// Event map

BEGIN_EVENT_MAP(CMatrixCtrlCtrl, COleControl)
	//{{AFX_EVENT_MAP(CMatrixCtrlCtrl)
	// NOTE - ClassWizard will add and remove event map entries
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_EVENT_MAP
END_EVENT_MAP()


/////////////////////////////////////////////////////////////////////////////
// Property pages

// TODO: Add more property pages as needed.  Remember to increase the count!
BEGIN_PROPPAGEIDS(CMatrixCtrlCtrl, 1)
	PROPPAGEID(CMatrixCtrlPropPage::guid)
END_PROPPAGEIDS(CMatrixCtrlCtrl)


/////////////////////////////////////////////////////////////////////////////
// Initialize class factory and guid

IMPLEMENT_OLECREATE_EX(CMatrixCtrlCtrl, "MATRIXCTRL.MatrixCtrlCtrl.1",
	0x18e58e6a, 0x2948, 0x4594, 0x84, 0x99, 0xc9, 0x8, 0x7f, 0xca, 0x3, 0x5f)


/////////////////////////////////////////////////////////////////////////////
// Type library ID and version

IMPLEMENT_OLETYPELIB(CMatrixCtrlCtrl, _tlid, _wVerMajor, _wVerMinor)


/////////////////////////////////////////////////////////////////////////////
// Interface IDs

const IID BASED_CODE IID_DMatrixCtrl =
		{ 0x3261f60, 0x4d07, 0x4e67, { 0x9a, 0x77, 0xb4, 0xd1, 0xc1, 0x95, 0x6e, 0x8f } };
const IID BASED_CODE IID_DMatrixCtrlEvents =
		{ 0x6ee255ed, 0xf4a9, 0x4288, { 0xa0, 0xa0, 0x6f, 0x6f, 0xca, 0x1c, 0xf9, 0xab } };


/////////////////////////////////////////////////////////////////////////////
// Control type information

static const DWORD BASED_CODE _dwMatrixCtrlOleMisc =
	OLEMISC_ACTIVATEWHENVISIBLE |
	OLEMISC_SETCLIENTSITEFIRST |
	OLEMISC_INSIDEOUT |
	OLEMISC_CANTLINKINSIDE |
	OLEMISC_RECOMPOSEONRESIZE;

IMPLEMENT_OLECTLTYPE(CMatrixCtrlCtrl, IDS_MATRIXCTRL, _dwMatrixCtrlOleMisc)


/////////////////////////////////////////////////////////////////////////////
// CMatrixCtrlCtrl::CMatrixCtrlCtrlFactory::UpdateRegistry -
// Adds or removes system registry entries for CMatrixCtrlCtrl

BOOL CMatrixCtrlCtrl::CMatrixCtrlCtrlFactory::UpdateRegistry(BOOL bRegister)
{
	// TODO: Verify that your control follows apartment-model threading rules.
	// Refer to MFC TechNote 64 for more information.
	// If your control does not conform to the apartment-model rules, then
	// you must modify the code below, changing the 6th parameter from
	// afxRegApartmentThreading to 0.

	if (bRegister)
		return AfxOleRegisterControlClass(
			AfxGetInstanceHandle(),
			m_clsid,
			m_lpszProgID,
			IDS_MATRIXCTRL,
			IDB_MATRIXCTRL,
			afxRegApartmentThreading,
			_dwMatrixCtrlOleMisc,
			_tlid,
			_wVerMajor,
			_wVerMinor);
	else
		return AfxOleUnregisterClass(m_clsid, m_lpszProgID);
}


/////////////////////////////////////////////////////////////////////////////
// CMatrixCtrlCtrl::CMatrixCtrlCtrl - Constructor

CMatrixCtrlCtrl::CMatrixCtrlCtrl()
{
	InitializeIIDs(&IID_DMatrixCtrl, &IID_DMatrixCtrlEvents);
	m_Tops=0;
	m_Matrix=NULL;
	// TODO: Initialize your control's instance data here.
}


/////////////////////////////////////////////////////////////////////////////
// CMatrixCtrlCtrl::~CMatrixCtrlCtrl - Destructor

CMatrixCtrlCtrl::~CMatrixCtrlCtrl()
{
	// TODO: Cleanup your control's instance data here.
	m_Tops=0;
	delete []m_Matrix;
}


/////////////////////////////////////////////////////////////////////////////
// CMatrixCtrlCtrl::OnDraw - Drawing function

void CMatrixCtrlCtrl::OnDraw(
			CDC* pdc, const CRect& rcBounds, const CRect& rcInvalid)
{
	// TODO: Replace the following code with your own drawing code.
	pdc->FillRect(rcBounds, CBrush::FromHandle((HBRUSH)GetStockObject(WHITE_BRUSH)));
	CString Text;
	for (int i=1; i<=m_Tops; i++) Text = Text + 
	pdc->DrawText(
}


/////////////////////////////////////////////////////////////////////////////
// CMatrixCtrlCtrl::DoPropExchange - Persistence support

void CMatrixCtrlCtrl::DoPropExchange(CPropExchange* pPX)
{
	ExchangeVersion(pPX, MAKELONG(_wVerMinor, _wVerMajor));
	COleControl::DoPropExchange(pPX);

	// TODO: Call PX_ functions for each persistent custom property.

}


/////////////////////////////////////////////////////////////////////////////
// CMatrixCtrlCtrl::OnResetState - Reset control to default state

void CMatrixCtrlCtrl::OnResetState()
{
	COleControl::OnResetState();  // Resets defaults found in DoPropExchange

	// TODO: Reset any other control state here.
}


/////////////////////////////////////////////////////////////////////////////
// CMatrixCtrlCtrl::AboutBox - Display an "About" box to the user

void CMatrixCtrlCtrl::AboutBox()
{
	CDialog dlgAbout(IDD_ABOUTBOX_MATRIXCTRL);
	dlgAbout.DoModal();
}


/////////////////////////////////////////////////////////////////////////////
// CMatrixCtrlCtrl message handlers

short CMatrixCtrlCtrl::GetTops() 
{
	// TODO: Add your property handler here
	
	return m_Tops;
}

void CMatrixCtrlCtrl::SetTops(short nNewValue) 
{
	// TODO: Add your property handler here
	delete []m_Matrix;
	m_Tops = nNewValue;
	m_Matrix = new int[m_Tops*m_Tops];
	ClearMatrix();
	SetModifiedFlag();
}

long CMatrixCtrlCtrl::GetCell(short i, short j) 
{
	// TODO: Add your dispatch handler code here

	return m_Matrix[(i-1)*m_Tops+j-1];
}


void CMatrixCtrlCtrl::SetCell(short i, short j, long Value) 
{
	m_Matrix[(i-1)*m_Tops+j-1] = Value;
	SetModifiedFlag();
}

void CMatrixCtrlCtrl::ClearMetrix()
{
	for (int i=0; i<m_Tops*m_Tops; i++) m_Matrix[i] = 0;
}
