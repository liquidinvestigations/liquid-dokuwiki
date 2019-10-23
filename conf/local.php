<?php
$conf['title']  = '<a style="display:inline-block;margin-left:10px;" href="';
$conf['title'] .= $_SERVER["LIQUID_CORE_URL"];
$conf['title'] .= '">&#8594; ';
$conf['title'] .= $_SERVER["LIQUID_TITLE"];
$conf['title'] .= '</a><script src="https://hypothesis.';
$conf['title'] .= $_SERVER["LIQUID_DOMAIN"];
$conf['title'] .= '/embed.js"></script>';

$conf['lang'] = 'en';
$conf['template'] = 'liquid';
$conf['license'] = '0';
$conf['useacl'] = 1;
$conf['superuser'] = '@admin';
$conf['disableactions'] = 'register';
$conf['authtype'] = 'liquid';
$conf['defaultgroup'] = 'admin,user';
$conf['baseurl'] = $_SERVER["LIQUID_HTTP_PROTOCOL"] . '://dokuwiki.' . $_SERVER["LIQUID_DOMAIN"];
