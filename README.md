# liquid-dokuwiki

Dokuwiki Docker Image with custom theme and extra plugins.


## Running this docker image

Set the following envs:

- `LIQUID_CORE_URL`
- `LIQUID_TITLE`
- `LIQUID_DOMAIN`
- `LIQUID_HTTP_PROTOCOL`


## How it works

The entrypoint overwrites all plugins found under the `/liquid/plugins` directory on the Docker image. After the Bitnami initialization is done, the entrypoint also overwrites `conf/local.php` with our own. In all other aspects it emulates [our source image](https://bitnami.com/stack/dokuwiki).


## Installed plugin list

- `liquid` -- our custom authentication provider and theme
- `addnewpage` -- https://www.dokuwiki.org/plugin:addnewpage


## Installed templates

There is only one template -- `liquid` -- cloned from the default `dokuwiki`
template. The template adds the "addnewpage" plugin form to the main page, just
before the article.
