module durge.system.display.driver;

import durge.draw.bitmap;
import durge.system.display.modeinfo;

interface IDisplayDriver
{
    @property string name();

    nothrow @nogc void dispose();
    DisplayModeInfo[] enumDisplayModes();
    void setDisplayMode(int width, int height, int depth, int refreshRate, bool fullscreen);
    void resetDisplayMode();
    Bitmap getFrameBuffer();
    void flipFrameBuffers();
}

package class NullDisplayDriver : IDisplayDriver
{
    @property string name() { return "Null"; }

    nothrow @nogc void dispose() { }
    DisplayModeInfo[] enumDisplayModes() { return null; }
    void setDisplayMode(int width, int height, int depth, int refreshRate, bool fullscreen) { }
    void resetDisplayMode() { }
    Bitmap getFrameBuffer() { return null; }
    void flipFrameBuffers() { }
}
