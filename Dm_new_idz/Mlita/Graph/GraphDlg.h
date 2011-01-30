// GraphDlg.h : header file
//

#if !defined(AFX_GRAPHDLG_H__2B17DBD7_1C45_4E23_A327_11CC6318BB62__INCLUDED_)
#define AFX_GRAPHDLG_H__2B17DBD7_1C45_4E23_A327_11CC6318BB62__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CGraphDlg dialog
class CPropertiesDlg;
class CGraphDlg : public CDialog
{
// Construction
public:
	CGraph* m_Graph;
	CGraphDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CGraphDlg)
	enum { IDD = IDD_GRAPH_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CGraphDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CGraphDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnClose();
	afx_msg void OnViewShowpropertieswindow();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	CPropertiesDlg* pPropDlg;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_GRAPHDLG_H__2B17DBD7_1C45_4E23_A327_11CC6318BB62__INCLUDED_)
