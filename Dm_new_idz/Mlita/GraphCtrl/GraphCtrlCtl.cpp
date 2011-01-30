// GraphCtrlCtl.cpp : Implementation of the CGraphCtrlCtrl ActiveX Control class.

#include "stdafx.h"
#include "GraphCtrl.h"
#include "GraphCtrlCtl.h"
#include "GraphCtrlPpg.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


IMPLEMENT_DYNCREATE(CGraphCtrlCtrl, COleControl)


/////////////////////////////////////////////////////////////////////////////
// Message map

BEGIN_MESSAGE_MAP(CGraphCtrlCtrl, COleControl)
	//{{AFX_MSG_MAP(CGraphCtrlCtrl)
	// NOTE - ClassWizard will add and remove message map entries
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG_MAP
	ON_OLEVERB(AFX_IDS_VERB_PROPERTIES, OnProperties)
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Dispatch map

BEGIN_DISPATCH_MAP(CGraphCtrlCtrl, COleControl)
	//{{AFX_DISPATCH_MAP(CGraphCtrlCtrl)
	DISP_PROPERTY_EX(CGraphCtrlCtrl, "Tops", GetTops, SetTops, VT_I2)
	DISP_PROPERTY_EX(CGraphCtrlCtrl, "Oriented", GetOriented, SetOriented, VT_BOOL)
	DISP_FUNCTION(CGraphCtrlCtrl, "SetEdge", SetEdge, VT_EMPTY, VTS_I4 VTS_I4)
	DISP_FUNCTION(CGraphCtrlCtrl, "RemoveEdge", RemoveEdge, VT_EMPTY, VTS_I2 VTS_I2)
	//}}AFX_DISPATCH_MAP
	DISP_FUNCTION_ID(CGraphCtrlCtrl, "AboutBox", DISPID_ABOUTBOX, AboutBox, VT_EMPTY, VTS_NONE)
END_DISPATCH_MAP()


/////////////////////////////////////////////////////////////////////////////
// Event map

BEGIN_EVENT_MAP(CGraphCtrlCtrl, COleControl)
	//{{AFX_EVENT_MAP(CGraphCtrlCtrl)
	// NOTE - ClassWizard will add and remove event map entries
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_EVENT_MAP
END_EVENT_MAP()


/////////////////////////////////////////////////////////////////////////////
// Property pages

// TODO: Add more property pages as needed.  Remember to increase the count!
BEGIN_PROPPAGEIDS(CGraphCtrlCtrl, 1)
	PROPPAGEID(CGraphCtrlPropPage::guid)
END_PROPPAGEIDS(CGraphCtrlCtrl)


/////////////////////////////////////////////////////////////////////////////
// Initialize class factory and guid

IMPLEMENT_OLECREATE_EX(CGraphCtrlCtrl, "GRAPHCTRL.GraphCtrlCtrl.1",
	0x80b7cc80, 0xf4c3, 0x4eac, 0x81, 0x74, 0xfd, 0x1f, 0x64, 0xd5, 0x2, 0x27)


/////////////////////////////////////////////////////////////////////////////
// Type library ID and version

IMPLEMENT_OLETYPELIB(CGraphCtrlCtrl, _tlid, _wVerMajor, _wVerMinor)


/////////////////////////////////////////////////////////////////////////////
// Interface IDs

const IID BASED_CODE IID_DGraphCtrl =
		{ 0x7c49fe05, 0x20a8, 0x42b0, { 0xbd, 0x79, 0x2c, 0xd7, 0xe2, 0x39, 0x71, 0xcc } };
const IID BASED_CODE IID_DGraphCtrlEvents =
		{ 0xe2b53d75, 0x4ebb, 0x4fd9, { 0x87, 0x16, 0xcf, 0x1, 0xad, 0x8, 0x5, 0xcd } };


/////////////////////////////////////////////////////////////////////////////
// Control type information

static const DWORD BASED_CODE _dwGraphCtrlOleMisc =
	OLEMISC_ACTIVATEWHENVISIBLE |
	OLEMISC_SETCLIENTSITEFIRST |
	OLEMISC_INSIDEOUT |
	OLEMISC_CANTLINKINSIDE |
	OLEMISC_RECOMPOSEONRESIZE;

IMPLEMENT_OLECTLTYPE(CGraphCtrlCtrl, IDS_GRAPHCTRL, _dwGraphCtrlOleMisc)


/////////////////////////////////////////////////////////////////////////////
// CGraphCtrlCtrl::CGraphCtrlCtrlFactory::UpdateRegistry -
// Adds or removes system registry entries for CGraphCtrlCtrl

BOOL CGraphCtrlCtrl::CGraphCtrlCtrlFactory::UpdateRegistry(BOOL bRegister)
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
			IDS_GRAPHCTRL,
			IDB_GRAPHCTRL,
			afxRegApartmentThreading,
			_dwGraphCtrlOleMisc,
			_tlid,
			_wVerMajor,
			_wVerMinor);
	else
		return AfxOleUnregisterClass(m_clsid, m_lpszProgID);
}


/////////////////////////////////////////////////////////////////////////////
// CGraphCtrlCtrl::CGraphCtrlCtrl - Constructor
CPoint V[100][100];

