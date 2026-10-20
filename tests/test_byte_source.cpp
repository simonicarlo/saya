#include <gtest/gtest.h>
#include "byte_source.hpp"

#include <cstddef>
#include <initializer_list>
#include <vector>

namespace {

std::vector<std::byte> bytes(std::initializer_list<int> values) {
    std::vector<std::byte> out;

    for (int v : values) {
        out.push_back(std::byte{static_cast<unsigned char>(v)});
    }

    return out;
}

} // namespace


TEST(MemoryByteSource, ReportsSize) {
    saya::MemoryByteSource src{bytes({1, 2, 3, 4})};
    // Expect this to be a 4 byte source
    EXPECT_EQ(src.size(), 4u);
}

TEST(MemoryByteSource, ReadsFromMiddle) {
    saya::MemoryByteSource src{bytes({1, 2, 3, 4, 5})};
    std::vector<std::byte> buf(3);

    std::size_t n = src.read(1, buf);

    EXPECT_EQ(n, 3u);
    EXPECT_EQ(buf, bytes({2, 3, 4}));
}

TEST(MemoryByteSource, TruncatesReadAtEnd) {
    saya::MemoryByteSource src{bytes({1, 2, 3, 4})};
    std::vector<std::byte> buf(4);

    std::size_t n = src.read(2, buf);

    EXPECT_EQ(n, 2u);
    EXPECT_EQ(buf, bytes({3, 4, 0, 0}));
}

TEST(MemoryByteSource, ReadAtOrPastEndReturnsZero) {
    saya::MemoryByteSource src{bytes({1, 2, 3, 4})};
    std::vector<std::byte> buf(4);

    std::size_t n1 = src.read(4, buf);
    std::size_t n2 = src.read(100, buf);

    EXPECT_EQ(n1, 0u);
    EXPECT_EQ(n2, 0u);
    EXPECT_EQ(buf, bytes({0, 0, 0, 0}));
}

TEST(MemoryByteSource, EmptySource) {
    saya::MemoryByteSource src{bytes({})};
    std::vector<std::byte> buf(4);

    std::size_t n = src.read(0, buf);

    EXPECT_EQ(src.size(), 0u);
    EXPECT_EQ(n, 0u);
}

TEST(MemoryByteSource, ReadIntoEmptyBuffer){
    saya::MemoryByteSource src{bytes({1, 2, 3, 4})};
    std::vector<std::byte> buf(0);

    std::size_t n = src.read(0, buf);

    EXPECT_EQ(n, 0u);
}