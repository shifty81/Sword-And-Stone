#pragma once

#include "IRenderer.h"
#include <unordered_map>

namespace SwordAndStone {
namespace Renderer {

class OpenGLRenderer : public IRenderer {
public:
    OpenGLRenderer();
    ~OpenGLRenderer() override;

    // IRenderer implementation
    bool Initialize(void* windowHandle, uint32_t width, uint32_t height) override;
    void Shutdown() override;
    void Resize(uint32_t width, uint32_t height) override;

    void BeginFrame() override;
    void EndFrame() override;
    void Present() override;

    void Clear(uint32_t flags, float r, float g, float b, float a) override;
    void SetClearColor(float r, float g, float b, float a) override;

    void SetViewport(int x, int y, uint32_t width, uint32_t height) override;
    void SetScissor(int x, int y, uint32_t width, uint32_t height) override;

    uint32_t CreateVertexBuffer(const void* data, size_t size, BufferUsage usage) override;
    uint32_t CreateIndexBuffer(const uint32_t* data, size_t count, BufferUsage usage) override;
    void UpdateVertexBuffer(uint32_t buffer, const void* data, size_t size, size_t offset) override;
    void DeleteBuffer(uint32_t buffer) override;

    uint32_t CreateTexture2D(uint32_t width, uint32_t height, TextureFormat format, const void* data) override;
    void UpdateTexture2D(uint32_t texture, const void* data, uint32_t mipLevel) override;
    void DeleteTexture(uint32_t texture) override;
    void BindTexture(uint32_t slot, uint32_t texture) override;

    uint32_t CreateShader(const std::string& vertexSource, const std::string& fragmentSource) override;
    void DeleteShader(uint32_t shader) override;
    void BindShader(uint32_t shader) override;
    void SetShaderUniform(uint32_t shader, const std::string& name, const void* data, size_t size) override;

    void DrawIndexed(uint32_t vertexBuffer, uint32_t indexBuffer, uint32_t indexCount, 
                    PrimitiveTopology topology) override;
    void Draw(uint32_t vertexBuffer, uint32_t vertexCount, PrimitiveTopology topology) override;

    void SetDepthTest(bool enabled) override;
    void SetBlending(bool enabled) override;
    void SetCulling(bool enabled) override;
    void SetWireframe(bool enabled) override;

    const RenderStats& GetStats() const override { return m_stats; }
    void ResetStats() override { m_stats = RenderStats(); }

    RenderAPI GetAPI() const override { return RenderAPI::OpenGL; }
    const char* GetAPIName() const override { return "OpenGL"; }

private:
    void* m_windowHandle;
    uint32_t m_width;
    uint32_t m_height;
    
    uint32_t m_vao;  // Vertex Array Object
    uint32_t m_currentShader;
    uint32_t m_currentVBO;
    uint32_t m_currentIBO;
    
    float m_clearColor[4];
    RenderStats m_stats;
    
    std::unordered_map<uint32_t, int32_t> m_uniformLocations;
    
    uint32_t ConvertTopology(PrimitiveTopology topology);
    uint32_t ConvertBufferUsage(BufferUsage usage);
    void SetupVertexAttributes();
};

} // namespace Renderer
} // namespace SwordAndStone
