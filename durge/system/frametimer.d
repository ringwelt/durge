module durge.system.frametimer;

import core.time;

class FrameTimer
{
    private int _updatesPerSecond;
    private int _maxMsecsPerFrame;

    private MonoTime _prevTime;
    private MonoTime _currTime;

    private int _frameIndex;
    private Duration _maxFrameTime;
    private Duration _frameTime;
    private Duration _croppedFrameTime;
    private Duration _frameTotal;
    private Duration _frameDelta;
    private Duration _frameLag;
    private Duration[32] _frameTimes;
    private int _framesPerSecond;

    this(int updatesPerSecond, int maxMsecsPerFrame)
    {
        _updatesPerSecond = updatesPerSecond;
        _maxMsecsPerFrame = maxMsecsPerFrame;

        _maxFrameTime = msecs(_maxMsecsPerFrame);
        _frameDelta = usecs(1000000 / _updatesPerSecond);

        reset();
    }

    @property int updatesPerSecond() { return _updatesPerSecond; }
    @property int maxMsecsPerFrame() { return _maxMsecsPerFrame; }

    @property MonoTime prevTime() { return _prevTime; }
    @property MonoTime currTime() { return _currTime; }

    @property int frameIndex() { return _frameIndex; }
    @property Duration maxFrameTime() { return _maxFrameTime; }
    @property Duration frameTime() { return _frameTime; }
    @property Duration croppedFrameTime() { return _croppedFrameTime; }
    @property Duration frameTotal() { return _frameTotal; }
    @property Duration frameDelta() { return _frameDelta; }
    @property Duration frameLag() { return _frameLag; }
    @property int framesPerSecond() { return _framesPerSecond; }

    void reset()
    {
        _currTime = MonoTime.currTime;
        _prevTime = _currTime;

        _frameIndex = -1;
        _frameTime = msecs(0);
        _croppedFrameTime = msecs(0);
        _frameTotal = msecs(0);
        _frameLag = msecs(0);
        _frameTimes = msecs(1);
        _framesPerSecond = 0;
    }

    void next()
    {
        import std.algorithm.comparison : min, max;
        import std.algorithm.iteration : fold;

        _prevTime = _currTime;
        _currTime = MonoTime.currTime;

        _frameIndex++;
        _frameTime = _currTime - _prevTime;
        _frameTimes[_frameIndex & _frameTimes.length - 1] = _frameTime;
        _croppedFrameTime = min(_frameTime, _maxFrameTime);
        _frameLag += _croppedFrameTime;

        auto frameTimesSum = fold!((a, b) => a + b)(_frameTimes);
        _framesPerSecond = cast (int) (1000 * _frameTimes.length / max(frameTimesSum.total!"msecs", 1));
    }

    bool shouldUpdate()
    {
        return _frameLag > _frameDelta;
    }

    void update()
    {
        _frameTotal += _frameDelta;
        _frameLag -= _frameDelta;
    }
}
