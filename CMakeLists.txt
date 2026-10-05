cmake_minimum_required(VERSION 3.16)
project(saya VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)   # for clang-tidy

find_package(Qt6 REQUIRED COMPONENTS Quick QuickLayouts)
qt_standard_project_setup(REQUIRES 6.10)

add_subdirectory(engine)
add_subdirectory(app)

enable_testing()
add_subdirectory(tests)