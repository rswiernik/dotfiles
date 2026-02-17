#!/usr/bin/env bash
# Source this file or add the function to your shell config.
# Usage: gwt <branch>

gwt() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: gwt <branch>"
    echo ""
    echo "Creates a git worktree at ~/tmp/worktrees/{repo_name}/{branch}"
    echo "Automatically creates a new branch if it doesn't already exist."
    return 1
  fi

raw="$1"
branch="$(echo "$raw" | sed 's/[^a-zA-Z0-9/_-]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')"

if [[ "$raw" != "$branch" ]]; then
  echo "Scrubbed branch name: $raw -> $branch"
fi

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "Error: not inside a git repository" >&2
  return 1
}

repo_name="$(basename "$repo_root")"
worktree_name="$(echo "$branch" | sed 's/\//-/g')"
worktree_dir="$HOME/tmp/worktrees/$repo_name/$worktree_name"

if [[ -d "$worktree_dir" ]]; then
  echo "Worktree already exists at $worktree_dir"
  return 1
fi

mkdir -p "$(dirname "$worktree_dir")"

if git show-ref --verify --quiet "refs/heads/$branch" || git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
  git worktree add "$worktree_dir" "$branch"
else
  git worktree add -b "$branch" "$worktree_dir"
fi

echo ""
echo "Worktree ready: $worktree_dir"
cd "$worktree_dir"
}
