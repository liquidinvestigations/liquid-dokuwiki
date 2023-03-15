FROM bitnami/dokuwiki:0.20180422.202005011246-debian-10-r39

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
    https://github.com/liquidinvestigations/dokuwiki-highlight \
    272e672db204aec43f9072cd72f51d8f94622a6e
RUN /liquid/add-plugin.sh \
    virtualgroup \
    https://github.com/cosmocode/virtualgroup \
    fac6acf4b4db40ca28c3f4d4b8f0871049fe0df3
RUN /liquid/add-plugin.sh \
    sneakyindexfix \
    https://github.com/lisps/plugin-sneakyindexfix \
    595f2fc44c7c7bcb51ef95ecfc2d5f221d0df3d6
RUN /liquid/add-plugin.sh \
    indexmenu \
    https://github.com/samuelet/indexmenu \
    571dc33ef0e6357e536abf91c2eaceda8effd959
RUN /liquid/add-plugin.sh \
    dw2pdf \
    https://github.com/splitbrain/dokuwiki-plugin-dw2pdf \
    8e03ab9cf11d77ae76d1542cc6bd726e251c7859
RUN /liquid/add-plugin.sh \
    bookcreator \
    https://github.com/Klap-in/dokuwiki-plugin-bookcreator \
    c4839451d995400bfb595120ea040898f1979145

# if we ever need it...
#RUN /liquid/add-plugin.sh \
#    oauth \
#    https://github.com/cosmocode/dokuwiki-plugin-oauth \
#    8c4b6783010f9f47f9f5c076fb3fd9d5127d724d


RUN chown -R daemon: /liquid/plugins /liquid/tpl

EXPOSE 80
ENTRYPOINT ["/opt/bitnami/common/bin/tini", "--"]
CMD ["/liquid/entrypoint.sh"]
