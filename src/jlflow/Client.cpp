#include "jlflow/Client.hpp"

#include "jlflow/utility.hpp"
#include "jlflow/WorkflowAdapter.hpp"

#include <util-generic/executable_path.hpp>
#include <boost/program_options.hpp>
#include <we/type/value.hpp>

#include <map>

#include <iostream>

namespace {
  boost::program_options::variables_map parse_config (std::string const& config)
  {
    namespace po = boost::program_options;

    po::options_description driver_opts;
    driver_opts.add (gspc::options::installation());
    driver_opts.add (gspc::options::drts());
    driver_opts.add (gspc::options::logging());
    driver_opts.add (gspc::options::scoped_rifd());
    
    std::cout << "Initiating connection..." << std::endl;

    auto command_line = jlflow::split (config);
    command_line.emplace_back ("--application-search-path");
    // command_line.emplace_back ("./build/src/workflow/gen/pnetc/op");
    command_line.emplace_back (GSPC_APPLICATION_SEARCH_PATH);
    po::variables_map parameters;
    po::store ( po::command_line_parser (command_line)
                . options (driver_opts)
                . run()
                , parameters
                );

    parameters.notify();

    return parameters;
  }
}

namespace jlflow
{   
  Client::Client (std::string const& topology, std::string const& gspc_config)
    : _gspc_config {parse_config(gspc_config)}
    , _installation {_gspc_config} 
  {
   
    _rifds = std::make_unique<gspc::scoped_rifds>(gspc::rifd::strategy {_gspc_config},
           gspc::rifd::hostnames {_gspc_config},
           gspc::rifd::port {_gspc_config},
           _installation);

    // gspc::set_application_search_path(_gspc_config, "./build/src/workflow/gen/pnetc/op");
   
    _drts = std::make_unique<gspc::scoped_runtime_system> (_gspc_config,
          _installation,
          topology,
          _rifds->entry_points());

    _client = std::make_unique<gspc::client>(*_drts);

  }
    
  std::vector<KeyValuePair> Client::submit (Workflow const& workflow, std::vector<KeyValuePair> const& inputs)
  {
    auto const hello_julia_installation_path
      (fhg::util::executable_path().parent_path().parent_path());

    WorkflowAdapter wrkflw_adapter(workflow);
    
    std::multimap<std::string, pnet::type::value::value_type> workflow_inputs {to_multimap(inputs)};
    workflow_inputs.insert(wrkflw_adapter.get_config().begin(), wrkflw_adapter.get_config().end());

    // gspc::set_application_search_path
    //   (inputs, hello_julia_installation_path / "lib");

    gspc::workflow const workflow_obj (wrkflw_adapter.get_pnet());

    for (auto p : workflow_inputs)
      {
        std::cout << p.first << " : " << boost::get<std::string>(p.second) << std::endl;
      }

    auto result = _client->put_and_run(workflow_obj, workflow_inputs);



    for (auto const& entry : result)
    {
      std::cout << entry.first << " " << boost::get<std::string>(entry.second) << std::endl;
    }

    return from_multimap(result);
  }
}
  