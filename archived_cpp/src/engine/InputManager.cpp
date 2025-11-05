#include "engine/InputManager.h"
#include "engine/Window.h"

#ifdef ENABLE_OPENGL
#include <GLFW/glfw3.h>
#endif

namespace SwordAndStone {

InputManager::InputManager()
    : m_window(nullptr)
{
}

InputManager::~InputManager() {
}

void InputManager::Initialize(Window* window) {
    m_window = window;
}

void InputManager::Update() {
    // TODO: Update input state
}

bool InputManager::IsKeyPressed(int keyCode) const {
    // TODO: Implement key press detection
    return false;
}

bool InputManager::IsKeyDown(int keyCode) const {
#ifdef ENABLE_OPENGL
    if (m_window) {
        GLFWwindow* window = static_cast<GLFWwindow*>(m_window->GetNativeHandle());
        return glfwGetKey(window, keyCode) == GLFW_PRESS;
    }
#endif
    return false;
}

bool InputManager::IsKeyReleased(int keyCode) const {
    // TODO: Implement key release detection
    return false;
}

bool InputManager::IsMouseButtonPressed(int button) const {
    // TODO: Implement mouse button press detection
    return false;
}

bool InputManager::IsMouseButtonDown(int button) const {
#ifdef ENABLE_OPENGL
    if (m_window) {
        GLFWwindow* window = static_cast<GLFWwindow*>(m_window->GetNativeHandle());
        return glfwGetMouseButton(window, button) == GLFW_PRESS;
    }
#endif
    return false;
}

bool InputManager::IsMouseButtonReleased(int button) const {
    // TODO: Implement mouse button release detection
    return false;
}

void InputManager::GetMousePosition(float& x, float& y) const {
#ifdef ENABLE_OPENGL
    if (m_window) {
        GLFWwindow* window = static_cast<GLFWwindow*>(m_window->GetNativeHandle());
        double dx, dy;
        glfwGetCursorPos(window, &dx, &dy);
        x = static_cast<float>(dx);
        y = static_cast<float>(dy);
        return;
    }
#endif
    x = y = 0.0f;
}

void InputManager::GetMouseDelta(float& dx, float& dy) const {
    // TODO: Implement mouse delta tracking
    dx = dy = 0.0f;
}

} // namespace SwordAndStone
