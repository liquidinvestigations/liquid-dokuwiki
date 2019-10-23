FROM bitnami/dokuwiki:0.20180422.201901061035

RUN set -e \
 && apt-get update -qq \
 && apt-get install  -qq -y --no-install-recommends \
    curl unzip

WORKDIR /bitnami/dokuwiki

ADD . /liquid

RUN curl -L https://github.com/samwilson/dokuwiki-plugin-addnewpage/archive/9856122f05a5d8cedc363634e34b016249564f92.zip -o /tmp/addnewpage.zip \
 && unzip /tmp/addnewpage.zip -d /tmp/addnewpage \
 && mv /tmp/addnewpage/dokuwiki-plugin-addnewpage-9856122f05a5d8cedc363634e34b016249564f92 /liquid/plugins/addnewpage \
 && rm -rf /tmp/addnewpage.zip /tmp/addnewpage

EXPOSE 80
VOLUME /bitnami
ENTRYPOINT [ "/liquid/entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
