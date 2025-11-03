cmake_minimum_required(VERSION 3.15)
project(SwordAndStone VERSION 1.0.0 LANGUAGES CXX)

# C++ Standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Export compile commands for IDEs
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Platform detection
if(WIN32)
    set(PLATFORM_WINDOWS TRUE)
    add_definitions(-DPLATFORM_WINDOWS)
endif()

# Build options
option(BUILD_TESTS "Build test suite" ON)
option(ENABLE_OPENGL "Enable OpenGL renderer" ON)
option(ENABLE_DX11 "Enable DirectX 11 renderer" ON)
option(ENABLE_DX12 "Enable DirectX 12 renderer" ON)

# Include directories
include_directories(
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_SOURCE_DIR}/include/engine
    ${PROJECT_SOURCE_DIR}/include/game
    ${PROJECT_SOURCE_DIR}/include/platform
    ${PROJECT_SOURCE_DIR}/include/renderer
)

# Third-party dependencies
add_subdirectory(third_party)

# Engine library
add_subdirectory(src/engine)

# Renderer library
add_subdirectory(src/renderer)

# Platform library
add_subdirectory(src/platform)

# Game library
add_subdirectory(src/game)

# Main executable
add_executable(SwordAndStone
    src/main.cpp
)

target_link_libraries(SwordAndStone PRIVATE
    Engine
    Renderer
    Platform
    Game
)

# Tests
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

# Installation
install(TARGETS SwordAndStone
    RUNTIME DESTINATION bin
)

# Copy assets
install(DIRECTORY ${CMAKE_SOURCE_DIR}/assets
    DESTINATION bin
    PATTERN "*.gd" EXCLUDE
)

# Windows-specific settings
if(WIN32)
    # Set as Windows application (not console)
    set_target_properties(SwordAndStone PROPERTIES
        WIN32_EXECUTABLE TRUE
    )
    
    # Copy DLLs to output directory
    add_custom_command(TARGET SwordAndStone POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        $<TARGET_RUNTIME_DLLS:SwordAndStone>
        $<TARGET_FILE_DIR:SwordAndStone>
        COMMAND_EXPAND_LISTS
    )
endif()
