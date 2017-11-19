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

project(HtmlGrapheasApp_Desktop CXX)
set(hga_EXE_NAME "html_grapheas")

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/install")

# External libs directories.
set(EXTERNAL_SRC_DIR "${PROJECT_SOURCE_DIR}/external")
if(NOT EXTERNAL_DOWNLOAD_DIR)
  set(EXTERNAL_DOWNLOAD_DIR "${PROJECT_SOURCE_DIR}/.downloads")
endif()
if(NOT EXTERNAL_UNPACKED_SRC_DIR)
  set(EXTERNAL_UNPACKED_SRC_DIR "${EXTERNAL_DOWNLOAD_DIR}/external_unpacked")
endif()
set(EXTERNAL_BIN_DIR "${PROJECT_BINARY_DIR}/external/build")
set(EXTERNAL_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}")


#-----------------------------------------------------------------------
# Set path to LibCMaker root
#-----------------------------------------------------------------------

#set(LIBCMAKER_SRC_DIR "${PROJECT_SOURCE_DIR}/cmake/LibCMaker")
# Uncomment it if need functions from LibCMaker
#list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_SRC_DIR}/cmake/modules")

# Standard CMake vars.
#set(BUILD_SHARED_LIBS ON)

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
# find_package
#-----------------------------------------------------------------------

#set(wxWidgets_USE_STATIC ON)
#set(wxWidgets_USE_UNICODE ON)

find_package(wxWidgets COMPONENTS core REQUIRED)
include(${wxWidgets_USE_FILE})


#-----------------------------------------------------------------------
# HtmlGrapheasKamva
#-----------------------------------------------------------------------

add_subdirectory(HtmlGrapheasKamva "${PROJECT_BINARY_DIR}/HtmlGrapheasKamva")
link_directories(${AGG_LIBRARY_DIRS}) # TODO: remove it

#-----------------------------------------------------------------------
# Link to the library
#-----------------------------------------------------------------------

set(wxAGG_SRC_DIR "${PROJECT_SOURCE_DIR}/HtmlGrapheasKamva/external/wxAGG")

# Build test executables
add_executable(${hga_EXE_NAME}
# wxWidgets examples.
#  ${PROJECT_SOURCE_DIR}/src/wx_examples/wx_ex_hello_world.cpp
#  ${PROJECT_SOURCE_DIR}/src/wx_examples/wx_ex_scrolled_window.cpp
#  ${PROJECT_SOURCE_DIR}/src/wx_examples/wx_ex_custom_button.cpp
#  ${PROJECT_SOURCE_DIR}/src/wx_examples/wx_ex_basic_draw_pane.cpp

# wxAGG sources
  ${wxAGG_SRC_DIR}/src/main.cpp
  ${wxAGG_SRC_DIR}/src/LionWindow.cpp
  ${wxAGG_SRC_DIR}/src/AGGWindow.cpp
  # Included in LionWindow.cpp
  #${wxAGG_SRC_DIR}/src/parse_lion.cpp
  ${wxAGG_SRC_DIR}/include/LionWindow.h
  ${wxAGG_SRC_DIR}/include/AGGWindow.h
  ${wxAGG_SRC_DIR}/include/PixelFormatConvertor.h
)
target_include_directories(${hga_EXE_NAME} PRIVATE ${wxAGG_SRC_DIR}/include)

# HtmlGrapheasKamva
target_link_libraries(${hga_EXE_NAME} htmlgrapheaskamva)

# wxWidgets
#target_compile_definitions(${hga_EXE_NAME} PRIVATE ${wxWidgets_DEFINITIONS})
#target_include_directories(${hga_EXE_NAME} PRIVATE ${wxWidgets_INCLUDE_DIRS})
target_link_libraries(${hga_EXE_NAME} ${wxWidgets_LIBRARIES})
