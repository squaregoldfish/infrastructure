<?php
/**
 * @file
 * icos_base_feature.rules_defaults.inc
 */

/**
 * Implements hook_default_rules_configuration().
 */
function icos_base_feature_default_rules_configuration() {
  $items = array();
  $items['rules_icos_redirect_back_to_term_list'] = entity_import('rules_config', '{ "rules_icos_redirect_back_to_term_list" : {
      "LABEL" : "ICOS Redirect back to term list after term creation",
      "PLUGIN" : "reaction rule",
      "OWNER" : "rules",
      "REQUIRES" : [ "rules", "taxonomy" ],
      "ON" : { "taxonomy_term_insert" : [] },
      "DO" : [
        { "entity_fetch" : {
            "USING" : { "type" : "taxonomy_vocabulary", "id" : [ "term:vocabulary:vid" ] },
            "PROVIDE" : { "entity_fetched" : { "taxonomy_vocabulary" : "Taxonomy vocabulary" } }
          }
        },
        { "redirect" : { "url" : "admin\\/structure\\/taxonomy\\/[taxonomy-vocabulary:machine-name]" } }
      ]
    }
  }');
  return $items;
}
