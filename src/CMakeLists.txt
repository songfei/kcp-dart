# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(kcp_library VERSION 0.0.1 LANGUAGES C)

include_directories(include)

add_library(kcp SHARED
        "include/internal/dart_api_dl_impl.h"
        "include/dart_api.h"
        "include/dart_api_dl.c"
        "include/dart_api_dl.h"
        "include/dart_native_api.h"
        "include/dart_tools_api.h"
        "include/dart_version.h"
        "ikcp.h"
        "ikcp.c"
        "kcp.c"
        )

set_target_properties(kcp PROPERTIES
  PUBLIC_HEADER kcp.h
  OUTPUT_NAME "kcp"
)

target_compile_definitions(kcp PUBLIC DART_SHARED_LIB)
