#!/usr/bin/env python3
import os
import sys
import re
from subprocess import check_output, CalledProcessError
from typing import List


_zsh_colors = {
    'black': '30',
    'red': '31',
    'green': '32',
    'yellow': '33',
    'blue': '34',
    'magenta': '35',
    'cyan': '36',
    'white': '37',
}


def zsh_color(color: str) -> str:
    return '\x1b[{}m'.format(_zsh_colors[color])


def color(thing: str, color: str = 'white') -> str:
    return '{}{}{}'.format(
        zsh_color(color),
        thing,
        zsh_color('white')
    )


def get_tagname_or_hash():
    """return tagname if exists else hash"""
    cmd = ['git', 'log', '-1', '--format="%h%d"']
    output = check_output(cmd).decode('utf-8').strip()
    hash_, tagname = None, None
    # get hash
    m = re.search('\(.*\)$', output)
    if m:
        hash_ = output[:m.start()-1]
    # get tagname
    m = re.search('tag: .*[,\)]', output)
    if m:
        tagname = 'tags/' + output[m.start()+len('tag: '): m.end()-1]

    if tagname:
        return tagname
    elif hash_:
        return hash_
    return None


class GitStatus(object):
    branch: str = "Unknown"
    ahead: int = 0
    behind: int = 0
    staged: List[str] = list()
    conflicts: List[str] = list()
    changed: List[str] = list()
    untracked: List[str] = list()


def parse_git_status_porcelain(status: str) -> GitStatus:
    git_status = GitStatus()
    for line in status.splitlines():
        if line.startswith('##'):
            if re.search('Initial commit on', line[2]):
                git_status.branch = line[2].split(' ')[-1]
            elif re.search('no branch', line[2]):  # detached status
                git_status.branch = get_tagname_or_hash()
            elif len(line[2:].strip().split('...')) == 1:
                git_status.branch = line[2:].strip()
            else:
                # TODO: FIGURE OUT WHAT THIS BRANCH DOES
                # current and remote branch info
                git_status.branch, rest = line[2:].strip().split('...')
                if len(rest.split(' ')) == 1:
                    # remote_branch = rest.split(' ')[0]
                    pass
                else:
                    # ahead or behind
                    divergence = ' '.join(rest.split(' ')[1:])
                    divergence = divergence.lstrip('[').rstrip(']')
                    for div in divergence.split(', '):
                        if 'ahead' in div:
                            git_status.ahead += int(div[len('ahead '):].strip())
                        elif 'behind' in div:
                            git_status.behind += int(div[len('behind '):].strip())
        elif line[0] == '?' and line[1] == '?':
            git_status.untracked.append(line)
        else:
            if line[1] == 'M':
                git_status.changed.append(line)
            if line[0] == 'U':
                git_status.conflicts.append(line)
            elif line[0] != ' ':
                git_status.staged.append(line)
    return git_status


def _empty_temp(template: str, thing: int):
    return template.format(thing) if thing else ""


def get_rprompt(status: GitStatus) -> str:
    rprompt_template = "({branch_info}|{commit_info})"
    branch_template = "{branch}{behind}{ahead}"
    info_template = "{staged}{conflicts}{changed}{untracked}"
    branch = branch_template.format(
        branch=color(status.branch, color='magenta'),
        behind=_empty_temp("↓{}", status.behind),
        ahead=_empty_temp("↑{}", status.ahead)
    )
    info = info_template.format(
        staged=_empty_temp(
            color("●{}", 'red'),
            len(status.staged)),
        conflicts=_empty_temp(
            color("✖{}", 'red'),
            len(status.conflicts)),
        changed=_empty_temp(
            color("+{}", 'yellow'),
            len(status.changed)),
        untracked="…" if len(status.untracked) else "",
    )
    clean = color("✔", color='green')
    return rprompt_template.format(
        branch_info=branch,
        commit_info=info or clean
    )


def escape(rprompt: str) -> str:
    """
    ZSH requires that all string literals not intended to move the cursor be wrapped in %{ and %}

    http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Visual-effects
    """
    return re.sub(
        r'([\x1b]\[\d\dm)',
        r'%{\1%}',
        rprompt
    )


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("No path provided!\nUsage:\n{filename} <path>".format(filename=__file__))
        exit(1)

    os.chdir(sys.argv[1])

    try:
        status = check_output(['git', 'status', '--porcelain', '--branch'])
    except CalledProcessError as e:
        # 128 means we're not in a git repo, that's fine for us
        if e.returncode == 128:
            exit(0)
        else:
            print("Failed to get git branch status!")
            raise

    git_status = parse_git_status_porcelain(
        status.decode('utf-8').strip()
    )

    rprompt = get_rprompt(git_status)

    if '--zsh-escape' in sys.argv:
        escaped_prompt = escape(rprompt)
        print(escaped_prompt, end='')
    else:
        print(rprompt, end='')
