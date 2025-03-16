cmake_minimum_required(VERSION 3.2)
project(template VERSION 0.1.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


# this bit here will fetch the tramway sdk runtime from github
message(STATUS "Fetching Tramway SDK...")
include(FetchContent)
FetchContent_Declare(
	tramsdk
	GIT_REPOSITORY https://github.com/racenis/tram-sdk.git
	GIT_TAG        270759be8c2f9dbc3c169289e233601f22b42097
	GIT_PROGRESS   TRUE
)
FetchContent_MakeAvailable(tramsdk)


# after that we'll get Lua
message(STATUS "Fetching Lua...")

FetchContent_Declare(
	lua
	GIT_REPOSITORY https://github.com/lua/lua.git
	GIT_TAG        6443185167c77adcc8552a3fee7edab7895db1a9
	GIT_PROGRESS   TRUE
)
FetchContent_MakeAvailable(lua)

# this next bit of lua stuff copy-pasted off of the internet
# https://github.com/eliasdaler/sdl_breakout /edge/third_party/CMakeLists.txt
set(LUA_SOURCES lapi.c lauxlib.c lbaselib.c lcode.c lcorolib.c
		lctype.c ldblib.c ldebug.c ldo.c ldump.c lfunc.c lgc.c linit.c liolib.c
		llex.c lmathlib.c lmem.c loadlib.c lobject.c lopcodes.c loslib.c
		lparser.c lstate.c lstring.c lstrlib.c ltable.c ltablib.c ltm.c lundump.c
		lutf8lib.c lvm.c lzio.c)

list(TRANSFORM LUA_SOURCES PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/_deps/lua-src/")

add_library(lua ${LUA_SOURCES})
add_library(lua::lua ALIAS lua)

if (${BUILD_LUA_AS_CPP})
  target_compile_definitions(lua PUBLIC SOL_USE_CXX_LUA)
  set_source_files_properties(${LUA_SOURCES} PROPERTIES
    LANGUAGE CXX
    LINKER_LANGUAGE CXX
  )
endif()

target_include_directories(lua PUBLIC lua)
if (UNIX)
  target_compile_definitions(lua PUBLIC LUA_USE_LINUX)
  target_link_libraries(lua PUBLIC dl m)
endif()

# next up we'll get bullet
message(STATUS "Fetching Bullet...")

# for some reason bullet come with a lot of junk, so we'll turn them off
set(USE_DOUBLE_PRECISION OFF CACHE BOOL "Use double precision"	FORCE)
set(USE_GRAPHICAL_BENCHMARK OFF CACHE BOOL "Use Graphical Benchmark" FORCE)
set(BUILD_SHARED_LIBS OFF CACHE BOOL "Use shared libraries" FORCE)
#set(USE_SOFT_BODY_MULTI_BODY_DYNAMICS_WORLD OFF CACHE BOOL "Use btSoftMultiBodyDynamicsWorld" FORCE)
set(USE_OPENVR OFF CACHE BOOL "Use OpenVR for virtual reality" FORCE)
set(ENABLE_VHACD OFF CACHE BOOL "Use VHACD in BulletRobotics and pybullet" FORCE)
set(BULLET2_MULTITHREADING OFF CACHE BOOL "Build Bullet 2 libraries with mutex locking around certain operations (required for multi-threading)" FORCE)
set(BUILD_CPU_DEMOS OFF CACHE BOOL "Build original Bullet CPU examples" FORCE)
set(USE_GLUT OFF CACHE BOOL "Use Glut"	FORCE)
set(BUILD_BULLET3 OFF CACHE BOOL "Set when you want to build Bullet 3" FORCE)
set(BUILD_PYBULLET OFF CACHE BOOL "Set when you want to build pybullet (Python bindings for Bullet)" FORCE)
set(BUILD_ENET OFF CACHE BOOL "Set when you want to build apps with enet UDP networking support" FORCE)
set(BUILD_CLSOCKET OFF CACHE BOOL "Set when you want to build apps with enet TCP networking support" FORCE)
set(BUILD_BULLET2_DEMOS OFF CACHE BOOL "Set when you want to build the Bullet 2 demos" FORCE)
set(BUILD_EXTRAS OFF CACHE BOOL "Set when you want to build the extras" FORCE)
set(INSTALL_LIBS OFF CACHE BOOL "Set when you want to install libraries" FORCE)
set(BUILD_UNIT_TESTS OFF CACHE BOOL "Build Unit Tests"	FORCE)
set(INSTALL_CMAKE_FILES OFF CACHE BOOL "Install generated CMake files" FORCE)

FetchContent_Declare(
	bullet
	GIT_REPOSITORY https://github.com/bulletphysics/bullet3.git
	GIT_TAG        2c204c49e56ed15ec5fcfa71d199ab6d6570b3f5
	GIT_PROGRESS   TRUE
)
FetchContent_MakeAvailable(bullet)

# then we install glfw
message(STATUS "Fetching GLFW...")

#set(BUILD_SHARED_LIBS OFF CACHE BOOL  "Build shared libraries" FORCE)
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "Build the GLFW example programs" FORCE)
set(GLFW_BUILD_TESTS OFF CACHE BOOL "Build the GLFW test programs" FORCE)
set(GLFW_BUILD_DOCS OFF CACHE BOOL "Build the GLFW documentation" FORCE)
set(GLFW_INSTALL OFF CACHE BOOL "Generate installation target" FORCE)
set(GLFW_VULKAN_STATIC OFF CACHE BOOL "Assume the Vulkan loader is linked with the application" FORCE)

FetchContent_Declare(
	glfw
	GIT_REPOSITORY https://github.com/glfw/glfw.git
	GIT_TAG        dc46d3f8129712e42856c20e99a604a3b08ad581
	GIT_PROGRESS   TRUE
)
FetchContent_MakeAvailable(glfw)

# and finally we get OpenAL
message(STATUS "Fetching OpenAL...")

set(ALSOFT_BACKEND_PIPEWIRE OFF CACHE BOOL   "Check for the dlopen API for loading optional libs"  FORCE)
set(ALSOFT_BACKEND_SNDIO OFF CACHE BOOL   "Check for the dlopen API for loading optional libs"  FORCE)
set(ALSOFT_DLOPEN OFF CACHE BOOL   "Check for the dlopen API for loading optional libs"  FORCE)
set(ALSOFT_WERROR OFF CACHE BOOL   "Treat compile warnings as errors"      FORCE)
set(ALSOFT_UTILS OFF CACHE BOOL  "Build utility programs"  FORCE)
set(ALSOFT_NO_CONFIG_UTIL ON CACHE BOOL   "Disable building the alsoft-config utility" FORCE)
set(ALSOFT_EXAMPLES OFF CACHE BOOL   "Build example programs"  FORCE)
set(ALSOFT_INSTALL OFF CACHE BOOL   "Install main library" FORCE)
set(ALSOFT_INSTALL_CONFIG OFF CACHE BOOL   "Install alsoft.conf sample configuration file" FORCE)
set(ALSOFT_INSTALL_HRTF_DATA OFF CACHE BOOL   "Install HRTF data files" FORCE)
set(ALSOFT_INSTALL_AMBDEC_PRESETS OFF CACHE BOOL   "Install AmbDec preset files" FORCE)
set(ALSOFT_INSTALL_EXAMPLES OFF CACHE BOOL   "Install example programs (alplay, alstream, ...)" FORCE)
set(ALSOFT_INSTALL_UTILS OFF CACHE BOOL   "Install utility programs (openal-info, alsoft-config, ...)" FORCE)
set(ALSOFT_UPDATE_BUILD_VERSION OFF CACHE BOOL   "Update git build version info" FORCE)

FetchContent_Declare(
	OpenAL
	GIT_REPOSITORY https://github.com/kcat/openal-soft.git
	GIT_TAG        d3875f333fb6abe2f39d82caca329414871ae53b
	GIT_PROGRESS   TRUE
)
FetchContent_MakeAvailable(OpenAL)

message(STATUS "Finished fetching!")


include_directories(${tramsdk_SOURCE_DIR}/src)
include_directories(${tramsdk_SOURCE_DIR}/libraries)

file(GLOB_RECURSE SOURCES ${CMAKE_SOURCE_DIR}/src/*.cpp)

add_executable(template ${SOURCES})

target_link_libraries(template tramsdk
	lua
	OpenAL
	glfw
	BulletSoftBody
	BulletDynamics
	BulletCollision
	LinearMath
)