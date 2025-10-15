# ============================================================
# function: add_dep
# usage:
#   add_dep(
#       NAME        <name>
#       URL         <git-url>
#       TAG         <tag-or-branch>        # optional (default: main)
#       SUBDIR      <subdir>               # optional (if CMakeLists.txt is in a subfolder)
#       INCLUDE_HINTS <path1> <path2> ...  # optional (extra include directories to consider)
#       CMAKE_ARGS  VAR1=VAL1 VAR2=VAL2... # optional (sets cache vars before MakeAvailable)
#   )
#
# Example:
#   add_dep(
#     NAME sentry-native
#     URL https://github.com/getsentry/sentry-native.git
#     TAG 0.7.14
#     CMAKE_ARGS
#       SENTRY_LIBRARY_TYPE=SHARED
#   )
#
#   target_link_libraries(app PRIVATE sentry)
#   target_include_directories(app PRIVATE ${sentry-native_SOURCE_DIR}/include)
# ============================================================

include(FetchContent)

function(add_dep)
    set(options)
    set(oneValueArgs NAME URL TAG SUBDIR)
    set(multiValueArgs INCLUDE_HINTS CMAKE_ARGS)
    cmake_parse_arguments(FETCHDEP "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT FETCHDEP_NAME)
        message(FATAL_ERROR "add_dep: NAME argument is required")
    endif()
    if(NOT FETCHDEP_URL)
        message(FATAL_ERROR "add_dep: URL argument is required")
    endif()

    set(_tag ${FETCHDEP_TAG})
    if(NOT _tag)
        set(_tag main)
    endif()

    message(STATUS "Fetching dependency ${FETCHDEP_NAME} from ${FETCHDEP_URL} (tag=${_tag})")

    # 1) Apply user-specified CMAKE_ARGS to the cache before MakeAvailable
    #    (useful to override project options like SENTRY_LIBRARY_TYPE=SHARED)
    foreach(arg IN LISTS FETCHDEP_CMAKE_ARGS)
        if(arg MATCHES "^[^=]+=")
            string(REGEX MATCH "^[^=]+" _key "${arg}")
            string(REGEX REPLACE "^[^=]+=" "" _val "${arg}")
            set(${_key} "${_val}" CACHE STRING "set by add_dep(${FETCHDEP_NAME})" FORCE)
            message(STATUS "[add_dep] cache: ${_key}=\'${_val}\'")
        else()
            message(WARNING "[add_dep] ignored CMAKE_ARGS entry (expected VAR=VAL): \'${arg}\'")
        endif()
    endforeach()

    # 2) Fetch and make the dependency available
    FetchContent_Declare(${FETCHDEP_NAME}
        GIT_REPOSITORY         ${FETCHDEP_URL}
        GIT_TAG                ${_tag}
        GIT_PROGRESS           TRUE
        GIT_SUBMODULES_RECURSE TRUE
        GIT_SHALLOW            FALSE
    )
    if(FETCHDEP_SUBDIR)
        set(${FETCHDEP_NAME}_SOURCE_SUBDIR ${FETCHDEP_SUBDIR})
    endif()
    FetchContent_MakeAvailable(${FETCHDEP_NAME})

    # 3) Try to detect useful include directories automatically
    FetchContent_GetProperties(${FETCHDEP_NAME})
    set(_src "${${FETCHDEP_NAME}_SOURCE_DIR}")

    if(FETCHDEP_SUBDIR)
        set(_base "${_src}/${FETCHDEP_SUBDIR}")
    else()
        set(_base "${_src}")
    endif()

    # Common include directory candidates
    set(_cands
        "${_base}/include"
        "${_base}/${FETCHDEP_NAME}/include"
        "${_base}/inc"
        "${_base}/${FETCHDEP_NAME}"
        "${_base}"
    )

    # Add user-provided hints (optional)
    foreach(hint IN LISTS FETCHDEP_INCLUDE_HINTS)
        list(APPEND _cands "${hint}")
    endforeach()

    # Filter only existing directories
    set(_incs "")
    foreach(dir IN LISTS _cands)
        if(EXISTS "${dir}")
            list(APPEND _incs "${dir}")
        endif()
    endforeach()
    list(REMOVE_DUPLICATES _incs)

    # Create an interface target for includes and export a variable
    if(_incs)
        add_library(${FETCHDEP_NAME}__inc INTERFACE)
        target_include_directories(${FETCHDEP_NAME}__inc INTERFACE ${_incs})
        add_library(${FETCHDEP_NAME}::inc ALIAS ${FETCHDEP_NAME}__inc)

        set(${FETCHDEP_NAME}_INCLUDE_DIRS "${_incs}" PARENT_SCOPE)
        message(STATUS "[add_dep] ${FETCHDEP_NAME} include dirs: ${_incs}")
    else()
        message(WARNING "[add_dep] No include directories found for ${FETCHDEP_NAME} in ${_base}.")
        set(${FETCHDEP_NAME}_INCLUDE_DIRS "" PARENT_SCOPE)
    endif()
endfunction()

