#include "renderer/IRenderer.h"
#include "renderer/OpenGLRenderer.h"

#ifdef ENABLE_DX11
#include "renderer/DirectX11Renderer.h"
#endif

#ifdef ENABLE_DX12
#include "renderer/DirectX12Renderer.h"
#endif

#include <stdexcept>

namespace SwordAndStone {
namespace Renderer {

std::unique_ptr<IRenderer> RendererFactory::Create(RenderAPI api) {
    switch (api) {
        case RenderAPI::OpenGL:
#ifdef ENABLE_OPENGL
            return std::make_unique<OpenGLRenderer>();
#else
            throw std::runtime_error("OpenGL renderer not compiled in this build");
#endif

        case RenderAPI::DirectX11:
#ifdef ENABLE_DX11
            return std::make_unique<DirectX11Renderer>();
#else
            throw std::runtime_error("DirectX 11 renderer not available on this platform");
#endif

        case RenderAPI::DirectX12:
#ifdef ENABLE_DX12
            return std::make_unique<DirectX12Renderer>();
#else
            throw std::runtime_error("DirectX 12 renderer not available on this platform");
#endif

        default:
            throw std::runtime_error("Unknown or unsupported render API");
    }
}

std::vector<RenderAPI> RendererFactory::GetAvailableAPIs() {
    std::vector<RenderAPI> apis;
    
#ifdef ENABLE_OPENGL
    apis.push_back(RenderAPI::OpenGL);
#endif

#ifdef ENABLE_DX11
    apis.push_back(RenderAPI::DirectX11);
#endif

#ifdef ENABLE_DX12
    apis.push_back(RenderAPI::DirectX12);
#endif

    return apis;
}

} // namespace Renderer
} // namespace SwordAndStone
