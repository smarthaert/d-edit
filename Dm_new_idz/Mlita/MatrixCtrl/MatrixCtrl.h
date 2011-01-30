#if !defined(AFX_MATRIXCTRL_H__75AFEA79_853E_4C57_8149_94EB8653C706__INCLUDED_)
#define AFX_MATRIXCTRL_H__75AFEA79_853E_4C57_8149_94EB8653C706__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// MatrixCtrl.h : main header file for MATRIXCTRL.DLL

#if !defined( __AFXCTL_H__ )
	#error include 'afxctl.h' before including this file
#endif

#include "resource.h"       // main symbols

/////////////////////////////////////////////////////////////////////////////
// CMatrixCtrlApp : See MatrixCtrl.cpp for implementation.

class CMatrixCtrlApp : public COleControlModule
{
public:
	BOOL InitInstance();
	int ExitInstance();
};

extern const GUID CDECL _tlid;
extern const WORD _wVerMajor;
extern const WORD _wVerMinor;

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MATRIXCTRL_H__75AFEA79_853E_4C57_8149_94EB8653C706__INCLUDED)
