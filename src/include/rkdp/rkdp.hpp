#ifndef RKDP_INTERFACE_HEADER_HPP
#define RKDP_INTERFACE_HEADER_HPP

namespace rkdp {

void hello();

} // namespace rkdp

#ifdef RKDP_HEADER_ONLY
namespace {
#include <rkdp/rkdp.cpp>
} // anonymous namespace
#endif // RKDP_HEADER_ONLY

#endif // RKDP_INTERFACE_HEADER_HPP
