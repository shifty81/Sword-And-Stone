#include "renderer/DirectX12Renderer.h"
#include <iostream>

#ifdef ENABLE_DX12

namespace SwordAndStone {
namespace Renderer {

DirectX12Renderer::DirectX12Renderer()
    : m_width(0)
    , m_height(0)
    , m_frameIndex(0)
    , m_rtvDescriptorSize(0)
    , m_srvDescriptorSize(0)
    , m_nextID(1)
    , m_fenceEvent(nullptr)
{
    m_clearColor[0] = 0.2f;
    m_clearColor[1] = 0.3f;
    m_clearColor[2] = 0.4f;
    m_clearColor[3] = 1.0f;
    
    for (uint32_t i = 0; i < FRAME_COUNT; i++) {
        m_fenceValues[i] = 0;
    }
}

DirectX12Renderer::~DirectX12Renderer() {
    Shutdown();
}

bool DirectX12Renderer::Initialize(void* windowHandle, uint32_t width, uint32_t height) {
    m_width = width;
    m_height = height;
    
    // Create device
    if (!CreateDevice()) {
        std::cerr << "Failed to create D3D12 device" << std::endl;
        return false;
    }
    
    // Create command objects
    if (!CreateCommandObjects()) {
        std::cerr << "Failed to create command objects" << std::endl;
        return false;
    }
    
    // Create swap chain
    if (!CreateSwapChain(windowHandle)) {
        std::cerr << "Failed to create swap chain" << std::endl;
        return false;
    }
    
    // Create descriptor heaps
    if (!CreateDescriptorHeaps()) {
        std::cerr << "Failed to create descriptor heaps" << std::endl;
        return false;
    }
    
    // Create render targets
    if (!CreateRenderTargets()) {
        std::cerr << "Failed to create render targets" << std::endl;
        return false;
    }
    
    // Create depth stencil
    if (!CreateDepthStencil()) {
        std::cerr << "Failed to create depth stencil" << std::endl;
        return false;
    }
    
    // Create root signature
    if (!CreateRootSignature()) {
        std::cerr << "Failed to create root signature" << std::endl;
        return false;
    }
    
    // Create fence for synchronization
    if (FAILED(m_device->CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_PPV_ARGS(m_fence.GetAddressOf())))) {
        return false;
    }
    
    m_fenceEvent = CreateEvent(nullptr, FALSE, FALSE, nullptr);
    if (!m_fenceEvent) {
        return false;
    }
    
    // Set viewport and scissor
    m_viewport.TopLeftX = 0;
    m_viewport.TopLeftY = 0;
    m_viewport.Width = static_cast<float>(width);
    m_viewport.Height = static_cast<float>(height);
    m_viewport.MinDepth = 0.0f;
    m_viewport.MaxDepth = 1.0f;
    
    m_scissorRect.left = 0;
    m_scissorRect.top = 0;
    m_scissorRect.right = static_cast<LONG>(width);
    m_scissorRect.bottom = static_cast<LONG>(height);
    
