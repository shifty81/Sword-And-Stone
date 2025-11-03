# Engine library

set(ENGINE_SOURCES
    Engine.cpp
    Window.cpp
    InputManager.cpp
    TimeManager.cpp
)

set(ENGINE_HEADERS
    ${PROJECT_SOURCE_DIR}/include/engine/Engine.h
    ${PROJECT_SOURCE_DIR}/include/engine/Window.h
    ${PROJECT_SOURCE_DIR}/include/engine/InputManager.h
    ${PROJECT_SOURCE_DIR}/include/engine/TimeManager.h
)

add_library(Engine STATIC ${ENGINE_SOURCES} ${ENGINE_HEADERS})

target_include_directories(Engine PUBLIC
    ${PROJECT_SOURCE_DIR}/include
)

target_link_libraries(Engine PUBLIC
    Renderer
    glm
)

if(ENABLE_OPENGL)
    target_link_libraries(Engine PRIVATE glfw)
endif()

# Organize in IDE
source_group("Header Files" FILES ${ENGINE_HEADERS})
source_group("Source Files" FILES ${ENGINE_SOURCES})
