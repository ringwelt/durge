module durge.system.console;

import durge.common;
import durge.system.engine;

class Console
{
	private Engine _engine;

	this(Engine engine)
	{
        enforceEx!ArgumentNullException(engine !is null, "engine");

        _engine = engine;
	}

	@property Engine engine() { return this._engine; }

    void init(string[] args)
    {

    }
}
