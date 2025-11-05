#include "engine/Engine.h"
#include "renderer/IRenderer.h"
#include <iostream>

#ifdef PLATFORM_WINDOWS
#include <Windows.h>

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
#else
int main(int argc, char** argv) {
#endif
    
    std::cout << "Sword And Stone - Native C++ Edition" << std::endl;
    std::cout << "======================================" << std::endl;
    
    try {
        // Create engine instance
        SwordAndStone::Engine engine;
        
        // Initialize with preferred rendering API
        // Try DirectX 12 first, then DirectX 11, then OpenGL
        if (!engine.Initialize(1920, 1080, "Sword And Stone")) {
            std::cerr << "Failed to initialize engine!" << std::endl;
            return 1;
        }
        
        // Run the game loop
        engine.Run();
        
        // Cleanup
        engine.Shutdown();
        
        return 0;
    }
    catch (const std::exception& e) {
        std::cerr << "Fatal error: " << e.what() << std::endl;
        return 1;
    }
}
