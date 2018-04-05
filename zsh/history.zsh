
SAVEHIST=10000
HIST_STAMPS="mm/dd"
HISTFILE=~/.histfile

# 不保留重复的历史记录项
setopt hist_ignore_all_dups
# 时间戳
setopt EXTENDED_HISTORY
# 在命令前添加空格，不将此命令添加到记录文件中
#setopt hist_ignore_space
# zsh 4.3.6 doesn't have this option
setopt hist_fcntl_lock 2>/dev/null
setopt hist_reduce_blanks
# 共享历史记录
setopt SHARE_HISTORY
# 启用 cd 命令的历史纪录，cd -[TAB]进入历史路径
setopt AUTO_PUSHD
# 相同的历史路径只保留一个
setopt PUSHD_IGNORE_DUPS
# 允许交互界面注释
setopt INTERACTIVE_COMMENTS

