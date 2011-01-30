//{{AFX_INCLUDES()
#include "msflexgrid.h"
//}}AFX_INCLUDES
#if !defined(AFX_FORD_BELMANDLG_H__081AEEAF_6DF5_4011_9824_9E3EF1C28FEC__INCLUDED_)
#define AFX_FORD_BELMANDLG_H__081AEEAF_6DF5_4011_9824_9E3EF1C28FEC__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// Ford_BelmanDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CFord_BelmanDlg dialog
class CGraph;

class CFord_BelmanDlg : public CDialog
{
// Construction
public:
	CGraph* Graph;
	CFord_BelmanDlg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CFord_BelmanDlg)
	enum { IDD = IDD_Ford_BelmanDlg };
	CListBox	m_PathCtrl;
	CMSFlexGrid	m_ACtrl;
	UINT	m_Destination;
	CString	m_Price;
	UINT	m_Source;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFord_BelmanDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CFord_BelmanDlg)
	afx_msg void OnStart();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FORD_BELMANDLG_H__081AEEAF_6DF5_4011_9824_9E3EF1C28FEC__INCLUDED_)
