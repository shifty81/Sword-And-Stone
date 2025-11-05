#pragma once

#include <memory>
#include <string>

namespace SwordAndStone {

// Forward declarations
namespace Renderer { class IRenderer; }
class Window;
class InputManager;
class TimeManager;
class SceneManager;

class Engine {
public:
    Engine();
    ~Engine();

    // Initialize the engine
    bool Initialize(uint32_t width, uint32_t height, const std::string& title);
    
    // Main game loop
    void Run();
    
    // Shutdown and cleanup
    void Shutdown();
    
    // Accessors
    Renderer::IRenderer* GetRenderer() const { return m_renderer.get(); }
    Window* GetWindow() const { return m_window.get(); }
    InputManager* GetInput() const { return m_input.get(); }
    TimeManager* GetTime() const { return m_time.get(); }
    SceneManager* GetScene() const { return m_scene.get(); }
    
    bool IsRunning() const { return m_isRunning; }
    void RequestExit() { m_isRunning = false; }

private:
    std::unique_ptr<Window> m_window;
    std::unique_ptr<Renderer::IRenderer> m_renderer;
    std::unique_ptr<InputManager> m_input;
    std::unique_ptr<TimeManager> m_time;
    std::unique_ptr<SceneManager> m_scene;
    
    bool m_isRunning;
    
    // Core update functions
    void ProcessInput();
    void Update(float deltaTime);
    void Render();
};

} // namespace SwordAndStone
