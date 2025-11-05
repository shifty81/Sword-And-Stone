#pragma once

namespace SwordAndStone {
namespace Platform {

// Platform-specific utilities
class Platform {
public:
    static void* GetModuleHandle();
    static void ShowMessageBox(const char* title, const char* message);
    static double GetHighResolutionTime();
};

} // namespace Platform
} // namespace SwordAndStone
