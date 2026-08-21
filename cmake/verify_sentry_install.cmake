# Verify that sentry-native installed the crash handler binaries.
#
# The crashpad backend is useless without crashpad_handler, and fast-fail /
# stack-buffer-overrun crashes are missed without crashpad_wer.dll next to it.
# Neither omission produces any error at runtime, so check at build time.

set(_required
  "${SENTRY_BIN_DIR}/crashpad_handler${CMAKE_EXECUTABLE_SUFFIX}"
  "${SENTRY_BIN_DIR}/crashpad_wer.dll"
)

if(NOT WIN32)
  list(REMOVE_ITEM _required "${SENTRY_BIN_DIR}/crashpad_wer.dll")
endif()

set(_missing "")
foreach(_file ${_required})
  if(NOT EXISTS "${_file}")
    list(APPEND _missing "${_file}")
  endif()
endforeach()

if(_missing)
  string(REPLACE ";" "\n  " _missing_list "${_missing}")
  message(FATAL_ERROR
    "sentry-native did not install its crash handler binaries:\n"
    "  ${_missing_list}\n"
    "Crash reporting would silently do nothing. Check whether the "
    "sentry-native install rules changed in this version.")
endif()

message(STATUS "sentry-native crash handler binaries verified in ${SENTRY_BIN_DIR}")
