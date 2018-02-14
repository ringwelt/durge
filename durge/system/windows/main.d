module durge.system.windows.main;

version (Windows):

import core.runtime;
import durge.common;
import durge.system.windows.native.common;
import durge.system.windows.engine;

extern (Windows)
INT WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPWSTR lpCmdLine, INT nCmdShow)
{
	INT result;

    Runtime.initialize();

	try
	{
        auto engine = new WindowsEngine(hInstance, Runtime.args);
        scope (exit) engine.dispose();

        result = engine.run();
	}
	catch (Throwable e)
	{
        import std.utf : toUTF16z;

        MessageBox(null, e.toStringEx().toUTF16z(), "Error".toUTF16z(), MB_OK | MB_ICONEXCLAMATION);
		result = 0;
	}

    Runtime.terminate();

    return result;
}

/*

Compatibility Fixes for Windows 10, Windows 8, Windows 7, and Windows Vista
https://docs.microsoft.com/en-us/windows/deployment/planning/compatibility-fixes-for-windows-8-windows-7-and-windows-vista


- 8And16BitAggregateBlts
Applications that are mitigated by 8/16-bit mitigation can exhibit performance issues. This layer aggregates all the blt operations and improves performance.

- 8And16BitDXMaxWinMode
Applications that use DX8/9 and are mitigated by the 8/16-bit mitigation are run in a maximized windowed mode. This layer mitigates applications that exhibit graphical corruption in full screen mode.

- 8And16BitGDIRedraw
This fix repairs applications that use GDI and that work in 8-bit color mode. The application is forced to repaint its window on RealizePalette.

- DWM8And16BitMitigation
The fix offers mitigation for applications that work in 8/16-bit display color mode because these legacy color modes are not supported in Windows 8.


*/
