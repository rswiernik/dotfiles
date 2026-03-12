#!/usr/bin/env zsh
# Source this file or add the function to your shell config.
# Usage: gwt-main

gwt-main() {
  # Find the main worktree directory (first line of `git worktree list`)
  local main_dir
  main_dir="$(git worktree list --porcelain 2>/dev/null | head -1 | sed 's/^worktree //')" || {
    echo "Error: not inside a git repository" >&2
    return 1
  }

  if [[ -z "$main_dir" ]]; then
    echo "Error: could not determine main worktree" >&2
    return 1
  fi

  if [[ "$PWD" == "$main_dir" ]]; then
    echo "Already in main worktree: $main_dir"
    return 0
  fi

  echo "Switching to main worktree: $main_dir"
  cd "$main_dir" || {
    echo "Error: could not cd to $main_dir" >&2
    return 1
  }
}
