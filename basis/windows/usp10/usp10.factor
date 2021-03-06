! Copyright (C) 2009 Doug Coleman.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.syntax alien.destructors ;
IN: windows.usp10

LIBRARY: usp10

C-STRUCT: SCRIPT_CONTROL
    { "DWORD" "flags" } ;

C-STRUCT: SCRIPT_STATE
    { "WORD" "flags" } ;

C-STRUCT: SCRIPT_ANALYSIS
    { "WORD" "flags" }
    { "SCRIPT_STATE" "s" } ;

C-STRUCT: SCRIPT_ITEM
    { "int" "iCharPos" }
    { "SCRIPT_ANALYSIS" "a" } ;

FUNCTION: HRESULT ScriptItemize (
    WCHAR* pwcInChars,
    int cInChars,
    int cMaxItems,
    SCRIPT_CONTROL* psControl,
    SCRIPT_STATE* psState,
    SCRIPT_ITEM* pItems,
    int* pcItems
) ;

FUNCTION: HRESULT ScriptLayout (
    int cRuns,
    BYTE* pbLevel,
    int* piVisualToLogical,
    int* piLogicalToVisual
) ;

C-ENUM: SCRIPT_JUSTIFY_NONE
SCRIPT_JUSTIFY_ARABIC_BLANK
SCRIPT_JUSTIFY_CHARACTER
SCRIPT_JUSTIFY_RESERVED1
SCRIPT_JUSTIFY_BLANK
SCRIPT_JUSTIFY_RESERVED2
SCRIPT_JUSTIFY_RESERVED3
SCRIPT_JUSTIFY_ARABIC_NORMAL
SCRIPT_JUSTIFY_ARABIC_KASHIDA
SCRIPT_JUSTIFY_ALEF
SCRIPT_JUSTIFY_HA
SCRIPT_JUSTIFY_RA
SCRIPT_JUSTIFY_BA
SCRIPT_JUSTIFY_BARA
SCRIPT_JUSTIFY_SEEN
SCRIPT_JUSTIFFY_RESERVED4 ;

C-STRUCT: SCRIPT_VISATTR
    { "WORD" "flags" } ;

FUNCTION: HRESULT ScriptShape (
    HDC hdc,
    SCRIPT_CACHE* psc,
    WCHAR* pwcChars,
    int cChars,
    int cMaxGlyphs,
    SCRIPT_ANALYSIS* psa,
    WORD* pwOutGlyphs,
    WORD* pwLogClust,
    SCRIPT_VISATTR* psva,
    int* pcGlyphs
) ;

C-STRUCT: GOFFSET
    { "LONG" "du" }
    { "LONG" "dv" } ;

FUNCTION: HRESULT ScriptPlace (
    HDC hdc,
    SCRIPT_CACHE* psc,
    WORD* pwGlyphs,
    int cGlyphs,
    SCRIPT_VISATTR* psva,
    SCRIPT_ANALYSIS* psa,
    int* piAdvance,
    GOFFSET* pGoffset,
    ABC* pABC
) ;

FUNCTION: HRESULT ScriptTextOut (
    HDC hdc,
    SCRIPT_CACHE* psc,
    int x,
    int y,
    UINT fuOptions,
    RECT* lprc,
    SCRIPT_ANALYSIS* psa,
    WCHAR* pwcReserved,
    int iReserved,
    WORD* pwGlyphs,
    int cGlyphs,
    int* piAdvance,
    int* piJustify,
    GOFFSET* pGoffset
) ;

FUNCTION: HRESULT ScriptJustify (
    SCRIPT_VISATTR* psva,
    int* piAdvance,
    int cGlyphs,
    int iDx,
    int iMinKashida,
    int* piJustify
) ;

C-STRUCT: SCRIPT_LOGATTR
    { "BYTE" "flags" } ;

