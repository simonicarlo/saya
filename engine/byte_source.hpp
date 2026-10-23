#ifndef BYTE_SOURCE_HPP
#define BYTE_SOURCE_HPP

#include <cstddef>
#include <cstdint>
#include <span>
#include <vector>
#include <filesystem>
#include <fstream>

namespace saya {

    class ByteSource {
    public:
        virtual ~ByteSource() = default;

        [[nodiscard]] virtual std::uint64_t size() const = 0;

        [[nodiscard]] virtual std::size_t read(std::uint64_t offset, std::span<std::byte> out) const = 0;

    };

    class MemoryByteSource final : public ByteSource {
    public:
        explicit MemoryByteSource(std::vector<std::byte> data);

        [[nodiscard]] std::uint64_t size() const override;
        [[nodiscard]] std::size_t read(std::uint64_t offset, std::span<std::byte> out) const override;


    private:
        std::vector<std::byte> data_;
    };

    class FileByteSource final : public ByteSource {
    public:
        explicit FileByteSource(const std::filesystem::path& path);

        [[nodiscard]] std::uint64_t size() const override;
        [[nodiscard]] std::size_t read(std::uint64_t offset, std::span<std::byte> out) const override;

    private:
        // read() moves this stream's position, so FileByteSource is not safe
        // to use from several threads at once.
        mutable std::ifstream file_;
        std::uint64_t size_;
    };

} // namespace saya


#endif // BYTE_SOURCE_HPP
