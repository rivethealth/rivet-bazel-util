#!/bin/bash -e
RUNFILES_DIR="$0.runfiles"

cd "$BUILD_WORKSPACE_DIRECTORY"

function escape_pattern {
  <<< "$1" sed 's/[\/&]/\\&/g'
}

file_packages="$( \
    (find . -name BUILD -o -name BUILD.bazel) \
    | sed -e 's:/[^/]*$::' -e 's:^\./::' -e 's:^:@rivet_bazel_util_files//files/:' -e 's:/.$::' \
)"

packages="$(
    (echo "$file_packages") \
    | tr '\n' , \
    | sed 's/,$//' \
    | sort \
)"

sed -e "s/%{deleted_packages}/$(escape_pattern "$packages")/g" "$RUNFILES_DIR/rivet_bazel_util/tools/deleted.bazelrc.tpl" > tools/deleted.bazelrc
