#ifndef EXAMPLE_INTERFACE_HEADER_HPP
#define EXAMPLE_INTERFACE_HEADER_HPP

namespace example {

void hello();

} // namespace example

#ifdef EXAMPLE_HEADER_ONLY
namespace {
#include <example/example.cpp>
} // anonymous namespace
#endif // EXAMPLE_HEADER_ONLY

#endif // EXAMPLE_INTERFACE_HEADER_HPP
