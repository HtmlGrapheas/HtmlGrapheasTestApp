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
if(NOT DEFINED USING_WX_SUB_DIR)
  set(USING_WX_SUB_DIR ON)
endif()

set(WX_DOWNLOAD_DIR "${EXTERNAL_DOWNLOAD_DIR}")
set(WX_UNPACKED_SRC_DIR "${EXTERNAL_UNPACKED_SRC_DIR}")
set(WX_BUILD_DIR "${EXTERNAL_BIN_DIR}/build_wxwidgets")

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
  ON
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

# Exclude STC for version 3.1.0. TODO: remove it for 3.1.1.
#cmr_wx_option(wxUSE_STC "use wxStyledTextCtrl library" OFF)


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
if(NOT USING_WX_SUB_DIR)
  find_package(wxWidgets ${WX_lib_VERSION}
    COMPONENTS ${WX_lib_COMPONENTS} QUIET
  )
endif()

if(NOT wxWidgets_FOUND OR USING_WX_SUB_DIR)
  if(NOT USING_WX_SUB_DIR)
    cmr_print_message(
      "wxWidgets is not installed, build and install it.")
  endif()

  set(ONLY_CONFIGURE "")
  if(USING_WX_SUB_DIR)
    set(ONLY_CONFIGURE "ONLY_CONFIGURE")
  endif()

  include(${LIBCMAKER_WX_SRC_DIR}/lib_cmaker_wxwidgets.cmake)
  lib_cmaker_wxwidgets(
    VERSION ${WX_lib_VERSION}
    DOWNLOAD_DIR ${WX_DOWNLOAD_DIR}
    UNPACKED_SRC_DIR ${WX_UNPACKED_SRC_DIR}
    BUILD_DIR ${WX_BUILD_DIR}
    ${ONLY_CONFIGURE}
  )
  
  # wxWidgets
  if(NOT USING_WX_SUB_DIR)
    find_package(wxWidgets ${WX_lib_VERSION}
      COMPONENTS ${WX_lib_COMPONENTS} REQUIRED
    )
  endif()
  
else()
  cmr_print_message(
    "wxWidgets is installed, skip building and installing it.")
endif()

if(USING_WX_SUB_DIR)
  add_subdirectory(${WX_lib_SRC_DIR} ${WX_BUILD_DIR})
else()
  include(${wxWidgets_USE_FILE})
endif()
