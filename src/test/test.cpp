#include <gtest/gtest.h>
#include <rkdp/rkdp.hpp>

TEST(rkdp, hello)
{
    testing::internal::CaptureStdout();
    rkdp::hello();
    ASSERT_EQ("hello", testing::internal::GetCapturedStdout());
}
