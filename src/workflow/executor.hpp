#pragma once
#include <cerrno>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>


inline std::vector<std::vector<std::string>> execute(std::string implementation, std::string julia_impl, std::string fname, std::vector<std::string> input_files, std::size_t num_outputs)
{
    constexpr std::size_t buffer_size = 130;
    char buffer[buffer_size];

    std::stringstream cmd;
    cmd << "julia " << implementation << " " << julia_impl << " " << fname; 
    for (auto const& in_file : input_files)
    {
        cmd << " " << in_file;
    }
    std::cerr << "THIS IS TO CHECK WHAT CMD CONTAINS:" << cmd.str() << std::endl;
            
    // open a child pipe
    std::FILE *pipe = popen(cmd.str().c_str(), "r");
    if (pipe == nullptr)
    {
        std::cerr << std::strerror(errno) << std::endl;
        throw std::runtime_error(std::strerror(errno));
    }

    // read the pipe stdout until EOF is reached
    std::stringstream ss;
    while (std::fgets(buffer, buffer_size, pipe) != nullptr)
    {
        ss << buffer;
    }

    // check if pipe stdout reading successfully reached EOF
    int eof_value = std::feof(pipe);
    if (!eof_value)
    {
    std::cerr << std::strerror(errno) << std::endl;
    throw std::runtime_error(std::strerror(errno));
    }
    
    // check if pipe was successfully closed
    int close_return_value = pclose(pipe);
    if (close_return_value)
    {
    std::cerr << close_return_value << std::endl;
    std::cerr << std::strerror(errno) << std::endl;
    }
    
    std::vector<std::vector<std::string>> output(num_outputs); 
    std::cerr << "THIS IS THE JULIA OUTPUT: " << ss.str() << std::endl;
    std::string output_marker = "################################# YOUR OUTPUT FILES ARE #################################";

    std::string line;
    std::getline(ss, line);
    while (line != output_marker)
    {
        std::cerr << line << std::endl;
        std::getline(ss, line);
    }
    for (std::size_t i=0; i < num_outputs; i++)
    {
        std::getline(ss, line);
        std::cerr << "MULTIPLICITY IS: " << line << std::endl;

        auto multiplicity = std::stoull(line);
        for (std::size_t j=0; j < multiplicity; j++)
        {
        std::getline(ss, line);
        output[i].emplace_back(line);
        }  
    }

    return output;
}
