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

include(cmr_print_message)

#-----------------------------------------------------------------------
# Build, install and find wxWidgets library
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Set vars for LibCMaker_wxWidgets.
#-----------------------------------------------------------------------

set(LIBCMAKER_WX_SRC_DIR "${PLATFORM_WX_EXTERNAL_SRC_DIR}/LibCMaker_wxWidgets")
# To use our FindwxWidgets.cmake and UsewxWidgets.cmake.
list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_WX_SRC_DIR}/cmake")
list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_WX_SRC_DIR}/cmake/modules")


set(WX_lib_VERSION "3.1.1")
set(WX_lib_COMPONENTS core base)
set(WX_USE_FIND_PACKAGE_MODULE OFF)

set(WX_DOWNLOAD_DIR "${EXTERNAL_DOWNLOAD_DIR}")
set(WX_UNPACKED_SRC_DIR "${EXTERNAL_UNPACKED_SRC_DIR}")
set(WX_BUILD_DIR "${EXTERNAL_BIN_DIR}/build_wxwidgets")

# Used only for wxWidgets 3.1.0.
# TODO: remove it with all files in dir "cmake/modules/build_cmake".
set(COPY_WX_CMAKE_BUILD_SCRIPTS OFF)

set(wxWidgets_ROOT_DIR "${EXTERNAL_INSTALL_DIR}")
set(ENV{wxWidgets_ROOT_DIR} "${wxWidgets_ROOT_DIR}")

if(USING_WX_SUB_DIR)
  include(cmr_wxwidgets_get_download_params)
  cmr_wxwidgets_get_download_params(${WX_lib_VERSION}
    WX_lib_URL WX_lib_SHA WX_lib_SRC_DIR_NAME WX_lib_ARCH_FILE_NAME)
  set(WX_lib_SRC_DIR "${WX_UNPACKED_SRC_DIR}/${WX_lib_SRC_DIR_NAME}")
endif()


# Library specific vars and options.

include(${LIBCMAKER_WX_SRC_DIR}/cmake/modules/cmr_wx_option.cmake)



# Global build options
#cmr_wx_option(wxBUILD_SHARED "Build wx libraries as shared libs"
#  ${BUILD_SHARED_LIBS}
#)
cmr_wx_option(wxBUILD_MONOLITHIC "Build wxWidgets as single library" OFF)
cmr_wx_option(wxBUILD_SAMPLES "Build only important samples (SOME) or ALL" OFF
  STRINGS SOME ALL OFF
)
cmr_wx_option(wxBUILD_TESTS "Build console tests (CONSOLE_ONLY) or ALL" OFF
  STRINGS CONSOLE_ONLY ALL OFF
)
cmr_wx_option(wxBUILD_DEMOS "Build demos" OFF)
cmr_wx_option(wxBUILD_PRECOMP "Use precompiled headers" ON)
cmr_wx_option(wxBUILD_INSTALL "Create install/uninstall target for wxWidgets"
  ${WX_USE_FIND_PACKAGE_MODULE}
)
cmr_wx_option(wxBUILD_COMPATIBILITY "Enable compatibilty with earlier wxWidgets versions"
  3.1
  STRINGS 2.8 3.0 3.1
)

#set(wxBUILD_CUSTOM_SETUP_HEADER_PATH "" CACHE PATH
#  "Include path containing custom wx/setup.h"
#)

if(MSVC)
  cmr_wx_option(wxBUILD_USE_STATIC_RUNTIME "Link using the static runtime library"
    OFF
  )
  cmr_wx_option(wxBUILD_MSVC_MULTIPROC "Enable multi-processor compilation for MSVC"
    ON
  )
else()
  # It set in WX by CMAKE_CXX_STANDARD
  #cmr_wx_option(wxBUILD_CXX_STANDARD "C++ standard used to build wxWidgets targets"
  #  ${CXX_STANDARD_DEFAULT}
  #  STRINGS COMPILER_DEFAULT 98 11 14
  #)
endif()

# TODO: cmr_wx_option(wxUSE_*)

# Exclude STC for version 3.1.1. TODO: check it for newer version.
cmr_wx_option(wxUSE_STC "use wxStyledTextCtrl library" OFF)


#-----------------------------------------------------------------------
# Configure for find_package.
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


if(WX_USE_FIND_PACKAGE_MODULE)
  # Set CMake's search path for find_package(), find_program(), find_library(),
  # find_file(), and find_path() commands.
  list(APPEND CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}")
  
  if(ANDROID)
    list(APPEND CMAKE_FIND_ROOT_PATH "${CMAKE_INSTALL_PREFIX}")
  endif()
endif()


#-----------------------------------------------------------------------
# Build the wxWidgets and include it.
#-----------------------------------------------------------------------

# Build the library at a config CMake phase.

if(WX_USE_FIND_PACKAGE_MODULE)
  find_package(wxWidgets ${WX_lib_VERSION}
    COMPONENTS ${WX_lib_COMPONENTS} QUIET
  )
endif()

set(WX_lib_EXPORT_FILE "${WX_BUILD_DIR}/export-wxWidgets.cmake")

if(NOT wxWidgets_FOUND AND NOT EXISTS ${WX_lib_EXPORT_FILE})
  cmr_print_message("wxWidgets is not built, build it.")

  if(WX_USE_FIND_PACKAGE_MODULE)
    set(WX_lib_BUILD_MODE "INSTALL")
  else()
    set(WX_lib_BUILD_MODE "BUILD")
  endif()
  
  # Build specified library version.
  include(${LIBCMAKER_WX_SRC_DIR}/lib_cmaker_wxwidgets.cmake)
  lib_cmaker_wxwidgets(
    VERSION ${WX_lib_VERSION}
    DOWNLOAD_DIR ${WX_DOWNLOAD_DIR}
    UNPACKED_SRC_DIR ${WX_UNPACKED_SRC_DIR}
    BUILD_DIR ${WX_BUILD_DIR}
    ${WX_lib_BUILD_MODE}
    COMPONENTS ${WX_lib_COMPONENTS}
  )

  if(WX_USE_FIND_PACKAGE_MODULE)
    find_package(wxWidgets ${WX_lib_VERSION}
      COMPONENTS ${WX_lib_COMPONENTS} REQUIRED
    )
  endif()
  
else()
  cmr_print_message("wxWidgets is built, skip its building.")
endif()

if(WX_USE_FIND_PACKAGE_MODULE)
  include(${wxWidgets_USE_FILE})
else()
  include(${WX_lib_EXPORT_FILE})
endif()
