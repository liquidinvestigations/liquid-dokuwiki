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
      $groups_hdr = $_SERVER['HTTP_X_FORWARDED_GROUPS'];
      // split by spaces and comma
      $groups = preg_split("/[\s,]+/", $groups_hdr);

      $USERINFO['user'] = $userid;
      $USERINFO['mail'] = $_SERVER['HTTP_X_FORWARDED_EMAIL'];
      $USERINFO['name'] = $_SERVER['HTTP_X_FORWARDED_PREFERRED_USERNAME'];
      if (!isset($USERINFO['grps'])) {
          $USERINFO['grps'] = array();
      }
      $USERINFO['grps'] = array_merge($groups, $USERINFO['grps']);
      array_push($USERINFO['grps'], "ALL");

      $_SERVER['REMOTE_USER'] = $userid;
      $_SESSION[DOKU_COOKIE]['auth']['user'] = $userid;
      $_SESSION[DOKU_COOKIE]['auth']['info'] = $USERINFO;
      error_log('AUTH User = ' . $userid . "   Groups = " . implode(', ', $USERINFO['grps']));
      return true;
    }
    // error_log('AUTH - NO HTTP_X_FORWARD_USER');
    return false;
  }
  function logOff() {
    send_redirect("/oauth2/sign_out?rd=".urlencode(getenv("LIQUID_CORE_LOGOUT_URL")));
  }

  function getUserData($user, $requireGroups = true) {
    $groups_hdr = $_SERVER['HTTP_X_FORWARDED_GROUPS'];
    // split by spaces and comma
    $groups = preg_split("/[\s,]+/", $groups_hdr);
    if (!isset($USERINFO['grps'])) {
            $USERINFO['grps'] = array();
    }
    $USERINFO['grps'] = array_merge($groups, $USERINFO['grps']);
    array_push($USERINFO['grps'], "ALL");

    error_log('GET USER INFO User = ' . $user . "   Groups = " . implode(', ', $USERINFO['grps']));

    return array(
            'name' => $_SERVER['HTTP_X_FORWARDED_PREFERRED_USERNAME'],
            'mail' => $_SERVER['HTTP_X_FORWARDED_EMAIL'],
            'grps' => $USERINFO['grps'],
    );
    }
}