FUNCTION: HRESULT ScriptBreak (
    WCHAR* pwcChars,
    int cChars,
    SCRIPT_ANALYSIS* psa,
    SCRIPT_LOGATTR* psla
) ;

FUNCTION: HRESULT ScriptCPtoX (
    int iCP,
    BOOL fTrailing,
    int cChars,
    int cGlyphs,
    WORD* pwLogClust,
    SCRIPT_VISATTR* psva,
    int* piAdvance,
    SCRIPT_ANALYSIS* psa,
    int* piX
) ;

FUNCTION: HRESULT ScriptXtoCP (
    int iCP,
    BOOL fTrailing,
    int cChars,
    int cGlyphs,
    WORD* pwLogClust,
    SCRIPT_VISATTR* psva,
    int* piAdvance,
    SCRIPT_ANALYSIS* psa,
    int* piCP,
    int* piTrailing
) ;

FUNCTION: HRESULT ScriptGetLogicalWidths (
    SCRIPT_ANALYSIS* psa,
    int cChars,
    int cGlyphs,
    int* piGlyphWidth,
    WORD* pwLogClust,
    SCRIPT_VISATTR* psva,
    int* piDx
) ;

FUNCTION: HRESULT ScriptApplyLogicalWidth (
    int* piDx,
    int cChars,
    int cGlyphs,
    WORD* pwLogClust,
    SCRIPT_VISATTR* psva,
    int* piAdvance,
    SCRIPT_ANALYSIS* psa,
    ABC* pABC,
    int* piJustify
) ;

FUNCTION: HRESULT ScriptGetCMap (
    HDC hdc,
    SCRIPT_CACHE* psc,
    WCHAR* pwcInChars,
    int cChars,
    DWORD dwFlags,
    WORD* pwOutGlyphs
) ;

FUNCTION: HRESULT ScriptGetGlyphABCWidth (
    HDC hdc,
    SCRIPT_CACHE* psc,
    WORD wGlyph,
    ABC* pABC
) ;

C-STRUCT: SCRIPT_PROPERTIES
    { "DWORD" "flags" } ;

FUNCTION: HRESULT ScriptGetProperties (
    SCRIPT_PROPERTIES*** ppSp,
    int* piNumScripts
) ;

C-STRUCT: SCRIPT_FONTPROPERTIES
    { "int" "cBytes" }
    { "WORD" "wgBlank" }
    { "WORD" "wgDefault" }
    { "WORD" "wgInvalid" }
    { "WORD" "wgKashida" }
    { "int" "iKashidaWidth" } ;

FUNCTION: HRESULT ScriptGetFontProperties (
    HDC hdc,
    SCRIPT_CACHE* psc,
    SCRIPT_FONTPROPERTIES* sfp
) ;

FUNCTION: HRESULT ScriptCacheGetHeight (
    HDC hdc,
    SCRIPT_CACHE* psc,
    long* tmHeight
) ;

CONSTANT: SSA_PASSWORD HEX: 00000001
CONSTANT: SSA_TAB HEX: 00000002
CONSTANT: SSA_CLIP HEX: 00000004
CONSTANT: SSA_FIT HEX: 00000008
CONSTANT: SSA_DZWG HEX: 00000010
CONSTANT: SSA_FALLBACK HEX: 00000020
CONSTANT: SSA_BREAK HEX: 00000040
CONSTANT: SSA_GLYPHS HEX: 00000080
CONSTANT: SSA_RTL HEX: 00000100
CONSTANT: SSA_GCP HEX: 00000200
CONSTANT: SSA_HOTKEY HEX: 00000400
CONSTANT: SSA_METAFILE HEX: 00000800
CONSTANT: SSA_LINK HEX: 00001000
CONSTANT: SSA_HIDEHOTKEY HEX: 00002000
CONSTANT: SSA_HOTKEYONLY HEX: 00002400
CONSTANT: SSA_FULLMEASURE HEX: 04000000
CONSTANT: SSA_LPKANSIFALLBACK HEX: 08000000
CONSTANT: SSA_PIDX HEX: 10000000
CONSTANT: SSA_LAYOUTRTL HEX: 20000000
CONSTANT: SSA_DONTGLYPH HEX: 40000000
CONSTANT: SSA_NOKASHIDA HEX: 80000000

