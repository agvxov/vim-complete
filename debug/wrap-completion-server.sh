#!/bin/sh
#FILE=/home/anon/stow/vim/.vim/plugin/HiTags/vim.tags
FILE=test.tags

bash -c './completion-server.py $$ '$FILE
