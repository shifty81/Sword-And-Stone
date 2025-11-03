#include "renderer/DirectX11Renderer.h"
#include <iostream>

#ifdef ENABLE_DX11

namespace SwordAndStone {
namespace Renderer {

DirectX11Renderer::DirectX11Renderer()
    : m_width(0)
    , m_height(0)
    , m_nextID(1)
{
    m_clearColor[0] = 0.2f;
    m_clearColor[1] = 0.3f;
    m_clearColor[2] = 0.4f;
    m_clearColor[3] = 1.0f;
}

DirectX11Renderer::~DirectX11Renderer() {
    Shutdown();
}

bool DirectX11Renderer::Initialize(void* windowHandle, uint32_t width, uint32_t height) {
    m_width = width;
    m_height = height;
    
    // Create device and swap chain
    DXGI_SWAP_CHAIN_DESC sd = {};
    sd.BufferCount = 1;
    sd.BufferDesc.Width = width;
    sd.BufferDesc.Height = height;
    sd.BufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    sd.BufferDesc.RefreshRate.Numerator = 60;
    sd.BufferDesc.RefreshRate.Denominator = 1;
    sd.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
    sd.OutputWindow = static_cast<HWND>(windowHandle);
    sd.SampleDesc.Count = 1;
    sd.SampleDesc.Quality = 0;
    sd.Windowed = TRUE;
    sd.SwapEffect = DXGI_SWAP_EFFECT_DISCARD;
    
    D3D_FEATURE_LEVEL featureLevel;
    const D3D_FEATURE_LEVEL featureLevels[] = { D3D_FEATURE_LEVEL_11_0 };
    
    HRESULT hr = D3D11CreateDeviceAndSwapChain(
        nullptr,
        D3D_DRIVER_TYPE_HARDWARE,
        nullptr,
        0,
        featureLevels,
        1,
        D3D11_SDK_VERSION,
        &sd,
        m_swapChain.GetAddressOf(),
        m_device.GetAddressOf(),
        &featureLevel,
        m_context.GetAddressOf()
    );
    
    if (FAILED(hr)) {
        std::cerr << "Failed to create D3D11 device and swap chain" << std::endl;
        return false;
    }
    
    // Create render target view
    if (!CreateRenderTarget()) {
        return false;
    }
    
    // Create depth stencil
    if (!CreateDepthStencil()) {
        return false;
    }
    
    // Set render targets
    m_context->OMSetRenderTargets(1, m_renderTargetView.GetAddressOf(), m_depthStencilView.Get());
    
    // Create default states
    CreateDefaultStates();
    
    // Set viewport
    SetViewport(0, 0, width, height);
    
    std::cout << "DirectX 11 Renderer initialized" << std::endl;
    return true;
}

void DirectX11Renderer::Shutdown() {
    m_buffers.clear();
    m_textures.clear();
    m_textureSRVs.clear();
    m_shaders.clear();
    
    if (m_context) {
        m_context->ClearState();
        m_context->Flush();
    }
    
    std::cout << "DirectX 11 Renderer shut down" << std::endl;
}

void DirectX11Renderer::Resize(uint32_t width, uint32_t height) {
    if (!m_swapChain) return;
    
    m_width = width;
    m_height = height;
    
    m_renderTargetView.Reset();
    m_depthStencilView.Reset();
    m_depthStencilBuffer.Reset();
    
    m_swapChain->ResizeBuffers(0, width, height, DXGI_FORMAT_UNKNOWN, 0);
    
    CreateRenderTarget();
    CreateDepthStencil();
    
    m_context->OMSetRenderTargets(1, m_renderTargetView.GetAddressOf(), m_depthStencilView.Get());
    SetViewport(0, 0, width, height);
}

void DirectX11Renderer::BeginFrame() {
    m_stats = RenderStats();
}

void DirectX11Renderer::EndFrame() {
}

void DirectX11Renderer::Present() {
    if (m_swapChain) {
        m_swapChain->Present(1, 0);
    }
}

void DirectX11Renderer::Clear(uint32_t flags, float r, float g, float b, float a) {
    if (flags & ClearColor) {
        float color[4] = { r, g, b, a };
        m_context->ClearRenderTargetView(m_renderTargetView.Get(), color);
    }
    
    if ((flags & ClearDepth) || (flags & ClearStencil)) {
        UINT clearFlags = 0;
        if (flags & ClearDepth) clearFlags |= D3D11_CLEAR_DEPTH;
        if (flags & ClearStencil) clearFlags |= D3D11_CLEAR_STENCIL;
        m_context->ClearDepthStencilView(m_depthStencilView.Get(), clearFlags, 1.0f, 0);
    }
}

void DirectX11Renderer::SetClearColor(float r, float g, float b, float a) {
    m_clearColor[0] = r;
    m_clearColor[1] = g;
    m_clearColor[2] = b;
    m_clearColor[3] = a;
}

void DirectX11Renderer::SetViewport(int x, int y, uint32_t width, uint32_t height) {
    D3D11_VIEWPORT vp;
    vp.TopLeftX = static_cast<float>(x);
    vp.TopLeftY = static_cast<float>(y);
    vp.Width = static_cast<float>(width);
    vp.Height = static_cast<float>(height);
    vp.MinDepth = 0.0f;
    vp.MaxDepth = 1.0f;
    m_context->RSSetViewports(1, &vp);
}

void DirectX11Renderer::SetScissor(int x, int y, uint32_t width, uint32_t height) {
    D3D11_RECT rect;
    rect.left = x;
    rect.top = y;
    rect.right = x + width;
    rect.bottom = y + height;
    m_context->RSSetScissorRects(1, &rect);
}

uint32_t DirectX11Renderer::CreateVertexBuffer(const void* data, size_t size, BufferUsage usage) {
    D3D11_BUFFER_DESC bd = {};
    bd.Usage = ConvertBufferUsage(usage);
    bd.ByteWidth = static_cast<UINT>(size);
    bd.BindFlags = D3D11_BIND_VERTEX_BUFFER;
    bd.CPUAccessFlags = (usage == BufferUsage::Dynamic) ? D3D11_CPU_ACCESS_WRITE : 0;
    
    D3D11_SUBRESOURCE_DATA initData = {};
    initData.pSysMem = data;
    
    ComPtr<ID3D11Buffer> buffer;
    HRESULT hr = m_device->CreateBuffer(&bd, data ? &initData : nullptr, buffer.GetAddressOf());
    
    if (FAILED(hr)) {
        return 0;
    }
    
    uint32_t id = m_nextID++;
    m_buffers[id] = buffer;
    return id;
}

uint32_t DirectX11Renderer::CreateIndexBuffer(const uint32_t* data, size_t count, BufferUsage usage) {
    D3D11_BUFFER_DESC bd = {};
    bd.Usage = ConvertBufferUsage(usage);
    bd.ByteWidth = static_cast<UINT>(count * sizeof(uint32_t));
    bd.BindFlags = D3D11_BIND_INDEX_BUFFER;
    bd.CPUAccessFlags = (usage == BufferUsage::Dynamic) ? D3D11_CPU_ACCESS_WRITE : 0;
    
    D3D11_SUBRESOURCE_DATA initData = {};
    initData.pSysMem = data;
    
    ComPtr<ID3D11Buffer> buffer;
    HRESULT hr = m_device->CreateBuffer(&bd, data ? &initData : nullptr, buffer.GetAddressOf());
    
    if (FAILED(hr)) {
        return 0;
    }
    
    uint32_t id = m_nextID++;
    m_buffers[id] = buffer;
    return id;
}

void DirectX11Renderer::UpdateVertexBuffer(uint32_t buffer, const void* data, size_t size, size_t offset) {
    auto it = m_buffers.find(buffer);
    if (it == m_buffers.end()) return;
    
    D3D11_MAPPED_SUBRESOURCE mapped;
    if (SUCCEEDED(m_context->Map(it->second.Get(), 0, D3D11_MAP_WRITE_DISCARD, 0, &mapped))) {
        memcpy(static_cast<char*>(mapped.pData) + offset, data, size);
        m_context->Unmap(it->second.Get(), 0);
    }
}

void DirectX11Renderer::DeleteBuffer(uint32_t buffer) {
    m_buffers.erase(buffer);
}

uint32_t DirectX11Renderer::CreateTexture2D(uint32_t width, uint32_t height, TextureFormat format, const void* data) {
    // TODO: Implement texture creation
    return 0;
}

void DirectX11Renderer::UpdateTexture2D(uint32_t texture, const void* data, uint32_t mipLevel) {
    // TODO: Implement texture update
}

void DirectX11Renderer::DeleteTexture(uint32_t texture) {
    m_textures.erase(texture);
    m_textureSRVs.erase(texture);
}

void DirectX11Renderer::BindTexture(uint32_t slot, uint32_t texture) {
    auto it = m_textureSRVs.find(texture);
    if (it != m_textureSRVs.end()) {
        m_context->PSSetShaderResources(slot, 1, it->second.GetAddressOf());
    }
}

uint32_t DirectX11Renderer::CreateShader(const std::string& vertexSource, const std::string& fragmentSource) {
    // TODO: Implement shader creation
    return 0;
}

void DirectX11Renderer::DeleteShader(uint32_t shader) {
    m_shaders.erase(shader);
}

void DirectX11Renderer::BindShader(uint32_t shader) {
    auto it = m_shaders.find(shader);
    if (it != m_shaders.end()) {
        m_context->VSSetShader(it->second.vertexShader.Get(), nullptr, 0);
        m_context->PSSetShader(it->second.pixelShader.Get(), nullptr, 0);
    }
}

void DirectX11Renderer::SetShaderUniform(uint32_t shader, const std::string& name, const void* data, size_t size) {
    // TODO: Implement uniform setting
}

void DirectX11Renderer::DrawIndexed(uint32_t vertexBuffer, uint32_t indexBuffer, uint32_t indexCount, 
                                    PrimitiveTopology topology) {
    auto vbIt = m_buffers.find(vertexBuffer);
    auto ibIt = m_buffers.find(indexBuffer);
    
    if (vbIt == m_buffers.end() || ibIt == m_buffers.end()) return;
    
    UINT stride = sizeof(Vertex);
    UINT offset = 0;
    ID3D11Buffer* vb = vbIt->second.Get();
    
    m_context->IASetVertexBuffers(0, 1, &vb, &stride, &offset);
    m_context->IASetIndexBuffer(ibIt->second.Get(), DXGI_FORMAT_R32_UINT, 0);
    m_context->IASetPrimitiveTopology(ConvertTopology(topology));
    
    if (m_inputLayout) {
        m_context->IASetInputLayout(m_inputLayout.Get());
    }
    
    m_context->DrawIndexed(indexCount, 0, 0);
    
    m_stats.drawCalls++;
    m_stats.triangles += (topology == PrimitiveTopology::TriangleList) ? indexCount / 3 : 0;
}

void DirectX11Renderer::Draw(uint32_t vertexBuffer, uint32_t vertexCount, PrimitiveTopology topology) {
    auto it = m_buffers.find(vertexBuffer);
    if (it == m_buffers.end()) return;
    
    UINT stride = sizeof(Vertex);
    UINT offset = 0;
    ID3D11Buffer* vb = it->second.Get();
    
    m_context->IASetVertexBuffers(0, 1, &vb, &stride, &offset);
    m_context->IASetPrimitiveTopology(ConvertTopology(topology));
    
    if (m_inputLayout) {
        m_context->IASetInputLayout(m_inputLayout.Get());
    }
    
    m_context->Draw(vertexCount, 0);
    
    m_stats.drawCalls++;
    m_stats.vertices += vertexCount;
}

void DirectX11Renderer::SetDepthTest(bool enabled) {
    if (enabled) {
        m_context->OMSetDepthStencilState(m_depthStencilStateEnabled.Get(), 0);
    } else {
        m_context->OMSetDepthStencilState(m_depthStencilStateDisabled.Get(), 0);
    }
}

void DirectX11Renderer::SetBlending(bool enabled) {
    if (enabled) {
        m_context->OMSetBlendState(m_blendStateEnabled.Get(), nullptr, 0xFFFFFFFF);
    } else {
        m_context->OMSetBlendState(m_blendStateDisabled.Get(), nullptr, 0xFFFFFFFF);
    }
}

void DirectX11Renderer::SetCulling(bool enabled) {
    if (enabled) {
        m_context->RSSetState(m_rasterizerStateSolid.Get());
    } else {
        // Use a cull-disabled state (would need to be created)
        m_context->RSSetState(m_rasterizerStateSolid.Get());
    }
}

void DirectX11Renderer::SetWireframe(bool enabled) {
    if (enabled) {
        m_context->RSSetState(m_rasterizerStateWireframe.Get());
    } else {
        m_context->RSSetState(m_rasterizerStateSolid.Get());
    }
}

bool DirectX11Renderer::CreateRenderTarget() {
    ComPtr<ID3D11Texture2D> backBuffer;
    HRESULT hr = m_swapChain->GetBuffer(0, IID_PPV_ARGS(backBuffer.GetAddressOf()));
    if (FAILED(hr)) return false;
    
    hr = m_device->CreateRenderTargetView(backBuffer.Get(), nullptr, m_renderTargetView.GetAddressOf());
    return SUCCEEDED(hr);
}

bool DirectX11Renderer::CreateDepthStencil() {
    D3D11_TEXTURE2D_DESC descDepth = {};
    descDepth.Width = m_width;
    descDepth.Height = m_height;
    descDepth.MipLevels = 1;
    descDepth.ArraySize = 1;
    descDepth.Format = DXGI_FORMAT_D24_UNORM_S8_UINT;
    descDepth.SampleDesc.Count = 1;
    descDepth.SampleDesc.Quality = 0;
    descDepth.Usage = D3D11_USAGE_DEFAULT;
    descDepth.BindFlags = D3D11_BIND_DEPTH_STENCIL;
    
    HRESULT hr = m_device->CreateTexture2D(&descDepth, nullptr, m_depthStencilBuffer.GetAddressOf());
    if (FAILED(hr)) return false;
    
    hr = m_device->CreateDepthStencilView(m_depthStencilBuffer.Get(), nullptr, m_depthStencilView.GetAddressOf());
    return SUCCEEDED(hr);
}

void DirectX11Renderer::CreateDefaultStates() {
    // Rasterizer states
    D3D11_RASTERIZER_DESC rsDesc = {};
    rsDesc.FillMode = D3D11_FILL_SOLID;
    rsDesc.CullMode = D3D11_CULL_BACK;
    rsDesc.FrontCounterClockwise = FALSE;
    rsDesc.DepthClipEnable = TRUE;
    m_device->CreateRasterizerState(&rsDesc, m_rasterizerStateSolid.GetAddressOf());
    
    rsDesc.FillMode = D3D11_FILL_WIREFRAME;
    m_device->CreateRasterizerState(&rsDesc, m_rasterizerStateWireframe.GetAddressOf());
    
    // Depth stencil states
    D3D11_DEPTH_STENCIL_DESC dsDesc = {};
    dsDesc.DepthEnable = TRUE;
    dsDesc.DepthWriteMask = D3D11_DEPTH_WRITE_MASK_ALL;
    dsDesc.DepthFunc = D3D11_COMPARISON_LESS;
    m_device->CreateDepthStencilState(&dsDesc, m_depthStencilStateEnabled.GetAddressOf());
    
    dsDesc.DepthEnable = FALSE;
    m_device->CreateDepthStencilState(&dsDesc, m_depthStencilStateDisabled.GetAddressOf());
    
    // Blend states
    D3D11_BLEND_DESC blendDesc = {};
    blendDesc.RenderTarget[0].BlendEnable = FALSE;
    blendDesc.RenderTarget[0].RenderTargetWriteMask = D3D11_COLOR_WRITE_ENABLE_ALL;
    m_device->CreateBlendState(&blendDesc, m_blendStateDisabled.GetAddressOf());
    
    blendDesc.RenderTarget[0].BlendEnable = TRUE;
    blendDesc.RenderTarget[0].SrcBlend = D3D11_BLEND_SRC_ALPHA;
    blendDesc.RenderTarget[0].DestBlend = D3D11_BLEND_INV_SRC_ALPHA;
    blendDesc.RenderTarget[0].BlendOp = D3D11_BLEND_OP_ADD;
    blendDesc.RenderTarget[0].SrcBlendAlpha = D3D11_BLEND_ONE;
    blendDesc.RenderTarget[0].DestBlendAlpha = D3D11_BLEND_ZERO;
    blendDesc.RenderTarget[0].BlendOpAlpha = D3D11_BLEND_OP_ADD;
    m_device->CreateBlendState(&blendDesc, m_blendStateEnabled.GetAddressOf());
}

D3D11_USAGE DirectX11Renderer::ConvertBufferUsage(BufferUsage usage) {
    switch (usage) {
        case BufferUsage::Static: return D3D11_USAGE_DEFAULT;
        case BufferUsage::Dynamic: return D3D11_USAGE_DYNAMIC;
        case BufferUsage::Stream: return D3D11_USAGE_DYNAMIC;
        default: return D3D11_USAGE_DEFAULT;
    }
}

D3D_PRIMITIVE_TOPOLOGY DirectX11Renderer::ConvertTopology(PrimitiveTopology topology) {
    switch (topology) {
        case PrimitiveTopology::TriangleList: return D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
        case PrimitiveTopology::TriangleStrip: return D3D_PRIMITIVE_TOPOLOGY_TRIANGLESTRIP;
        case PrimitiveTopology::LineList: return D3D_PRIMITIVE_TOPOLOGY_LINELIST;
        case PrimitiveTopology::PointList: return D3D_PRIMITIVE_TOPOLOGY_POINTLIST;
        default: return D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
    }
}

DXGI_FORMAT DirectX11Renderer::ConvertTextureFormat(TextureFormat format) {
    switch (format) {
        case TextureFormat::RGBA8: return DXGI_FORMAT_R8G8B8A8_UNORM;
        case TextureFormat::RGB8: return DXGI_FORMAT_R8G8B8A8_UNORM;  // D3D11 doesn't have RGB8
        case TextureFormat::RGBA16F: return DXGI_FORMAT_R16G16B16A16_FLOAT;
        case TextureFormat::RGBA32F: return DXGI_FORMAT_R32G32B32A32_FLOAT;
        case TextureFormat::Depth24Stencil8: return DXGI_FORMAT_D24_UNORM_S8_UINT;
        case TextureFormat::Depth32F: return DXGI_FORMAT_D32_FLOAT;
        default: return DXGI_FORMAT_R8G8B8A8_UNORM;
    }
}

} // namespace Renderer
} // namespace SwordAndStone

#endif // ENABLE_DX11
