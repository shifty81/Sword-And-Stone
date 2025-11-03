# Platform library

set(PLATFORM_SOURCES
    Platform.cpp
)

set(PLATFORM_HEADERS
    ${PROJECT_SOURCE_DIR}/include/platform/Platform.h
)

add_library(Platform STATIC ${PLATFORM_SOURCES} ${PLATFORM_HEADERS})

target_include_directories(Platform PUBLIC
    ${PROJECT_SOURCE_DIR}/include
)

# Organize in IDE
source_group("Header Files" FILES ${PLATFORM_HEADERS})
source_group("Source Files" FILES ${PLATFORM_SOURCES})
