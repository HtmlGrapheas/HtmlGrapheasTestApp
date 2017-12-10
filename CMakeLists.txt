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

project(HtmlGrapheasApp_wxWidgets CXX)
set(WX_PLATFORM_SRC_DIR ${PROJECT_SOURCE_DIR}/platform/wxWidgets)

list(APPEND CMAKE_MODULE_PATH "${WX_PLATFORM_SRC_DIR}/cmake")
set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/install")

# External libs directories.
set(EXTERNAL_SRC_DIR "${WX_PLATFORM_SRC_DIR}/external")
if(NOT EXTERNAL_DOWNLOAD_DIR)
  set(EXTERNAL_DOWNLOAD_DIR "${PROJECT_SOURCE_DIR}/.downloads")
endif()
if(NOT EXTERNAL_UNPACKED_SRC_DIR)
  set(EXTERNAL_UNPACKED_SRC_DIR "${EXTERNAL_DOWNLOAD_DIR}/external_unpacked")
endif()
set(EXTERNAL_BIN_DIR "${PROJECT_BINARY_DIR}/external/build")
set(EXTERNAL_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}")

set(HtmlGrapheasKamva_DIR "${PROJECT_SOURCE_DIR}/HtmlGrapheasKamva")

set(LIBCMAKER_FREETYPE_SRC_DIR
  "${HtmlGrapheasKamva_DIR}/external/LibCMaker_FreeType")
# To use our FindFreetype.cmake.
list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_FREETYPE_SRC_DIR}/cmake/")

set(LIBCMAKER_HARFBUZZ_SRC_DIR
  "${EXTERNAL_SRC_DIR}/external/LibCMaker_HarfBuzz")
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

add_subdirectory(${HtmlGrapheasKamva_DIR})

# TODO: rewrite AGG's CMake scripts to exclude link_directories().
# AGG_LIBRARY_DIRS is cache var from AggConfig.cmake
# by find_package(Agg REQUIRED CONFIG) in HtmlGrapheasKamva.
link_directories(${AGG_LIBRARY_DIRS})


#-----------------------------------------------------------------------
# Build, install and find wxWidgets library
#-----------------------------------------------------------------------

include(build_wxwidgets) # In ${WX_PLATFORM_SRC_DIR}/cmake


#-----------------------------------------------------------------------
# HtmlGrapheasApp
#-----------------------------------------------------------------------

add_subdirectory(${WX_PLATFORM_SRC_DIR})
