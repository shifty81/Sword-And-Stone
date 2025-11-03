#include "engine/TimeManager.h"
#include "platform/Platform.h"

namespace SwordAndStone {

TimeManager::TimeManager()
    : m_lastTime(0.0)
    , m_deltaTime(0.0f)
    , m_time(0.0f)
    , m_frameCount(0)
    , m_fps(0.0f)
    , m_fpsTimer(0.0f)
    , m_fpsCounter(0)
{
}

TimeManager::~TimeManager() {
}

void TimeManager::Initialize() {
    m_lastTime = Platform::Platform::GetHighResolutionTime();
    m_time = 0.0f;
    m_frameCount = 0;
}

void TimeManager::Update() {
    double currentTime = Platform::Platform::GetHighResolutionTime();
    m_deltaTime = static_cast<float>(currentTime - m_lastTime);
    m_lastTime = currentTime;
    
    m_time += m_deltaTime;
    m_frameCount++;
    
    // Update FPS counter
    m_fpsTimer += m_deltaTime;
    m_fpsCounter++;
    
    if (m_fpsTimer >= 1.0f) {
        m_fps = static_cast<float>(m_fpsCounter) / m_fpsTimer;
        m_fpsTimer = 0.0f;
        m_fpsCounter = 0;
    }
}

} // namespace SwordAndStone
