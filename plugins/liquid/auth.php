<?php

define('DOKU_AUTH', dirname(__FILE__));
define('AUTH_USERFILE', DOKU_CONF.'users.auth.php');
class auth_plugin_liquid extends DokuWiki_Auth_Plugin {
  function auth_plugin_liquid(){
    global $config_cascade;
    $this->cando['external'] = true;
    $this->success = true;
  }
  function trustExternal($user, $pass, $sticky = false) {
    global $USERINFO;
    if (isset($_SERVER['HTTP_X_FORWARDED_USER'])) {
      $userid = $_SERVER['HTTP_X_FORWARDED_USER'];
      $USERINFO['user'] = $userid;
      $USERINFO['mail'] = $_SERVER['HTTP_X_FORWARDED_USER_EMAIL'];
      $USERINFO['name'] = $_SERVER['HTTP_X_FORWARDED_USER_FULL_NAME'];
      if ($_SERVER['HTTP_X_FORWARDED_USER_ADMIN'] == 'true') {
        $USERINFO['grps'] = array('admin', 'user');
      } else {
        $USERINFO['grps'] = array('user');
      }
      $_SERVER['REMOTE_USER'] = $userid;
      $_SESSION[DOKU_COOKIE]['auth']['user'] = $userid;
      $_SESSION[DOKU_COOKIE]['auth']['info'] = $USERINFO;
      return true;
    }
    return false;
  }
  function logOff() {
    send_redirect('/__auth/logout');
  }
}
