#if !defined(AFX_GRAPHCTRLCTL_H__EF20E2ED_ACCD_4595_8F9F_803DCE692370__INCLUDED_)
#define AFX_GRAPHCTRLCTL_H__EF20E2ED_ACCD_4595_8F9F_803DCE692370__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// GraphCtrlCtl.h : Declaration of the CGraphCtrlCtrl ActiveX Control class.

/////////////////////////////////////////////////////////////////////////////
// CGraphCtrlCtrl : See GraphCtrlCtl.cpp for implementation.

class CGraphCtrlCtrl : public COleControl
{
	DECLARE_DYNCREATE(CGraphCtrlCtrl)

// Constructor
public:
	CGraphCtrlCtrl();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CGraphCtrlCtrl)
	public:
	virtual void OnDraw(CDC* pdc, const CRect& rcBounds, const CRect& rcInvalid);
	virtual void DoPropExchange(CPropExchange* pPX);
	virtual void OnResetState();
	//}}AFX_VIRTUAL

// Implementation
protected:
	~CGraphCtrlCtrl();

	DECLARE_OLECREATE_EX(CGraphCtrlCtrl)    // Class factory and guid
	DECLARE_OLETYPELIB(CGraphCtrlCtrl)      // GetTypeInfo
	DECLARE_PROPPAGEIDS(CGraphCtrlCtrl)     // Property page IDs
	DECLARE_OLECTLTYPE(CGraphCtrlCtrl)		// Type name and misc status

// Message maps
	//{{AFX_MSG(CGraphCtrlCtrl)
		// NOTE - ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

// Dispatch maps
	//{{AFX_DISPATCH(CGraphCtrlCtrl)
	afx_msg short GetTops();
	afx_msg void SetTops(short nNewValue);
	afx_msg BOOL GetOriented();
	afx_msg void SetOriented(BOOL bNewValue);
	afx_msg void SetEdge(long v1, long v2);
	afx_msg void RemoveEdge(short v1, short v2);
	//}}AFX_DISPATCH
	DECLARE_DISPATCH_MAP()

	afx_msg void AboutBox();

// Event maps
	//{{AFX_EVENT(CGraphCtrlCtrl)
	//}}AFX_EVENT
	DECLARE_EVENT_MAP()

// Dispatch and event IDs
public:
	void RemoveAllEdges();
	bool m_Oriented;
	int M[100][100];
	int m_Tops;
	enum {
	//{{AFX_DISP_ID(CGraphCtrlCtrl)
	dispidTops = 1L,
	dispidOriented = 2L,
	dispidSetEdge = 3L,
	dispidRemoveEdge = 4L,
	//}}AFX_DISP_ID
	};
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_GRAPHCTRLCTL_H__EF20E2ED_ACCD_4595_8F9F_803DCE692370__INCLUDED)
