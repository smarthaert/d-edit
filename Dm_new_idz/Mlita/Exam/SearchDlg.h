#if !defined(AFX_SEARCHDLG_H__9B3DD7FF_0734_470A_BA52_3458A2EF5405__INCLUDED_)
#define AFX_SEARCHDLG_H__9B3DD7FF_0734_470A_BA52_3458A2EF5405__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// SearchDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CSearchDlg dialog
class CGraph;

class CSearchDlg : public CDialog
{
// Construction
public:
	int ID;
	CGraph* Graph;
	CString m_Caption;
	CSearchDlg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CSearchDlg)
	enum { IDD = IDD_SearchDlg };
	CListBox	m_LabelsCtrl;
	CListBox	m_StatusCtrl;
	UINT	m_Source;
	CString	m_StatusCaption;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSearchDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CSearchDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnStart();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SEARCHDLG_H__9B3DD7FF_0734_470A_BA52_3458A2EF5405__INCLUDED_)
