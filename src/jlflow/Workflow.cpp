#include "jlflow/Workflow.hpp" // mandatory for source file
#include "jlflow/utility.hpp" // used within this file

namespace jlflow
{
    Workflow::Workflow (std::string const& pnet, std::vector<KeyValuePair> const& config)
        : _pnet {pnet}
        , _config {to_multimap (config)}
    {}

}
