#include "renderer/OpenGLRenderer.h"
#include <iostream>

// Include GLAD before GLFW
#ifdef ENABLE_OPENGL
#include <glad/glad.h>
#include <GLFW/glfw3.h>
#endif

namespace SwordAndStone {
namespace Renderer {

OpenGLRenderer::OpenGLRenderer()
    : m_windowHandle(nullptr)
    , m_width(0)
    , m_height(0)
    , m_vao(0)
    , m_currentShader(0)
    , m_currentVBO(0)
    , m_currentIBO(0)
{
    m_clearColor[0] = 0.2f;
    m_clearColor[1] = 0.3f;
    m_clearColor[2] = 0.4f;
    m_clearColor[3] = 1.0f;
}

OpenGLRenderer::~OpenGLRenderer() {
    Shutdown();
}

bool OpenGLRenderer::Initialize(void* windowHandle, uint32_t width, uint32_t height) {
#ifdef ENABLE_OPENGL
    m_windowHandle = windowHandle;
    m_width = width;
    m_height = height;
    
    // Initialize GLAD
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
        std::cerr << "Failed to initialize GLAD" << std::endl;
        return false;
    }
    
    std::cout << "OpenGL Renderer initialized" << std::endl;
    std::cout << "  Vendor: " << glGetString(GL_VENDOR) << std::endl;
    std::cout << "  Renderer: " << glGetString(GL_RENDERER) << std::endl;
    std::cout << "  Version: " << glGetString(GL_VERSION) << std::endl;
    
    // Create default VAO
    glGenVertexArrays(1, &m_vao);
    glBindVertexArray(m_vao);
    
    // Set default OpenGL state
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);
    glFrontFace(GL_CCW);
    
    SetViewport(0, 0, width, height);
    
    return true;
#else
    return false;
#endif
}

void OpenGLRenderer::Shutdown() {
#ifdef ENABLE_OPENGL
    if (m_vao) {
        glDeleteVertexArrays(1, &m_vao);
        m_vao = 0;
    }
    std::cout << "OpenGL Renderer shut down" << std::endl;
#endif
}

void OpenGLRenderer::Resize(uint32_t width, uint32_t height) {
    m_width = width;
    m_height = height;
    SetViewport(0, 0, width, height);
}

void OpenGLRenderer::BeginFrame() {
    m_stats = RenderStats();
}

void OpenGLRenderer::EndFrame() {
}

void OpenGLRenderer::Present() {
#ifdef ENABLE_OPENGL
    glfwSwapBuffers(static_cast<GLFWwindow*>(m_windowHandle));
#endif
}

void OpenGLRenderer::Clear(uint32_t flags, float r, float g, float b, float a) {
#ifdef ENABLE_OPENGL
    GLbitfield clearFlags = 0;
    
    if (flags & ClearColor) {
        clearFlags |= GL_COLOR_BUFFER_BIT;
        glClearColor(r, g, b, a);
    }
    if (flags & ClearDepth) {
        clearFlags |= GL_DEPTH_BUFFER_BIT;
    }
    if (flags & ClearStencil) {
        clearFlags |= GL_STENCIL_BUFFER_BIT;
    }
    
    glClear(clearFlags);
#endif
}

void OpenGLRenderer::SetClearColor(float r, float g, float b, float a) {
    m_clearColor[0] = r;
    m_clearColor[1] = g;
    m_clearColor[2] = b;
    m_clearColor[3] = a;
}

void OpenGLRenderer::SetViewport(int x, int y, uint32_t width, uint32_t height) {
#ifdef ENABLE_OPENGL
    glViewport(x, y, width, height);
#endif
}

void OpenGLRenderer::SetScissor(int x, int y, uint32_t width, uint32_t height) {
#ifdef ENABLE_OPENGL
    glScissor(x, y, width, height);
#endif
}

uint32_t OpenGLRenderer::CreateVertexBuffer(const void* data, size_t size, BufferUsage usage) {
#ifdef ENABLE_OPENGL
    GLuint vbo;
    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, size, data, ConvertBufferUsage(usage));
    return vbo;
#else
    return 0;
#endif
}

uint32_t OpenGLRenderer::CreateIndexBuffer(const uint32_t* data, size_t count, BufferUsage usage) {
#ifdef ENABLE_OPENGL
    GLuint ibo;
    glGenBuffers(1, &ibo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, count * sizeof(uint32_t), data, ConvertBufferUsage(usage));
    return ibo;
#else
    return 0;
#endif
}

void OpenGLRenderer::UpdateVertexBuffer(uint32_t buffer, const void* data, size_t size, size_t offset) {
#ifdef ENABLE_OPENGL
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferSubData(GL_ARRAY_BUFFER, offset, size, data);
#endif
}

void OpenGLRenderer::DeleteBuffer(uint32_t buffer) {
#ifdef ENABLE_OPENGL
    GLuint buf = buffer;
    glDeleteBuffers(1, &buf);
#endif
}

