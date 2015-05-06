<?php
/**
 * @file
 * icos_user_feature.rules_defaults.inc
 */

/**
 * Implements hook_default_rules_configuration().
 */
function icos_user_feature_default_rules_configuration() {
  $items = array();
  $items['rules_icos_redirect_to_front_page_on_login'] = entity_import('rules_config', '{ "rules_icos_redirect_to_front_page_on_login" : {
      "LABEL" : "ICOS Redirect to front page on login",
      "PLUGIN" : "reaction rule",
      "OWNER" : "rules",
      "REQUIRES" : [ "rules" ],
      "ON" : { "user_login" : [] },
      "DO" : [ { "redirect" : { "url" : "\\u003Cfront\\u003E" } } ]
    }
  }');
  return $items;
}
