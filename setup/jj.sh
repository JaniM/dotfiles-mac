#!/usr/bin/env zsh

set -euxo pipefail

jj config set --user user.name "Jani Mustonen"

jj config set --user ui.paginate "never"
jj config set --user ui.default-command log

jj config set --user revsets.log \
  '@ | trunk() | ancestors(branches(), 2) | (ancestors(immutable_heads().., 2) ~ ::(remote_branches() ~ branches()))'

# Finds branches being worked on by x
jj config set --user revset-aliases."work(x)" \
  'immutable_heads()..((immutable_heads().. & (author(x) | committer(x)))::)'

