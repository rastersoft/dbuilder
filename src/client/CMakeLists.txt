### CMakeLists automatically created with AutoVala
### Do not edit

set (DATADIR "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_DATAROOTDIR}")
set (PKGDATADIR "${DATADIR}/dbuilder")
set (GETTEXT_PACKAGE "dbuilder")
set (RELEASE_NAME "dbuilder")
set (CMAKE_C_FLAGS "")
set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (VERSION "1.0.0")
set (DOLLAR "$")

configure_file (${CMAKE_SOURCE_DIR}/src/client/Config.vala.cmake ${CMAKE_BINARY_DIR}/src/client/Config.vala)
add_definitions(-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
set (VERSION "1.0.0")
add_definitions (${DEPS_CFLAGS})
include_directories ( ${CMAKE_BINARY_DIR}/src ${CMAKE_BINARY_DIR}/src/applet )
link_libraries ( ${DEPS_LIBRARIES} -lDBuilder -lDBuilderApplet )
link_directories ( ${DEPS_LIBRARY_DIRS} ${CMAKE_BINARY_DIR}/src ${CMAKE_BINARY_DIR}/src/applet )
find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.24" MINIMUM)
include (ValaPrecompile)

set (VALA_PACKAGES ${VALA_PACKAGES} posix)
set (VALA_PACKAGES ${VALA_PACKAGES} atk)
set (VALA_PACKAGES ${VALA_PACKAGES} cairo)
set (VALA_PACKAGES ${VALA_PACKAGES} gdk-3.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gdk-pixbuf-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gee-0.8)
set (VALA_PACKAGES ${VALA_PACKAGES} gio-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} glib-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gobject-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gtk+-3.0)
set (VALA_PACKAGES ${VALA_PACKAGES} pango)
set (VALA_PACKAGES ${VALA_PACKAGES} x11)

set (APP_SOURCES ${APP_SOURCES} ${CMAKE_CURRENT_BINARY_DIR}/Config.vala)
set (APP_SOURCES ${APP_SOURCES} client_demo.vala)

set (CUSTOM_VAPIS_LIST ${CUSTOM_VAPIS_LIST} ${CMAKE_BINARY_DIR}/src/DBuilder.vapi)
set (CUSTOM_VAPIS_LIST ${CUSTOM_VAPIS_LIST} ${CMAKE_BINARY_DIR}/src/applet/DBuilderApplet.vapi)

vala_precompile(VALA_C dbuilder_client
	${APP_SOURCES}
PACKAGES
	${VALA_PACKAGES}
CUSTOM_VAPIS
	${CUSTOM_VAPIS_LIST}
)

add_executable(dbuilder_client ${VALA_C})

install(TARGETS
	dbuilder_client
RUNTIME DESTINATION
	${CMAKE_INSTALL_BINDIR}/
)

if(HAVE_VALADOC)
	valadoc(dbuilder_client
		${CMAKE_BINARY_DIR}/valadoc/dbuilder_client
		${APP_SOURCES}
	PACKAGES
		${VALA_PACKAGES}
	CUSTOM_VAPIS
		${CUSTOM_VAPIS_LIST}
	)
	install(DIRECTORY
		${CMAKE_BINARY_DIR}/valadoc
	DESTINATION
		${CMAKE_INSTALL_DATAROOTDIR}/doc/dbuilder
	)
endif()
