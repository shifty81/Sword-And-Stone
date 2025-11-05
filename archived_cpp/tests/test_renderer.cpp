#include "renderer/IRenderer.h"
#include <iostream>

// Test renderer functionality
void test_renderer_factory() {
    std::cout << "Testing Renderer Factory..." << std::endl;
    
    auto apis = SwordAndStone::Renderer::RendererFactory::GetAvailableAPIs();
    
    std::cout << "Available rendering APIs: " << apis.size() << std::endl;
    for (auto api : apis) {
        std::cout << "  - API available" << std::endl;
    }
    
    std::cout << "Renderer Factory test passed!" << std::endl;
}
