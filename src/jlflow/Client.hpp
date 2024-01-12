#pragma once

#include "jlflow/KeyValuePair.hpp"
#include "jlflow/Workflow.hpp"

#include <drts/client.hpp>
#include <drts/drts.hpp>
#include <drts/scoped_rifd.hpp>

#include <memory>
#include <string>
#include <vector>

namespace jlflow
{
    struct Client
    {
        Client (
            std::string const& topology,
            std::string const& gspc_config
        );
        
        std::vector<KeyValuePair> submit (Workflow const& workflow, std::vector<KeyValuePair> const& inputs);

    private:
        boost::program_options::variables_map _gspc_config;
        gspc::installation _installation;
        std::unique_ptr<gspc::scoped_rifds> _rifds;
        std::unique_ptr<gspc::scoped_runtime_system> _drts;
        std::unique_ptr<gspc::client> _client;
    };

}
