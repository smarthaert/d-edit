#if !defined(AFX_MATRIXCTRLPPG_H__25CF4702_3A92_4FFD_A0D5_D6E6EA1482E0__INCLUDED_)
#define AFX_MATRIXCTRLPPG_H__25CF4702_3A92_4FFD_A0D5_D6E6EA1482E0__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// MatrixCtrlPpg.h : Declaration of the CMatrixCtrlPropPage property page class.

////////////////////////////////////////////////////////////////////////////
// CMatrixCtrlPropPage : See MatrixCtrlPpg.cpp.cpp for implementation.

class CMatrixCtrlPropPage : public COlePropertyPage
{
	DECLARE_DYNCREATE(CMatrixCtrlPropPage)
	DECLARE_OLECREATE_EX(CMatrixCtrlPropPage)

// Constructor
public:
	CMatrixCtrlPropPage();

// Dialog Data
	//{{AFX_DATA(CMatrixCtrlPropPage)
	enum { IDD = IDD_PROPPAGE_MATRIXCTRL };
		// NOTE - ClassWizard will add data members here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA

// Implementation
protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Message maps
protected:
	//{{AFX_MSG(CMatrixCtrlPropPage)
		// NOTE - ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MATRIXCTRLPPG_H__25CF4702_3A92_4FFD_A0D5_D6E6EA1482E0__INCLUDED)
