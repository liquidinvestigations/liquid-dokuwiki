FROM bitnami/dokuwiki:20220731.1.0-debian-11-r60

USER root

RUN set -e \
 && apt-get update  \
 && apt-get install  -y  \
    curl unzip tini

RUN mkdir -p /liquid/tpl
RUN cp -a /opt/bitnami/dokuwiki/lib/tpl/dokuwiki /liquid/tpl/liquid
ADD . /liquid

# Download and store the "addnewpage" plugin under /liquid/plugins
RUN /liquid/add-plugin.sh \
    addnewpage \
    https://github.com/samwilson/dokuwiki-plugin-addnewpage \
    9856122f05a5d8cedc363634e34b016249564f92  # 2016
RUN /liquid/add-plugin.sh \
    color \
    https://github.com/hanche/dokuwiki_color_plugin \
    e28b337ddad77b04831d98c0ce71d3d546c7240f  # 2022-10-19
RUN /liquid/add-plugin.sh \
    move \
    https://github.com/michitux/dokuwiki-plugin-move \
    f2416147498d9b33e36445820b54e015f1968776  # 2022-01-26
RUN /liquid/add-plugin.sh \
    csv \
    https://github.com/cosmocode/csv \
    04fa173229cdc1caca63eed5d272c1b9147cb0c0 # 2022-01-04
RUN /liquid/add-plugin.sh \
    highlight \
    https://github.com/liquidinvestigations/dokuwiki-highlight \
    272e672db204aec43f9072cd72f51d8f94622a6e
RUN /liquid/add-plugin.sh \
    virtualgroup \
    https://github.com/cosmocode/virtualgroup \
    39d3d0cafac9bcca0e3cef4bdb930558242a8d1a  # 2023-01-16
RUN /liquid/add-plugin.sh \
    sneakyindexfix \
    https://github.com/lisps/plugin-sneakyindexfix \
    595f2fc44c7c7bcb51ef95ecfc2d5f221d0df3d6  # 2018
RUN /liquid/add-plugin.sh \
    indexmenu \
    https://github.com/samuelet/indexmenu \
    dd97c882d257200e48770adb7201313795f37216  # 2023-01-22

# if we ever need it...
#RUN /liquid/add-plugin.sh \
#    oauth \
#    https://github.com/cosmocode/dokuwiki-plugin-oauth \
#    8c4b6783010f9f47f9f5c076fb3fd9d5127d724d


RUN chown -v -R daemon: /liquid
RUN chown -v -R daemon: /opt/bitnami/dokuwiki

EXPOSE 8080
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/liquid/entrypoint.sh"]
