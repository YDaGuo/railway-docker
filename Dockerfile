FROM ubuntu

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq software-properties-common wget \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && add-apt-repository ppa:no1wantdthisname/ppa && apt-get update && apt-get -y upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq nginx build-essential \
    language-pack-zh-hans-base xvfb x11vnc xterm megatools \
    fonts-droid-fallback fonts-wqy-microhei fluxbox wmctrl google-chrome-stable lxterminal \
    pcmanfm mousepad vim-nox emacs-nox aria2 python3-pip python3-dev python3-websockify \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone

RUN echo 'nginx &' >>/bootstrap.sh
RUN chmod 755 /bootstrap.sh
EXPOSE 80
CMD  /bootstrap.sh
