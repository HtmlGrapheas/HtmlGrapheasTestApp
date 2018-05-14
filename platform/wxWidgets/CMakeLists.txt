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

#-----------------------------------------------------------------------
# HtmlGrapheasKamvaWxWidgets
#-----------------------------------------------------------------------

if(NOT HtmlGrapheasKamva_DIR)
  message(FATAL_ERROR
    "Please set HtmlGrapheasKamva_DIR with path to HtmlGrapheasKamva library.")
endif()

set(HtmlGrapheasKamvaWx_DIR
  "${HtmlGrapheasKamva_DIR}/src/hgkamva/platform/wxwidgets"
)

add_subdirectory(
  ${HtmlGrapheasKamvaWx_DIR}
  ${PROJECT_BINARY_DIR}/HtmlGrapheasKamvaWx
)


#-----------------------------------------------------------------------
# HtmlGrapheasApp
#-----------------------------------------------------------------------

set(hga_EXE_NAME "html_grapheas")


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
# Link to the library
#-----------------------------------------------------------------------

# Build test executables

set(exe_HEADERS
)

set(exe_SOURCES
# wxWidgets examples.
#  ${PLATFORM_WX_SRC_DIR}/src/wx_examples/wx_ex_hello_world.cpp
#  ${PLATFORM_WX_SRC_DIR}/src/wx_examples/wx_ex_scrolled_window.cpp
#  ${PLATFORM_WX_SRC_DIR}/src/wx_examples/wx_ex_custom_button.cpp
#  ${PLATFORM_WX_SRC_DIR}/src/wx_examples/wx_ex_basic_draw_pane.cpp

# HtmlGrapheasApp
  ${PLATFORM_WX_SRC_DIR}/src/hgapp/main.cpp
)

if(WIN32 AND NOT ATTACH_WX_CONSOLE)
  # See docs for add_executable().
  set(WIN32GUI WIN32)    
else()
  set(WIN32GUI "")    
endif()

add_executable(${hga_EXE_NAME} ${WIN32GUI} ${exe_SOURCES} ${exe_HEADERS})
set_target_properties(${hga_EXE_NAME} PROPERTIES
  CXX_STANDARD 11
  C_STANDARD 11
)
set_property(TARGET ${hga_EXE_NAME}
  PROPERTY RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}"
)
if(ATTACH_WX_CONSOLE)
  target_compile_definitions(${hga_EXE_NAME} PRIVATE ATTACH_WX_CONSOLE)
endif()

# HtmlGrapheasKamvaWx with HtmlGrapheasKamva
target_link_libraries(${hga_EXE_NAME} PRIVATE htmlgrapheaskamvawx)

# wxWidgets
# Used from HtmlGrapheasKamvaWx.
#if(WX_USE_FIND_PACKAGE_MODULE)
#  target_compile_definitions(${hga_EXE_NAME} PRIVATE ${wxWidgets_DEFINITIONS})
#  target_include_directories(${hga_EXE_NAME} PRIVATE ${wxWidgets_INCLUDE_DIRS})
#  target_link_libraries(${hga_EXE_NAME} PRIVATE ${wxWidgets_LIBRARIES})
#  # TODO:
#  #COMPILE_DEFINITIONS_DEBUG ${wxWidgets_DEFINITIONS_DEBUG}
#  #wxWidgets_CXX_FLAGS
#else()
#  target_link_libraries(${hga_EXE_NAME} PRIVATE ${WX_lib_COMPONENTS})
#endif()

if(BUILD_TESTING)
  set(WX_HGRAPH_TEST_DIR "${PROJECT_BINARY_DIR}")
  set(WX_HGRAPH_TEST_FONT_DIR "${WX_HGRAPH_TEST_DIR}/fonts")
  set(WX_HGRAPH_TEST_DATA_DIR "${WX_HGRAPH_TEST_DIR}/data")

  add_custom_target(prepare_wx_test_fonts ALL
    COMMAND
      ${CMAKE_COMMAND} -E make_directory "${WX_HGRAPH_TEST_FONT_DIR}"

    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      # Arimo font files
      "${HtmlGrapheasKamva_DIR}/fonts/Arimo/Arimo-BoldItalic.ttf"
      "${HtmlGrapheasKamva_DIR}/fonts/Arimo/Arimo-Bold.ttf"
      "${HtmlGrapheasKamva_DIR}/fonts/Arimo/Arimo-Italic.ttf"
      "${HtmlGrapheasKamva_DIR}/fonts/Arimo/Arimo-Regular.ttf"

      # Tinos font files
      "${HtmlGrapheasKamva_DIR}/fonts/Tinos/Tinos-BoldItalic.ttf"
      "${HtmlGrapheasKamva_DIR}/fonts/Tinos/Tinos-Bold.ttf"
      "${HtmlGrapheasKamva_DIR}/fonts/Tinos/Tinos-Italic.ttf"
      "${HtmlGrapheasKamva_DIR}/fonts/Tinos/Tinos-Regular.ttf"

      # To dir 'fonts'
      "${WX_HGRAPH_TEST_FONT_DIR}"
  )

  add_custom_target(prepare_wx_test_font_conf ALL
    COMMAND ${CMAKE_COMMAND} -E copy_directory
      "${CMAKE_INSTALL_PREFIX}/etc/fonts"

      # To dir 'fonts'
      "${WX_HGRAPH_TEST_FONT_DIR}"
  )

  add_custom_target(prepare_wx_test_data ALL
    COMMAND
      ${CMAKE_COMMAND} -E make_directory "${WX_HGRAPH_TEST_DATA_DIR}"

    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      "${HtmlGrapheasKamva_DIR}/test/data/master.css"
      "${HtmlGrapheasKamva_DIR}/test/data/test.html"

      # To dir 'data'
      "${WX_HGRAPH_TEST_DATA_DIR}"
  )
endif()
