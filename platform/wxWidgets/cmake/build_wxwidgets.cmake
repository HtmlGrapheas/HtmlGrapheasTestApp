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

include(cmr_print_message)

#-----------------------------------------------------------------------
# Build, install and find wxWidgets library
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Set vars for LibCMaker_wxWidgets.
#-----------------------------------------------------------------------

set(LIBCMAKER_WX_SRC_DIR "${EXTERNAL_SRC_DIR}/LibCMaker_wxWidgets")
# To use our FindwxWidgets.cmake and UsewxWidgets.cmake.
list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_WX_SRC_DIR}/cmake/")

set(WX_lib_VERSION "3.1.0")
set(WX_lib_COMPONENTS core base)

set(WX_DOWNLOAD_DIR "${EXTERNAL_DOWNLOAD_DIR}")
set(WX_UNPACKED_SRC_DIR "${EXTERNAL_UNPACKED_SRC_DIR}")
set(WX_BUILD_DIR "${EXTERNAL_BIN_DIR}/build_wxwidgets")

set(COPY_WX_CMAKE_BUILD_SCRIPTS ON)

# TODO: make wx-config OR use with add_subdirectory()
set(wxWidgets_ROOT_DIR "${EXTERNAL_INSTALL_DIR}")
set(ENV{wxWidgets_ROOT_DIR} "${wxWidgets_ROOT_DIR}")

# Library specific vars and options.

# Add a option. Parameter STRINGS represents a valid values.
# wx_option(<name> <desc> [default] [STRINGS strings])
function(wx_option name desc)
  cmake_parse_arguments(OPTION "" "" "STRINGS" ${ARGN})
  set(default ${OPTION_UNPARSED_ARGUMENTS})
  set(${name} "${default}" PARENT_SCOPE)
endfunction()


# Global build options
#wx_option(wxBUILD_SHARED "Build wx libraries as shared libs"
#  ${BUILD_SHARED_LIBS}
#)
wx_option(wxBUILD_MONOLITHIC "Build wxWidgets as single library" OFF)
wx_option(wxBUILD_SAMPLES "Build only important samples (SOME) or ALL" OFF
  STRINGS SOME ALL OFF
)
wx_option(wxBUILD_TESTS "Build console tests (CONSOLE_ONLY) or ALL" OFF
  STRINGS CONSOLE_ONLY ALL OFF
)
wx_option(wxBUILD_DEMOS "Build demos" OFF)
wx_option(wxBUILD_PRECOMP "Use precompiled headers" ON)
wx_option(wxBUILD_INSTALL "Create install/uninstall target for wxWidgets" ON)
wx_option(wxBUILD_COMPATIBILITY "Enable compatibilty with earlier wxWidgets versions"
  3.0
  STRINGS 2.8 3.0 3.1
)

if(MSVC)
  wx_option(wxBUILD_USE_STATIC_RUNTIME "Link using the static runtime library"
    OFF
  )
else()
  # It set in WX by CMAKE_CXX_STANDARD
  #wx_option(wxBUILD_CXX_STANDARD "C++ standard used to build wxWidgets targets"
  #  ${CXX_STANDARD_DEFAULT}
  #  STRINGS COMPILER_DEFAULT 98 11 14
  #)
endif()

# TODO: wx_option(wxUSE_*)

# Exclude STC for version 3.1.0. TODO: remove it for 3.1.1.
wx_option(wxUSE_STC "use wxStyledTextCtrl library" OFF)


#-----------------------------------------------------------------------
# Build and install the wxWidgets.
#-----------------------------------------------------------------------

# TODO: needed?
# WIN32 config part.
#set(WX_CFG_DEBUG_SFX "")
#if(CMAKE_CFG_INTDIR STREQUAL "." AND CMAKE_BUILD_TYPE STREQUAL "Debug"
#    OR CMAKE_CFG_INTDIR STREQUAL "Debug")
#  set(WX_CFG_DEBUG_SFX "d")
#endif()
#set(wxWidgets_CONFIGURATION "mswu${WX_CFG_DEBUG_SFX}")

# TODO: needed?
# UNIX config part.
#set(wxWidgets_USE_STATIC ON)
#set(wxWidgets_USE_UNICODE ON)


# Try to find already installed lib.
# TODO: change FindwxWidgets.cmake
#find_package(wxWidgets ${WX_lib_VERSION}
#  COMPONENTS ${WX_lib_COMPONENTS} QUIET
#)

if(NOT wxWidgets_FOUND)
  cmr_print_message(
    "wxWidgets is not installed, build and install it.")

  include(${EXTERNAL_SRC_DIR}/LibCMaker_wxWidgets/lib_cmaker_wxwidgets.cmake)
  lib_cmaker_wxwidgets(
    VERSION ${WX_lib_VERSION}
    DOWNLOAD_DIR ${WX_DOWNLOAD_DIR}
    UNPACKED_SRC_DIR ${WX_UNPACKED_SRC_DIR}
    BUILD_DIR ${WX_BUILD_DIR}
  )
  
  # wxWidgets
  find_package(wxWidgets ${WX_lib_VERSION}
    COMPONENTS ${WX_lib_COMPONENTS} REQUIRED
  )
  
else()
  cmr_print_message(
    "wxWidgets is installed, skip building and installing it.")
endif()

include(${wxWidgets_USE_FILE})