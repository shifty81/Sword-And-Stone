#pragma once

#include <cstdint>

namespace SwordAndStone {

class Window;

class InputManager {
public:
    InputManager();
    ~InputManager();

    void Initialize(Window* window);
    void Update();
    
    bool IsKeyPressed(int keyCode) const;
    bool IsKeyDown(int keyCode) const;
    bool IsKeyReleased(int keyCode) const;
    
    bool IsMouseButtonPressed(int button) const;
    bool IsMouseButtonDown(int button) const;
    bool IsMouseButtonReleased(int button) const;
    
    void GetMousePosition(float& x, float& y) const;
    void GetMouseDelta(float& dx, float& dy) const;
    
private:
    Window* m_window;
    // TODO: Add key and mouse state arrays
};

} // namespace SwordAndStone
