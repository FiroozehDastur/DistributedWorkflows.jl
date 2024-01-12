cmake_minimum_required(VERSION 3.24)

project (DistributedWorkflow
  VERSION 0.1.0
  LANGUAGES CXX
)

include (GNUInstallDirs)

set (CMAKE_CXX_STANDARD 17)
set (CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(${PROJECT_NAME} SHARED)

add_subdirectory(src)

