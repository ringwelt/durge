module durge.draw.font;

import durge.common;
import durge.draw.bitmap;

interface IFont
{
    //int getCharWidth(dchar c);
    void write(Bitmap bitmap, int x, int y, string s);
}

class Font
{
    static
    {
        private IFont _temp;
        @property IFont temp() { return _temp; }

        this()
        {
            _temp = new TempFont();
        }
    }
}

class TempFont : IFont
{
    private class CharDef
    {
        int width;
        ushort[16] mask;
    }

    static
    {
        private CharDef[] _charDefs;

        this()
        {
            _charDefs = new CharDef[255];

            _charDefs['0'] = new CharDef();
            _charDefs['0'].width = 6;
            _charDefs['0'].mask[0]  = 0b_00000000;
            _charDefs['0'].mask[1]  = 0b_00000000;
            _charDefs['0'].mask[2]  = 0b_00011110;
            _charDefs['0'].mask[3]  = 0b_00100001;
            _charDefs['0'].mask[4]  = 0b_00100001;
            _charDefs['0'].mask[5]  = 0b_00100001;
            _charDefs['0'].mask[6]  = 0b_00100001;
            _charDefs['0'].mask[7]  = 0b_00100001;
            _charDefs['0'].mask[8]  = 0b_00100001;
            _charDefs['0'].mask[9]  = 0b_00011110;
            _charDefs['0'].mask[10] = 0b_00000000;
            _charDefs['0'].mask[11] = 0b_00000000;

            _charDefs['1'] = new CharDef();
            _charDefs['1'].width = 6;
            _charDefs['1'].mask[0]  = 0b_00000000;
            _charDefs['1'].mask[1]  = 0b_00000000;
            _charDefs['1'].mask[2]  = 0b_00011110;
            _charDefs['1'].mask[3]  = 0b_00100001;
            _charDefs['1'].mask[4]  = 0b_00100001;
            _charDefs['1'].mask[5]  = 0b_00100001;
            _charDefs['1'].mask[6]  = 0b_00100001;
            _charDefs['1'].mask[7]  = 0b_00100001;
            _charDefs['1'].mask[8]  = 0b_00100001;
            _charDefs['1'].mask[9]  = 0b_00011110;
            _charDefs['1'].mask[10] = 0b_00000000;
            _charDefs['1'].mask[11] = 0b_00000000;

            _charDefs['2'] = new CharDef();
            _charDefs['2'].width = 6;
            _charDefs['2'].mask[0]  = 0b_00000000;
            _charDefs['2'].mask[1]  = 0b_00000000;
            _charDefs['2'].mask[2]  = 0b_00011110;
            _charDefs['2'].mask[3]  = 0b_00000001;
            _charDefs['2'].mask[4]  = 0b_00000001;
            _charDefs['2'].mask[5]  = 0b_00111111;
            _charDefs['2'].mask[6]  = 0b_00100000;
            _charDefs['2'].mask[7]  = 0b_00100000;
            _charDefs['2'].mask[8]  = 0b_00100001;
            _charDefs['2'].mask[9]  = 0b_00011110;
            _charDefs['2'].mask[10] = 0b_00000000;
            _charDefs['2'].mask[11] = 0b_00000000;

            _charDefs['3'] = new CharDef();
            _charDefs['3'].width = 6;
            _charDefs['3'].mask[0]  = 0b_00000000;
            _charDefs['3'].mask[1]  = 0b_00000000;
            _charDefs['3'].mask[2]  = 0b_00011110;
            _charDefs['3'].mask[3]  = 0b_00100001;
            _charDefs['3'].mask[4]  = 0b_00000001;
            _charDefs['3'].mask[5]  = 0b_00011111;
            _charDefs['3'].mask[6]  = 0b_00000001;
            _charDefs['3'].mask[7]  = 0b_00000001;
            _charDefs['3'].mask[8]  = 0b_00100001;
            _charDefs['3'].mask[9]  = 0b_00011110;
            _charDefs['3'].mask[10] = 0b_00000000;
            _charDefs['3'].mask[11] = 0b_00000000;

            _charDefs['0'] = new CharDef();
            _charDefs['0'].width = 6;
            _charDefs['0'].mask[0]  = 0b_00000000;
            _charDefs['0'].mask[1]  = 0b_00000000;
            _charDefs['0'].mask[2]  = 0b_00011110;
            _charDefs['0'].mask[3]  = 0b_00100001;
            _charDefs['0'].mask[4]  = 0b_00100001;
            _charDefs['0'].mask[5]  = 0b_00100001;
            _charDefs['0'].mask[6]  = 0b_00100001;
            _charDefs['0'].mask[7]  = 0b_00100001;
            _charDefs['0'].mask[8]  = 0b_00100001;
            _charDefs['0'].mask[9]  = 0b_00011110;
            _charDefs['0'].mask[10] = 0b_00000000;
            _charDefs['0'].mask[11] = 0b_00000000;

            _charDefs['0'] = new CharDef();
            _charDefs['0'].width = 6;
            _charDefs['0'].mask[0]  = 0b_00000000;
            _charDefs['0'].mask[1]  = 0b_00000000;
            _charDefs['0'].mask[2]  = 0b_00011110;
            _charDefs['0'].mask[3]  = 0b_00100001;
            _charDefs['0'].mask[4]  = 0b_00100001;
            _charDefs['0'].mask[5]  = 0b_00100001;
            _charDefs['0'].mask[6]  = 0b_00100001;
            _charDefs['0'].mask[7]  = 0b_00100001;
            _charDefs['0'].mask[8]  = 0b_00100001;
            _charDefs['0'].mask[9]  = 0b_00011110;
            _charDefs['0'].mask[10] = 0b_00000000;
            _charDefs['0'].mask[11] = 0b_00000000;

            _charDefs['0'] = new CharDef();
            _charDefs['0'].width = 6;
            _charDefs['0'].mask[0]  = 0b_00000000;
            _charDefs['0'].mask[1]  = 0b_00000000;
            _charDefs['0'].mask[2]  = 0b_00011110;
            _charDefs['0'].mask[3]  = 0b_00100001;
            _charDefs['0'].mask[4]  = 0b_00100001;
            _charDefs['0'].mask[5]  = 0b_00100001;
            _charDefs['0'].mask[6]  = 0b_00100001;
            _charDefs['0'].mask[7]  = 0b_00100001;
            _charDefs['0'].mask[8]  = 0b_00100001;
            _charDefs['0'].mask[9]  = 0b_00011110;
            _charDefs['0'].mask[10] = 0b_00000000;
            _charDefs['0'].mask[11] = 0b_00000000;

            _charDefs['0'] = new CharDef();
            _charDefs['0'].width = 6;
            _charDefs['0'].mask[0]  = 0b_00000000;
            _charDefs['0'].mask[1]  = 0b_00000000;
            _charDefs['0'].mask[2]  = 0b_00011110;
            _charDefs['0'].mask[3]  = 0b_00100001;
            _charDefs['0'].mask[4]  = 0b_00100001;
            _charDefs['0'].mask[5]  = 0b_00100001;
            _charDefs['0'].mask[6]  = 0b_00100001;
            _charDefs['0'].mask[7]  = 0b_00100001;
            _charDefs['0'].mask[8]  = 0b_00100001;
            _charDefs['0'].mask[9]  = 0b_00011110;
            _charDefs['0'].mask[10] = 0b_00000000;
            _charDefs['0'].mask[11] = 0b_00000000;

            _charDefs['9'] = new CharDef();
            _charDefs['9'].width = 6;
            _charDefs['9'].mask[0]  = 0b_00000000;
            _charDefs['9'].mask[1]  = 0b_00000000;
            _charDefs['9'].mask[2]  = 0b_00011110;
            _charDefs['9'].mask[3]  = 0b_00100001;
            _charDefs['9'].mask[4]  = 0b_00100001;
            _charDefs['9'].mask[5]  = 0b_00100001;
            _charDefs['9'].mask[6]  = 0b_00100001;
            _charDefs['9'].mask[7]  = 0b_00100001;
            _charDefs['9'].mask[8]  = 0b_00100001;
            _charDefs['9'].mask[9]  = 0b_00011110;
            _charDefs['9'].mask[10] = 0b_00000000;
            _charDefs['9'].mask[11] = 0b_00000000;
        }
    }

    void write(Bitmap bitmap, int x, int y, string s)
    {
        foreach (i, dchar c; s)
        {
            switch (c)
            {
                case 'A':
                    bitmap.drawer.point(x + 0, y + 0);
                    bitmap.drawer.point(x + 0, y + 0);

                    x += 0;
                    break;

                default:
                    break;
            }
        }
    }
}
