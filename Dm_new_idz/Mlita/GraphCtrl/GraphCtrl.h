#if !defined(AFX_GRAPHCTRL_H__F10AE677_5040_4FF1_ADC3_1EAAC2C7ECC8__INCLUDED_)
#define AFX_GRAPHCTRL_H__F10AE677_5040_4FF1_ADC3_1EAAC2C7ECC8__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// GraphCtrl.h : main header file for GRAPHCTRL.DLL

#if !defined( __AFXCTL_H__ )
	#error include 'afxctl.h' before including this file
#endif

#include "resource.h"       // main symbols

/////////////////////////////////////////////////////////////////////////////
// CGraphCtrlApp : See GraphCtrl.cpp for implementation.

class CGraphCtrlApp : public COleControlModule
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

#endif // !defined(AFX_GRAPHCTRL_H__F10AE677_5040_4FF1_ADC3_1EAAC2C7ECC8__INCLUDED)
