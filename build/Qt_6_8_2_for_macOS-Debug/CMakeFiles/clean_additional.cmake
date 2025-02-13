# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/Crosswords_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/Crosswords_autogen.dir/ParseCache.txt"
  "CrosswordsGame/CMakeFiles/CrosswordsGame_autogen.dir/AutogenUsed.txt"
  "CrosswordsGame/CMakeFiles/CrosswordsGame_autogen.dir/ParseCache.txt"
  "CrosswordsGame/CMakeFiles/CrosswordsGameplugin_autogen.dir/AutogenUsed.txt"
  "CrosswordsGame/CMakeFiles/CrosswordsGameplugin_autogen.dir/ParseCache.txt"
  "CrosswordsGame/CrosswordsGame_autogen"
  "CrosswordsGame/CrosswordsGameplugin_autogen"
  "Crosswords_autogen"
  "Native/CMakeFiles/Native_autogen.dir/AutogenUsed.txt"
  "Native/CMakeFiles/Native_autogen.dir/ParseCache.txt"
  "Native/CMakeFiles/Nativeplugin_autogen.dir/AutogenUsed.txt"
  "Native/CMakeFiles/Nativeplugin_autogen.dir/ParseCache.txt"
  "Native/Native_autogen"
  "Native/Nativeplugin_autogen"
  )
endif()
