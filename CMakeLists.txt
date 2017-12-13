# ****************************************************************************
#  Project:  HtmlGrapheas
#  Purpose:  HTML text editor library
#  Author:   NikitaFeodonit, nfeodonit@yandex.com
# ****************************************************************************
#    Copyright (c) 2017 NikitaFeodonit
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

project(HtmlGrapheasApp CXX)

set(HtmlGrapheasKamva_DIR "${PROJECT_SOURCE_DIR}/HtmlGrapheasKamva")


#-----------------------------------------------------------------------
# Settings for wxWidgets platform
#-----------------------------------------------------------------------

if(WIN32 OR (UNIX AND NOT ANDROID))
  set(wxWidgets_PLATFORM ON)
endif()

if(wxWidgets_PLATFORM)
  set(PLATFORM_WX_SRC_DIR ${PROJECT_SOURCE_DIR}/platform/wxWidgets)
  set(USING_WX_SUB_DIR ON)
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
  set(EXTERNAL_UNPACKED_SRC_DIR "${EXTERNAL_DOWNLOAD_DIR}/external_unpacked")
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
set(BUILD_SHARED_LIBS OFF)

#set(SKIP_INSTALL_HEADERS ON)
#set(SKIP_INSTALL_LIBRARIES ON)
#set(SKIP_INSTALL_ALL ON)

# Set useful vars for lib_cmaker_*().
#set(cmr_PRINT_DEBUG ON)


#-----------------------------------------------------------------------
# Configure for find_package.
#-----------------------------------------------------------------------

# Append our installed libs path to CMake's search path for find_*() commands.
#list(APPEND CMAKE_PREFIX_PATH "${EXTERNAL_INSTALL_DIR}")


#-----------------------------------------------------------------------
# HtmlGrapheasKamva
#-----------------------------------------------------------------------

if(wxWidgets_PLATFORM AND USING_WX_SUB_DIR)
  add_subdirectory(${HtmlGrapheasKamva_DIR})

  # TODO: rewrite AGG's CMake scripts to exclude link_directories().
  # AGG_LIBRARY_DIRS is cache var from AggConfig.cmake
  # by find_package(Agg REQUIRED CONFIG) in HtmlGrapheasKamva.
  link_directories(${AGG_LIBRARY_DIRS})
endif()


#-----------------------------------------------------------------------
# Platforms
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# wxWidgets
#-----------------------------------------------------------------------

if(wxWidgets_PLATFORM)
  set(HtmlGrapheasKamva_PLATFORM_WX_DIR
    "${HtmlGrapheasKamva_DIR}/src/hgk/platform/wxwidgets/grapheaskamva"
  )
  set(PLATFORM_WX_EXTERNAL_SRC_DIR "${PLATFORM_WX_SRC_DIR}/external")

  # Build, install and find wxWidgets library.
  include(build_wxwidgets) # In ${PLATFORM_WX_SRC_DIR}/cmake

  # HtmlGrapheasApp
  add_subdirectory(${PLATFORM_WX_SRC_DIR})
endif()
