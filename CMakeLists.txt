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

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

# External libs directories.
set(EXTERNAL_SRC_DIR "${PROJECT_SOURCE_DIR}/external")
set(EXTERNAL_BIN_DIR "${PROJECT_BINARY_DIR}/external")

# Download all external libs with LibCMaker to this dir.
if(NOT EXTERNAL_DOWNLOAD_DIR)
  set(EXTERNAL_DOWNLOAD_DIR "${PROJECT_SOURCE_DIR}/.downloads")
endif()

# Install all external libs with LibCMaker to this dir.
set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/install")


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
#list(APPEND CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}")


#-----------------------------------------------------------------------
# find_package
#-----------------------------------------------------------------------

#set(wxWidgets_USE_STATIC ON)
#set(wxWidgets_USE_UNICODE ON)

find_package(wxWidgets COMPONENTS core REQUIRED)
include(${wxWidgets_USE_FILE})


#-----------------------------------------------------------------------
# Link to the library
#-----------------------------------------------------------------------

# Build test executables
add_executable(${PROJECT_NAME}
  ${PROJECT_SOURCE_DIR}/src/wx_ex_hello_world.cpp
)
#target_compile_definitions(${PROJECT_NAME} PRIVATE ${wxWidgets_DEFINITIONS})
#target_include_directories(${PROJECT_NAME} PRIVATE ${wxWidgets_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} ${wxWidgets_LIBRARIES})
