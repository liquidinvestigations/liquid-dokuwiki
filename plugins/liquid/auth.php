<?php

define('DOKU_AUTH', dirname(__FILE__));
define('AUTH_USERFILE', DOKU_CONF.'users.auth.php');
class auth_plugin_liquid extends DokuWiki_Auth_Plugin {
  function auth_plugin_liquid(){
    global $config_cascade;
    $this->cando['external'] = true;
    $this->success = true;
  }

  function profile($access_token) {
    // Use the following to get the user profile data from the oauth2 provider.
    // https://www.php.net/manual/en/function.file-get-contents.php
    // Imitates the hoover-search contrib.auth.oauth2 implementation for the client:
    // https://github.com/liquidinvestigations/hoover-search/blob/7cc4751996091e5e88708681b87f57f45c7d34a4/hoover/contrib/oauth2/views.py#L53
    // We get the access token from oauth2-proxy X-Forwarded-Access-Token header: https://oauth2-proxy.github.io/oauth2-proxy/configuration
    $opts = array(
      'http'=>array(
        'method'=>"GET",
        'header'=>"Authorization: Bearer {$access_token}\r\n"
      )
    );
    $context = stream_context_create($opts);
    $data = file_get_contents(getenv('LIQUID_CORE_PROFILE_URL'), false, $context);
    return json_decode($data);
  }

  function trustExternal($user, $pass, $sticky = false) {
    global $USERINFO;

    if (isset($_SERVER['X_FORWARDED_ACCESS_TOKEN'])) {
      $token = $_SERVER['X_FORWARDED_ACCESS_TOKEN'];
      $profile = $this->profile($token);
      $userid = $profile['id'];

      $USERINFO['user'] = $userid;
      $USERINFO['mail'] = $profile['email'];
      $USERINFO['name'] = $profile['name'];
      $USERINFO['grps'] = $profile['roles'];

      $_SERVER['REMOTE_USER'] = $userid;
      $_SESSION[DOKU_COOKIE]['auth']['user'] = $userid;
      $_SESSION[DOKU_COOKIE]['auth']['info'] = $USERINFO;
      return true;
    }
    return false;
  }
  function logOff() {
    send_redirect("/oauth2/sign_out?rd=".urlencode(getenv("LIQUID_CORE_LOGOUT_URL")));
  }
}
