#if !defined(AFX_PROPERTIESDLG_H__542BF0B0_92A2_4731_BD1C_03AEC7ACD7FC__INCLUDED_)
#define AFX_PROPERTIESDLG_H__542BF0B0_92A2_4731_BD1C_03AEC7ACD7FC__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// PropertiesDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CPropertiesDlg dialog

class CPropertiesDlg : public CDialog
{
// Construction
public:
	CPropertiesDlg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CPropertiesDlg)
	enum { IDD = IDD_PropertiesDlg };
	BOOL	m_Positive;
	BOOL	m_Oriented;
	BOOL	m_Linked;
	BOOL	m_Priced;
	CString	m_Tops;
	CString	m_Edges;
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
	virtual BOOL OnInitDialog();
	afx_msg void OnGenerate();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PROPERTIESDLG_H__542BF0B0_92A2_4731_BD1C_03AEC7ACD7FC__INCLUDED_)
