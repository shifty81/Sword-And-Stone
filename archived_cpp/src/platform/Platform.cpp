#include "platform/Platform.h"

#ifdef PLATFORM_WINDOWS
#include <Windows.h>
#endif

namespace SwordAndStone {
namespace Platform {

void* Platform::GetModuleHandle() {
#ifdef PLATFORM_WINDOWS
    return GetModuleHandle(nullptr);
#else
    return nullptr;
#endif
}

void Platform::ShowMessageBox(const char* title, const char* message) {
#ifdef PLATFORM_WINDOWS
    MessageBoxA(nullptr, message, title, MB_OK | MB_ICONINFORMATION);
#endif
}

double Platform::GetHighResolutionTime() {
#ifdef PLATFORM_WINDOWS
    LARGE_INTEGER frequency, counter;
    QueryPerformanceFrequency(&frequency);
    QueryPerformanceCounter(&counter);
    return static_cast<double>(counter.QuadPart) / static_cast<double>(frequency.QuadPart);
#else
    return 0.0;
#endif
}

} // namespace Platform
} // namespace SwordAndStone
