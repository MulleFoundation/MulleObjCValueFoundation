# cmake/_Dependencies.cmake is generated by `mulle-sde`. Edits will be lost.
#
if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

if( NOT MULLE_OBJC_LIBRARY)
   find_library( MULLE_OBJC_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}MulleObjC${CMAKE_STATIC_LIBRARY_SUFFIX} MulleObjC)
   message( STATUS "MULLE_OBJC_LIBRARY is ${MULLE_OBJC_LIBRARY}")

   # the order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need
   if( MULLE_OBJC_LIBRARY)
      set( ALL_LOAD_DEPENDENCY_LIBRARIES
         ${ALL_LOAD_DEPENDENCY_LIBRARIES}
         ${MULLE_OBJC_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_OBJC_ROOT "${MULLE_OBJC_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_OBJC_ROOT "${_TMP_MULLE_OBJC_ROOT}" DIRECTORY)

      # search for DependenciesAndLibraries.cmake to include
      foreach( _TMP_MULLE_OBJC_NAME "MulleObjC")
         set( _TMP_MULLE_OBJC_DIR "${_TMP_MULLE_OBJC_ROOT}/include/${_TMP_MULLE_OBJC_NAME}/cmake")
         # use explicit path to avoid "surprises"
         message( STATUS "_TMP_MULLE_OBJC_DIR is ${_TMP_MULLE_OBJC_DIR}")
         if( EXISTS "${_TMP_MULLE_OBJC_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_OBJC_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_OBJC_DIR}")
            # we only want top level INHERIT_OBJC_LOADERS, so disable them
            if( NOT NO_INHERIT_OBJC_LOADERS)
               set( NO_INHERIT_OBJC_LOADERS OFF)
            endif()
            list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
            set( NO_INHERIT_OBJC_LOADERS ON)
            #
            include( "${_TMP_MULLE_OBJC_DIR}/DependenciesAndLibraries.cmake")
            #
            list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
            list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_OBJC_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_OBJC_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_OBJC_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()

      # search for objc-loader.inc in include directory
      # this can be turned  off (see above)
      if( NOT NO_INHERIT_OBJC_LOADERS)
         foreach( _TMP_MULLE_OBJC_NAME "MulleObjC")
            set( _TMP_MULLE_OBJC_FILE "${_TMP_MULLE_OBJC_ROOT}/include/${_TMP_MULLE_OBJC_NAME}/objc-loader.inc")
            if( EXISTS "${_TMP_MULLE_OBJC_FILE}")
               set( INHERITED_OBJC_LOADERS
                  ${INHERITED_OBJC_LOADERS}
                  ${_TMP_MULLE_OBJC_FILE}
                  CACHE INTERNAL "need to cache this"
               )
               break()
            endif()
         endforeach()
      endif()
   else()
      message( FATAL_ERROR "MULLE_OBJC_LIBRARY was not found")
   endif()
endif()


if( NOT MULLE_BUFFER_LIBRARY)
   find_library( MULLE_BUFFER_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-buffer${CMAKE_STATIC_LIBRARY_SUFFIX} mulle-buffer)
   message( STATUS "MULLE_BUFFER_LIBRARY is ${MULLE_BUFFER_LIBRARY}")

   # the order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need
   if( MULLE_BUFFER_LIBRARY)
      set( DEPENDENCY_LIBRARIES
         ${DEPENDENCY_LIBRARIES}
         ${MULLE_BUFFER_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_BUFFER_ROOT "${MULLE_BUFFER_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_BUFFER_ROOT "${_TMP_MULLE_BUFFER_ROOT}" DIRECTORY)

      # search for DependenciesAndLibraries.cmake to include
      foreach( _TMP_MULLE_BUFFER_NAME "mulle-buffer")
         set( _TMP_MULLE_BUFFER_DIR "${_TMP_MULLE_BUFFER_ROOT}/include/${_TMP_MULLE_BUFFER_NAME}/cmake")
         # use explicit path to avoid "surprises"
         message( STATUS "_TMP_MULLE_BUFFER_DIR is ${_TMP_MULLE_BUFFER_DIR}")
         if( EXISTS "${_TMP_MULLE_BUFFER_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_BUFFER_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_BUFFER_DIR}")
            # we only want top level INHERIT_OBJC_LOADERS, so disable them
            if( NOT NO_INHERIT_OBJC_LOADERS)
               set( NO_INHERIT_OBJC_LOADERS OFF)
            endif()
            list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
            set( NO_INHERIT_OBJC_LOADERS ON)
            #
            include( "${_TMP_MULLE_BUFFER_DIR}/DependenciesAndLibraries.cmake")
            #
            list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
            list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_BUFFER_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_BUFFER_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_BUFFER_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
   else()
      message( FATAL_ERROR "MULLE_BUFFER_LIBRARY was not found")
   endif()
endif()


if( NOT MULLE_CONTAINER_LIBRARY)
   find_library( MULLE_CONTAINER_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-container${CMAKE_STATIC_LIBRARY_SUFFIX} mulle-container)
   message( STATUS "MULLE_CONTAINER_LIBRARY is ${MULLE_CONTAINER_LIBRARY}")

   # the order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need
   if( MULLE_CONTAINER_LIBRARY)
      set( DEPENDENCY_LIBRARIES
         ${DEPENDENCY_LIBRARIES}
         ${MULLE_CONTAINER_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_CONTAINER_ROOT "${MULLE_CONTAINER_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_CONTAINER_ROOT "${_TMP_MULLE_CONTAINER_ROOT}" DIRECTORY)

      # search for DependenciesAndLibraries.cmake to include
      foreach( _TMP_MULLE_CONTAINER_NAME "mulle-container")
         set( _TMP_MULLE_CONTAINER_DIR "${_TMP_MULLE_CONTAINER_ROOT}/include/${_TMP_MULLE_CONTAINER_NAME}/cmake")
         # use explicit path to avoid "surprises"
         message( STATUS "_TMP_MULLE_CONTAINER_DIR is ${_TMP_MULLE_CONTAINER_DIR}")
         if( EXISTS "${_TMP_MULLE_CONTAINER_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_CONTAINER_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_CONTAINER_DIR}")
            # we only want top level INHERIT_OBJC_LOADERS, so disable them
            if( NOT NO_INHERIT_OBJC_LOADERS)
               set( NO_INHERIT_OBJC_LOADERS OFF)
            endif()
            list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
            set( NO_INHERIT_OBJC_LOADERS ON)
            #
            include( "${_TMP_MULLE_CONTAINER_DIR}/DependenciesAndLibraries.cmake")
            #
            list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
            list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_CONTAINER_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_CONTAINER_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_CONTAINER_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
   else()
      message( FATAL_ERROR "MULLE_CONTAINER_LIBRARY was not found")
   endif()
endif()


if( NOT MULLE_UTF_LIBRARY)
   find_library( MULLE_UTF_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-utf${CMAKE_STATIC_LIBRARY_SUFFIX} mulle-utf)
   message( STATUS "MULLE_UTF_LIBRARY is ${MULLE_UTF_LIBRARY}")

   # the order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need
   if( MULLE_UTF_LIBRARY)
      set( DEPENDENCY_LIBRARIES
         ${DEPENDENCY_LIBRARIES}
         ${MULLE_UTF_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_UTF_ROOT "${MULLE_UTF_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_UTF_ROOT "${_TMP_MULLE_UTF_ROOT}" DIRECTORY)

      # search for DependenciesAndLibraries.cmake to include
      foreach( _TMP_MULLE_UTF_NAME "mulle-utf")
         set( _TMP_MULLE_UTF_DIR "${_TMP_MULLE_UTF_ROOT}/include/${_TMP_MULLE_UTF_NAME}/cmake")
         # use explicit path to avoid "surprises"
         message( STATUS "_TMP_MULLE_UTF_DIR is ${_TMP_MULLE_UTF_DIR}")
         if( EXISTS "${_TMP_MULLE_UTF_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_UTF_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_UTF_DIR}")
            # we only want top level INHERIT_OBJC_LOADERS, so disable them
            if( NOT NO_INHERIT_OBJC_LOADERS)
               set( NO_INHERIT_OBJC_LOADERS OFF)
            endif()
            list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
            set( NO_INHERIT_OBJC_LOADERS ON)
            #
            include( "${_TMP_MULLE_UTF_DIR}/DependenciesAndLibraries.cmake")
            #
            list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
            list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_UTF_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_UTF_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_UTF_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
   else()
      message( FATAL_ERROR "MULLE_UTF_LIBRARY was not found")
   endif()
endif()


if( NOT MULLE_VARARG_LIBRARY)
   find_library( MULLE_VARARG_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-vararg${CMAKE_STATIC_LIBRARY_SUFFIX} mulle-vararg)
   message( STATUS "MULLE_VARARG_LIBRARY is ${MULLE_VARARG_LIBRARY}")

   # the order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need
   if( MULLE_VARARG_LIBRARY)
      set( DEPENDENCY_LIBRARIES
         ${DEPENDENCY_LIBRARIES}
         ${MULLE_VARARG_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_VARARG_ROOT "${MULLE_VARARG_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_VARARG_ROOT "${_TMP_MULLE_VARARG_ROOT}" DIRECTORY)

      # search for DependenciesAndLibraries.cmake to include
      foreach( _TMP_MULLE_VARARG_NAME "mulle-vararg")
         set( _TMP_MULLE_VARARG_DIR "${_TMP_MULLE_VARARG_ROOT}/include/${_TMP_MULLE_VARARG_NAME}/cmake")
         # use explicit path to avoid "surprises"
         message( STATUS "_TMP_MULLE_VARARG_DIR is ${_TMP_MULLE_VARARG_DIR}")
         if( EXISTS "${_TMP_MULLE_VARARG_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_VARARG_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_VARARG_DIR}")
            # we only want top level INHERIT_OBJC_LOADERS, so disable them
            if( NOT NO_INHERIT_OBJC_LOADERS)
               set( NO_INHERIT_OBJC_LOADERS OFF)
            endif()
            list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
            set( NO_INHERIT_OBJC_LOADERS ON)
            #
            include( "${_TMP_MULLE_VARARG_DIR}/DependenciesAndLibraries.cmake")
            #
            list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
            list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_VARARG_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_VARARG_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_VARARG_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
   else()
      message( FATAL_ERROR "MULLE_VARARG_LIBRARY was not found")
   endif()
endif()


if( NOT MULLE_SPRINTF_LIBRARY)
   find_library( MULLE_SPRINTF_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-sprintf${CMAKE_STATIC_LIBRARY_SUFFIX} mulle-sprintf)
   message( STATUS "MULLE_SPRINTF_LIBRARY is ${MULLE_SPRINTF_LIBRARY}")

   # the order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need
   if( MULLE_SPRINTF_LIBRARY)
      set( ALL_LOAD_DEPENDENCY_LIBRARIES
         ${ALL_LOAD_DEPENDENCY_LIBRARIES}
         ${MULLE_SPRINTF_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_SPRINTF_ROOT "${MULLE_SPRINTF_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_SPRINTF_ROOT "${_TMP_MULLE_SPRINTF_ROOT}" DIRECTORY)

      # search for DependenciesAndLibraries.cmake to include
      foreach( _TMP_MULLE_SPRINTF_NAME "mulle-sprintf")
         set( _TMP_MULLE_SPRINTF_DIR "${_TMP_MULLE_SPRINTF_ROOT}/include/${_TMP_MULLE_SPRINTF_NAME}/cmake")
         # use explicit path to avoid "surprises"
         message( STATUS "_TMP_MULLE_SPRINTF_DIR is ${_TMP_MULLE_SPRINTF_DIR}")
         if( EXISTS "${_TMP_MULLE_SPRINTF_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_SPRINTF_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_SPRINTF_DIR}")
            # we only want top level INHERIT_OBJC_LOADERS, so disable them
            if( NOT NO_INHERIT_OBJC_LOADERS)
               set( NO_INHERIT_OBJC_LOADERS OFF)
            endif()
            list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
            set( NO_INHERIT_OBJC_LOADERS ON)
            #
            include( "${_TMP_MULLE_SPRINTF_DIR}/DependenciesAndLibraries.cmake")
            #
            list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
            list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_SPRINTF_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_SPRINTF_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_SPRINTF_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()

      # search for objc-loader.inc in include directory
      # this can be turned  off (see above)
      if( NOT NO_INHERIT_OBJC_LOADERS)
         foreach( _TMP_MULLE_SPRINTF_NAME "mulle-sprintf")
            set( _TMP_MULLE_SPRINTF_FILE "${_TMP_MULLE_SPRINTF_ROOT}/include/${_TMP_MULLE_SPRINTF_NAME}/objc-loader.inc")
            if( EXISTS "${_TMP_MULLE_SPRINTF_FILE}")
               set( INHERITED_OBJC_LOADERS
                  ${INHERITED_OBJC_LOADERS}
                  ${_TMP_MULLE_SPRINTF_FILE}
                  CACHE INTERNAL "need to cache this"
               )
               break()
            endif()
         endforeach()
      endif()
   else()
      message( FATAL_ERROR "MULLE_SPRINTF_LIBRARY was not found")
   endif()
endif()
