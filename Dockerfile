FROM bitnami/dokuwiki:0.20180422.201901061035

RUN set -e \
 && apt-get update -qq \
 && apt-get install  -qq -y --no-install-recommends \
    curl unzip

RUN mkdir -p /liquid/tpl
RUN cp -a /opt/bitnami/dokuwiki/lib/tpl/dokuwiki /liquid/tpl/liquid
ADD . /liquid

# Download and store the "addnewpage" plugin under /liquid/plugins
RUN /liquid/add-plugin.sh \
    addnewpage \
    https://github.com/samwilson/dokuwiki-plugin-addnewpage \
    9856122f05a5d8cedc363634e34b016249564f92
RUN /liquid/add-plugin.sh \
    color \
    https://github.com/hanche/dokuwiki_color_plugin \
    17447c465031f348031b9f86507026c91f23186b
RUN /liquid/add-plugin.sh \
    move \
    https://github.com/michitux/dokuwiki-plugin-move \
    5538001d5f14ef1001bf3412d2426f62e07ddf7f
RUN /liquid/add-plugin.sh \
    csv \
    https://github.com/cosmocode/csv \
    f12410b9a2d21895e308cab9aff30e789ed69582
RUN /liquid/add-plugin.sh \
    highlight \
    https://github.com/munduch/dokuwiki-highlight \
    ca744e0c6123fa73abf7f96bc8998173de04b6fa

RUN chown -R daemon: /liquid/plugins /liquid/tpl

EXPOSE 80
ENTRYPOINT ["/usr/local/bin/tini", "--"]
CMD ["/liquid/entrypoint.sh"]
