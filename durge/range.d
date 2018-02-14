module durge.range;

import std.range.primitives;
import std.traits;

auto frontOrNull(Range)(Range r) if (isInputRange!(Unqual!Range))
{
    return !r.empty ? r.front : null;
}
