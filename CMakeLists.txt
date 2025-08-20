cmake_minimum_required(VERSION 3.20)
project(solarsim LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(SOLAR_WITH_VIZ "Build visualization" ON)
option(SOLAR_WITH_TESTS "Build tests" ON)

# Core simulation library
add_library(sim_core
    src/sim/world.cpp
    # add more sim source files here
)
target_include_directories(sim_core PUBLIC ${CMAKE_SOURCE_DIR}/include)

# CLI executable
add_executable(solarsim_cli apps/solarsim_cli.cpp)
target_link_libraries(solarsim_cli PRIVATE sim_core)

# Visualization (optional)
if (SOLAR_WITH_VIZ)
    add_library(viz_gl
        src/viz/renderer_opengl.cpp
        # add more viz source files here
    )
    target_include_directories(viz_gl PUBLIC ${CMAKE_SOURCE_DIR}/include)

    add_executable(solarsim_viewer apps/solarsim_viewer.cpp)
    target_link_libraries(solarsim_viewer PRIVATE sim_core viz_gl)
endif()

# Tests (optional)
if (SOLAR_WITH_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()
