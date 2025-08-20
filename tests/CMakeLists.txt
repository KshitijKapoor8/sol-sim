include(FetchContent)

FetchContent_Declare(
  Catch2
  GIT_REPOSITORY https://github.com/catchorg/Catch2.git
  GIT_TAG v3.5.2
)
FetchContent_MakeAvailable(Catch2)

add_executable(unit_tests
    test_hello.cpp
)

target_link_libraries(unit_tests PRIVATE
    sim_core       # link your core lib so tests can use it
    Catch2::Catch2WithMain
)

include(CTest)
include(Catch)
catch_discover_tests(unit_tests)
