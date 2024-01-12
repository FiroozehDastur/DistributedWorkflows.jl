#include "jlflow/Client.hpp"
#include "jlflow/KeyValuePair.hpp"
#include "jlflow/Workflow.hpp"

#include "jlcxx/jlcxx.hpp"
#include "jlcxx/stl.hpp"

#include <string>
#include <vector>

JLCXX_MODULE define_module_interface (jlcxx::Module& interface)
{
  using namespace jlflow;
  
  interface.add_type<KeyValuePair>("KeyValuePair")
    .constructor<std::string, std::string>()
    .method("get_port", [](KeyValuePair const& kvp) -> std::string const& { return kvp.port; })
    .method("get_value", [](KeyValuePair const& kvp) -> std::string const& { return kvp.value; });

  interface.add_type<Workflow>("Workflow")
    .constructor<std::string const&, std::vector<KeyValuePair> const&>();

  interface.add_type<Client>("Client")
    .constructor<std::string const&, std::string const&>()
    .method("submit", &Client::submit);
}