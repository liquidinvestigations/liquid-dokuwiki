<?php
$conf['title']  = "<a style=\"display:inline-block;margin-left:10px;\" href=\"{$_SERVER['LIQUID_CORE_URL']}\">&#8594; {$_SERVER["LIQUID_TITLE"]}</a><script src=\"https://hypothesis.{$_SERVER["LIQUID_DOMAIN"]}/embed.js\"></script>";
$conf['lang'] = 'en';
$conf['template'] = 'liquid';
$conf['license'] = '0';
$conf['useacl'] = 1;
$conf['superuser'] = '@admin';
$conf['disableactions'] = 'register';
$conf['authtype'] = 'liquid';
$conf['defaultgroup'] = 'admin,user';
$conf['baseurl'] = "{$_SERVER["LIQUID_HTTP_PROTOCOL"]}://dokuwiki.{$_SERVER["LIQUID_DOMAIN"]}";
