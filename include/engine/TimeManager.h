#pragma once

#include <cstdint>

namespace SwordAndStone {

class TimeManager {
public:
    TimeManager();
    ~TimeManager();

    void Initialize();
    void Update();
    
    float GetDeltaTime() const { return m_deltaTime; }
    float GetTime() const { return m_time; }
    uint64_t GetFrameCount() const { return m_frameCount; }
    float GetFPS() const { return m_fps; }
    
private:
    double m_lastTime;
    float m_deltaTime;
    float m_time;
    uint64_t m_frameCount;
    float m_fps;
    float m_fpsTimer;
    uint32_t m_fpsCounter;
};

} // namespace SwordAndStone