    std::cout << "DirectX 12 Renderer initialized" << std::endl;
    return true;
}

void DirectX12Renderer::Shutdown() {
    WaitForGPU();
    
    if (m_fenceEvent) {
        CloseHandle(m_fenceEvent);
        m_fenceEvent = nullptr;
    }
    
    m_buffers.clear();
    m_textures.clear();
    m_pipelineStates.clear();
    
    std::cout << "DirectX 12 Renderer shut down" << std::endl;
}

void DirectX12Renderer::Resize(uint32_t width, uint32_t height) {
    // TODO: Implement resize
    m_width = width;
    m_height = height;
}

void DirectX12Renderer::BeginFrame() {
    m_stats = RenderStats();
    
    // Reset command allocator and list
    m_commandAllocators[m_frameIndex]->Reset();
    m_commandList->Reset(m_commandAllocators[m_frameIndex].Get(), nullptr);
    
    // Transition back buffer to render target state
    D3D12_RESOURCE_BARRIER barrier = {};
    barrier.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    barrier.Transition.pResource = m_renderTargets[m_frameIndex].Get();
    barrier.Transition.StateBefore = D3D12_RESOURCE_STATE_PRESENT;
    barrier.Transition.StateAfter = D3D12_RESOURCE_STATE_RENDER_TARGET;
    barrier.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
    
    m_commandList->ResourceBarrier(1, &barrier);
    
    // Set render target
    D3D12_CPU_DESCRIPTOR_HANDLE rtvHandle;
    rtvHandle.ptr = m_rtvHeap->GetCPUDescriptorHandleForHeapStart().ptr + 
                    m_frameIndex * m_rtvDescriptorSize;
    
    D3D12_CPU_DESCRIPTOR_HANDLE dsvHandle = m_dsvHeap->GetCPUDescriptorHandleForHeapStart();
    
    m_commandList->OMSetRenderTargets(1, &rtvHandle, FALSE, &dsvHandle);
    
    // Set viewport and scissor
    m_commandList->RSSetViewports(1, &m_viewport);
    m_commandList->RSSetScissorRects(1, &m_scissorRect);
}

void DirectX12Renderer::EndFrame() {
    // Transition back buffer to present state
    D3D12_RESOURCE_BARRIER barrier = {};
    barrier.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    barrier.Transition.pResource = m_renderTargets[m_frameIndex].Get();
    barrier.Transition.StateBefore = D3D12_RESOURCE_STATE_RENDER_TARGET;
    barrier.Transition.StateAfter = D3D12_RESOURCE_STATE_PRESENT;
    barrier.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
    
    m_commandList->ResourceBarrier(1, &barrier);
    
    // Close command list
    m_commandList->Close();
    
    // Execute command list
    ID3D12CommandList* commandLists[] = { m_commandList.Get() };
    m_commandQueue->ExecuteCommandLists(1, commandLists);
}

void DirectX12Renderer::Present() {
    if (m_swapChain) {
        m_swapChain->Present(1, 0);
    }
    
    MoveToNextFrame();
}

void DirectX12Renderer::Clear(uint32_t flags, float r, float g, float b, float a) {
    if (flags & ClearColor) {
        float color[4] = { r, g, b, a };
        D3D12_CPU_DESCRIPTOR_HANDLE rtvHandle;
        rtvHandle.ptr = m_rtvHeap->GetCPUDescriptorHandleForHeapStart().ptr + 
                        m_frameIndex * m_rtvDescriptorSize;
        m_commandList->ClearRenderTargetView(rtvHandle, color, 0, nullptr);
    }
    
    if ((flags & ClearDepth) || (flags & ClearStencil)) {
        D3D12_CLEAR_FLAGS clearFlags = (D3D12_CLEAR_FLAGS)0;
        if (flags & ClearDepth) clearFlags |= D3D12_CLEAR_FLAG_DEPTH;
        if (flags & ClearStencil) clearFlags |= D3D12_CLEAR_FLAG_STENCIL;
        
        D3D12_CPU_DESCRIPTOR_HANDLE dsvHandle = m_dsvHeap->GetCPUDescriptorHandleForHeapStart();
        m_commandList->ClearDepthStencilView(dsvHandle, clearFlags, 1.0f, 0, 0, nullptr);
    }
}

void DirectX12Renderer::SetClearColor(float r, float g, float b, float a) {
    m_clearColor[0] = r;
    m_clearColor[1] = g;
    m_clearColor[2] = b;
    m_clearColor[3] = a;
}

void DirectX12Renderer::SetViewport(int x, int y, uint32_t width, uint32_t height) {
    m_viewport.TopLeftX = static_cast<float>(x);
    m_viewport.TopLeftY = static_cast<float>(y);
    m_viewport.Width = static_cast<float>(width);
    m_viewport.Height = static_cast<float>(height);
}

void DirectX12Renderer::SetScissor(int x, int y, uint32_t width, uint32_t height) {
    m_scissorRect.left = x;
    m_scissorRect.top = y;
    m_scissorRect.right = x + width;
    m_scissorRect.bottom = y + height;
}

// Stub implementations for remaining methods
uint32_t DirectX12Renderer::CreateVertexBuffer(const void* data, size_t size, BufferUsage usage) {
    // TODO: Implement
    return 0;
}

uint32_t DirectX12Renderer::CreateIndexBuffer(const uint32_t* data, size_t count, BufferUsage usage) {
    // TODO: Implement
    return 0;
}

void DirectX12Renderer::UpdateVertexBuffer(uint32_t buffer, const void* data, size_t size, size_t offset) {
    // TODO: Implement
}

void DirectX12Renderer::DeleteBuffer(uint32_t buffer) {
    m_buffers.erase(buffer);
}

uint32_t DirectX12Renderer::CreateTexture2D(uint32_t width, uint32_t height, TextureFormat format, const void* data) {
    // TODO: Implement
    return 0;
}

void DirectX12Renderer::UpdateTexture2D(uint32_t texture, const void* data, uint32_t mipLevel) {
    // TODO: Implement
}

void DirectX12Renderer::DeleteTexture(uint32_t texture) {
    m_textures.erase(texture);
}

void DirectX12Renderer::BindTexture(uint32_t slot, uint32_t texture) {
    // TODO: Implement
}

uint32_t DirectX12Renderer::CreateShader(const std::string& vertexSource, const std::string& fragmentSource) {
    // TODO: Implement
    return 0;
}

void DirectX12Renderer::DeleteShader(uint32_t shader) {
    m_pipelineStates.erase(shader);
}

void DirectX12Renderer::BindShader(uint32_t shader) {
    // TODO: Implement
}

void DirectX12Renderer::SetShaderUniform(uint32_t shader, const std::string& name, const void* data, size_t size) {
    // TODO: Implement
}

void DirectX12Renderer::DrawIndexed(uint32_t vertexBuffer, uint32_t indexBuffer, uint32_t indexCount, 
                                    PrimitiveTopology topology) {
    // TODO: Implement
    m_stats.drawCalls++;
}

void DirectX12Renderer::Draw(uint32_t vertexBuffer, uint32_t vertexCount, PrimitiveTopology topology) {
    // TODO: Implement
    m_stats.drawCalls++;
}

void DirectX12Renderer::SetDepthTest(bool enabled) {
    // TODO: Implement (requires PSO switching)
}

void DirectX12Renderer::SetBlending(bool enabled) {
    // TODO: Implement (requires PSO switching)
}

void DirectX12Renderer::SetCulling(bool enabled) {
    // TODO: Implement (requires PSO switching)
}

void DirectX12Renderer::SetWireframe(bool enabled) {
    // TODO: Implement (requires PSO switching)
}

// Helper methods
bool DirectX12Renderer::CreateDevice() {
#ifdef _DEBUG
    ComPtr<ID3D12Debug> debugController;
    if (SUCCEEDED(D3D12GetDebugInterface(IID_PPV_ARGS(debugController.GetAddressOf())))) {
        debugController->EnableDebugLayer();
    }
#endif
    
    return SUCCEEDED(D3D12CreateDevice(nullptr, D3D_FEATURE_LEVEL_11_0, IID_PPV_ARGS(m_device.GetAddressOf())));
}

bool DirectX12Renderer::CreateCommandObjects() {
    D3D12_COMMAND_QUEUE_DESC queueDesc = {};
    queueDesc.Type = D3D12_COMMAND_LIST_TYPE_DIRECT;
    queueDesc.Flags = D3D12_COMMAND_QUEUE_FLAG_NONE;
    
    if (FAILED(m_device->CreateCommandQueue(&queueDesc, IID_PPV_ARGS(m_commandQueue.GetAddressOf())))) {
        return false;
    }
    
    for (uint32_t i = 0; i < FRAME_COUNT; i++) {
        if (FAILED(m_device->CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT, 
                                                     IID_PPV_ARGS(m_commandAllocators[i].GetAddressOf())))) {
            return false;
        }
    }
    
