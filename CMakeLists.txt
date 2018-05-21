# ****************************************************************************
#  Project:  HtmlGrapheas
#  Purpose:  HTML text editor library
#  Author:   NikitaFeodonit, nfeodonit@yandex.com
# ****************************************************************************
#    Copyright (c) 2017-2018 NikitaFeodonit
#
#    This file is part of the HtmlGrapheas project.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published
#    by the Free Software Foundation, either version 3 of the License,
#    or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program. If not, see <http://www.gnu.org/licenses/>.
# ****************************************************************************

cmake_minimum_required(VERSION 3.2 FATAL_ERROR)

# We must add "C" language for subprojects with "C" because of error:
# CMake Error: Error required internal CMake variable not set,
# cmake may not be built correctly.
# Missing variable is:
# CMAKE_C_COMPILE_OBJECT
# (Now only for wxWidgets subproject.)
project(HtmlGrapheasApp CXX C)

set(HtmlGrapheasKamva_DIR "${PROJECT_SOURCE_DIR}/HtmlGrapheasKamva")


#-----------------------------------------------------------------------
# Settings for wxWidgets platform
#-----------------------------------------------------------------------

if(WIN32 OR (UNIX AND NOT ANDROID))
  set(wxWidgets_PLATFORM ON)
endif()

if(wxWidgets_PLATFORM)
  set(PLATFORM_WX_SRC_DIR ${PROJECT_SOURCE_DIR}/platform/wxWidgets)

  list(APPEND CMAKE_MODULE_PATH "${PLATFORM_WX_SRC_DIR}/cmake")

  set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/install")
  
  # Use /MP flag in command line. Just specify /MP by itself to have
  # VS's build system automatically select how many threads to compile on
  # (which usually is the maximum number of threads available):
  # cmake ..\ -DCMAKE_CXX_FLAGS="/MP" -DCMAKE_C_FLAGS="/MP" -DCMAKE_BUILD_TYPE=Release ^
  # && cmake --build . --config Release
  #
  # Enable /MP flag for Visual Studio 2008 and greater.
  #if(MSVC_VERSION GREATER 1400)
  #  include(ProcessorCount) # ProcessorCount
  #  ProcessorCount(CPU_CNT)
  #  if(CPU_CNT GREATER 0)
  #    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP${CPU_CNT}")
  #    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /MP${CPU_CNT}")
  #  endif()
  #endif()

endif()


#-----------------------------------------------------------------------
# External libs directories.
#-----------------------------------------------------------------------

if(NOT EXTERNAL_DOWNLOAD_DIR)
  set(EXTERNAL_DOWNLOAD_DIR "${PROJECT_SOURCE_DIR}/.downloads")
endif()
if(NOT EXTERNAL_UNPACKED_SRC_DIR)
  set(platform_DIR "")
  if(UNIX AND NOT APPLE)
    set(platform_DIR "_linux")
  elseif(APPLE)
    set(platform_DIR "_macos")
  elseif(WIN32)
    set(platform_DIR "_windows")
  endif()
  
  set(compiler_DIR "")
  if(MSVC)
    set(compiler_DIR "_msvc")
  elseif(MINGW)
    set(compiler_DIR "_mingw")
  endif()

  set(EXTERNAL_UNPACKED_SRC_DIR
    "${EXTERNAL_DOWNLOAD_DIR}/.unpacked${platform_DIR}${compiler_DIR}"
  )
endif()
set(EXTERNAL_BIN_DIR "${PROJECT_BINARY_DIR}/external/build")
set(EXTERNAL_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}")


#-----------------------------------------------------------------------
# Use our Find* modules
#-----------------------------------------------------------------------

set(LIBCMAKER_FREETYPE_SRC_DIR
  "${HtmlGrapheasKamva_DIR}/external/LibCMaker_FreeType")
# To use our FindFreetype.cmake.
list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_FREETYPE_SRC_DIR}/cmake/")

set(LIBCMAKER_HARFBUZZ_SRC_DIR
  "${HtmlGrapheasKamva_DIR}/external/LibCMaker_HarfBuzz")
# To use our FindHarfBuzz.cmake.
list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_HARFBUZZ_SRC_DIR}/cmake/")


