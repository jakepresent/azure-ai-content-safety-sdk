include(ExternalProject)
set(PACKAGE_VERSION_OPENCV "4.10.0")
set(OPENCV_PROJECT "extern_opencv")

set(OPENCV_PREFIX_DIR ${THIRD_PARTY_PATH}/opencv)

SET(OPENCV_LIB_NAME "opencv_world4100")
if (CMAKE_BUILD_TYPE STREQUAL Debug)
    SET(OPENCV_LIB_NAME "opencv_world4100d")
endif()

set(OPENCV_SOURCE_DIR
        ${THIRD_PARTY_PATH}/opencv/src/${OPENCV_PROJECT})
set(OPENCV_INSTALL_DIR ${THIRD_PARTY_PATH}/install/opencv)

set(OPENCV_SHARED_LIB_SOURCE
        "${OPENCV_SOURCE_DIR}/build/x64/vc16/bin/${OPENCV_LIB_NAME}.dll"
        CACHE FILEPATH "shared library source." FORCE)
set(LOCAL_OPENCV_SHARED_LIB_SOURCE
        "${CMAKE_SOURCE_DIR}/opencv/windows/arm64/${OPENCV_LIB_NAME}.dll"
        CACHE FILEPATH "shared library source." FORCE)
set(OPENCV_SHARED_LIB_DEST
        "${OPENCV_INSTALL_DIR}/lib/${OPENCV_LIB_NAME}.dll"
        CACHE FILEPATH "shared library install target." FORCE)

set(OPENCV_STATIC_LIB_SOURCE
        "${OPENCV_SOURCE_DIR}/build/x64/vc16/lib/${OPENCV_LIB_NAME}.lib"
        CACHE FILEPATH "static library source." FORCE)
set(LOCAL_OPENCV_STATIC_LIB_SOURCE
        "${CMAKE_SOURCE_DIR}/opencv/windows/arm64/${OPENCV_LIB_NAME}.lib"
        CACHE FILEPATH "static library source." FORCE)
set(OPENCV_STATIC_LIB_DEST
        "${OPENCV_INSTALL_DIR}/lib/${OPENCV_LIB_NAME}.lib"
        CACHE FILEPATH "static library target." FORCE)
set(OPENCV_URL
        "https://github.com/opencv/opencv/releases/download/${PACKAGE_VERSION_OPENCV}/opencv-${PACKAGE_VERSION_OPENCV}-windows.exe"
)

string(TOUPPER "${CMAKE_SYSTEM_PROCESSOR}" SYSTEM_PROCESSOR)
if (SYSTEM_PROCESSOR STREQUAL ARM64)
    ExternalProject_Add(
            ${OPENCV_PROJECT}
            ${EXTERNAL_PROJECT_LOG_ARGS}
            PREFIX ${OPENCV_PREFIX_DIR}
            DOWNLOAD_COMMAND ""
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            UPDATE_COMMAND ""
            INSTALL_COMMAND
            ${CMAKE_COMMAND} -E copy ${LOCAL_OPENCV_SHARED_LIB_SOURCE} ${OPENCV_SHARED_LIB_DEST} &&
            ${CMAKE_COMMAND} -E copy ${LOCAL_OPENCV_STATIC_LIB_SOURCE} ${OPENCV_STATIC_LIB_DEST}
            BUILD_BYPRODUCTS ${OPENCV_SHARED_LIB_DEST})
else()
    ExternalProject_Add(
            ${OPENCV_PROJECT}
            ${EXTERNAL_PROJECT_LOG_ARGS}
            URL ${OPENCV_URL}
            PREFIX ${OPENCV_PREFIX_DIR}
            DOWNLOAD_NO_PROGRESS 1
            DOWNLOAD_EXTRACT_TIMESTAMP true
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            UPDATE_COMMAND ""
            INSTALL_COMMAND
            ${CMAKE_COMMAND} -E copy ${OPENCV_SHARED_LIB_SOURCE} ${OPENCV_SHARED_LIB_DEST} &&
            ${CMAKE_COMMAND} -E copy ${OPENCV_STATIC_LIB_SOURCE} ${OPENCV_STATIC_LIB_DEST}
            BUILD_BYPRODUCTS ${OPENCV_SHARED_LIB_DEST})
endif()
add_library(opencv STATIC IMPORTED GLOBAL)
set_property(TARGET opencv PROPERTY IMPORTED_LOCATION ${OPENCV_STATIC_LIB_DEST})
add_dependencies(opencv ${OPENCV_PROJECT})
