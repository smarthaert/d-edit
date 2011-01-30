#if !defined(AFX_GRAPHCTRLPPG_H__C6A1025A_40BE_4090_A54C_15FC2B790A2C__INCLUDED_)
#define AFX_GRAPHCTRLPPG_H__C6A1025A_40BE_4090_A54C_15FC2B790A2C__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// GraphCtrlPpg.h : Declaration of the CGraphCtrlPropPage property page class.

////////////////////////////////////////////////////////////////////////////
// CGraphCtrlPropPage : See GraphCtrlPpg.cpp.cpp for implementation.

class CGraphCtrlPropPage : public COlePropertyPage
{
	DECLARE_DYNCREATE(CGraphCtrlPropPage)
	DECLARE_OLECREATE_EX(CGraphCtrlPropPage)

// Constructor
public:
	CGraphCtrlPropPage();

// Dialog Data
	//{{AFX_DATA(CGraphCtrlPropPage)
	enum { IDD = IDD_PROPPAGE_GRAPHCTRL };
		// NOTE - ClassWizard will add data members here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA

// Implementation
protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Message maps
protected:
	//{{AFX_MSG(CGraphCtrlPropPage)
		// NOTE - ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_GRAPHCTRLPPG_H__C6A1025A_40BE_4090_A54C_15FC2B790A2C__INCLUDED)
