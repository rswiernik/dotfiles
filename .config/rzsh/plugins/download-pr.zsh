#!/usr/bin/env zsh
# Usage: download_pr [--no-worktree] <pr_id>

download_pr() {
  local remote="${REMOTE:-origin}"
  local no_worktree=0
  local pr_id=""

  for arg in "$@"; do
    case "$arg" in
      --no-worktree) no_worktree=1 ;;
      *) pr_id="$arg" ;;
    esac
  done

  if [[ -z "$pr_id" ]]; then
    echo "Usage: download_pr [--no-worktree] <pr_id>"
    return 1
  fi

  git rev-parse --show-toplevel &>/dev/null || { echo "Error: not a git repo" >&2; return 1; }
  [[ -n "$(git remote | grep "$remote")" ]] || { echo "Error: remote '$remote' not found" >&2; return 1; }

  local branch="PR-${pr_id}"

  echo "Fetching Pull Request: ${pr_id}"
  git fetch "$remote" "pull/${pr_id}/head:${branch}" || return 1

  if [[ $no_worktree -eq 1 ]]; then
    echo "Checking out branch: ${branch}"
    git checkout "$branch"
    return $?
  fi

  local repo_root repo_name worktree_dir
  repo_root="$(git rev-parse --show-toplevel)"
  repo_name="$(basename "$repo_root")"
  worktree_dir="$HOME/tmp/worktrees/$repo_name/${branch}"
  mkdir -p "$(dirname "$worktree_dir")"

  echo "Creating worktree at: ${worktree_dir}"
  git worktree add "$worktree_dir" "$branch" || return 1

  echo "\nWorktree ready: $worktree_dir"
  cd "$worktree_dir"
}
