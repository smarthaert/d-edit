#if !defined(AFX_MATRIXCTRLCTL_H__7210DF71_1030_4430_88E1_3B2B47A7A640__INCLUDED_)
#define AFX_MATRIXCTRLCTL_H__7210DF71_1030_4430_88E1_3B2B47A7A640__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// MatrixCtrlCtl.h : Declaration of the CMatrixCtrlCtrl ActiveX Control class.

/////////////////////////////////////////////////////////////////////////////
// CMatrixCtrlCtrl : See MatrixCtrlCtl.cpp for implementation.

class CMatrixCtrlCtrl : public COleControl
{
	DECLARE_DYNCREATE(CMatrixCtrlCtrl)

// Constructor
public:
	CMatrixCtrlCtrl();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMatrixCtrlCtrl)
	public:
	virtual void OnDraw(CDC* pdc, const CRect& rcBounds, const CRect& rcInvalid);
	virtual void DoPropExchange(CPropExchange* pPX);
	virtual void OnResetState();
	//}}AFX_VIRTUAL

// Implementation
protected:
	~CMatrixCtrlCtrl();

	DECLARE_OLECREATE_EX(CMatrixCtrlCtrl)    // Class factory and guid
	DECLARE_OLETYPELIB(CMatrixCtrlCtrl)      // GetTypeInfo
	DECLARE_PROPPAGEIDS(CMatrixCtrlCtrl)     // Property page IDs
	DECLARE_OLECTLTYPE(CMatrixCtrlCtrl)		// Type name and misc status

// Message maps
	//{{AFX_MSG(CMatrixCtrlCtrl)
		// NOTE - ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

// Dispatch maps
	//{{AFX_DISPATCH(CMatrixCtrlCtrl)
	afx_msg short GetTops();
	afx_msg void SetTops(short nNewValue);
	afx_msg long GetCell(short i, short j);
	afx_msg void SetCell(short i, short j, long Value);
	//}}AFX_DISPATCH
	DECLARE_DISPATCH_MAP()

	afx_msg void AboutBox();

// Event maps
	//{{AFX_EVENT(CMatrixCtrlCtrl)
	//}}AFX_EVENT
	DECLARE_EVENT_MAP()

// Dispatch and event IDs
public:
	void ClearMetrix();
	int* m_Matrix;
	int m_Tops;
	enum {
	//{{AFX_DISP_ID(CMatrixCtrlCtrl)
	dispidTops = 1L,
	dispidGetCell = 2L,
	dispidSetCell = 3L,
	//}}AFX_DISP_ID
	};
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MATRIXCTRLCTL_H__7210DF71_1030_4430_88E1_3B2B47A7A640__INCLUDED)
