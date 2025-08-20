#include <catch2/catch_test_macros.hpp>

TEST_CASE("Hello world test") {
    int a = 2;
    int b = 2;
    REQUIRE(a + b == 4);
}
