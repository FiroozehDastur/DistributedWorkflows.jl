#pragma once

#include "jlflow/KeyValuePair.hpp"

#include <we/type/value.hpp>

#include <map>
#include <string>
#include <vector>

namespace jlflow
{
    struct Workflow
    {
        Workflow (std::string const& pnet, std::vector<KeyValuePair> const& config);

    protected:
        std::string _pnet;
        std::multimap<std::string, pnet::type::value::value_type> _config;
    };

}