#-----------------------------------------------------------------------
# Set path to LibCMaker root
#-----------------------------------------------------------------------

set(LIBCMAKER_SRC_DIR "${HtmlGrapheasKamva_DIR}/external/LibCMaker")
# Uncomment it if need functions from LibCMaker
list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_SRC_DIR}/cmake/modules")

# Standard CMake vars.

# We must set this variable explicitly for the wxWidgets static lib building.
if(NOT DEFINED BUILD_SHARED_LIBS)
  set(BUILD_SHARED_LIBS OFF)
endif()

#set(SKIP_INSTALL_HEADERS ON)
#set(SKIP_INSTALL_LIBRARIES ON)
#set(SKIP_INSTALL_ALL ON)

# Set useful vars for lib_cmaker_*().
#set(cmr_PRINT_DEBUG ON)

#-----------------------------------------------------------------------
# Testing
#-----------------------------------------------------------------------

option(BUILD_TESTING "Build the testing tree." OFF)
if(BUILD_TESTING)
  enable_testing()
endif()


#-----------------------------------------------------------------------
# Compiler flags
#-----------------------------------------------------------------------

# From Google Test sources.
# Also see https://stackoverflow.com/a/14172871
macro(fix_default_compiler_settings)
  if (MSVC)
    # For MSVC, CMake sets certain flags to defaults we want to override.
    # This replacement code is taken from sample in the CMake Wiki at
    # http://www.cmake.org/Wiki/CMake_FAQ#Dynamic_Replace.
    foreach (flag_var
      CMAKE_CXX_FLAGS 
      CMAKE_CXX_FLAGS_DEBUG 
      CMAKE_CXX_FLAGS_RELEASE
      CMAKE_CXX_FLAGS_MINSIZEREL 
      CMAKE_CXX_FLAGS_RELWITHDEBINFO
      CMAKE_C_FLAGS 
      CMAKE_C_FLAGS_DEBUG 
      CMAKE_C_FLAGS_RELEASE
      CMAKE_C_FLAGS_MINSIZEREL 
      CMAKE_C_FLAGS_RELWITHDEBINFO
    )
      if (NOT BUILD_SHARED_LIBS)
        # When Google Test is built as a shared library, it should also use
        # shared runtime libraries.  Otherwise, it may end up with multiple
        # copies of runtime library data in different modules, resulting in
        # hard-to-find crashes. When it is built as a static library, it is
        # preferable to use CRT as static libraries, as we don't have to rely
        # on CRT DLLs being available. CMake always defaults to using shared
        # CRT libraries, so we override that default here.
        string(REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
      endif()
    endforeach()
  endif()
endmacro()

fix_default_compiler_settings()

if(NOT DEFINED cmr_BUILD_MULTIPROC)
  set(cmr_BUILD_MULTIPROC ON)
endif()

if(cmr_BUILD_MULTIPROC OR cmr_BUILD_MULTIPROC_CNT)
  if(NOT cmr_BUILD_MULTIPROC_CNT)
    set(cmr_BUILD_MULTIPROC_CNT "")
  endif()
  
  # Enable /MP flag for Visual Studio 2008 and greater.
  if(MSVC AND MSVC_VERSION GREATER 1400)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /MP${cmr_BUILD_MULTIPROC_CNT}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP${cmr_BUILD_MULTIPROC_CNT}")
  endif()
endif()


#-----------------------------------------------------------------------
# Configure for find_package.
#-----------------------------------------------------------------------

# Append our installed libs path to CMake's search path for find_*() commands.
#list(APPEND CMAKE_PREFIX_PATH "${EXTERNAL_INSTALL_DIR}")


#-----------------------------------------------------------------------
# Platforms
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# wxWidgets
#-----------------------------------------------------------------------

if(wxWidgets_PLATFORM)
  # Build, install and find wxWidgets library.
  set(PLATFORM_WX_EXTERNAL_SRC_DIR "${PLATFORM_WX_SRC_DIR}/external")
  include(build_wxwidgets) # In ${PLATFORM_WX_SRC_DIR}/cmake

  # HtmlGrapheasApp
  add_subdirectory(${PLATFORM_WX_SRC_DIR})
endif()
