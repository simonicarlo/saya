add_library(engine STATIC
    carver.cpp
    byte_source.hpp
    byte_source.cpp
)

target_include_directories(engine PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})