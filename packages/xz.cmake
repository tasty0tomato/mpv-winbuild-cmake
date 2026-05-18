# If the source directory is absent (repository cache miss), clear the download
# stamp so ExternalProject re-clones instead of skipping download with no source.
if(NOT EXISTS "${SOURCE_LOCATION}")
    file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/xz-prefix/src/xz-stamp/xz-download")
endif()

ExternalProject_Add(xz
    GIT_REPOSITORY https://github.com/tukaani-project/xz.git
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    GIT_RESET 4b73f2ec19a99ef465282fbce633e8deb33691b3 # v5.8.3
    CONFIGURE_COMMAND ${EXEC} CONF=1 autoreconf -fi && <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-xz
        --disable-xzdec
        --disable-lzmadec
        --disable-lzmainfo
        --disable-doc
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(xz)
cleanup(xz install)
