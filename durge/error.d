module durge.error;

public import std.exception : enforceEx;

string toStringEx(Throwable e)
{
    auto msg = e.toString();

    while (e.next !is null)
    {
        e = e.next;
        msg ~= e.toString();
    }

    return msg;
}

class NotSupportedException : Exception
{
    this(string file = __FILE__, size_t line = __LINE__)
    {
        super("Not supported.", file, line);
    }
}

class ArgumentException : Exception
{
    this(string msg, string file = __FILE__, size_t line = __LINE__)
    {
        super(msg, file, line);
    }
}

class ArgumentNullException : Exception
{
    this(string argName, string file = __FILE__, size_t line = __LINE__)
    {
        super("Parameter " ~ argName ~ " must not be null.", file, line);
    }
}
