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
CMAKE_SOURCE_DIR = /home/lovewei/Project/WProtect/test/Algorithms

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/lovewei/Project/WProtect/test/Algorithms/build

# Include any dependencies generated for this target.
include CMakeFiles/TestApp.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/TestApp.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/TestApp.dir/flags.make

CMakeFiles/TestApp.dir/AlgorithmsTest.o: CMakeFiles/TestApp.dir/flags.make
CMakeFiles/TestApp.dir/AlgorithmsTest.o: ../AlgorithmsTest.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/lovewei/Project/WProtect/test/Algorithms/build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object CMakeFiles/TestApp.dir/AlgorithmsTest.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/TestApp.dir/AlgorithmsTest.o -c /home/lovewei/Project/WProtect/test/Algorithms/AlgorithmsTest.cpp

CMakeFiles/TestApp.dir/AlgorithmsTest.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/TestApp.dir/AlgorithmsTest.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/lovewei/Project/WProtect/test/Algorithms/AlgorithmsTest.cpp > CMakeFiles/TestApp.dir/AlgorithmsTest.i

CMakeFiles/TestApp.dir/AlgorithmsTest.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/TestApp.dir/AlgorithmsTest.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/lovewei/Project/WProtect/test/Algorithms/AlgorithmsTest.cpp -o CMakeFiles/TestApp.dir/AlgorithmsTest.s

CMakeFiles/TestApp.dir/AlgorithmsTest.o.requires:
.PHONY : CMakeFiles/TestApp.dir/AlgorithmsTest.o.requires

CMakeFiles/TestApp.dir/AlgorithmsTest.o.provides: CMakeFiles/TestApp.dir/AlgorithmsTest.o.requires
	$(MAKE) -f CMakeFiles/TestApp.dir/build.make CMakeFiles/TestApp.dir/AlgorithmsTest.o.provides.build
.PHONY : CMakeFiles/TestApp.dir/AlgorithmsTest.o.provides

CMakeFiles/TestApp.dir/AlgorithmsTest.o.provides.build: CMakeFiles/TestApp.dir/AlgorithmsTest.o

# Object files for target TestApp
TestApp_OBJECTS = \
"CMakeFiles/TestApp.dir/AlgorithmsTest.o"

# External object files for target TestApp
TestApp_EXTERNAL_OBJECTS =

TestApp: CMakeFiles/TestApp.dir/AlgorithmsTest.o
TestApp: CMakeFiles/TestApp.dir/build.make
TestApp: /home/lovewei/Project/WProtect/bin/libAlgorithms_Static.a
TestApp: /home/lovewei/Project/WProtect/bin/libAsmJit_Static.a
TestApp: CMakeFiles/TestApp.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable TestApp"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/TestApp.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/TestApp.dir/build: TestApp
.PHONY : CMakeFiles/TestApp.dir/build

CMakeFiles/TestApp.dir/requires: CMakeFiles/TestApp.dir/AlgorithmsTest.o.requires
.PHONY : CMakeFiles/TestApp.dir/requires

CMakeFiles/TestApp.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/TestApp.dir/cmake_clean.cmake
.PHONY : CMakeFiles/TestApp.dir/clean

CMakeFiles/TestApp.dir/depend:
	cd /home/lovewei/Project/WProtect/test/Algorithms/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/lovewei/Project/WProtect/test/Algorithms /home/lovewei/Project/WProtect/test/Algorithms /home/lovewei/Project/WProtect/test/Algorithms/build /home/lovewei/Project/WProtect/test/Algorithms/build /home/lovewei/Project/WProtect/test/Algorithms/build/CMakeFiles/TestApp.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/TestApp.dir/depend

