
get_filename_component(__tools_switch_sdir ${CMAKE_CURRENT_LIST_FILE} PATH) # Used to locate files to be used with configure_file

#############
## ELF2NRO ##
#############
if (NOT ELF2NRO)
    # message(STATUS "Looking for makerom...")
    find_program(ELF2NRO elf2nro ${DEVKITPRO}/tools/bin)
    if (ELF2NRO)
        message(STATUS "elf2nro: ${ELF2NRO} - found")
    else ()
        message(WARNING "elf2nro - not found")
    endif ()
endif ()

#############
## ELF2KIP ##
#############
if (NOT ELF2KIP)
    # message(STATUS "Looking for makerom...")
    find_program(ELF2KIP elf2kip ${DEVKITPRO}/tools/bin)
    if (ELF2KIP)
        message(STATUS "elf2kip: ${ELF2KIP} - found")
    else ()
        message(WARNING "elf2kip - not found")
    endif ()
endif ()
#############
## ELF2NSO ##
#############
if (NOT ELF2NSO)
    # message(STATUS "Looking for makerom...")
    find_program(ELF2NSO elf2nso ${DEVKITPRO}/tools/bin)
    if (ELF2NSO)
        message(STATUS "elf2nso: ${ELF2NSO} - found")
    else ()
        message(WARNING "elf2nso - not found")
    endif ()
endif ()

#############
##  BIN2S  ##
#############
if (NOT BIN2S)
    # message(STATUS "Looking for bin2s...")
    find_program(BIN2S bin2s ${DEVKITPRO}/tools/bin)
    if (BIN2S)
        message(STATUS "bin2s: ${BIN2S} - found")
    else ()
        message(WARNING "bin2s - not found")
    endif ()
endif ()

#############
##  RAW2C  ##
#############
if (NOT RAW2C)
    # message(STATUS "Looking for bin2s...")
    find_program(RAW2C raw2c ${DEVKITPRO}/tools/bin)
    if (RAW2C)
        message(STATUS "raw2c: ${RAW2C} - found")
    else ()
        message(WARNING "raw2c - not found")
    endif ()
endif ()

##################
##  BUILD_PFS0  ##
##################
if (NOT BUILD_PFS0)
    # message(STATUS "Looking for bin2s...")
    find_program(BUILD_PFS0 build_pfs0 ${DEVKITPRO}/tools/bin)
    if (BUILD_PFS0)
        message(STATUS "build_pfs0: ${BUILD_PFS0} - found")
    else ()
        message(WARNING "build_pfs0 - not found")
    endif ()
endif ()

################
##  NACPTOOL  ##
################
if (NOT NACPTOOL)
    # message(STATUS "Looking for bin2s...")
    find_program(NACPTOOL nacptool ${DEVKITPRO}/tools/bin)
    if (NACPTOOL)
        message(STATUS "nacptool: ${NACPTOOL} - found")
    else ()
        message(WARNING "nacptool - not found")
    endif ()
endif ()


function(__add_nacp target APP_TITLE APP_AUTHOR APP_VERSION)
    set(__NACP_COMMAND ${NACPTOOL} --create ${APP_TITLE} ${APP_AUTHOR} ${APP_VERSION} ${CMAKE_CURRENT_BINARY_DIR}/${target})

    add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${target}
            COMMAND ${__NACP_COMMAND}
            WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
            VERBATIM
            )
endfunction()
function(add_nro_target target)
    get_filename_component(target_we ${target} NAME_WE)
    if ((NOT (${ARGC} GREATER 1 AND "${ARGV1}" STREQUAL "NO_NACP")) OR (${ARGC} GREATER 3))
        if (${ARGC} GREATER 3)
            set(APP_TITLE ${ARGV1})
            set(APP_AUTHOR ${ARGV2})
            set(APP_VERSION ${ARGV3})
        endif ()
        if (${ARGC} EQUAL 5)
            set(APP_ICON ${ARGV4})
        endif ()
        if (NOT APP_TITLE)
            set(APP_TITLE ${target})
        endif ()
        if (NOT APP_AUTHOR)
            set(APP_AUTHOR "Unspecified Author")
        endif ()
        if (NOT APP_VERSION)
            set(APP_VERSION "1.0")
        endif ()
        if (NOT APP_ICON)
            if (EXISTS ${target}.png)
                set(APP_ICON ${target}.png)
            elseif (EXISTS icon.png)
                set(APP_ICON icon.png)
            elseif (NX)
                set(APP_ICON ${DEVKITPRO}/libnx/default_icon.png)
            else ()
                message(FATAL_ERROR "No icon found ! Please use NO_SMDH or provide some icon.")
            endif ()
        endif ()
        if (NOT ${target_we}.nacp)
            __add_nacp(${target_we}.nacp ${APP_TITLE} ${APP_AUTHOR} ${APP_VERSION})
        endif ()
        if (CMAKE_RUNTIME_OUTPUT_DIRECTORY)
            add_custom_command(OUTPUT ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${target_we}.nro
                    COMMAND ${ELF2NRO} $<TARGET_FILE:${target}> --icon=${APP_ICON} --nacp=${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nacp ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${target_we}.nro
                    DEPENDS ${target} ${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nacp
                    VERBATIM
                    )
        else ()
            add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nro
                    COMMAND ${ELF2NRO} $<TARGET_FILE:${target}> --icon=${APP_ICON} --nacp=${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nacp ${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nro
                    DEPENDS ${target} ${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nacp
                    VERBATIM
                    )
        endif ()
    else ()
        message(STATUS "No nacp file will be generated")
        if (CMAKE_RUNTIME_OUTPUT_DIRECTORY)
            add_custom_command(OUTPUT ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${target_we}.nro
                    COMMAND ${ELF2NRO} $<TARGET_FILE:${target}> ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${target_we}.nro
                    DEPENDS ${target}
                    VERBATIM
                    )
        else ()
            add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nro
                    COMMAND ${ELF2NRO} $<TARGET_FILE:${target}> ${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nro
                    DEPENDS ${target}
                    VERBATIM
                    )
        endif ()

    endif ()
    if (CMAKE_RUNTIME_OUTPUT_DIRECTORY)
        add_custom_target(${target_we}_nro ALL SOURCES ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${target_we}.nro)

    else ()
        add_custom_target(${target_we}_nro ALL SOURCES ${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nro)
    endif ()
endfunction()
