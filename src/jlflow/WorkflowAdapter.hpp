#pragma once

#include "jlflow/Workflow.hpp"

#include <we/type/value.hpp>

#include <map>
#include <string>

namespace jlflow
{
    struct WorkflowAdapter : private Workflow
    {
        WorkflowAdapter (Workflow const& workflow);

        std::multimap<std::string, pnet::type::value::value_type> const& get_config() const;
        std::string const& get_pnet() const;
    };
}
