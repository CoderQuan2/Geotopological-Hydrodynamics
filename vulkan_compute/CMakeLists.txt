cmake_minimum_required(VERSION 3.20)
project(GTH_Vulkan_Compute VERSION 5.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Vulkan REQUIRED)
find_package(glm REQUIRED)

add_executable(gth_vulkan_compute src/main.cpp)
target_include_directories(gth_vulkan_compute PRIVATE ${Vulkan_INCLUDE_DIRS})
target_link_libraries(gth_vulkan_compute PRIVATE Vulkan::Vulkan glm::glm)
