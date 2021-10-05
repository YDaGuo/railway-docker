FROM ubuntu

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq software-properties-common \
    && add-apt-repository ppa:no1wantdthisname/ppa && apt-get update && apt-get -y upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq nginx build-essential \
    language-pack-zh-hans-base xvfb x11vnc xterm megatools \
    fonts-droid-fallback fonts-wqy-microhei fluxbox blackbox firefox firefox-locale-zh-hans firefox-geckodriver lxterminal \
    pcmanfm mousepad vim-nox emacs-nox aria2 python3-pip python3-dev python3-websockify python3-selenium openjfx libopenjfx-java \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone

RUN echo 'nginx &' >>/run.sh
RUN chmod +x /run.sh
EXPOSE 80
CMD  /run.sh
