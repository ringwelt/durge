module durge.logger;

void log(T...)(string message, T args) //pure nothrow @safe
{
    version (Windows)
    {
        import std.format : format;
        import std.utf : toUTF16z;
        import durge.system.windows.native.common;

        OutputDebugString((message.format(args) ~ "\r\n").toUTF16z());
    }
}

void logn(T...)(string message, T args)
{
    version (Windows)
    {
        import std.format : format;
        import std.utf : toUTF16z;
        import durge.system.windows.native.common;

        OutputDebugString(message.format(args).toUTF16z());
    }
}
