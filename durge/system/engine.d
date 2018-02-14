module durge.system.engine;

import durge.common;
import durge.draw.common;
import durge.system.console;
import durge.system.config;
import durge.system.display;
import durge.system.input;
import durge.system.frametimer;

abstract class Engine
{
    private string[] _args;
    private Config _config;
    private Console _console;
    private FrameTimer _frameTimer;
    private bool _running;

	protected this(string[] args)
	{
        log("Engine.this()");

		_args = args;
        _config = new Config();
        _console = new Console(this);
        _frameTimer = new FrameTimer(60, 250);
        _running = true;

        console.init(args);
	}

	protected @property string[] args() { return _args; }
	protected @property Config config() { return _config; }
	protected @property Console console() { return _console; }
    protected @property FrameTimer frameTimer() { return _frameTimer; }
    protected @property bool running() { return _running; }
    protected @property void running(bool value) { _running = value; }

	protected abstract @property DisplayManager displayManager();
	protected abstract @property InputManager inputManager();

    protected void setDisplayMode(string driverName, int width, int height, int depth, int refreshRate, bool fullscreen)
    {
        log("Engine.setDisplayMode(%s, %s, %s, %s, %s, %s)", driverName, width, height, depth, refreshRate, fullscreen);

        enforceEx!ArgumentNullException(driverName !is null, "driverName");
        enforceEx!ArgumentException(width > 0, "Parameter width must be greater zero.");
        enforceEx!ArgumentException(height > 0, "Parameter height must be greater zero.");
        enforceEx!ArgumentException(depth == 8 || depth == 16 || depth == 32, "Parameter depth must be 8, 16 or 32.");
        enforceEx!ArgumentException(refreshRate >= 0, "Parameter refreshRate must be zero or greater.");

        scope (success)
        {
            _config.displayDriver = driverName;
            _config.width = width;
            _config.height = height;
            _config.depth = depth;
            _config.refreshRate = refreshRate;
            _config.fullscreen = fullscreen;
        }

        displayManager.setDisplayMode(driverName, width, height, depth, refreshRate, fullscreen);
    }

	int run()
	{
        log("Engine.run()");

        //checkDisplayModeCompatibility();

        setDisplayMode(config.displayDriver, config.width, config.height, config.depth, config.refreshRate, config.fullscreen);
        scope (exit) displayManager.resetDisplayMode();

        frameTimer.reset();

        while (running)
        {
            frameTimer.next();

            while (frameTimer.shouldUpdate)
            {
                update();
                frameTimer.update();
            }

            auto frameBuffer = displayManager.getFrameBuffer();

            if (frameBuffer !is null)
            {
                render(frameBuffer);
            }
        }

		return 0;
	}

    protected void update()
    {
        checkKeys();


    }

    protected void render(Bitmap frameBuffer)
    {
        //import core.thread;
        //Thread.sleep(msecs(35));

        /*for (auto y = 0; y < frameBuffer.height; y++)
        for (auto x = 0; x < frameBuffer.width; x++)
        {
            auto color = Color(x + y + frameTimer.frameIndex * 100);
            frameBuffer.drawer.setPixel(x, y, color);
        }*/

        frameBuffer.clip = false;
        auto i = 0, j = frameTimer.frameIndex;

        for (auto y = 0; y < frameBuffer.height; y++, i++, j++)
        {
            frameBuffer.drawer.color = Color(cast (uint8) (128 + (j >> 1)), cast (uint8) (128 - j), cast (uint8) (i + j));
            frameBuffer.drawer.hline(0, frameBuffer.maxx, y);
        }

        for (auto k = 0; k < 256; k++)
        {
            frameBuffer.drawer.color = Color.from8(cast (uint8) k);
            frameBuffer.drawer.vline(k, frameBuffer.maxy >> 2, frameBuffer.maxy >> 1);

            frameBuffer.drawer.color = Color(cast (uint8) k, cast (uint8) k, cast (uint8) k);
            frameBuffer.drawer.vline(frameBuffer.width - 256 + k, frameBuffer.maxy >> 2, frameBuffer.maxy >> 1);
        }

        //renderFramesPerSecond(frameBuffer);
        displayManager.flipFrameBuffers();
    }

    private void renderFramesPerSecond(Bitmap frameBuffer)
    {
        log("frameTimer: index: %s dur: %s crop: %s total: %s delta: %s lag: %s fps: %s",
            frameTimer.frameIndex,
            frameTimer.frameTime.total!("msecs"),
            frameTimer.croppedFrameTime.total!("msecs"),
            frameTimer.frameTotal.total!("msecs"),
            frameTimer.frameDelta.total!("msecs"),
            frameTimer.frameLag.total!("msecs"),
            frameTimer.framesPerSecond);

        // Todo: Engine.renderFramesPerSecond()
    }

    private void checkKeys()
    {
        import durge.system.windows.native.rawinput;

        if (inputManager.key(KeyCode.F1) || inputManager.key(KeyCode.F2) || inputManager.key(KeyCode.F3))
        {
            auto depth = inputManager.key(KeyCode.F1) ? 8 : inputManager.key(KeyCode.F2) ? 16 : 32;

            if (config.depth != depth)
            {
                setDisplayMode(config.displayDriver, config.width, config.height, depth, 0, config.fullscreen);
            }

            inputManager.resetKey(KeyCode.F1);
            inputManager.resetKey(KeyCode.F2);
            inputManager.resetKey(KeyCode.F3);
            return;
        }

        if (inputManager.getKey(KeyCode.F4, true))
        {
            running = false;
            return;
        }

        if (inputManager.getKey(KeyCode.F10, true))
        {
            auto driverName = config.displayDriver == "gdi" ? "ddraw" : "gdi";
            setDisplayMode(driverName, config.width, config.height, config.depth, 0, config.fullscreen);
            return;
        }

        if (inputManager.getKey(KeyCode.F11, true))
        {
            setDisplayMode(config.displayDriver, config.width, config.height, config.depth, 0, !config.fullscreen);
            return;
        }
    }
}
