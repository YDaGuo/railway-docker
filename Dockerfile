FROM ubuntu

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq software-properties-common wget git curl \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && add-apt-repository ppa:no1wantdthisname/ppa && apt-get update && apt-get -y upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq nginx build-essential \
    language-pack-zh-hans-base xvfb x11vnc xterm megatools \
    fonts-droid-fallback fonts-wqy-microhei fluxbox wmctrl firefox firefox-locale-zh-hans lxterminal \
    pcmanfm mousepad vim-nox emacs-nox aria2 python3-pip python3-dev python3-websockify \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone

# overwrite this env variable to use a different window manager
ENV LANG="zh_CN.UTF-8" 
ENV WINDOW_MANAGER="fluxbox"

# Install novnc
RUN git clone --depth 1 https://github.com/novnc/noVNC.git /opt/novnc \
 && git clone --depth 1 https://github.com/novnc/websockify /opt/novnc/utils/websockify \
 && curl -O -L https://raw.githubusercontent.com/gitpod-io/workspace-images/master/full-vnc/novnc-index.html \
 && curl -O -L https://raw.githubusercontent.com/gitpod-io/workspace-images/master/full-vnc/start-vnc-session.sh \
 && mv novnc-index.html /opt/novnc/index.html \
 && mv start-vnc-session.sh /usr/bin/ \
 && chmod +x /usr/bin/start-vnc-session.sh \
 && sed -ri "s/launch.sh/novnc_proxy/g" /usr/bin/start-vnc-session.sh \
 && sed -ri "s/1920x1080/1366x830/g" /usr/bin/start-vnc-session.sh \
 && sed -ri '/Automatically generated/a\   \[exec\] \(Xterm\) \{ x-terminal-emulator -T "Bash" -e /bin/bash --login\} \<\>' /etc/X11/fluxbox/fluxbox-menu \
 && sed -ri '/Automatically generated/a\   \[exec\] \(LXterm\) \{lxterminal\} \<\>' /etc/X11/fluxbox/fluxbox-menu \
 && sed -ri '/Automatically generated/a\   \[exec\] \(Filemanager\) \{pcmanfm\} \<\>' /etc/X11/fluxbox/fluxbox-menu \
 && sed -ri '/Automatically generated/a\   \[exec\] \(Mousepad\) \{mousepad\} \<\>' /etc/X11/fluxbox/fluxbox-menu \
 && sed -ri '/Automatically generated/a\   \[exec\] \(Firefox\) \{firefox\} \<\>' /etc/X11/fluxbox/fluxbox-menu 
 
RUN echo 'export DISPLAY=:0' >>/bootstrap.sh \
  && echo 'start-vnc-session.sh &' >>/bootstrap.sh \
  && echo 'sed -ri "s/80 default_server/$PORT default_server/g" /etc/nginx/sites-enabled/default' >>/bootstrap.sh \
  && echo 'cat /etc/nginx/sites-enabled/default' >>/bootstrap.sh \
  && echo 'nginx -t' >>/bootstrap.sh \
  && echo 'nginx -g "daemon on; master_process on;" &' >>/bootstrap.sh \
  && echo 'curl http://localhost:$PORT' >>/bootstrap.sh \
  && echo 'ps -aux' >>/bootstrap.sh \
  && chmod +x /bootstrap.sh
  
EXPOSE 8088  
  
CMD  /bootstrap.sh
