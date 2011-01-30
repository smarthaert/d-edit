//{{AFX_INCLUDES()
#include "graphctrl.h"
//}}AFX_INCLUDES
#if !defined(AFX_KRASKALDLG_H__3B5E9912_F96B_4FC3_97A1_9FBB5C4BE076__INCLUDED_)
#define AFX_KRASKALDLG_H__3B5E9912_F96B_4FC3_97A1_9FBB5C4BE076__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// KraskalDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CKraskalDlg dialog
class CGraph;
class CStack;

class CKraskalDlg : public CDialog
{
// Construction
public:
	void ShowTree(CGraph* Graph, CStack* Stack);
	CGraph* Graph;
	CKraskalDlg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CKraskalDlg)
	enum { IDD = IDD_KraskalDlg };
	CListBox	m_TreeCtrl;
	CGraphCtrl	m_GraphCtrl;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CKraskalDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CKraskalDlg)
	afx_msg void OnStart();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_KRASKALDLG_H__3B5E9912_F96B_4FC3_97A1_9FBB5C4BE076__INCLUDED_)
