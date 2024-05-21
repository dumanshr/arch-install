mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/share/applications
mkdir -p $HOME/.config/autostart

touch $HOME/.local/share/applications/{assistant,avahi-discover,bssh,bvnc,designer,java-java-openjdk,jconsole-java-openjdk,jshell-java-openjdk,linguist,lstopo,nvim,org.gnome.Extensions,qdbusviewer,qv4l2,qvidcap,xdvi}.desktop




files=(.bashrc .local/bin/after-reboot.sh .config/autostart/firstconfig.desktop)
for file in ${files[@]}
do
	curl -o $HOME/"$file" https://raw.githubusercontent.com/dumanshr/arch-install/master/assets/regular_user/$file
done
