#include "engine/Engine.h"
#include "engine/Window.h"
#include "engine/InputManager.h"
#include "engine/TimeManager.h"
#include "renderer/IRenderer.h"
#include <iostream>

namespace SwordAndStone {

Engine::Engine()
    : m_isRunning(false)
{
}

Engine::~Engine() {
    Shutdown();
}

bool Engine::Initialize(uint32_t width, uint32_t height, const std::string& title) {
    std::cout << "Initializing Sword And Stone Engine..." << std::endl;
    
    // Create window
    m_window = std::make_unique<Window>();
    if (!m_window->Create(width, height, title)) {
        std::cerr << "Failed to create window!" << std::endl;
        return false;
    }
    
    // Create renderer - try APIs in order of preference
    auto availableAPIs = Renderer::RendererFactory::GetAvailableAPIs();
    
    if (availableAPIs.empty()) {
        std::cerr << "No rendering APIs available!" << std::endl;
        return false;
    }
    
    // Try each API until one succeeds
    for (auto api : availableAPIs) {
        try {
            m_renderer = Renderer::RendererFactory::Create(api);
            if (m_renderer && m_renderer->Initialize(m_window->GetNativeHandle(), width, height)) {
                std::cout << "Using renderer: " << m_renderer->GetAPIName() << std::endl;
                break;
            }
        }
        catch (const std::exception& e) {
            std::cerr << "Failed to create renderer: " << e.what() << std::endl;
            m_renderer.reset();
        }
    }
    
    if (!m_renderer) {
        std::cerr << "Failed to initialize any rendering API!" << std::endl;
        return false;
    }
    
    // Create input manager
    m_input = std::make_unique<InputManager>();
    m_input->Initialize(m_window.get());
    
    // Create time manager
    m_time = std::make_unique<TimeManager>();
    m_time->Initialize();
    
    // TODO: Create scene manager
    // m_scene = std::make_unique<SceneManager>();
    
    m_isRunning = true;
    std::cout << "Engine initialized successfully!" << std::endl;
    
    return true;
}

void Engine::Run() {
    std::cout << "Starting game loop..." << std::endl;
    
    while (m_isRunning && m_window->IsOpen()) {
        // Update time
        m_time->Update();
        float deltaTime = m_time->GetDeltaTime();
        
        // Process input
        ProcessInput();
        
        // Update game logic
        Update(deltaTime);
        
        // Render
        Render();
        
        // Poll events
        m_window->PollEvents();
    }
    
    std::cout << "Game loop ended." << std::endl;
}

void Engine::Shutdown() {
    std::cout << "Shutting down engine..." << std::endl;
    
    m_scene.reset();
    m_time.reset();
    m_input.reset();
    
    if (m_renderer) {
        m_renderer->Shutdown();
        m_renderer.reset();
    }
    
    if (m_window) {
        m_window->Destroy();
        m_window.reset();
    }
    
    std::cout << "Engine shut down." << std::endl;
}

void Engine::ProcessInput() {
    m_input->Update();
    
    // Check for exit request (ESC key)
    if (m_input->IsKeyPressed(27)) {  // ESC key
        RequestExit();
    }
}

void Engine::Update(float deltaTime) {
    // TODO: Update game systems
    // if (m_scene) {
    //     m_scene->Update(deltaTime);
    // }
}

void Engine::Render() {
    if (!m_renderer) return;
    
    m_renderer->BeginFrame();
    
    // Clear screen
    m_renderer->Clear(
        Renderer::ClearColor | Renderer::ClearDepth,
        0.2f, 0.3f, 0.4f, 1.0f
    );
    
    // TODO: Render game objects
    // if (m_scene) {
    //     m_scene->Render(m_renderer.get());
    // }
    
    m_renderer->EndFrame();
    m_renderer->Present();
}

} // namespace SwordAndStone
