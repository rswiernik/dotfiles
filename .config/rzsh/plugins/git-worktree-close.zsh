#!/usr/bin/env zsh
# Source this file or add the function to your shell config.
# Usage: gwt-close

gwt-close() {
  local worktree_dir
  worktree_dir="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Error: not inside a git repository" >&2
    return 1
  }

  # Check that we're actually inside a worktree (not the main repo)
  local git_common_dir git_dir
  git_common_dir="$(git rev-parse --git-common-dir 2>/dev/null)"
  git_dir="$(git rev-parse --git-dir 2>/dev/null)"

  if [[ "$git_common_dir" == "$git_dir" ]]; then
    echo "Error: not inside a worktree (this is the main repository)" >&2
    return 1
  fi

  local branch
  branch="$(git branch --show-current)"

  # Resolve the main repo root from the common git dir
  local main_repo
  main_repo="$(cd "$git_common_dir" && git rev-parse --show-toplevel 2>/dev/null)" || {
    # git-common-dir is typically <main_repo>/.git — go up one level
    main_repo="$(dirname "$git_common_dir")"
  }

  echo "Closing worktree: $worktree_dir"
  echo "Branch: $branch"
  echo "Returning to: $main_repo"

  cd "$main_repo" || {
    echo "Error: could not cd to $main_repo" >&2
    return 1
  }

  git worktree remove "$worktree_dir" || {
    echo ""
    echo "Hint: if there are uncommitted changes, use: git worktree remove --force \"$worktree_dir\""
    return 1
  }

  if [[ -n "$branch" ]]; then
    echo "Deleting local branch: $branch"
    git branch -D "$branch"
  fi

  echo ""
  echo "Worktree closed. Now in: $(pwd)"
}
