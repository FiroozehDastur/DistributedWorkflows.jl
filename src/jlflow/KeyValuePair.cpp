#include "jlflow/KeyValuePair.hpp"

namespace jlflow
{
    KeyValuePair::KeyValuePair(std::string port, std::string value)
        : port {port}
        , value {value}
    {}
}
