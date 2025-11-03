# Game library

set(GAME_SOURCES
    GameWorld.cpp
    Player.cpp
    VoxelSystem.cpp
)

set(GAME_HEADERS
    ${PROJECT_SOURCE_DIR}/include/game/GameWorld.h
    ${PROJECT_SOURCE_DIR}/include/game/Player.h
    ${PROJECT_SOURCE_DIR}/include/game/VoxelSystem.h
)

add_library(Game STATIC ${GAME_SOURCES} ${GAME_HEADERS})

target_include_directories(Game PUBLIC
    ${PROJECT_SOURCE_DIR}/include
)

target_link_libraries(Game PUBLIC
    Engine
    glm
)

# Organize in IDE
source_group("Header Files" FILES ${GAME_HEADERS})
source_group("Source Files" FILES ${GAME_SOURCES})