    return SUCCEEDED(m_device->CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, 
                                                  m_commandAllocators[0].Get(), nullptr, 
                                                  IID_PPV_ARGS(m_commandList.GetAddressOf())));
}

bool DirectX12Renderer::CreateSwapChain(void* windowHandle) {
    // TODO: Create swap chain using DXGI
    return false;  // Stub
}

bool DirectX12Renderer::CreateDescriptorHeaps() {
    // RTV heap
    D3D12_DESCRIPTOR_HEAP_DESC rtvHeapDesc = {};
    rtvHeapDesc.NumDescriptors = FRAME_COUNT;
    rtvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
    rtvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
    
    if (FAILED(m_device->CreateDescriptorHeap(&rtvHeapDesc, IID_PPV_ARGS(m_rtvHeap.GetAddressOf())))) {
        return false;
    }
    
    m_rtvDescriptorSize = m_device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);
    
    // DSV heap
    D3D12_DESCRIPTOR_HEAP_DESC dsvHeapDesc = {};
    dsvHeapDesc.NumDescriptors = 1;
    dsvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_DSV;
    dsvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
    
    if (FAILED(m_device->CreateDescriptorHeap(&dsvHeapDesc, IID_PPV_ARGS(m_dsvHeap.GetAddressOf())))) {
        return false;
    }
    
    // SRV heap
    D3D12_DESCRIPTOR_HEAP_DESC srvHeapDesc = {};
    srvHeapDesc.NumDescriptors = 100;  // Allocate space for textures
    srvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
    srvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
    
    if (FAILED(m_device->CreateDescriptorHeap(&srvHeapDesc, IID_PPV_ARGS(m_srvHeap.GetAddressOf())))) {
        return false;
    }
    
    m_srvDescriptorSize = m_device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);
    
    return true;
}

