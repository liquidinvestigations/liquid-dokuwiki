FROM bitnami/dokuwiki:0.20180422.201901061035

RUN set -e \
 && apt-get update -qq \
 && apt-get install  -qq -y --no-install-recommends \
    curl unzip

RUN mkdir -p /liquid/tpl
RUN cp -a /opt/bitnami/dokuwiki/lib/tpl/dokuwiki /liquid/tpl/liquid
ADD . /liquid

# Download and store the "addnewpage" plugin under /liquid/plugins
RUN curl -L https://github.com/samwilson/dokuwiki-plugin-addnewpage/archive/9856122f05a5d8cedc363634e34b016249564f92.zip -o /tmp/addnewpage.zip \
 && unzip /tmp/addnewpage.zip -d /tmp/addnewpage \
 && mv /tmp/addnewpage/dokuwiki-plugin-addnewpage-9856122f05a5d8cedc363634e34b016249564f92 /liquid/plugins/addnewpage \
 && rm -rf /tmp/addnewpage.zip /tmp/addnewpage

RUN chown -R daemon: /liquid/plugins /liquid/tpl

EXPOSE 80
ENTRYPOINT ["/usr/local/bin/tini", "--"]
CMD ["/liquid/entrypoint.sh"]
