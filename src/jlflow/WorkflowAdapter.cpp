#include "jlflow/WorkflowAdapter.hpp"

#include <we/type/value.hpp>

namespace jlflow
{
    WorkflowAdapter::WorkflowAdapter (Workflow const& workflow)
        : Workflow(workflow)
    {}
    
    std::multimap<std::string, pnet::type::value::value_type> const& WorkflowAdapter::get_config() const
    {
        return _config;
    }

    std::string const& WorkflowAdapter::get_pnet() const
    {
        return _pnet;
    }
}