CGraphCtrlCtrl::CGraphCtrlCtrl()
{
	InitializeIIDs(&IID_DGraphCtrl, &IID_DGraphCtrlEvents);
	m_Tops=0;
	m_Oriented = 0;
	for (int i=0; i<100; i++)
		for (int j=0; j<100; j++) M[i][j] = 0;

	FILE *f=fopen("points.dat","rt");
	int Count=0,x,y;
	fscanf(f,"%d\n",&Count);
	for (i=1; i<=Count; i++)
	{
		for (int j=0; j<=i; j++)
		{
			fscanf(f,"%d %d",&x,&y);
			V[i][j].x=x;
			V[i][j].y=y;
		}
		fscanf(f,"\n");
	}
	fclose(f);
}


/////////////////////////////////////////////////////////////////////////////
// CGraphCtrlCtrl::~CGraphCtrlCtrl - Destructor

CGraphCtrlCtrl::~CGraphCtrlCtrl()
{
	// TODO: Cleanup your control's instance data here.
}


/////////////////////////////////////////////////////////////////////////////
// CGraphCtrlCtrl::OnDraw - Drawing function
CPoint GetPoint(int r, int v,int W, int H)
{
	CPoint Ret( (W*V[r][v].x) / V[r][0].x, (H*V[r][v].y)/V[r][0].y);
	return (Ret);
}
void Arraw(CDC* pdc, CPoint v1, CPoint v2, bool t)
{
	pdc->MoveTo(v1);
	pdc->LineTo(v2);
}

void CGraphCtrlCtrl::OnDraw(
			CDC* pdc, const CRect& rcBounds, const CRect& rcInvalid)
{
	pdc->FillRect(rcBounds, CBrush::FromHandle((HBRUSH)GetStockObject(WHITE_BRUSH)));
	for (int i=1; i<=m_Tops; i++)
	{
		
		pdc->Ellipse(GetPoint(m_Tops,i,rcBounds.Width(),rcBounds.Height()).x-2,
					 GetPoint(m_Tops,i,rcBounds.Width(),rcBounds.Height()).y-2,
					 GetPoint(m_Tops,i,rcBounds.Width(),rcBounds.Height()).x+2,
					 GetPoint(m_Tops,i,rcBounds.Width(),rcBounds.Height()).y+2);
	}
	for (i=1; i<=m_Tops; i++)
		for (int j=1; j<=m_Tops; j++)
		{
			if (M[i][j]) Arraw(pdc, GetPoint(m_Tops,i,rcBounds.Width(),rcBounds.Height()),
								 GetPoint(m_Tops,j,rcBounds.Width(),rcBounds.Height()),m_Oriented);
			}
//	pdc->LineTo(
}


/////////////////////////////////////////////////////////////////////////////
// CGraphCtrlCtrl::DoPropExchange - Persistence support

void CGraphCtrlCtrl::DoPropExchange(CPropExchange* pPX)
{
	ExchangeVersion(pPX, MAKELONG(_wVerMinor, _wVerMajor));
	COleControl::DoPropExchange(pPX);

	// TODO: Call PX_ functions for each persistent custom property.

}


/////////////////////////////////////////////////////////////////////////////
// CGraphCtrlCtrl::OnResetState - Reset control to default state

void CGraphCtrlCtrl::OnResetState()
{
	COleControl::OnResetState();  // Resets defaults found in DoPropExchange

	// TODO: Reset any other control state here.
}


/////////////////////////////////////////////////////////////////////////////
// CGraphCtrlCtrl::AboutBox - Display an "About" box to the user

void CGraphCtrlCtrl::AboutBox()
{
	CDialog dlgAbout(IDD_ABOUTBOX_GRAPHCTRL);
	dlgAbout.DoModal();
}


/////////////////////////////////////////////////////////////////////////////
// CGraphCtrlCtrl message handlers

short CGraphCtrlCtrl::GetTops() 
{
	// TODO: Add your property handler here
	return m_Tops;
}

void CGraphCtrlCtrl::SetTops(short nNewValue) 
{
	// TODO: Add your property handler here
	m_Tops = nNewValue;
	RemoveAllEdges();
	InvalidateControl();
	SetModifiedFlag();

}

void CGraphCtrlCtrl::SetEdge(long v1, long v2) 
{
	M[v1][v2] = 1;
	if (!m_Oriented) M[v2][v1]=1;
	InvalidateControl();
}

void CGraphCtrlCtrl::RemoveEdge(short v1, short v2) 
{
	M[v1][v2] = 0;
	if (!m_Oriented) M[v2][v1]=0;
	InvalidateControl();
}

BOOL CGraphCtrlCtrl::GetOriented() 
{
	// TODO: Add your property handler here

	return m_Oriented;
}

void CGraphCtrlCtrl::SetOriented(BOOL bNewValue) 
{
	// TODO: Add your property handler here
	m_Oriented = bNewValue;
	SetModifiedFlag();
}

void CGraphCtrlCtrl::RemoveAllEdges()
{
	for (int i=0; i<100; i++)
	for (int j=0; j<100; j++) M[i][j] = 0;
}
