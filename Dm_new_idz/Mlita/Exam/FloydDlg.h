//{{AFX_INCLUDES()
#include "msflexgrid.h"
//}}AFX_INCLUDES
#if !defined(AFX_FLOYDDLG_H__107755FB_6F8B_477F_A04E_F719A4E76893__INCLUDED_)
#define AFX_FLOYDDLG_H__107755FB_6F8B_477F_A04E_F719A4E76893__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// FloydDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CFloydDlg dialog
class CGraph;

class CFloydDlg : public CDialog
{
// Construction
public:
	CGraph* Graph;
	CFloydDlg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CFloydDlg)
	enum { IDD = IDD_FloydDlg };
	CListBox	m_PathCtrl;
	UINT	m_Destination;
	CMSFlexGrid	m_HCtrl;
	CString	m_Price;
	UINT	m_Source;
	CMSFlexGrid	m_TCtrl;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFloydDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CFloydDlg)
	afx_msg void OnStart();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FLOYDDLG_H__107755FB_6F8B_477F_A04E_F719A4E76893__INCLUDED_)
