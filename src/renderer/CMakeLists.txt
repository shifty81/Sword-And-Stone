# Renderer library

set(RENDERER_SOURCES
    OpenGLRenderer.cpp
    RendererFactory.cpp
)

set(RENDERER_HEADERS
    ${PROJECT_SOURCE_DIR}/include/renderer/IRenderer.h
    ${PROJECT_SOURCE_DIR}/include/renderer/OpenGLRenderer.h
)

# Add DirectX renderers on Windows
if(WIN32)
    if(ENABLE_DX11)
        list(APPEND RENDERER_SOURCES DirectX11Renderer.cpp)
        list(APPEND RENDERER_HEADERS ${PROJECT_SOURCE_DIR}/include/renderer/DirectX11Renderer.h)
    endif()
    
    if(ENABLE_DX12)
        list(APPEND RENDERER_SOURCES DirectX12Renderer.cpp)
        list(APPEND RENDERER_HEADERS ${PROJECT_SOURCE_DIR}/include/renderer/DirectX12Renderer.h)
    endif()
endif()

add_library(Renderer STATIC ${RENDERER_SOURCES} ${RENDERER_HEADERS})

target_include_directories(Renderer PUBLIC
    ${PROJECT_SOURCE_DIR}/include
)

# Link OpenGL dependencies
if(ENABLE_OPENGL)
    target_link_libraries(Renderer PRIVATE glfw glad)
    target_compile_definitions(Renderer PUBLIC ENABLE_OPENGL)
endif()

# Link DirectX dependencies
if(WIN32)
    if(ENABLE_DX11)
        target_link_libraries(Renderer PRIVATE d3d11.lib dxgi.lib d3dcompiler.lib)
        target_compile_definitions(Renderer PUBLIC ENABLE_DX11)
    endif()
    
    if(ENABLE_DX12)
        target_link_libraries(Renderer PRIVATE d3d12.lib dxgi.lib d3dcompiler.lib)
        target_compile_definitions(Renderer PUBLIC ENABLE_DX12)
    endif()
endif()

# Organize in IDE
source_group("Header Files" FILES ${RENDERER_HEADERS})
source_group("Source Files" FILES ${RENDERER_SOURCES})
