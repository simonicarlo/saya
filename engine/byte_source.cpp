#include "byte_source.hpp"

#include <utility>
#include <algorithm>
#include <filesystem>
#include <fstream>
#include <stdexcept>

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


FileByteSource::FileByteSource(const std::filesystem::path& path)
    : file_(path, std::ios::binary), size_(std::filesystem::file_size(path)) {
    if(!file_.is_open()) {
        throw std::runtime_error("cannot open file: " + path.string());
    }
}

std::size_t FileByteSource::read(std::uint64_t offset, std::span<std::byte> out) const {
    if (offset >= size_) return 0;
    std::size_t count = std::min<std::size_t>(out.size(), size_ - offset);

    // clear flags in case previous read hit eof / failed
    file_.clear();

    file_.seekg(static_cast<std::streamoff>(offset));

    file_.read(reinterpret_cast<char*>(out.data()), static_cast<std::streamsize>(count));

    return static_cast<std::size_t>(file_.gcount());
}

std::uint64_t FileByteSource::size() const {
    return size_;
}


} // namespace saya