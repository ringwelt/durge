module durge.guard;

import std.exception : enforceEx;
import durge.error;

template isNotNull()
{
    T isNotNull(T : Object)(T value, string argName = "", string file = __FILE__, size_t line = __LINE__)
    {
        if (value is null)
        {
            throw new ArgumentNullException(argName, file, line);
        }

        return value;
    }
}
