cmake_minimum_required(VERSION 3.2)
project(template VERSION 0.1.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

message(STATUS "Fetching Tramway SDK...")

include(FetchContent)
FetchContent_Declare(
	tramsdk
	GIT_REPOSITORY https://github.com/racenis/tram-sdk.git
	GIT_TAG        2d876a37bf367d383443658aab60e492bf475a03
	GIT_PROGRESS   TRUE
)
FetchContent_MakeAvailable(tramsdk)

message(STATUS "Finished fetching!")


include_directories(${tramsdk_SOURCE_DIR}/src)
include_directories(${tramsdk_SOURCE_DIR}/libraries)

file(GLOB_RECURSE SOURCES ${CMAKE_SOURCE_DIR}/src/*.cpp)

add_executable(template ${SOURCES})

# TODO: use FetchContent to download the rest of the libraries
target_link_libraries(template tramsdk
	${CMAKE_SOURCE_DIR}/../tram-sdk/libraries/binaries/win64/liblua.a
	${CMAKE_SOURCE_DIR}/../tram-sdk/libraries/binaries/win64/libBulletSoftBody.a
	${CMAKE_SOURCE_DIR}/../tram-sdk/libraries/binaries/win64/libBulletDynamics.a
	${CMAKE_SOURCE_DIR}/../tram-sdk/libraries/binaries/win64/libBulletCollision.a
	${CMAKE_SOURCE_DIR}/../tram-sdk/libraries/binaries/win64/libLinearMath.a
	${CMAKE_SOURCE_DIR}/../tram-sdk/libraries/binaries/win64/libglfw3.a
	${CMAKE_SOURCE_DIR}/../tram-sdk/libraries/binaries/win64/libOpenAL32.a)