uint32_t OpenGLRenderer::CreateTexture2D(uint32_t width, uint32_t height, TextureFormat format, const void* data) {
    // TODO: Implement texture creation
    return 0;
}

void OpenGLRenderer::UpdateTexture2D(uint32_t texture, const void* data, uint32_t mipLevel) {
    // TODO: Implement texture update
}

void OpenGLRenderer::DeleteTexture(uint32_t texture) {
#ifdef ENABLE_OPENGL
    GLuint tex = texture;
    glDeleteTextures(1, &tex);
#endif
}

void OpenGLRenderer::BindTexture(uint32_t slot, uint32_t texture) {
#ifdef ENABLE_OPENGL
    glActiveTexture(GL_TEXTURE0 + slot);
    glBindTexture(GL_TEXTURE_2D, texture);
#endif
}

uint32_t OpenGLRenderer::CreateShader(const std::string& vertexSource, const std::string& fragmentSource) {
    // TODO: Implement shader creation
    return 0;
}

void OpenGLRenderer::DeleteShader(uint32_t shader) {
#ifdef ENABLE_OPENGL
    glDeleteProgram(shader);
#endif
}

void OpenGLRenderer::BindShader(uint32_t shader) {
#ifdef ENABLE_OPENGL
    glUseProgram(shader);
    m_currentShader = shader;
#endif
}

void OpenGLRenderer::SetShaderUniform(uint32_t shader, const std::string& name, const void* data, size_t size) {
    // TODO: Implement uniform setting
}

void OpenGLRenderer::DrawIndexed(uint32_t vertexBuffer, uint32_t indexBuffer, uint32_t indexCount, 
                                 PrimitiveTopology topology) {
#ifdef ENABLE_OPENGL
    glBindVertexArray(m_vao);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    
    SetupVertexAttributes();
    
    glDrawElements(ConvertTopology(topology), indexCount, GL_UNSIGNED_INT, nullptr);
    
    m_stats.drawCalls++;
    m_stats.triangles += (topology == PrimitiveTopology::TriangleList) ? indexCount / 3 : 0;
#endif
}

void OpenGLRenderer::Draw(uint32_t vertexBuffer, uint32_t vertexCount, PrimitiveTopology topology) {
#ifdef ENABLE_OPENGL
    glBindVertexArray(m_vao);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    SetupVertexAttributes();
    
    glDrawArrays(ConvertTopology(topology), 0, vertexCount);
    
    m_stats.drawCalls++;
    m_stats.vertices += vertexCount;
#endif
}

void OpenGLRenderer::SetDepthTest(bool enabled) {
#ifdef ENABLE_OPENGL
    if (enabled) {
        glEnable(GL_DEPTH_TEST);
    } else {
        glDisable(GL_DEPTH_TEST);
    }
#endif
}

void OpenGLRenderer::SetBlending(bool enabled) {
#ifdef ENABLE_OPENGL
    if (enabled) {
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    } else {
        glDisable(GL_BLEND);
    }
#endif
}

void OpenGLRenderer::SetCulling(bool enabled) {
#ifdef ENABLE_OPENGL
    if (enabled) {
        glEnable(GL_CULL_FACE);
    } else {
        glDisable(GL_CULL_FACE);
    }
#endif
}

void OpenGLRenderer::SetWireframe(bool enabled) {
#ifdef ENABLE_OPENGL
    if (enabled) {
        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    } else {
        glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    }
#endif
}

uint32_t OpenGLRenderer::ConvertTopology(PrimitiveTopology topology) {
#ifdef ENABLE_OPENGL
    switch (topology) {
        case PrimitiveTopology::TriangleList: return GL_TRIANGLES;
        case PrimitiveTopology::TriangleStrip: return GL_TRIANGLE_STRIP;
        case PrimitiveTopology::LineList: return GL_LINES;
        case PrimitiveTopology::PointList: return GL_POINTS;
        default: return GL_TRIANGLES;
    }
#else
    return 0;
#endif
}

uint32_t OpenGLRenderer::ConvertBufferUsage(BufferUsage usage) {
#ifdef ENABLE_OPENGL
    switch (usage) {
        case BufferUsage::Static: return GL_STATIC_DRAW;
        case BufferUsage::Dynamic: return GL_DYNAMIC_DRAW;
        case BufferUsage::Stream: return GL_STREAM_DRAW;
        default: return GL_STATIC_DRAW;
    }
#else
    return 0;
#endif
}

void OpenGLRenderer::SetupVertexAttributes() {
#ifdef ENABLE_OPENGL
    // Position attribute
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, position));
    glEnableVertexAttribArray(0);
    
    // Normal attribute
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, normal));
    glEnableVertexAttribArray(1);
    
    // Texcoord attribute
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, texcoord));
    glEnableVertexAttribArray(2);
    
    // Color attribute
    glVertexAttribPointer(3, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, color));
    glEnableVertexAttribArray(3);
#endif
}

} // namespace Renderer
} // namespace SwordAndStone
