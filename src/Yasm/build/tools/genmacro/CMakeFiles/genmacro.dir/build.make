# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = /usr/bin/ccmake

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = "/home/lovewei/Project/yasm/new yasm/yasm"

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = "/home/lovewei/Project/yasm/new yasm/yasm/build"

# Include any dependencies generated for this target.
include tools/genmacro/CMakeFiles/genmacro.dir/depend.make

# Include the progress variables for this target.
include tools/genmacro/CMakeFiles/genmacro.dir/progress.make

# Include the compile flags for this target's objects.
include tools/genmacro/CMakeFiles/genmacro.dir/flags.make

tools/genmacro/CMakeFiles/genmacro.dir/genmacro.o: tools/genmacro/CMakeFiles/genmacro.dir/flags.make
tools/genmacro/CMakeFiles/genmacro.dir/genmacro.o: ../tools/genmacro/genmacro.c
	$(CMAKE_COMMAND) -E cmake_progress_report "/home/lovewei/Project/yasm/new yasm/yasm/build/CMakeFiles" $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object tools/genmacro/CMakeFiles/genmacro.dir/genmacro.o"
	cd "/home/lovewei/Project/yasm/new yasm/yasm/build/tools/genmacro" && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/genmacro.dir/genmacro.o   -c "/home/lovewei/Project/yasm/new yasm/yasm/tools/genmacro/genmacro.c"

tools/genmacro/CMakeFiles/genmacro.dir/genmacro.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/genmacro.dir/genmacro.i"
	cd "/home/lovewei/Project/yasm/new yasm/yasm/build/tools/genmacro" && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E "/home/lovewei/Project/yasm/new yasm/yasm/tools/genmacro/genmacro.c" > CMakeFiles/genmacro.dir/genmacro.i

tools/genmacro/CMakeFiles/genmacro.dir/genmacro.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/genmacro.dir/genmacro.s"
	cd "/home/lovewei/Project/yasm/new yasm/yasm/build/tools/genmacro" && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S "/home/lovewei/Project/yasm/new yasm/yasm/tools/genmacro/genmacro.c" -o CMakeFiles/genmacro.dir/genmacro.s

tools/genmacro/CMakeFiles/genmacro.dir/genmacro.o.requires:
.PHONY : tools/genmacro/CMakeFiles/genmacro.dir/genmacro.o.requires

tools/genmacro/CMakeFiles/genmacro.dir/genmacro.o.provides: tools/genmacro/CMakeFiles/genmacro.dir/genmacro.o.requires
	$(MAKE) -f tools/genmacro/CMakeFiles/genmacro.dir/build.make tools/genmacro/CMakeFiles/genmacro.dir/genmacro.o.provides.build
.PHONY : tools/genmacro/CMakeFiles/genmacro.dir/genmacro.o.provides

tools/genmacro/CMakeFiles/genmacro.dir/genmacro.o.provides.build: tools/genmacro/CMakeFiles/genmacro.dir/genmacro.o

# Object files for target genmacro
genmacro_OBJECTS = \
"CMakeFiles/genmacro.dir/genmacro.o"

# External object files for target genmacro
genmacro_EXTERNAL_OBJECTS =

tools/genmacro/genmacro: tools/genmacro/CMakeFiles/genmacro.dir/genmacro.o
tools/genmacro/genmacro: tools/genmacro/CMakeFiles/genmacro.dir/build.make
tools/genmacro/genmacro: tools/genmacro/CMakeFiles/genmacro.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking C executable genmacro"
	cd "/home/lovewei/Project/yasm/new yasm/yasm/build/tools/genmacro" && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/genmacro.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tools/genmacro/CMakeFiles/genmacro.dir/build: tools/genmacro/genmacro
.PHONY : tools/genmacro/CMakeFiles/genmacro.dir/build

tools/genmacro/CMakeFiles/genmacro.dir/requires: tools/genmacro/CMakeFiles/genmacro.dir/genmacro.o.requires
.PHONY : tools/genmacro/CMakeFiles/genmacro.dir/requires

tools/genmacro/CMakeFiles/genmacro.dir/clean:
	cd "/home/lovewei/Project/yasm/new yasm/yasm/build/tools/genmacro" && $(CMAKE_COMMAND) -P CMakeFiles/genmacro.dir/cmake_clean.cmake
.PHONY : tools/genmacro/CMakeFiles/genmacro.dir/clean

tools/genmacro/CMakeFiles/genmacro.dir/depend:
	cd "/home/lovewei/Project/yasm/new yasm/yasm/build" && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" "/home/lovewei/Project/yasm/new yasm/yasm" "/home/lovewei/Project/yasm/new yasm/yasm/tools/genmacro" "/home/lovewei/Project/yasm/new yasm/yasm/build" "/home/lovewei/Project/yasm/new yasm/yasm/build/tools/genmacro" "/home/lovewei/Project/yasm/new yasm/yasm/build/tools/genmacro/CMakeFiles/genmacro.dir/DependInfo.cmake" --color=$(COLOR)
.PHONY : tools/genmacro/CMakeFiles/genmacro.dir/depend

