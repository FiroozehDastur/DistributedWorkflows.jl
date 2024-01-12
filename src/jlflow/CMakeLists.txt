find_package (GPISpace REQUIRED)
find_package (Boost 1.63.0 REQUIRED
  COMPONENTS
     program_options
)
find_package(JlCxx REQUIRED)

target_link_libraries(
    ${PROJECT_NAME}
    PUBLIC
        GPISpace::execution
        JlCxx::cxxwrap_julia
        JlCxx::cxxwrap_julia_stl

    PRIVATE
        Boost::headers
        Boost::program_options
    
)

target_compile_options (${PROJECT_NAME} PRIVATE -DGSPC_APPLICATION_SEARCH_PATH="${CMAKE_BINARY_DIR}/src/workflow/gen/pnetc/op")
target_sources(${PROJECT_NAME}
    PRIVATE
        Client.cpp
        interface.cpp
        KeyValuePair.cpp
        utility.cpp
        Workflow.cpp
        WorkflowAdapter.cpp
    PRIVATE
    FILE_SET private_headers
        TYPE HEADERS
        BASE_DIRS "${PROJECT_SOURCE_DIR}/src"
        FILES
        utility.hpp
        WorkflowAdapter.hpp
    PUBLIC
    FILE_SET public_headers
        TYPE HEADERS
        BASE_DIRS "${PROJECT_SOURCE_DIR}/src"
        FILES
        Client.hpp
        KeyValuePair.hpp
        Workflow.hpp
)
