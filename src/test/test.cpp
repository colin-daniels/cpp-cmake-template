#include <gtest/gtest.h>
#include "example_lib/example.hpp"

TEST(example, hello)
{
    testing::internal::CaptureStdout();
    example::hello();
    ASSERT_EQ("hello", testing::internal::GetCapturedStdout());
}
