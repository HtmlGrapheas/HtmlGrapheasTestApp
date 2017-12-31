goto license_header
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
:license_header

@rem https://stackoverflow.com/a/25746667
@rem -T v120_xp  (the best)
@rem or
@rem -DCMAKE_GENERATOR_TOOLSET=v120_xp

@rem https://stackoverflow.com/a/20423820
@rem To change the build type, on Windows, it must be done at build time:
@rem cmake --build {DIR} --config Release

@rem https://stackoverflow.com/a/35580404
@rem "-B" - specifies path to the build folder
@rem "-H" - specifies path to the source folder


@set CMAKE_PATH="cmake"

@set SOURCE_DIR=%~dp0
@set BUILD_DIR=%~dp0build_wxms

@set BUILD_TYPE=Debug
@rem set BUILD_TYPE=Release

@set ATTACH_WX_CONSOLE=ON
@rem set ATTACH_WX_CONSOLE=OFF


@if "%1" == "" goto win64
@if not "%2" == "" goto usage

@if /i %1 == win32_xp  goto win32_xp
@if /i %1 == win32     goto win32
@if /i %1 == win64     goto win64
@goto usage


:win32_xp
@set VS_GEN="Visual Studio 15 2017"
@set XP_TOOL=-T v141_xp
@goto :RunCMake

:win32
@set VS_GEN="Visual Studio 15 2017"
@set XP_TOOL=
@goto :RunCMake

:win64
@set VS_GEN="Visual Studio 15 2017 Win64"
@set XP_TOOL=
@goto :RunCMake

@rem Use /MP flag in command line. Just specify /MP by itself to have
@rem VS's build system automatically select how many threads to compile on
@rem (which usually is the maximum number of threads available).

:RunCMake
%CMAKE_PATH% ^
 -H%SOURCE_DIR% ^
 -B%BUILD_DIR% ^
 -DATTACH_WX_CONSOLE=%ATTACH_WX_CONSOLE% ^
 -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
 -DCMAKE_CXX_FLAGS="/MP" -DCMAKE_C_FLAGS="/MP" ^
 -G %VS_GEN% ^
 %XP_TOOL% ^
 -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ^
 && %CMAKE_PATH% --build %BUILD_DIR% --config %BUILD_TYPE%

@goto :eof

:usage
@echo usage TODO
@goto :eof
