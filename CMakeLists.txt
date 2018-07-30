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

if(wxWidgets_PLATFORM)
  set(HGAppWx_DIR ${PROJECT_SOURCE_DIR}/platform/wxwidgets)
  add_subdirectory("${HGAppWx_DIR}" "${PROJECT_BINARY_DIR}/HtmlGrapheasAppWx")
endif()
