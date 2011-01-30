#if !defined(AFX_PROPERTIESDLG_H__EFBEFB82_61AD_4FDD_B42D_E6114AF808C8__INCLUDED_)
#define AFX_PROPERTIESDLG_H__EFBEFB82_61AD_4FDD_B42D_E6114AF808C8__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// PropertiesDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CPropertiesDlg dialog
class CExamDlg;

class CPropertiesDlg : public CDialog
{
// Construction
public:
	void Add(CString Text);
	CExamDlg* h_main;
	CPropertiesDlg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CPropertiesDlg)
	enum { IDD = IDD_PropertiesDlg };
	CRichEditCtrl	m_TextCtrl;
	BOOL	m_Positive;
	BOOL	m_Oriented;
	BOOL	m_Linked;
	BOOL	m_Price;
	BOOL	m_Cycled;
	UINT	m_Tops;
	UINT	m_Edges;
	CString	m_Text;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPropertiesDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CPropertiesDlg)
	afx_msg void OnGenerate();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PROPERTIESDLG_H__EFBEFB82_61AD_4FDD_B42D_E6114AF808C8__INCLUDED_)
