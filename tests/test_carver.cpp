#include <gtest/gtest.h>
#include "carver.hpp"

TEST(Engine, Version) {
    EXPECT_EQ(saya::version(), "0.1");
}