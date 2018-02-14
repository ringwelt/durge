module durge.system.windows.native.common;

version (Windows):

import durge.common;
import durge.system.windows.native.windows;

enum // Boolean
{
	FALSE = 0,
    TRUE  = 1,
}

enum // Error Codes
{
    ERROR_SUCCESS           = 0x0000,
    ERROR_FILE_NOT_FOUND    = 0x0002,
	ERROR_INVALID_PARAMETER = 0x0057,
    ERROR_MORE_DATA         = 0x00EA,
    ERROR_MR_MID_NOT_FOUND  = 0x013D,
}

enum // COM Error Codes
{
    S_OK           = 0x00000000,
    S_FALSE        = 0x00000001,
    E_NOTIMPL      = 0x80004001,
    E_NOINTERFACE  = 0x80004002,
    E_POINTER      = 0x80004003,
    E_ABORT        = 0x80004004,
    E_FAIL         = 0x80004005,
    E_UNEXPECTED   = 0x8000FFFF,
    E_ACCESSDENIED = 0x80070005,
    E_HANDLE       = 0x80070006,
    E_OUTOFMEMORY  = 0x8007000E,
    E_INVALIDARG   = 0x80070057,

    CO_E_NOTINITIALIZED = 0x800401F0,
}

enum // Format Message
{
	FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x00000100U,
	FORMAT_MESSAGE_IGNORE_INSERTS  = 0x00000200U,
	FORMAT_MESSAGE_FROM_SYSTEM     = 0x00001000U,
}

enum // Message Box
{
    MB_OK              = 0x00000000U,
    MB_ICONEXCLAMATION = 0x00000030U,
}

enum // Access Rights
{
    DELETE       = 0x00010000,
    READ_CONTROL = 0x00020000,
    WRITE_DAC    = 0x00040000,
    WRITE_OWNER  = 0x00080000,
    SYNCHRONIZE  = 0x00100000,

    STANDARD_RIGHTS_REQUIRED = 0x000F0000,
    STANDARD_RIGHTS_ALL      = 0x001F0000,
    STANDARD_RIGHTS_READ     = READ_CONTROL,
    STANDARD_RIGHTS_WRITE    = READ_CONTROL,
    STANDARD_RIGHTS_EXECUTE  = READ_CONTROL,

    SPECIFIC_RIGHTS_ALL = 0x0000FFFF,

    GENERIC_ALL     = 0x10000000,
    GENERIC_EXECUTE = 0x20000000,
    GENERIC_WRITE   = 0x40000000,
    GENERIC_READ    = 0x80000000,
}

alias void   VOID;
alias int32  BOOL;
alias uint8  BOOLEAN;
alias uint8  BYTE;
alias uint16 WORD;
alias uint32 DWORD;
alias int16  SHORT;
alias uint16 USHORT;
alias int32  INT;
alias uint32 UINT;
alias int32  LONG;
alias uint32 ULONG;
alias int64  LONGLONG;
alias uint64 ULONGLONG;
alias char   CHAR;
alias uint8  UCHAR;
alias wchar  WCHAR;

alias VOID*      LPVOID;
alias BOOL*      LPBOOL;
alias BYTE*      LPBYTE;
alias WORD*      LPWORD;
alias DWORD*     LPDWORD;
alias SHORT*     LPSHORT;
alias USHORT*    LPUSHORT;
alias INT*       LPINT;
alias UINT*      LPUINT;
alias LONG*      LPLONG;
alias ULONG*     LPULONG;
alias LONGLONG*  LPLONGLONG;
alias ULONGLONG* LPULONGLONG;
alias WCHAR*     LPWSTR;

alias VOID*   PVOID;
alias USHORT* PUSHORT;
alias UINT*   PUINT;
alias ULONG*  PULONG;
alias CHAR*   PCHAR;

alias const (VOID)*  LPCVOID;
alias const (WCHAR)* LPCWSTR;

alias WORD   ATOM;
alias VOID*  HANDLE;
alias HANDLE HINSTANCE;
alias HANDLE HLOCAL;

version (Win32)
{
	alias uint32 UINT_PTR;
	alias int32  LONG_PTR;
    alias uint32 ULONG_PTR;
}

version (Win64)
{
	alias uint64 UINT_PTR;
	alias int64  LONG_PTR;
    alias uint64 ULONG_PTR;
}

alias LONG     HRESULT;
alias LONG_PTR LRESULT;
alias UINT_PTR WPARAM;
alias LONG_PTR LPARAM;
alias DWORD    ACCESS_MASK;

struct GUID
{
    static GUID empty;

    this(DWORD data1, WORD data2, WORD data3, BYTE[8] data4)
    {
        Data1 = data1;
        Data2 = data2;
        Data3 = data3;
        Data4 = data4;
    }

