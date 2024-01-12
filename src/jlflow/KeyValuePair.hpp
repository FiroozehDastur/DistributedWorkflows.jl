#pragma once

#include <string>

namespace jlflow
{
    struct KeyValuePair {
        KeyValuePair() = default;
        KeyValuePair (std::string port, std::string value);
        std::string port;
        std::string value;
    };
}
