module durge.event;

class EventArgs
{
	static this()
	{
		_empty = new EventArgs();
	}

	private static EventArgs _empty;
	static @property EventArgs empty()
	{
		return _empty;
	}
}

class CancelEventArgs : EventArgs
{
    bool cancel;
}

struct Event(TArgs...)
{
	alias void delegate(TArgs) THandler;
    private THandler[] _handlers;

    @property bool hasHandlers()
    {
        return _handlers !is null && _handlers.length > 0;
    }

    void opCall(TArgs args)
    {
        import std.algorithm.iteration : each;

		_handlers.each!(h => h(args));
    }

    void opOpAssign(string op)(THandler handler) if (op == "+")
	{
        _handlers ~= handler;
	}

    void opOpAssign(string op)(THandler handler) if (op == "-")
    {
        for (auto i = 0; i < _handlers.length; )
        {
            if (_handlers[i] is handler)
            {
                _handlers = _handlers[0 .. i] ~ _handlers[i + 1 .. $];
                continue;
            }

			i++;
        }
    }
}
