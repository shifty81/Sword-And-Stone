#pragma once

#include "IRenderer.h"
#include <d3d12.h>
#include <dxgi1_6.h>
#include <wrl/client.h>
#include <vector>
#include <queue>
#include <unordered_map>

using Microsoft::WRL::ComPtr;

namespace SwordAndStone {
namespace Renderer {

class DirectX12Renderer : public IRenderer {
public:
    DirectX12Renderer();
    ~DirectX12Renderer() override;

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

    RenderAPI GetAPI() const override { return RenderAPI::DirectX12; }
    const char* GetAPIName() const override { return "DirectX 12"; }

private:
    static constexpr uint32_t FRAME_COUNT = 2;
    
    // Core D3D12 objects
    ComPtr<ID3D12Device> m_device;
    ComPtr<ID3D12CommandQueue> m_commandQueue;
    ComPtr<IDXGISwapChain3> m_swapChain;
    ComPtr<ID3D12DescriptorHeap> m_rtvHeap;
    ComPtr<ID3D12DescriptorHeap> m_dsvHeap;
    ComPtr<ID3D12DescriptorHeap> m_srvHeap;
    
    ComPtr<ID3D12Resource> m_renderTargets[FRAME_COUNT];
    ComPtr<ID3D12Resource> m_depthStencil;
    
    ComPtr<ID3D12CommandAllocator> m_commandAllocators[FRAME_COUNT];
    ComPtr<ID3D12GraphicsCommandList> m_commandList;
    
    // Synchronization objects
    ComPtr<ID3D12Fence> m_fence;
    UINT64 m_fenceValues[FRAME_COUNT];
    HANDLE m_fenceEvent;
    
    // Pipeline state objects
    ComPtr<ID3D12RootSignature> m_rootSignature;
    std::unordered_map<uint32_t, ComPtr<ID3D12PipelineState>> m_pipelineStates;
    
    // Resource management
    struct BufferResource {
        ComPtr<ID3D12Resource> buffer;
        D3D12_VERTEX_BUFFER_VIEW vertexView;
        D3D12_INDEX_BUFFER_VIEW indexView;
        size_t size;
        bool isIndexBuffer;
    };
    
    struct TextureResource {
        ComPtr<ID3D12Resource> texture;
        D3D12_CPU_DESCRIPTOR_HANDLE srvHandle;
        uint32_t width;
        uint32_t height;
    };
    
    std::unordered_map<uint32_t, BufferResource> m_buffers;
    std::unordered_map<uint32_t, TextureResource> m_textures;
    
    uint32_t m_width;
    uint32_t m_height;
    uint32_t m_frameIndex;
    uint32_t m_rtvDescriptorSize;
    uint32_t m_srvDescriptorSize;
    uint32_t m_nextID;
    
    float m_clearColor[4];
    RenderStats m_stats;
    
    D3D12_VIEWPORT m_viewport;
    D3D12_RECT m_scissorRect;
    
    // Helper methods
    bool CreateDevice();
    bool CreateCommandObjects();
    bool CreateSwapChain(void* windowHandle);
    bool CreateDescriptorHeaps();
    bool CreateRenderTargets();
    bool CreateDepthStencil();
    bool CreateRootSignature();
    
    void WaitForGPU();
    void MoveToNextFrame();
    
    D3D12_PRIMITIVE_TOPOLOGY_TYPE ConvertTopologyType(PrimitiveTopology topology);
    D3D_PRIMITIVE_TOPOLOGY ConvertTopology(PrimitiveTopology topology);
    DXGI_FORMAT ConvertTextureFormat(TextureFormat format);
};

} // namespace Renderer
} // namespace SwordAndStone
