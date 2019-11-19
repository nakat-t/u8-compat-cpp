#include <u8_compat/u8_compat.hpp>

#include <string>
#include <catch2/catch.hpp>

TEST_CASE("U8() returns constexpr const char*")
{
    constexpr const char* s = U8("✨"); // SPARKLES(U+2728)
    REQUIRE(s == std::string{"\xE2\x9C\xA8"});
}

TEST_CASE("U8() and raw string literal")
{
    const char* s = U8(R"(☀)"); // BLACK SUN WITH RAYS(U+2600)
    REQUIRE(s == std::string{"\xE2\x98\x80"});
}
