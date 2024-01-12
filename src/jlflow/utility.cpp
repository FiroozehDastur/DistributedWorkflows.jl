#include "jlflow/utility.hpp"

#include <we/type/value.hpp>

#include <iterator>
#include <sstream>

namespace jlflow
{
    std::vector<KeyValuePair> from_multimap (std::multimap<std::string, pnet::type::value::value_type> const& mumap)
    {
        std::vector<KeyValuePair> result;
        result.reserve (mumap.size());

        for (auto const& entry : mumap)
        {
            result.emplace_back(entry.first, boost::get<std::string>(entry.second));
        }
        return result;
    }

    std::multimap<std::string, pnet::type::value::value_type> to_multimap (std::vector<KeyValuePair> const& vecmap)
    {
        std::multimap<std::string, pnet::type::value::value_type> result;

        for (auto const& entry : vecmap)
        {
            result.insert(
                {entry.port, entry.value}
            );
        }
        return result;
    }

    std::vector<std::string> split (std::string const& input)
    {
        std::istringstream iss {input};

        std::vector<std::string> result; 
    
        result.assign (std::istream_iterator<std::string> (iss), std::istream_iterator<std::string> ());

        return result;

    }
}
