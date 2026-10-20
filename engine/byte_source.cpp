#include "byte_source.hpp"

#include <utility>
#include <algorithm>

namespace saya {

MemoryByteSource::MemoryByteSource(std::vector<std::byte> data) : data_(std::move(data)) {}


std::uint64_t MemoryByteSource::size() const   {
    return data_.size();
}

std::size_t MemoryByteSource::read(std::uint64_t offset, std::span<std::byte> out) const {
    if(offset >= data_.size()) return 0;

    std::size_t space_available = std::min<std::size_t>(out.size(), (data_.size() - offset));

    std::span data_to_copy = std::span{data_}.subspan(offset, space_available);

    std::ranges::copy(data_to_copy, out.begin());


    return space_available;
}


} // namespace saya