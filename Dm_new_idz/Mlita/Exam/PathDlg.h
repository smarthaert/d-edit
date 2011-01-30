#if !defined(AFX_PATHDLG_H__6F20A092_1690_4E6C_B43F_664F9659DE65__INCLUDED_)
#define AFX_PATHDLG_H__6F20A092_1690_4E6C_B43F_664F9659DE65__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// PathDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CPathDlg dialog
class CGraph;

class CPathDlg : public CDialog
{
// Construction
public:
	CGraph* Graph;
	CString Caption;
	CPathDlg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CPathDlg)
	enum { IDD = IDD_PathDlg };
	CListBox	m_XCtrl;
	CListBox	m_TCtrl;
	CListBox	m_PathCtrl;
	CListBox	m_HCtrl;
	UINT	m_Destination;
	UINT	m_Source;
	CString	m_Price;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPathDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CPathDlg)
	afx_msg void OnStart();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PATHDLG_H__6F20A092_1690_4E6C_B43F_664F9659DE65__INCLUDED_)
