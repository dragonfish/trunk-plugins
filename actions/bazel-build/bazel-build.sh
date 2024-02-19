#!/bin/bash

# Run bazel build
if bazel build //...; then
  echo "Bazel build successful"
  exit 0
else
  while true; do
    read -r -p "Bazel build failed. Do you want to continue? (yes/no): " response
    if [[ ${response} == "Yes" || ${response} == "yes" || ${response} == "Y" || ${response} == "y" ]]; then
      exit 0
    elif [[ ${response} == "No" || ${response} == "no" || ${response} == "N" || ${response} == "n" ]]; then
      exit 1
    else
      echo "Invalid input. Please enter 'yes' or 'no'."
    fi
  done
fi

# Check if MODULE.bazel.lock has been modified
diff=$(git diff --name-only)
if echo "${diff}" | grep -q "MODULE.bazel.lock"; then
  echo "MODULE.bazel.lock has been modified"
  read -r -p "Do you want to commit the file? (yes/no): " response
  if [[ ${response} == "Yes" || ${response} == "yes" || ${response} == "Y" || ${response} == "y" ]]; then
    git add MODULE.bazel.lock
    git commit -m "chore: Update MODULE.bazel.lock"
    echo "File committed successfully"
  else
    echo "File not committed"
  fi
else
  exit 0
fi
