# Dotfiles

# clone
```bash
cd ~
git clone https://github.com/kaixili/dotfiles ~/.dotfiles
cd ~/.dotfiles
git submodule init
cd ~

# install vim plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# link
ln -s .dotfiles/zsh/zshrc .zshrc
ln -s .dotfiles/vim/vimrc .vimrc
ln -s .dotfiles/tmux/tmux.conf .tmux.conf
ln -s .dotfiles/tmux/tmux.conf.local .tmux.conf.local
```

# font
- fira-code

# life-saving termial software
- tmux
- ydcv
- fzf

# screen
![vim](vim.png)
![zsh](zsh.png)
