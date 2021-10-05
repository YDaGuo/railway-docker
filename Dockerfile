FROM ubuntu

RUN add-apt-repository ppa:no1wantdthisname/ppa && apt-get update && apt-get -y upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq nginx \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone

RUN echo 'nginx &' >>/run.sh
RUN chmod +x /run.sh
EXPOSE 80
CMD  /run.sh
