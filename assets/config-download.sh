cd /tmp

mkdir -p $HOME/.config/
mkdir -p $HOME/.local/bin/
mkdir -p $HOME/.local/share/applications/

git clone https://github.com/dumanshr/dotfiles.git
cd dotfiles
cp .bashrc $HOME/
rsync .local/ $HOME/.local/
rsync .config/ $HOME/.config/
chomd +x $HOME/.local/bin/*


touch $HOME/.local/share/applications/{assistant,avahi-discover,bssh,bvnc,designer,java-java-openjdk,jconsole-java-openjdk,jshell-java-openjdk,linguist,lstopo,nvim,org.gnome.Extensions,qdbusviewer,qv4l2,qvidcap,xdvi}.desktop
