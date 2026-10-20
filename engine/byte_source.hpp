#ifndef BYTE_SOURCE_HPP
#define BYTE_SOURCE_HPP

#include <cstddef>
#include <cstdint>
#include <span>
#include <vector>

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

} // namespace saya


#endif // BYTE_SOURCE_HPP