C-STRUCT: SCRIPT_TABDEF
    { "int" "cTabStops" }
    { "int" "iScale" }
    { "int*" "pTabStops" }
    { "int" "iTabOrigin" } ;

TYPEDEF: void* SCRIPT_STRING_ANALYSIS

FUNCTION: HRESULT ScriptStringAnalyse (
    HDC hdc,
    void* pString,
    int cString,
    int cGlyphs,
    int iCharset,
    DWORD dwFlags,
    int iReqWidth,
    SCRIPT_CONTROL* psControl,
    SCRIPT_STATE* psState,
    int* piDx,
    SCRIPT_TABDEF* pTabDef,
    BYTE* pbInClass,
    SCRIPT_STRING_ANALYSIS* pssa
) ;

FUNCTION: HRESULT ScriptStringFree (
    SCRIPT_STRING_ANALYSIS* pssa
) ;

DESTRUCTOR: ScriptStringFree

FUNCTION: SIZE* ScriptString_pSize ( SCRIPT_STRING_ANALYSIS ssa ) ;

FUNCTION: int* ScriptString_pcOutChars ( SCRIPT_STRING_ANALYSIS ssa ) ;

FUNCTION: SCRIPT_LOGATTR* ScriptString_pLogAttr ( SCRIPT_STRING_ANALYSIS ssa ) ;

FUNCTION: HRESULT ScriptStringGetOrder (
    SCRIPT_STRING_ANALYSIS ssa,
    UINT* puOrder
) ;

FUNCTION: HRESULT ScriptStringCPtoX (
    SCRIPT_STRING_ANALYSIS ssa,
    int icp,
    BOOL fTrailing,
    int* pX
) ;

FUNCTION: HRESULT ScriptStringXtoCP (
    SCRIPT_STRING_ANALYSIS ssa,
    int iX,
    int* piCh,
    int* piTrailing
) ;

FUNCTION: HRESULT ScriptStringGetLogicalWidths (
    SCRIPT_STRING_ANALYSIS ssa,
    int* piDx
) ;

FUNCTION: HRESULT ScriptStringValidate (
    SCRIPT_STRING_ANALYSIS ssa
) ;

FUNCTION: HRESULT ScriptStringOut (
    SCRIPT_STRING_ANALYSIS ssa,
    int iX,
    int iY,
    UINT uOptions,
    RECT* prc,
    int iMinSel,
    int iMaxSel,
    BOOL fDisabled
) ;

CONSTANT: SIC_COMPLEX 1
CONSTANT: SIC_ASCIIDIGIT 2
CONSTANT: SIC_NEUTRAL 4

FUNCTION: HRESULT ScriptIsComplex (
    WCHAR* pwcInChars,
    int cInChars,
    DWORD dwFlags
) ;

C-STRUCT: SCRIPT_DIGITSUBSTITUTE
    { "DWORD" "flags" } ;

FUNCTION: HRESULT ScriptRecordDigitSubstitution (
    LCID Locale,
    SCRIPT_DIGITSUBSTITUTE* psds
) ;

CONSTANT: SCRIPT_DIGITSUBSTITUTE_CONTEXT 0
CONSTANT: SCRIPT_DIGITSUBSTITUTE_NONE 1
CONSTANT: SCRIPT_DIGITSUBSTITUTE_NATIONAL 2
CONSTANT: SCRIPT_DIGITSUBSTITUTE_TRADITIONAL 3

FUNCTION: HRESULT ScriptApplyDigitSubstitution (
    SCRIPT_DIGITSUBSTITUTE* psds,
    SCRIPT_CONTROL* psc,
    SCRIPT_STATE* pss
) ;