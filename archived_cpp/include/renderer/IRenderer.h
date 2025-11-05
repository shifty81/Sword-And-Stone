#pragma once

#include <cstdint>
#include <memory>
#include <string>
#include <vector>

namespace SwordAndStone {
namespace Renderer {

// Forward declarations
struct Vertex;
struct Texture;
struct Shader;
struct RenderTarget;

// Rendering API types
enum class RenderAPI {
    None = 0,
    OpenGL,
    DirectX11,
    DirectX12
};

// Primitive topology
enum class PrimitiveTopology {
    TriangleList,
    TriangleStrip,
    LineList,
    PointList
};

// Texture formats
enum class TextureFormat {
    RGBA8,
    RGB8,
    RGBA16F,
    RGBA32F,
    Depth24Stencil8,
    Depth32F
};

// Buffer usage hints
enum class BufferUsage {
    Static,
    Dynamic,
    Stream
};

// Vertex structure
struct Vertex {
    float position[3];
    float normal[3];
    float texcoord[2];
    float color[4];
};

// Clear flags
enum ClearFlags {
    ClearColor = 1 << 0,
    ClearDepth = 1 << 1,
    ClearStencil = 1 << 2
};

// Render statistics
struct RenderStats {
    uint32_t drawCalls = 0;
    uint32_t triangles = 0;
    uint32_t vertices = 0;
    uint32_t textureBinds = 0;
    uint32_t shaderSwitches = 0;
};

/**
 * Abstract Renderer Interface
 * Provides a unified API for different rendering backends
 */
class IRenderer {
public:
    virtual ~IRenderer() = default;

    // Initialization and cleanup
    virtual bool Initialize(void* windowHandle, uint32_t width, uint32_t height) = 0;
    virtual void Shutdown() = 0;
    virtual void Resize(uint32_t width, uint32_t height) = 0;

    // Frame control
    virtual void BeginFrame() = 0;
    virtual void EndFrame() = 0;
    virtual void Present() = 0;

    // Clear operations
    virtual void Clear(uint32_t flags, float r = 0.0f, float g = 0.0f, float b = 0.0f, float a = 1.0f) = 0;
    virtual void SetClearColor(float r, float g, float b, float a) = 0;

    // Viewport and scissor
    virtual void SetViewport(int x, int y, uint32_t width, uint32_t height) = 0;
    virtual void SetScissor(int x, int y, uint32_t width, uint32_t height) = 0;

    // Buffer operations
    virtual uint32_t CreateVertexBuffer(const void* data, size_t size, BufferUsage usage) = 0;
    virtual uint32_t CreateIndexBuffer(const uint32_t* data, size_t count, BufferUsage usage) = 0;
    virtual void UpdateVertexBuffer(uint32_t buffer, const void* data, size_t size, size_t offset = 0) = 0;
    virtual void DeleteBuffer(uint32_t buffer) = 0;

    // Texture operations
    virtual uint32_t CreateTexture2D(uint32_t width, uint32_t height, TextureFormat format, 
                                      const void* data = nullptr) = 0;
    virtual void UpdateTexture2D(uint32_t texture, const void* data, uint32_t mipLevel = 0) = 0;
    virtual void DeleteTexture(uint32_t texture) = 0;
    virtual void BindTexture(uint32_t slot, uint32_t texture) = 0;

    // Shader operations
    virtual uint32_t CreateShader(const std::string& vertexSource, const std::string& fragmentSource) = 0;
    virtual void DeleteShader(uint32_t shader) = 0;
    virtual void BindShader(uint32_t shader) = 0;
    virtual void SetShaderUniform(uint32_t shader, const std::string& name, const void* data, size_t size) = 0;

    // Draw operations
    virtual void DrawIndexed(uint32_t vertexBuffer, uint32_t indexBuffer, uint32_t indexCount, 
                            PrimitiveTopology topology = PrimitiveTopology::TriangleList) = 0;
    virtual void Draw(uint32_t vertexBuffer, uint32_t vertexCount, 
                     PrimitiveTopology topology = PrimitiveTopology::TriangleList) = 0;

    // State management
    virtual void SetDepthTest(bool enabled) = 0;
    virtual void SetBlending(bool enabled) = 0;
    virtual void SetCulling(bool enabled) = 0;
    virtual void SetWireframe(bool enabled) = 0;

    // Stats
    virtual const RenderStats& GetStats() const = 0;
    virtual void ResetStats() = 0;

    // API info
    virtual RenderAPI GetAPI() const = 0;
    virtual const char* GetAPIName() const = 0;
};

/**
 * Factory for creating renderer instances
 */
class RendererFactory {
public:
    static std::unique_ptr<IRenderer> Create(RenderAPI api);
    static std::vector<RenderAPI> GetAvailableAPIs();
};

} // namespace Renderer
} // namespace SwordAndStone
