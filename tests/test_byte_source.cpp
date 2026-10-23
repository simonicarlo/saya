#include <gtest/gtest.h>
#include "byte_source.hpp"

#include <cstddef>
#include <initializer_list>
#include <vector>
#include <filesystem>
#include <fstream>

namespace {

std::vector<std::byte> bytes(std::initializer_list<int> values) {
    std::vector<std::byte> out;

    for (int v : values) {
        out.push_back(std::byte{static_cast<unsigned char>(v)});
    }

    return out;
}

} // namespace


// MemoryByteSource Tests


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

TEST(MemoryByteSource, ReadIntoEmptyBuffer) {
    saya::MemoryByteSource src{bytes({1, 2, 3, 4})};
    std::vector<std::byte> buf(0);

    std::size_t n = src.read(0, buf);

    EXPECT_EQ(n, 0u);
}

// FileByteSource Tests

class FileByteSourceTest : public ::testing::Test {
protected:
    void SetUp() override {
        path_ = std::filesystem::temp_directory_path() / "saya_file_byte_source_test.bin";
    }

    void TearDown() override {
        std::filesystem::remove(path_);   // runs even when the test failed
    }

    // writes `data` to path_, replacing any existing content
    void write_file(const std::vector<std::byte>& data) {
        std::ofstream file(path_, std::ios::binary);

        ASSERT_TRUE(file.is_open()) << "could not create " << path_;

        file.write(reinterpret_cast<const char*>(data.data()), static_cast<std::streamsize>(data.size()));

        ASSERT_TRUE(file.good());
    }

    std::filesystem::path path_;
};

TEST_F(FileByteSourceTest, ReportsSize) {
    write_file(bytes({1, 2, 3, 4}));
    saya::FileByteSource src{path_};
    EXPECT_EQ(src.size(), 4u);
}

TEST_F(FileByteSourceTest, ReadsFromMiddle) {
    write_file(bytes({1, 2, 3, 4, 5}));
    saya::FileByteSource src{path_};

    std::vector<std::byte> buf(3);

    std::size_t n = src.read(1, buf);

    EXPECT_EQ(n, 3u);
    EXPECT_EQ(buf, bytes({2, 3, 4}));
}

TEST_F(FileByteSourceTest, TruncatesReadAtEnd) {
    write_file(bytes({1, 2, 3, 4}));
    saya::FileByteSource src{path_};

    std::vector<std::byte> buf(4);

    std::size_t n = src.read(2, buf);

    EXPECT_EQ(n, 2u);
    EXPECT_EQ(buf, bytes({3, 4, 0, 0}));
}

TEST_F(FileByteSourceTest, ReadAtOrPastEndReturnsZero) {
    write_file(bytes({1, 2, 3, 4}));
    saya::FileByteSource src{path_};

    std::vector<std::byte> buf(4);

    std::size_t n1 = src.read(4, buf);
    std::size_t n2 = src.read(100, buf);

    EXPECT_EQ(n1, 0u);
    EXPECT_EQ(n2, 0u);
    EXPECT_EQ(buf, bytes({0, 0, 0, 0}));
}

TEST_F(FileByteSourceTest, EmptySource) {
    write_file(bytes({}));
    saya::FileByteSource src{path_};

    std::vector<std::byte> buf(4);

    std::size_t n = src.read(0, buf);

    EXPECT_EQ(src.size(), 0u);
    EXPECT_EQ(n, 0u);
}

TEST_F(FileByteSourceTest, ReadIntoEmptyBuffer) {
    write_file(bytes({1, 2, 3, 4}));
    saya::FileByteSource src{path_};

    std::vector<std::byte> buf(0);

    std::size_t n = src.read(0, buf);

    EXPECT_EQ(n, 0u);
}

TEST_F(FileByteSourceTest, ThrowsOnMissingFile) {
    EXPECT_THROW(saya::FileByteSource{path_}, std::runtime_error);
}

TEST_F(FileByteSourceTest, ReadsAgainAfterReadingToEnd) {
    write_file(bytes({1, 2, 3, 4}));
    saya::FileByteSource src{path_};

    std::vector<std::byte> buf(4);

    std::size_t n1 = src.read(3, buf);

    std::size_t n2 = src.read(0, buf);

    EXPECT_EQ(n1, 1u);
    EXPECT_EQ(n2, 4u);
    EXPECT_EQ(buf, bytes({1, 2, 3, 4}));
}

TEST_F(FileByteSourceTest, NeverReadsPastReportedSize) {
    write_file(bytes({1, 2, 3, 4}));
    saya::FileByteSource src{path_};


    {
        std::ofstream file(path_, std::ios::binary | std::ios::app);

        ASSERT_TRUE(file.is_open()) << "could not create " << path_;

        std::vector<std::byte> data = bytes({5, 6, 7, 8});

        file.write(reinterpret_cast<const char*>(data.data()), static_cast<std::streamsize>(data.size()));

    }

    std::vector<std::byte> buf(8);

    std::size_t n = src.read(2, buf);

    EXPECT_EQ(n, 2u);

}


