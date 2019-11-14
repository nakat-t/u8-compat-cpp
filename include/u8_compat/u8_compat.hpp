#ifndef NAKATT_U8_COMPAT_U8_COMPAT_H_
#define NAKATT_U8_COMPAT_U8_COMPAT_H_

#include <cstddef>

#define U8(s) u8##s##_u8_compat

namespace u8_compat {

inline namespace literals {

#if defined(__cpp_char8_t)

inline
const char*
operator""_u8_compat(const char8_t *p, std::size_t)
{
    return reinterpret_cast<const char*>(p);
}

#else // defined(__cpp_char8_t)

inline
const char*
operator""_u8_compat(const char *p, std::size_t)
{
    return p;
}

#endif // defined(__cpp_char8_t)

} // inline namespace literals

} // namespace u8_compat

#endif // NAKATT_U8_COMPAT_U8_COMPAT_H_