bool DirectX12Renderer::CreateRenderTargets() {
    // TODO: Create render targets from swap chain
    return false;  // Stub
}

bool DirectX12Renderer::CreateDepthStencil() {
    // TODO: Create depth stencil buffer
    return false;  // Stub
}

bool DirectX12Renderer::CreateRootSignature() {
    // TODO: Create root signature
    return false;  // Stub
}

void DirectX12Renderer::WaitForGPU() {
    if (m_commandQueue && m_fence && m_fenceEvent) {
        const UINT64 fenceValue = m_fenceValues[m_frameIndex];
        m_commandQueue->Signal(m_fence.Get(), fenceValue);
        m_fence->SetEventOnCompletion(fenceValue, m_fenceEvent);
        WaitForSingleObject(m_fenceEvent, INFINITE);
        m_fenceValues[m_frameIndex]++;
    }
}

void DirectX12Renderer::MoveToNextFrame() {
    const UINT64 currentFenceValue = m_fenceValues[m_frameIndex];
    m_commandQueue->Signal(m_fence.Get(), currentFenceValue);
    
    m_frameIndex = m_swapChain->GetCurrentBackBufferIndex();
    
    if (m_fence->GetCompletedValue() < m_fenceValues[m_frameIndex]) {
        m_fence->SetEventOnCompletion(m_fenceValues[m_frameIndex], m_fenceEvent);
        WaitForSingleObject(m_fenceEvent, INFINITE);
    }
    
    m_fenceValues[m_frameIndex] = currentFenceValue + 1;
}

D3D12_PRIMITIVE_TOPOLOGY_TYPE DirectX12Renderer::ConvertTopologyType(PrimitiveTopology topology) {
    switch (topology) {
        case PrimitiveTopology::TriangleList:
        case PrimitiveTopology::TriangleStrip:
            return D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
        case PrimitiveTopology::LineList:
            return D3D12_PRIMITIVE_TOPOLOGY_TYPE_LINE;
        case PrimitiveTopology::PointList:
            return D3D12_PRIMITIVE_TOPOLOGY_TYPE_POINT;
        default:
            return D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
    }
}

D3D_PRIMITIVE_TOPOLOGY DirectX12Renderer::ConvertTopology(PrimitiveTopology topology) {
    switch (topology) {
        case PrimitiveTopology::TriangleList: return D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
        case PrimitiveTopology::TriangleStrip: return D3D_PRIMITIVE_TOPOLOGY_TRIANGLESTRIP;
        case PrimitiveTopology::LineList: return D3D_PRIMITIVE_TOPOLOGY_LINELIST;
        case PrimitiveTopology::PointList: return D3D_PRIMITIVE_TOPOLOGY_POINTLIST;
        default: return D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
    }
}

DXGI_FORMAT DirectX12Renderer::ConvertTextureFormat(TextureFormat format) {
    switch (format) {
        case TextureFormat::RGBA8: return DXGI_FORMAT_R8G8B8A8_UNORM;
        case TextureFormat::RGB8: return DXGI_FORMAT_R8G8B8A8_UNORM;
        case TextureFormat::RGBA16F: return DXGI_FORMAT_R16G16B16A16_FLOAT;
        case TextureFormat::RGBA32F: return DXGI_FORMAT_R32G32B32A32_FLOAT;
        case TextureFormat::Depth24Stencil8: return DXGI_FORMAT_D24_UNORM_S8_UINT;
        case TextureFormat::Depth32F: return DXGI_FORMAT_D32_FLOAT;
        default: return DXGI_FORMAT_R8G8B8A8_UNORM;
    }
}

} // namespace Renderer
} // namespace SwordAndStone

#endif // ENABLE_DX12
