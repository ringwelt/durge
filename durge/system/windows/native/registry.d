module durge.system.windows.native.registry;

version (Windows):

import durge.system.windows.native.common;

enum // Value Types
{
    REG_NONE                       = 0,
    REG_SZ                         = 1,
    REG_EXPAND_SZ                  = 2,
    REG_BINARY                     = 3,
    REG_DWORD_LITTLE_ENDIAN        = 4,
    REG_DWORD_BIG_ENDIAN           = 5,
    REG_LINK                       = 6,
    REG_MULTI_SZ                   = 7,
    REG_RESOURCE_LIST              = 8,
    REG_FULL_RESOURCE_DESCRIPTOR   = 9,
    REG_RESOURCE_REQUIREMENTS_LIST = 10,
    REG_QWORD_LITTLE_ENDIAN        = 11,

    REG_DWORD = REG_DWORD_LITTLE_ENDIAN,
    REG_QWORD = REG_QWORD_LITTLE_ENDIAN,
}

enum // Reserved Key Handles
{
    HKEY_CLASSES_ROOT                = cast (HKEY) cast (ULONG_PTR) cast (LONG) 0x80000000,
    HKEY_CURRENT_USER                = cast (HKEY) cast (ULONG_PTR) cast (LONG) 0x80000001,
    HKEY_LOCAL_MACHINE               = cast (HKEY) cast (ULONG_PTR) cast (LONG) 0x80000002,
    HKEY_USERS                       = cast (HKEY) cast (ULONG_PTR) cast (LONG) 0x80000003,
    HKEY_PERFORMANCE_DATA            = cast (HKEY) cast (ULONG_PTR) cast (LONG) 0x80000004,
    HKEY_CURRENT_CONFIG              = cast (HKEY) cast (ULONG_PTR) cast (LONG) 0x80000005,
    HKEY_DYN_DATA                    = cast (HKEY) cast (ULONG_PTR) cast (LONG) 0x80000006,
    HKEY_CURRENT_USER_LOCAL_SETTINGS = cast (HKEY) cast (ULONG_PTR) cast (LONG) 0x80000007,
    HKEY_PERFORMANCE_TEXT            = cast (HKEY) cast (ULONG_PTR) cast (LONG) 0x80000050,
    HKEY_PERFORMANCE_NLSTEXT         = cast (HKEY) cast (ULONG_PTR) cast (LONG) 0x80000060,
}

enum // Access Rights
{
    KEY_QUERY_VALUE        = 0x0001,
    KEY_SET_VALUE          = 0x0002,
    KEY_CREATE_SUB_KEY     = 0x0004,
    KEY_ENUMERATE_SUB_KEYS = 0x0008,
    KEY_NOTIFY             = 0x0010,
    KEY_CREATE_LINK        = 0x0020,
    KEY_WOW64_64KEY        = 0x0100,
    KEY_WOW64_32KEY        = 0x0200,
    KEY_WOW64_RES          = 0x0300,

    KEY_READ       = (STANDARD_RIGHTS_READ | KEY_QUERY_VALUE | KEY_ENUMERATE_SUB_KEYS | KEY_NOTIFY) & ~SYNCHRONIZE,
    KEY_WRITE      = (STANDARD_RIGHTS_WRITE | KEY_SET_VALUE | KEY_CREATE_SUB_KEY) & ~SYNCHRONIZE,
    KEY_EXECUTE    = KEY_READ & ~SYNCHRONIZE,
    KEY_ALL_ACCESS = (STANDARD_RIGHTS_ALL | KEY_QUERY_VALUE | KEY_SET_VALUE | KEY_CREATE_SUB_KEY | KEY_ENUMERATE_SUB_KEYS | KEY_NOTIFY | KEY_CREATE_LINK) & ~SYNCHRONIZE,
}

alias HANDLE      HKEY;
alias ACCESS_MASK REGSAM;

alias HKEY* PHKEY;

extern (Windows)
{
    nothrow:
    @nogc:

    LONG RegCloseKey(HKEY hKey);
    LONG RegOpenKeyExW(HKEY hKey, LPCWSTR lpSubKey, DWORD ulOptions, REGSAM samDesired, PHKEY phkResult);
    LONG RegQueryValueExW(HKEY hKey, LPCWSTR lpValueName, LPDWORD lpReserved, LPDWORD lpType, LPBYTE lpData, LPDWORD lpcbData);
}

alias RegOpenKeyExW RegOpenKeyEx;
alias RegQueryValueExW RegQueryValueEx;

VOID _RegCloseKey(HKEY hKey)
{
    LONG result = RegCloseKey(hKey);

    if (result != ERROR_SUCCESS)
    {
        throw new WindowsException(result);
    }
}

string _RegGetStringValue(HKEY hKey, string subKey, string valueName)
{
    import std.string : chop;
    import std.utf : toUTF8, toUTF16z;

    HKEY hValueKey;

    _RegOpenKeyEx(hKey, subKey, KEY_QUERY_VALUE, &hValueKey);
    scope (exit) RegCloseKey(hValueKey);

    DWORD type;
    DWORD cbData = 255 << 1;

    WCHAR[] data = new WCHAR[(cbData >> 1) + 1];
    scope (exit) delete data;

    LONG result1 = _RegQueryValueEx(hValueKey, valueName, &type, cast (LPBYTE) data.ptr, &cbData);

    if (result1 == ERROR_FILE_NOT_FOUND)
    {
        return null;
    }

    if (type != REG_SZ && type != REG_EXPAND_SZ && type != REG_LINK)
    {
        return null;
    }

    if (result1 == ERROR_MORE_DATA)
    {
        delete data;
        data = new WCHAR[(cbData >> 1) + 1];

        LONG result2 = _RegQueryValueEx(hValueKey, valueName, null, cast (LPBYTE) data.ptr, &cbData);

        if (result2 != ERROR_SUCCESS)
        {
            throw new WindowsException(result2);
        }
    }

    data[(cbData >> 1)] = 0;
    return data[0..(cbData >> 1)].chop.toUTF8();
}

VOID _RegOpenKeyEx(HKEY hKey, string subKey, REGSAM samDesired, PHKEY phkResult)
{
    import std.utf : toUTF16z;

    LONG result = RegOpenKeyEx(hKey, subKey.toUTF16z(), 0, samDesired, phkResult);

    if (result != ERROR_SUCCESS)
    {
        throw new WindowsException(result);
    }
}

LONG _RegQueryValueEx(HKEY hKey, string valueName, LPDWORD lpType, LPBYTE lpData, LPDWORD lpcbData)
{
    import std.utf : toUTF16z;

    LONG result = RegQueryValueEx(hKey, valueName !is null ? valueName.toUTF16z() : null, null, lpType, lpData, lpcbData);

    if (result != ERROR_SUCCESS && result != ERROR_FILE_NOT_FOUND && result != ERROR_MORE_DATA)
    {
        throw new WindowsException(result);
    }

    return result;
}
