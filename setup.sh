#!/usr/bin/env bash
git_server_url='github.com' 
repo='ikeautomata'
repo_owner='onnorom'

dir="$(dirname $(readlink -f $0))"

pushd $dir && git init 2>/dev/null
#git remote add origin git@${git_server_url}:${repo_owner}/${repo}.git 2>/dev/null
git remote add origin https://${git_server_url}/${repo_owner}/${repo}.git 2>/dev/null
/usr/local/bin/r10k puppetfile install --verbose

puppet apply ./site.pp 
