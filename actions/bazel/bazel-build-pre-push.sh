#!/bin/bash

# Run bazel build
if bazel build //...; then
  echo "Bazel build successful"
  exit 0
else
  echo "Bazel build failed. Do you want to continue? (yes/no): "
  read -r response

  while ! [[ ${response} =~ ^(yes|y|Yes|no|n|No)$ ]]; do
    echo "Invalid input. Please enter 'yes' or 'no'."
  done

  if [[ ${response} =~ ^(yes|y|Yes)$ ]]; then
    exit 0
  elif [[ ${response} =~ ^(no|n|No)$ ]]; then
    exit 1
  fi
fi

# Check if MODULE.bazel.lock has been modified
diff=$(git diff --name-only)
if echo "${diff}" | grep -q "MODULE.bazel.lock"; then
  echo "MODULE.bazel.lock has been modified"
  read -r -p "Do you want to commit the file? (yes/no): " response
  if [[ ${response} =~ ^(yes|y|Yes)$ ]]; then
    git add MODULE.bazel.lock
    git commit -m "chore: Update MODULE.bazel.lock"
    echo "File committed successfully"
  else
    echo "File not committed"
  fi
else
  exit 0
fi
