include(FetchContent)

FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG v1.17.0   # or the latest release
)
set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)   # don't install gtest with the app
FetchContent_MakeAvailable(googletest)

add_executable(engine_tests
    test_carver.cpp
)

target_link_libraries(engine_tests
    PRIVATE engine GTest::gtest_main
)

include(GoogleTest)
gtest_discover_tests(engine_tests)