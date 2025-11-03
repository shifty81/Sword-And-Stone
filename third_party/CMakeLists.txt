# Third-party dependencies

# GLM - Math library
set(GLM_TEST_ENABLE OFF CACHE BOOL "" FORCE)
add_subdirectory(glm EXCLUDE_FROM_ALL)

# GLFW - Window/Input library (OpenGL context)
if(ENABLE_OPENGL)
    set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
    set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
    set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
    add_subdirectory(glfw EXCLUDE_FROM_ALL)
    
    # GLAD - OpenGL loader
    add_subdirectory(glad EXCLUDE_FROM_ALL)
endif()

# STB - Image loading
add_library(stb INTERFACE)
target_include_directories(stb INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/stb)
