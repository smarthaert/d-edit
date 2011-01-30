// ExamDlg.h : header file
//
//{{AFX_INCLUDES()
#include "graphctrl.h"
#include "richtext.h"
#include "msflexgrid.h"
//}}AFX_INCLUDES

#if !defined(AFX_EXAMDLG_H__65DCCC4E_84B7_44DA_B202_5940403FDFB2__INCLUDED_)
#define AFX_EXAMDLG_H__65DCCC4E_84B7_44DA_B202_5940403FDFB2__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000



/////////////////////////////////////////////////////////////////////////////
// CExamDlg dialog
class CGraph;

class CExamDlg : public CDialog
{
// Construction
public:
	void Kraskal();
	void Floyd();
	void Path();
	void Search(int ID);
	void RefreshControls();
	void ShowGraph();
	CExamDlg(CWnd* pParent = NULL);	// standard constructor
	CGraph* m_Current;

// Dialog Data
	//{{AFX_DATA(CExamDlg)
	enum { IDD = IDD_EXAM_DIALOG };
	CButton	m_Alhoritms;
	CEdit	m_EdgesCtrl;
	CButton	m_EditBtn;
	CGraphCtrl	m_GraphCtrl;
	BOOL	m_Positive;
	BOOL	m_Oriented;
	BOOL	m_Linked;
	BOOL	m_Priced;
	BOOL	m_Cycled;
	UINT	m_Edges;
	UINT	m_Tops;
	CMSFlexGrid	m_Grid;
	CMSFlexGrid	m_PriceGrid;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExamDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CExamDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnClose();
	afx_msg void OnHelpAbout();
	afx_msg void OnGenerate();
	afx_msg void OnEdit();
	afx_msg void OnLinked();
	afx_msg void OnCycled();
	afx_msg void OnAlhoritms();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXAMDLG_H__65DCCC4E_84B7_44DA_B202_5940403FDFB2__INCLUDED_)
