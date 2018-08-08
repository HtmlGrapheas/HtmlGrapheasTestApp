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

cmake_minimum_required(VERSION 3.3)

project(HtmlGrapheasApp CXX)

set(HGKamva_DIR "${PROJECT_SOURCE_DIR}/HtmlGrapheasKamva")
set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/install")

#set(CMAKE_VERBOSE_MAKEFILE ON)
#set(cmr_PRINT_DEBUG ON)


#-----------------------------------------------------------------------
# Configure external libs directories
#-----------------------------------------------------------------------

if(NOT EXTERNAL_DOWNLOAD_DIR)
  set(EXTERNAL_DOWNLOAD_DIR "${CMAKE_CURRENT_LIST_DIR}/.downloads")
endif()

if(NOT EXTERNAL_UNPACKED_DIR)
  if(UNIX AND NOT APPLE)
    set(platform_DIR "_linux")
  elseif(APPLE)
    set(platform_DIR "_macos")
  elseif(WIN32)
    set(platform_DIR "_windows")
  endif()
  
  if(MSVC)
    set(compiler_DIR "_msvc")
  elseif(MINGW)
    set(compiler_DIR "_mingw")
  endif()

  set(EXTERNAL_UNPACKED_DIR
    "${EXTERNAL_DOWNLOAD_DIR}/.unpacked${platform_DIR}${compiler_DIR}"
  )
endif()

if(NOT EXTERNAL_BIN_DIR)
  set(EXTERNAL_BIN_DIR "${PROJECT_BINARY_DIR}/external/build")
endif()
if(NOT EXTERNAL_INSTALL_DIR)
  set(EXTERNAL_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}")
endif()


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

if(MSVC AND NOT BUILD_SHARED_LIBS)
  set(cmr_USE_MSVC_STATIC_RUNTIME ON)
  
  # Set MSVC static runtime flags for all configurations.
  # See:
  # https://stackoverflow.com/a/20804336
  # https://stackoverflow.com/a/14172871
  foreach(cfg "" ${CMAKE_CONFIGURATION_TYPES})
    set(c_flag_var   CMAKE_C_FLAGS)
    set(cxx_flag_var CMAKE_CXX_FLAGS)
    if(cfg)
      string(TOUPPER ${cfg} cfg_upper)
      set(c_flag_var   "${c_flag_var}_${cfg_upper}")
      set(cxx_flag_var "${cxx_flag_var}_${cfg_upper}")
    endif()
    if(${c_flag_var} MATCHES "/MD")
      string(REPLACE "/MD" "/MT" ${c_flag_var} "${${c_flag_var}}")
      set(${c_flag_var} ${${c_flag_var}} CACHE STRING
        "Flags used by the C compiler during ${cfg_upper} builds." FORCE
      )
    endif()
    if(${cxx_flag_var} MATCHES "/MD")
      string(REPLACE "/MD" "/MT" ${cxx_flag_var} "${${cxx_flag_var}}")
      set(${cxx_flag_var} ${${cxx_flag_var}} CACHE STRING
        "Flags used by the CXX compiler during ${cfg_upper} builds." FORCE
      )
    endif()
  endforeach()
endif()

if(NOT DEFINED cmr_BUILD_MULTIPROC)
  set(cmr_BUILD_MULTIPROC ON)
endif()

if(cmr_BUILD_MULTIPROC)
  # Enable /MP flag for Visual Studio 2008 and greater.
  if(MSVC AND MSVC_VERSION GREATER 1400)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /MP${cmr_BUILD_MULTIPROC_CNT}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP${cmr_BUILD_MULTIPROC_CNT}")
  endif()
endif()


#-----------------------------------------------------------------------
# Platforms
#-----------------------------------------------------------------------

if(WIN32 OR (UNIX AND NOT ANDROID))
  set(wxWidgets_PLATFORM ON)
endif()


#-----------------------------------------------------------------------
# wxWidgets (HtmlGrapheasAppWx)
#-----------------------------------------------------------------------

# To run the application on Linux with the shared libs which are installed
# to the non standard path specified in CMAKE_INSTALL_PREFIX use:
# LD_LIBRARY_PATH="<${CMAKE_INSTALL_PREFIX}>/lib:.:$LD_LIBRARY_PATH" ./html_grapheas
# where <${CMAKE_INSTALL_PREFIX}> is path which is used
# as value for CMAKE_INSTALL_PREFIX.

if(wxWidgets_PLATFORM)
  set(HGAppWx_DIR ${PROJECT_SOURCE_DIR}/platform/wxwidgets)
  add_subdirectory("${HGAppWx_DIR}" "${PROJECT_BINARY_DIR}/HtmlGrapheasAppWx")
endif()