    DWORD   Data1;
    WORD    Data2;
    WORD    Data3;
    BYTE[8] Data4;
}

union LARGE_INTEGER
{
    struct
    {
        DWORD LowPart;
        LONG  HighPart;
    }
    LONGLONG QuadPart;
}

struct OVERLAPPED
{
    ULONG_PTR Internal;
    ULONG_PTR InternalHigh;
    union
    {
        struct
        {
            DWORD Offset;
            DWORD OffsetHigh;
        }
        PVOID Pointer;
    }
    HANDLE hEvent;
}

struct SECURITY_ATTRIBUTES
{
    DWORD  nLength;
    LPVOID lpSecurityDescriptor;
    BOOL   bInheritHandle;
}

alias GUID*                LPGUID;
alias LARGE_INTEGER*       PLARGE_INTEGER;
alias OVERLAPPED*          LPOVERLAPPED;
alias SECURITY_ATTRIBUTES* LPSECURITY_ATTRIBUTES;

alias GUID* REFGUID;
alias GUID  IID;
alias IID*  REFIID;

interface IUnknown
{
    extern (Windows):
    nothrow:
    @nogc:

    HRESULT QueryInterface(REFIID riid, LPVOID* ppvObj);
    ULONG AddRef();
    ULONG Release();
}

alias IUnknown LPUNKNOWN;

extern (Windows)
{
    nothrow:
    @nogc:

    BOOL CloseHandle(HANDLE hObject);
    DWORD FormatMessageW(DWORD dwFlags, LPCVOID lpSource, DWORD dwMessageId, DWORD dwLanguageId, LPWSTR lpBuffer, DWORD nSize, LPVOID* Arguments);
    DWORD GetLastError();
    HLOCAL LocalFree(HLOCAL hMem);
    INT MessageBoxW(HWND hWnd, LPCWSTR lpText, LPCWSTR lpCaption, UINT uType);
    VOID OutputDebugStringW(LPCWSTR lpOutputString) pure nothrow @safe;
    VOID SetLastError(DWORD dwErrCode);
}

alias FormatMessageW FormatMessage;
alias MessageBoxW MessageBox;
alias OutputDebugStringW OutputDebugString;

HRESULT MAKE_HRESULT(ULONG sev, ULONG fac, ULONG code)
{
    return cast (HRESULT) ((sev << 31) | (fac << 16) | code);
}

class WindowsException : Exception
{
	private DWORD _errorCode;

	this()
	{
		_errorCode = GetLastError();
        super(getErrorMessage(_errorCode));
	}

	this(DWORD errorCode)
	{
		_errorCode = errorCode;
        super(getErrorMessage(_errorCode));
	}

	this(DWORD errorCode, string message)
	{
		_errorCode = errorCode;
        super(message);
	}

    @property DWORD errorCode() { return _errorCode; }

	protected string getErrorMessage(DWORD errorCode)
	{
        import std.string : format;

        auto message = errorCode != ERROR_SUCCESS
            ? formatWindowsErrorMessage(errorCode)
            : "Unknown error.";

        if (message is null)
        {
            DWORD errorCode2 = GetLastError();

            if (errorCode2 == ERROR_MR_MID_NOT_FOUND)
            {
                message = "Unknown error. Cannot find message text.";
            }
            else
            {
                auto message2 = formatWindowsErrorMessage(errorCode2);

                message = message2 is null
                    ? "Unknown error. Format message returned with 0x%08X.".format(errorCode2)
                    : "Unknown error. Format message returned with 0x%08X: %s.".format(errorCode2, message2);
            }
        }

        return "0x%08X: %s".format(errorCode, message);
	}
}

private string formatWindowsErrorMessage(DWORD errorCode)
{
    import std.utf : toUTF8;

    LPWSTR lpBuffer;

    scope (exit) if (lpBuffer !is null)
    {
        LocalFree(lpBuffer);
        lpBuffer = null;
    }

    DWORD dwFlags = FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_IGNORE_INSERTS | FORMAT_MESSAGE_FROM_SYSTEM;
    DWORD charCount = FormatMessage(dwFlags, null, errorCode, 0, lpBuffer, 0, null);

    return charCount > 0
        ? lpBuffer[0..charCount].toUTF8()
        : null;
}

VOID _CloseHandle(HANDLE hObject)
{
    BOOL result = CloseHandle(hObject);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

nothrow @nogc VOID ReleaseAndSetNull(TObj : LPUNKNOWN)(ref TObj obj)
{
    if (obj !is null)
    {
        obj.Release();
        obj = null;
    }
}

VOID _ReleaseAndSetNull(TObj : LPUNKNOWN)(ref TObj obj)
{
    if (obj !is null)
    {
        obj.Release();
        obj = null;
    }
}
