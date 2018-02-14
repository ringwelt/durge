module durge.system.windows.engine;

version (Windows):

import durge.common;
import durge.event;
import durge.draw.common;
import durge.system.display.manager;
import durge.system.input.manager;
import durge.system.console;
import durge.system.config;
import durge.system.engine;
import durge.system.frametimer;
import durge.system.windows.display;
import durge.system.windows.input;
import durge.system.windows.native;
import durge.system.windows.renderwindow;
import durge.system.windows.window;

final class WindowsEngine : Engine
{
    private HINSTANCE _instanceHandle;
	private RenderWindow _renderWindow;
    private WindowsInputManager _inputManager;
    private WindowsDisplayManager _displayManager;

	this(HINSTANCE instanceHandle, string[] args)
	{
        log("WindowsEngine.this()");

        enforceEx!ArgumentNullException(instanceHandle !is null, "instanceHandle");

		super(args);

		_instanceHandle = instanceHandle;
        _renderWindow = new RenderWindow(this, "durge");
        _inputManager = new WindowsInputManager(_renderWindow);
        _displayManager = new WindowsDisplayManager(_renderWindow);

        _renderWindow.activate += &renderWindowActivate;
        _renderWindow.input += &renderWindowInput;
        _renderWindow.inputDeviceChanged += &renderWindowInputDeviceChanged;
	}

    nothrow @nogc void dispose()
    {
        // Todo: remove events

        /*_renderWindow.activate -= &renderWindowActivate;
        _renderWindow.input -= &renderWindowInput;
        _renderWindow.inputDeviceChanged -= &renderWindowInputDeviceChanged;*/

        _displayManager.dispose();
        _inputManager.dispose();
        _renderWindow.dispose();
    }

    @property HINSTANCE instanceHandle() { return _instanceHandle; }
    @property RenderWindow renderWindow() { return _renderWindow; }

	override @property DisplayManager displayManager() { return _displayManager; }
	override @property InputManager inputManager() { return _inputManager; }

    protected override void update()
    {
        _inputManager.resetKeys();

        processMessages();

        super.update();
    }

	private void processMessages()
	{
		MSG msg;

		while (_PeekMessage(&msg, PM_REMOVE) == TRUE)
		{
			if (msg.message == WM_QUIT)
			{
				return;
			}

			_TranslateMessage(&msg);
			_DispatchMessage(&msg);
		}
	}

    protected override void render(Bitmap frameBuffer)
    {


        super.render(frameBuffer);
    }

    private void renderWindowActivate(Window window, WindowActivateEventArgs eventArgs)
    {
        log("WindowsEngine.renderWindowActivate()");

        if (eventArgs.active)
        {
            _displayManager.restoreDisplayMode(eventArgs.focus);

            if (eventArgs.focus)
            {
                _inputManager.initDevices();
                _inputManager.setEnabled(true);
                _inputManager.resetKeys(true);
            }
        }
        else
        {
            _inputManager.setEnabled(false);
            _inputManager.resetKeys(true);
            _displayManager.suspendDisplayMode();
        }
    }

    private void renderWindowInput(Window window, InputEventArgs eventArgs)
    {
        _inputManager.parseInput(eventArgs.hRawInput);
    }

    private void renderWindowInputDeviceChanged(Window window, InputDeviceChangedEventArgs eventArgs)
    {
        log("WindowsEngine.renderWindowInputDeviceChanged(0x%08X, %s)", eventArgs.hDevice, eventArgs.removed ? "rem" : "add");

        if (_renderWindow.focus)
        {
            if (_inputManager.initDevices())
            {
                _inputManager.setEnabled(true);
            }
        }
    }
}
