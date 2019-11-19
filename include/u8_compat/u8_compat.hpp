#ifndef NAKATT_U8_COMPAT_U8_COMPAT_H_
#define NAKATT_U8_COMPAT_U8_COMPAT_H_

#include <cstddef>
#include <utility>

// @todo: The value of __cplusplus in C++20 is undefined now.
// 201704L is the minimum value returned by the current compiler with -std-c++2a or /std:c++latest.
#if __cplusplus > 201704L
#define U8(s) u8##s##_u8_compat
#else
#define U8(s) u8##s
#endif

#if __cplusplus > 201704L

namespace u8_compat {

namespace detail {

template<std::size_t N>
struct u8_compat_udl
{
    static inline constexpr const std::size_t size = N;

    template<std::size_t... I>
    constexpr u8_compat_udl(const char8_t (&s)[N], std::index_sequence<I...>) noexcept
        : value{s[I]...}
    {}

    constexpr u8_compat_udl(const char8_t (&s)[N]) noexcept
        : u8_compat_udl(s, std::make_index_sequence<N>())
    {}

    auto operator <=>(const u8_compat_udl&) const = default;

    char8_t value[N];
};

template<std::size_t N>
u8_compat_udl(const char8_t(&)[N]) -> u8_compat_udl<N>;

template<u8_compat_udl UDL, std::size_t... I>
inline
constexpr const char
template_buffer_per_udl[sizeof...(I)] = { static_cast<char>(UDL.value[I])... };

template<u8_compat_udl UDL, std::size_t... I>
constexpr auto&
make_template_buffer_per_udl(std::index_sequence<I...>)
{
    return template_buffer_per_udl<UDL, I...>;
}

} // namespace detail

inline namespace literals {

template<u8_compat::detail::u8_compat_udl UDL>
inline
constexpr const auto&
operator""_u8_compat()
{
    return detail::make_template_buffer_per_udl<UDL>(std::make_index_sequence<decltype(UDL)::size>());
}

} // inline namespace literals

} // namespace u8_compat

using namespace u8_compat::literals;

#endif // __cplusplus > 201704L

#endif // NAKATT_U8_COMPAT_U8_COMPAT_H_
