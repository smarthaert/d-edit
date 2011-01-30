// MlitaDlg.h : header file
//
//{{AFX_INCLUDES()
#include "graphctrl.h"
//}}AFX_INCLUDES

#if !defined(AFX_MLITADLG_H__85581F07_D3DD_4A36_BE25_F86AB1BE8B50__INCLUDED_)
#define AFX_MLITADLG_H__85581F07_D3DD_4A36_BE25_F86AB1BE8B50__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CMlitaDlg dialog
class CGraphList;
class CGraph;

class CMlitaDlg : public CDialog
{
// Construction
public:
	CGraph* Current;
	CGraphList* m_GraphList;
	CMlitaDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CMlitaDlg)
	enum { IDD = IDD_MLITA_DIALOG };
	CGraphCtrl	m_GraphCtrl;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMlitaDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CMlitaDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnGraf();
	afx_msg void OnGrafExit();
	afx_msg void OnNewgrafGenerate();
	afx_msg void OnClose();
	afx_msg void OnCancelMode();
	afx_msg void OnButton1();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MLITADLG_H__85581F07_D3DD_4A36_BE25_F86AB1BE8B50__INCLUDED_)
