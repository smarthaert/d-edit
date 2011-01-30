#if !defined(AFX_ALHORITMSDLG_H__1B83D233_66F3_4C1B_932C_ABA1D01C6B12__INCLUDED_)
#define AFX_ALHORITMSDLG_H__1B83D233_66F3_4C1B_932C_ABA1D01C6B12__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// AlhoritmsDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CAlhoritmsDlg dialog

class CAlhoritmsDlg : public CDialog
{
// Construction
public:
	int AlhoritmID;
	CAlhoritmsDlg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CAlhoritmsDlg)
	enum { IDD = IDD_AlhoritmDlg };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAlhoritmsDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CAlhoritmsDlg)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_ALHORITMSDLG_H__1B83D233_66F3_4C1B_932C_ABA1D01C6B12__INCLUDED_)
