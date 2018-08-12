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

include(cmr_print_status)

#-----------------------------------------------------------------------
# Build, install and find FontConfig library
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Set vars for LibCMaker_FontConfig
#-----------------------------------------------------------------------

# Used in 'cmr_build_rules_fontconfig.cmake'.
set(LIBCMAKER_DIRENT_SRC_DIR
  "${CMAKE_CURRENT_LIST_DIR}/LibCMaker_Dirent"
)
set(LIBCMAKER_EXPAT_SRC_DIR
  "${CMAKE_CURRENT_LIST_DIR}/LibCMaker_Expat"
)
set(LIBCMAKER_FREETYPE_SRC_DIR
  "${CMAKE_CURRENT_LIST_DIR}/LibCMaker_FreeType"
)

set(LIBCMAKER_FONTCONFIG_SRC_DIR
  "${CMAKE_CURRENT_LIST_DIR}/LibCMaker_FontConfig"
)
# To use our FindFontConfig.cmake.
list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_FONTCONFIG_SRC_DIR}/cmake")

set(FONTCONFIG_lib_VERSION    "2.13.0")
set(FONTCONFIG_DOWNLOAD_DIR   "${EXTERNAL_DOWNLOAD_DIR}")
set(FONTCONFIG_UNPACKED_DIR   "${EXTERNAL_UNPACKED_DIR}")
set(FONTCONFIG_BUILD_DIR      "${EXTERNAL_BIN_DIR}/build_fontconfig")

set(COPY_FONTCONFIG_CMAKE_BUILD_SCRIPTS ON)

# Library specific vars and options.


#-----------------------------------------------------------------------
# Build and install the FontConfig
#-----------------------------------------------------------------------

# Try to find already installed lib.
find_package(FontConfig QUIET)

if(NOT FONTCONFIG_FOUND)
  cmr_print_status(
    "FontConfig is not installed, build and install it.")

  include(${LIBCMAKER_FONTCONFIG_SRC_DIR}/lib_cmaker_fontconfig.cmake)
  lib_cmaker_fontconfig(
    VERSION       ${FONTCONFIG_lib_VERSION}
    DOWNLOAD_DIR  ${FONTCONFIG_DOWNLOAD_DIR}
    UNPACKED_DIR  ${FONTCONFIG_UNPACKED_DIR}
    BUILD_DIR     ${FONTCONFIG_BUILD_DIR}
  )

  find_package(FontConfig REQUIRED)

else()
  cmr_print_status(
    "FontConfig is installed, skip building and installing it.")
endif()
