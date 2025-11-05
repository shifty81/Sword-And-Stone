# Tests

enable_testing()

# Add Google Test if available
# For now, we'll create a simple test executable

set(TEST_SOURCES
    test_main.cpp
    test_renderer.cpp
)

add_executable(SwordAndStone_Tests ${TEST_SOURCES})

target_link_libraries(SwordAndStone_Tests PRIVATE
    Engine
    Renderer
    Platform
    Game
)

target_include_directories(SwordAndStone_Tests PRIVATE
    ${PROJECT_SOURCE_DIR}/include
)

# Add tests
add_test(NAME RendererTests COMMAND SwordAndStone_Tests)

# Copy test data if needed
# add_custom_command(TARGET SwordAndStone_Tests POST_BUILD
#     COMMAND ${CMAKE_COMMAND} -E copy_directory
#     ${CMAKE_SOURCE_DIR}/tests/data
#     $<TARGET_FILE_DIR:SwordAndStone_Tests>/data
# )
