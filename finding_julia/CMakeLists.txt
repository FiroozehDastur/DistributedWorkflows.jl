cmake_minimum_required(VERSION 3.15)

project(
  finding_julia
  VERSION 0.1.0
)

set (_module_path "${PROJECT_SOURCE_DIR}/cmake/modules")
if (NOT _module_path IN_LIST CMAKE_MODULE_PATH)
  list (APPEND CMAKE_MODULE_PATH ${_module_path})
  set (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} CACHE INTERNAL "CMake Module Path")
endif()

###############################################################################
# Includes
###############################################################################

include (GNUInstallDirs)
include (CMakePackageConfigHelpers)

###############################################################################
# Install and configure package find script
###############################################################################

set (_project_config_install_dir
  ${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}/cmake
)

install (
  DIRECTORY
    "${PROJECT_SOURCE_DIR}/cmake/modules" 
  DESTINATION
    ${_project_config_install_dir}
  USE_SOURCE_PERMISSIONS
)

configure_package_config_file (
  ${PROJECT_NAME}-config.cmake.in
  ${PROJECT_NAME}-config.cmake
  INSTALL_DESTINATION ${_project_config_install_dir}
)

write_basic_package_version_file (
  ${PROJECT_NAME}-config-version.cmake
  COMPATIBILITY SameMajorVersion
)

install (
  FILES
    ${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config.cmake
    ${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake
  DESTINATION
    ${_project_config_install_dir}
)
