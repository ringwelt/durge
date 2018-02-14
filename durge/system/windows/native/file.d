module durge.system.windows.native.file;

version (Windows):

import durge.system.windows.native.common;

enum // General
{
    INVALID_HANDLE_VALUE = -1,
}

enum // File Types
{
    FILE_TYPE_UNKNOWN = 0x0000,
    FILE_TYPE_DISK    = 0x0001,
    FILE_TYPE_CHAR    = 0x0002,
    FILE_TYPE_PIPE    = 0x0003,
    FILE_TYPE_REMOTE  = 0x8000,
}        

enum // Share Mode
{
    FILE_SHARE_READ   = 0x01,
    FILE_SHARE_WRITE  = 0x02,
    FILE_SHARE_DELETE = 0x04,
}        

enum // Creation Disposition
{
    CREATE_NEW        = 1,
    CREATE_ALWAYS     = 2,
    OPEN_EXISTING     = 3,
    OPEN_ALWAYS       = 4,
    TRUNCATE_EXISTING = 5,
}        

enum // File Flags
{
    FILE_FLAG_OPEN_NO_RECALL     = 0x00100000,
    FILE_FLAG_OPEN_REPARSE_POINT = 0x00200000,
    FILE_FLAG_SESSION_AWARE      = 0x00800000,
    FILE_FLAG_POSIX_SEMANTICS    = 0x01000000,
    FILE_FLAG_BACKUP_SEMANTICS   = 0x02000000,
    FILE_FLAG_DELETE_ON_CLOSE    = 0x04000000,
    FILE_FLAG_SEQUENTIAL_SCAN    = 0x08000000,
    FILE_FLAG_RANDOM_ACCESS      = 0x10000000,
    FILE_FLAG_NO_BUFFERING       = 0x20000000,
    FILE_FLAG_OVERLAPPED         = 0x40000000,
    FILE_FLAG_WRITE_THROUGH      = 0x80000000,
}        

enum // File Attributes
{
    FILE_ATTRIBUTE_READONLY  = 0x0001,
    FILE_ATTRIBUTE_HIDDEN    = 0x0002,
    FILE_ATTRIBUTE_SYSTEM    = 0x0004,
    FILE_ATTRIBUTE_ARCHIVE   = 0x0020,
    FILE_ATTRIBUTE_NORMAL    = 0x0080,
    FILE_ATTRIBUTE_TEMPORARY = 0x0100,
    FILE_ATTRIBUTE_OFFLINE   = 0x1000,
    FILE_ATTRIBUTE_ENCRYPTED = 0x4000,
}        

enum // Seek Origin
{
    FILE_BEGIN   = 0,
    FILE_CURRENT = 1,
    FILE_END     = 2,
}        

extern (Windows)
{
    nothrow:
    @nogc:

    HANDLE CreateFileW(LPCWSTR lpFileName, DWORD dwDesiredAccess, DWORD dwShareMode, LPSECURITY_ATTRIBUTES lpSecurityAttributes, DWORD dwCreationDisposition, DWORD dwFlagsAndAttributes, HANDLE hTemplateFile);
    BOOL FlushFileBuffers(HANDLE hFile);
    BOOL GetFileSizeEx(HANDLE hFile, PLARGE_INTEGER lpFileSize);
    DWORD GetFileType(HANDLE hFile);
    BOOL ReadFile(HANDLE hFile, LPVOID lpBuffer, DWORD nNumberOfBytesToRead, LPDWORD lpNumberOfBytesRead, LPOVERLAPPED lpOverlapped);
    BOOL SetEndOfFile(HANDLE hFile);
    BOOL SetFilePointerEx(HANDLE hFile, LARGE_INTEGER liDistanceToMove, PLARGE_INTEGER lpNewFilePointer, DWORD dwMoveMethod);
    BOOL WriteFile(HANDLE hFile, LPCVOID lpBuffer, DWORD nNumberOfBytesToWrite, LPDWORD lpNumberOfBytesWritten, LPOVERLAPPED lpOverlapped);
}

alias CreateFileW CreateFile;

HANDLE _CreateFile(string name, DWORD dwDesiredAccess, DWORD dwShareMode, DWORD dwCreationDisposition, DWORD dwFlagsAndAttributes)
{
    import std.utf : toUTF16z;

    HANDLE result = CreateFile(name.toUTF16z(), dwDesiredAccess, dwShareMode, null, dwCreationDisposition, dwFlagsAndAttributes, null);

    if (result == cast (HANDLE) INVALID_HANDLE_VALUE)
    {
        throw new WindowsException();
    }

    return result;
}

VOID _FlushFileBuffers(HANDLE hFile)
{
    BOOL result = FlushFileBuffers(hFile);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

LONGLONG _GetFilePointer(HANDLE hFile)
{
    LARGE_INTEGER liDistanceToMove;
    liDistanceToMove.QuadPart = 0;
    LARGE_INTEGER newFilePointer;

    BOOL result = SetFilePointerEx(hFile, liDistanceToMove, &newFilePointer, FILE_CURRENT);

    if (result == FALSE)
    {
        throw new WindowsException();
    }

    return newFilePointer.QuadPart;
}

LONGLONG _GetFileSize(HANDLE hFile)
{
    LARGE_INTEGER fileSize;
    BOOL result = GetFileSizeEx(hFile, &fileSize);

    if (result == FALSE)
    {
        throw new WindowsException();
    }

    return fileSize.QuadPart;
}

DWORD _GetFileType(HANDLE hFile)
{
    SetLastError(0);
    DWORD result = GetFileType(hFile);
    DWORD errorCode = GetLastError();

    if (result == FILE_TYPE_UNKNOWN && errorCode != 0)
    {
        throw new WindowsException(errorCode);
    }

    return result;
}

DWORD _ReadFile(HANDLE hFile, LPVOID lpBuffer, DWORD nNumberOfBytesToRead)
{
    DWORD numberOfBytesRead = 0;
    BOOL result = ReadFile(hFile, lpBuffer, nNumberOfBytesToRead, &numberOfBytesRead, null);

    if (result == FALSE)
    {
        throw new WindowsException();
    }

    return numberOfBytesRead;
}

VOID _SetEndOfFile(HANDLE hFile)
{
    BOOL result = SetEndOfFile(hFile);

    if (result == FALSE)
    {
        throw new WindowsException();
    }
}

LONGLONG _SetFilePointer(HANDLE hFile, LONGLONG distanceToMove, DWORD dwMoveMethod)
{
    LARGE_INTEGER liDistanceToMove, liNewFilePointer;
    liDistanceToMove.QuadPart = distanceToMove;

    BOOL result = SetFilePointerEx(hFile, liDistanceToMove, &liNewFilePointer, dwMoveMethod);

    if (result == FALSE)
    {
        throw new WindowsException();
    }

    return liNewFilePointer.QuadPart;
}

DWORD _WriteFile(HANDLE hFile, LPCVOID lpBuffer, DWORD nNumberOfBytesToWrite)
{
    DWORD numberOfBytesWritten = 0;
    BOOL result = WriteFile(hFile, lpBuffer, nNumberOfBytesToWrite, &numberOfBytesWritten, null);

    if (result == FALSE)
    {
        throw new WindowsException();
    }

    return numberOfBytesWritten;
}
