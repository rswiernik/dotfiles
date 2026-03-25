#!/usr/bin/env zsh
# Usage: gwt <branch> | gwt close

gwt() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: gwt <branch> | gwt close"
    echo "\nAvailable worktrees:"
    git worktree list 2>/dev/null || echo "  (not inside a git repository)"
    return 1
  fi

  if [[ "$1" == "close" ]]; then
    local dir branch git_common_dir git_dir main_repo
    dir="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "Error: not a git repo" >&2; return 1; }
    git_common_dir="$(git rev-parse --git-common-dir)"
    git_dir="$(git rev-parse --git-dir)"
    [[ "$git_common_dir" == "$git_dir" ]] && { echo "Error: not inside a worktree" >&2; return 1; }
    branch="$(git branch --show-current)"
    main_repo="$(cd "$git_common_dir" && git rev-parse --show-toplevel 2>/dev/null)" || main_repo="$(dirname "$git_common_dir")"
    echo "Closing $dir (branch: $branch), returning to $main_repo"
    cd "$main_repo" || { echo "Error: could not cd to $main_repo" >&2; return 1; }
    git worktree remove "$dir" || { echo "Hint: use git worktree remove --force \"$dir\" for uncommitted changes"; return 1; }
    [[ -n "$branch" ]] && git branch -D "$branch"
    echo "Done. Now in: $(pwd)"
    return 0
  fi

  local raw="$1"
  local branch="$(echo "$raw" | sed 's/[^a-zA-Z0-9/_-]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')"
  [[ "$raw" != "$branch" ]] && echo "Scrubbed branch name: $raw -> $branch"

  git rev-parse --show-toplevel &>/dev/null || { echo "Error: not a git repo" >&2; return 1; }

  local existing
  existing="$(git worktree list --porcelain | awk -v b="refs/heads/$branch" '
    /^worktree / { p=substr($0,10) }
    $0 == "branch " b { print p; exit }
  ')"

  if [[ -n "$existing" ]]; then
    [[ "$PWD" == "$existing" ]] && { echo "Already here: $existing"; return 0; }
    echo "Switching to: $existing"
    cd "$existing"
    return 0
  fi

  local repo_root repo_name worktree_dir
  repo_root="$(git rev-parse --show-toplevel)"
  repo_name="$(basename "$repo_root")"
  worktree_dir="$HOME/tmp/worktrees/$repo_name/$(echo "$branch" | sed 's/\//-/g')"
  mkdir -p "$(dirname "$worktree_dir")"

  if git show-ref --verify --quiet "refs/heads/$branch" || git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    git worktree add "$worktree_dir" "$branch"
  else
    git worktree add -b "$branch" "$worktree_dir"
  fi

  echo "\nWorktree ready: $worktree_dir"
  cd "$worktree_dir"
}
