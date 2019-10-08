#!/bin/bash

if [ -n "$VNC_PASSWORD" ]; then
    echo -n "$VNC_PASSWORD" > /.password1
    x11vnc -storepasswd $(cat /.password1) /.password2
    chmod 400 /.password*
    sed -i 's/^command=x11vnc.*/& -rfbauth \/.password2/' /etc/supervisor/conf.d/supervisord.conf
    export VNC_PASSWORD=
fi

if [ -n "$X11VNC_ARGS" ]; then
    sed -i "s/^command=x11vnc.*/& ${X11VNC_ARGS}/" /etc/supervisor/conf.d/supervisord.conf
fi

if [ -n "$OPENBOX_ARGS" ]; then
    sed -i "s#^command=/usr/bin/openbox.*#& ${OPENBOX_ARGS}#" /etc/supervisor/conf.d/supervisord.conf
fi

if [ -n "$RESOLUTION" ]; then
    sed -i "s/1024x768/$RESOLUTION/" /usr/local/bin/xvfb.sh
fi

if [ -n "$DISPLAY_SCREEN_DEPTH" ]; then
    sed -i "s/x16/x$DISPLAY_SCREEN_DEPTH/" /usr/local/bin/xvfb.sh
fi

PASSWORD=designsafeubuntu1234!!
USER="ubuntu"
echo "$USER:$PASSWORD" | chpasswd
HOME=/home/$USER
cp -r /root/{.gtkrc-2.0,.asoundrc} ${HOME}
[ -d "/dev/snd" ] && chgrp -R adm /dev/snd
chown -R $USER:$USER $HOME/.[^.]*

# USER="ubuntu"
# GROUP="G-816877"
# PASSWORD=designsafeubuntu1234!!
# USER=${USER:-root}
# HOME=/root
# if [ "$USER" != "root" ]; then
#     echo "* enable custom user: $USER"
#     groupadd --gid 816877 G-816877
#     useradd --uid 458981 --create-home --shell /bin/bash --user-group --groups G-816877,adm,sudo $USER
#     usermod -g G-816877 ubuntu
#     if [ -z "$PASSWORD" ]; then
#         echo "  set default password to \"ubuntu\""
#         PASSWORD=ubuntu
#     fi
#     HOME=/home/$USER
#     echo "$USER:$PASSWORD" | chpasswd
#     cp -r /root/{.gtkrc-2.0,.asoundrc} ${HOME}
#     [ -d "/dev/snd" ] && chgrp -R adm /dev/snd
# fi
sed -i "s|%USER%|$USER|" /etc/supervisor/conf.d/supervisord.conf
sed -i "s|%HOME%|$HOME|" /etc/supervisor/conf.d/supervisord.conf

# home folder
# mkdir -p $HOME/.config/pcmanfm/LXDE/
# ln -sf /usr/local/share/doro-lxde-wallpapers/desktop-items-0.conf $HOME/.config/pcmanfm/LXDE/
# chown -R $USER:$USER $HOME

# home folder, exclude recursive chown of mydata, community, projects, published, and public data
# shopt -s extglob
# chown $USER:$GROUP $HOME
# cd $HOME
# echo `pwd`
# echo `ls -alGF`
# chown -R $USER:$GROUP !(mydata|public|community|projects|published)
# shopt -u extglob
# cd /root

# nginx workers
sed -i 's|worker_processes .*|worker_processes 1;|' /etc/nginx/nginx.conf

# nginx ssl
if [ -n "$SSL_PORT" ] && [ -e "/etc/nginx/ssl/nginx.key" ]; then
    echo "* enable SSL"
	sed -i 's|#_SSL_PORT_#\(.*\)443\(.*\)|\1'$SSL_PORT'\2|' /etc/nginx/sites-enabled/default
	sed -i 's|#_SSL_PORT_#||' /etc/nginx/sites-enabled/default
fi

# nginx http base authentication
if [ -n "$HTTP_PASSWORD" ]; then
    echo "* enable HTTP base authentication"
    htpasswd -bc /etc/nginx/.htpasswd $USER $HTTP_PASSWORD
	sed -i 's|#_HTTP_PASSWORD_#||' /etc/nginx/sites-enabled/default
fi

# novnc websockify
ln -s /usr/local/lib/web/frontend/static/websockify /usr/local/lib/web/frontend/static/novnc/utils/websockify
chmod +x /usr/local/lib/web/frontend/static/websockify/run

# clearup
PASSWORD=
HTTP_PASSWORD=

exec /bin/tini -- /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
