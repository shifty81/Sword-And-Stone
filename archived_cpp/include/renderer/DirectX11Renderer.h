#pragma once

#include "IRenderer.h"
#include <d3d11.h>
#include <dxgi.h>
#include <wrl/client.h>
#include <unordered_map>

using Microsoft::WRL::ComPtr;

namespace SwordAndStone {
namespace Renderer {

class DirectX11Renderer : public IRenderer {
public:
    DirectX11Renderer();
    ~DirectX11Renderer() override;

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

    RenderAPI GetAPI() const override { return RenderAPI::DirectX11; }
    const char* GetAPIName() const override { return "DirectX 11"; }

private:
    // D3D11 objects
    ComPtr<ID3D11Device> m_device;
    ComPtr<ID3D11DeviceContext> m_context;
    ComPtr<IDXGISwapChain> m_swapChain;
    ComPtr<ID3D11RenderTargetView> m_renderTargetView;
    ComPtr<ID3D11DepthStencilView> m_depthStencilView;
    ComPtr<ID3D11Texture2D> m_depthStencilBuffer;
    
    // State objects
    ComPtr<ID3D11RasterizerState> m_rasterizerStateSolid;
    ComPtr<ID3D11RasterizerState> m_rasterizerStateWireframe;
    ComPtr<ID3D11DepthStencilState> m_depthStencilStateEnabled;
    ComPtr<ID3D11DepthStencilState> m_depthStencilStateDisabled;
    ComPtr<ID3D11BlendState> m_blendStateEnabled;
    ComPtr<ID3D11BlendState> m_blendStateDisabled;
    ComPtr<ID3D11InputLayout> m_inputLayout;
    
    // Resource maps
    std::unordered_map<uint32_t, ComPtr<ID3D11Buffer>> m_buffers;
    std::unordered_map<uint32_t, ComPtr<ID3D11Texture2D>> m_textures;
    std::unordered_map<uint32_t, ComPtr<ID3D11ShaderResourceView>> m_textureSRVs;
    
    struct ShaderData {
        ComPtr<ID3D11VertexShader> vertexShader;
        ComPtr<ID3D11PixelShader> pixelShader;
        ComPtr<ID3D11Buffer> constantBuffer;
    };
    std::unordered_map<uint32_t, ShaderData> m_shaders;
    
    uint32_t m_width;
    uint32_t m_height;
    float m_clearColor[4];
    RenderStats m_stats;
    uint32_t m_nextID;
    
    bool CreateRenderTarget();
    bool CreateDepthStencil();
    void CreateDefaultStates();
    D3D11_USAGE ConvertBufferUsage(BufferUsage usage);
    D3D_PRIMITIVE_TOPOLOGY ConvertTopology(PrimitiveTopology topology);
    DXGI_FORMAT ConvertTextureFormat(TextureFormat format);
};

} // namespace Renderer
} // namespace SwordAndStone
