#if !defined(AFX_GRAPHCTRL_H__417A43A9_E39C_4E1E_ABD4_C3054601578A__INCLUDED_)
#define AFX_GRAPHCTRL_H__417A43A9_E39C_4E1E_ABD4_C3054601578A__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// Machine generated IDispatch wrapper class(es) created by Microsoft Visual C++

// NOTE: Do not modify the contents of this file.  If this class is regenerated by
//  Microsoft Visual C++, your modifications will be overwritten.

/////////////////////////////////////////////////////////////////////////////
// CGraphCtrl wrapper class

class CGraphCtrl : public CWnd
{
protected:
	DECLARE_DYNCREATE(CGraphCtrl)
public:
	CLSID const& GetClsid()
	{
		static CLSID const clsid
			= { 0x80b7cc80, 0xf4c3, 0x4eac, { 0x81, 0x74, 0xfd, 0x1f, 0x64, 0xd5, 0x2, 0x27 } };
		return clsid;
	}
	virtual BOOL Create(LPCTSTR lpszClassName,
		LPCTSTR lpszWindowName, DWORD dwStyle,
		const RECT& rect,
		CWnd* pParentWnd, UINT nID,
		CCreateContext* pContext = NULL)
	{ return CreateControl(GetClsid(), lpszWindowName, dwStyle, rect, pParentWnd, nID); }

    BOOL Create(LPCTSTR lpszWindowName, DWORD dwStyle,
		const RECT& rect, CWnd* pParentWnd, UINT nID,
		CFile* pPersist = NULL, BOOL bStorage = FALSE,
		BSTR bstrLicKey = NULL)
	{ return CreateControl(GetClsid(), lpszWindowName, dwStyle, rect, pParentWnd, nID,
		pPersist, bStorage, bstrLicKey); }

// Attributes
public:
	short GetTops();
	void SetTops(short);
	BOOL GetOriented();
	void SetOriented(BOOL);

// Operations
public:
	void SetEdge(long v1, long v2);
	void RemoveEdge(short v1, short v2);
	void AboutBox();
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_GRAPHCTRL_H__417A43A9_E39C_4E1E_ABD4_C3054601578A__INCLUDED_)