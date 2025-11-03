#pragma once

#include <string>
#include <cstdint>

namespace SwordAndStone {

class Window {
public:
    Window();
    ~Window();

    bool Create(uint32_t width, uint32_t height, const std::string& title);
    void Destroy();
    
    void PollEvents();
    bool IsOpen() const { return m_isOpen; }
    
    void* GetNativeHandle() const { return m_nativeHandle; }
    
    uint32_t GetWidth() const { return m_width; }
    uint32_t GetHeight() const { return m_height; }
    
    void SetTitle(const std::string& title);
    void SetSize(uint32_t width, uint32_t height);
    
private:
    void* m_nativeHandle;
    uint32_t m_width;
    uint32_t m_height;
    bool m_isOpen;
    std::string m_title;
};

} // namespace SwordAndStone
