#if !defined(AFX_GENERATIONDLG_H__FE88604E_7D5B_42BA_BD3D_25D2869D1C98__INCLUDED_)
#define AFX_GENERATIONDLG_H__FE88604E_7D5B_42BA_BD3D_25D2869D1C98__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// GenerationDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CGenerationDlg dialog

class CGenerationDlg : public CDialog
{
// Construction
public:
	CGenerationDlg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CGenerationDlg)
	enum { IDD = IDD_GENERATION };
	UINT	m_Tops;
	UINT	m_Edges;
	BOOL	m_Bounds;
	BOOL	m_Oriented;
	BOOL	m_Fluidized;
	BOOL	m_Positive;
	BOOL	m_HasCycles;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CGenerationDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CGenerationDlg)
		// NOTE: the ClassWizard will add member functions here
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	long* m_Graph;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_GENERATIONDLG_H__FE88604E_7D5B_42BA_BD3D_25D2869D1C98__INCLUDED_)
