#pragma once

#include "jlflow/KeyValuePair.hpp"

#include <we/type/value.hpp>

#include <map>
#include <string>
#include <vector>

namespace jlflow
{
    std::vector<KeyValuePair> from_multimap (std::multimap<std::string, pnet::type::value::value_type> const& config);
    std::multimap<std::string, pnet::type::value::value_type> to_multimap (std::vector<KeyValuePair> const& vec_config);
    std::vector<std::string> split (std::string const& input);
}
