#include "engine/Window.h"
#include <iostream>

#ifdef ENABLE_OPENGL
#include <GLFW/glfw3.h>
#endif

#ifdef PLATFORM_WINDOWS
#include <Windows.h>
#endif

namespace SwordAndStone {

Window::Window()
    : m_nativeHandle(nullptr)
    , m_width(0)
    , m_height(0)
    , m_isOpen(false)
{
}

Window::~Window() {
    Destroy();
}

bool Window::Create(uint32_t width, uint32_t height, const std::string& title) {
    m_width = width;
    m_height = height;
    m_title = title;
    
#ifdef ENABLE_OPENGL
    // Initialize GLFW
    if (!glfwInit()) {
        std::cerr << "Failed to initialize GLFW" << std::endl;
        return false;
    }
    
    // Configure GLFW
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    
    // Create window
    GLFWwindow* window = glfwCreateWindow(width, height, title.c_str(), nullptr, nullptr);
    if (!window) {
        std::cerr << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return false;
    }
    
    glfwMakeContextCurrent(window);
    m_nativeHandle = window;
    m_isOpen = true;
    
    std::cout << "Window created: " << width << "x" << height << std::endl;
    return true;
#else
    // For DirectX, we'd create a native Win32 window here
    std::cerr << "Native window creation not implemented yet" << std::endl;
    return false;
#endif
}

void Window::Destroy() {
    if (!m_nativeHandle) return;
    
#ifdef ENABLE_OPENGL
    GLFWwindow* window = static_cast<GLFWwindow*>(m_nativeHandle);
    glfwDestroyWindow(window);
    glfwTerminate();
#endif
    
    m_nativeHandle = nullptr;
    m_isOpen = false;
    std::cout << "Window destroyed" << std::endl;
}

void Window::PollEvents() {
#ifdef ENABLE_OPENGL
    glfwPollEvents();
    
    GLFWwindow* window = static_cast<GLFWwindow*>(m_nativeHandle);
    if (glfwWindowShouldClose(window)) {
        m_isOpen = false;
    }
#endif
}

void Window::SetTitle(const std::string& title) {
    m_title = title;
    
#ifdef ENABLE_OPENGL
    if (m_nativeHandle) {
        GLFWwindow* window = static_cast<GLFWwindow*>(m_nativeHandle);
        glfwSetWindowTitle(window, title.c_str());
    }
#endif
}

void Window::SetSize(uint32_t width, uint32_t height) {
    m_width = width;
    m_height = height;
    
#ifdef ENABLE_OPENGL
    if (m_nativeHandle) {
        GLFWwindow* window = static_cast<GLFWwindow*>(m_nativeHandle);
        glfwSetWindowSize(window, width, height);
    }
#endif
}

} // namespace SwordAndStone
