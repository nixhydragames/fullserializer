#!/bin/bash

# Compiles Full Serializer into the current directory. This includes:
#  - runtime/editor DLL files
#  - XML docs
#  - mdb debugging information

# This script can be directly run
#
# $ ./compile.sh
#
# Make sure the script is marked executable:
#
# $ chmod +x compile-editor.sh

# This script can be customized when calling it. For example, to use a local C#
# compiler instead of the one Unity ships with, the script can be called like:
#
#   mcs_path=mcs ./compile-editor.sh

unity_folder=/Applications/Unity2018.3.12
unity_path=${unity_root:-$unity_folder"/Unity.app/Contents"}
mcs_path=${mcs_path:-"$unity_path/MonoBleedingEdge/bin/mcs"}

dll_output_path=${dll_file:-"FullSerializerEditor.dll"}
doc_output_path=${doc_file:-"FullSerializerEditor.xml"}

# script_dir is the path to the directory containing this script file.
script_dir="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
source_dir=${source_dir:-"$script_dir/../Assets/FullSerializer/Source/Aot/Editor"}
input_files=$(find $source_dir -name \*.cs)

echo "unity_path: '$unity_path'"
echo "mcs_path (C# compiler): '$mcs_path'"
echo "source_dir: '$source_dir'"
echo "Compiling DLLs (output_dll_file: $dll_output_path,"\
                     "output_doc_file: $doc_output_path)"

# TODO: Remove warning suppressions (all of them are for missing XML docs)
$mcs_path \
  /lib:$unity_path/Managed \
  /reference:UnityEngine.dll \
  /reference:UnityEditor.dll \
  /reference:FullSerializer.dll \
  /target:library /debug /sdk:2 \
  /nowarn:1570 \
  /nowarn:1572 \
  /nowarn:1573 \
  /nowarn:1587 \
  /nowarn:1591 \
  /out:$dll_output_path /doc:$doc_output_path \
  $input_files
