find_package (GPISpace REQUIRED)
find_package (util-generic REQUIRED)

if(NOT DEFINED WORKFLOW_NAME)
  message(FATAL_ERROR "Workflow name not found. Please provide the workflow name using:\n -D WORKFLOW_NAME=<workflow-name>")
endif()
if(NOT WORKFLOW_NAME)
  message(FATAL_ERROR "Workflow name cannot be an empty string")
endif()
message(STATUS "Workflow name detected")

# petri net path needs to be changed to something more generic and/or different (ASK MAX)
set (PETRI_NET "${CMAKE_CURRENT_SOURCE_DIR}/${WORKFLOW_NAME}.xpnet")
set (COMPILED_PETRI_NET "${CMAKE_CURRENT_BINARY_DIR}/${WORKFLOW_NAME}.pnet")
set (WRAPPER_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/gen")
set (WRAPPER_LIBRARY "${WRAPPER_DIRECTORY}/pnetc/op/lib${WORKFLOW_NAME}.so")

add_custom_command (
  COMMAND
    GPISpace::pnetc --input="${PETRI_NET}" --output="${COMPILED_PETRI_NET}"
  OUTPUT "${COMPILED_PETRI_NET}"
  DEPENDS "${PETRI_NET}"
)

add_custom_target (compiled_petri_net
  ALL
  DEPENDS
    "${COMPILED_PETRI_NET}"
)

add_custom_command (
  COMMAND
    GPISpace::pnetc
      --gen-cxxflags="-O3"
      --gen-cxxflags=-std=c++17
      --gen-cxxflags="-I${CMAKE_CURRENT_SOURCE_DIR}"
      --gen-ldflags="-L$<TARGET_FILE:Util::Generic>"
      --gen-ldflags="-L${CMAKE_CURRENT_BINARY_DIR}"
      --force-overwrite-file=true
      --input="${PETRI_NET}"
      --output="/dev/null"
      --path-to-cpp="${WRAPPER_DIRECTORY}"
      --Wbackup-file=OFF
      --Woverwrite-file=OFF
  COMMAND
    $(MAKE) -C "${WRAPPER_DIRECTORY}"
  OUTPUT "${WRAPPER_LIBRARY}"
  DEPENDS "${PETRI_NET}"
)
add_custom_target (workflow_library
  ALL
  DEPENDS
    "${WRAPPER_LIBRARY}"
)
