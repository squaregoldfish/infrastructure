<?php

// GENERAL

// Drupal instance
$databases = array (
  'default' => array (
    'default' => array (
      'database' => 'icos',
      'username' => 'icos',
      'password' => 'icos',
      'host' => 'mariadb',
      'port' => '3306',
      'driver' => 'mysql',
      'prefix' => '',
    ),
  ),
);

// REVERSE PROXY
$base_url = 'https://www.icos-ri.eu';
//$base_url = 'https://' . $_SERVER['HTTP_HOST'];

// MEMCACHE
$conf['memcache_servers'] = array('memcache:11211' => 'default');
$conf['cache_backends'][] = 'sites/all/modules/contrib/memcache/memcache.inc';
$conf['cache_class_cache_form'] = 'DrupalDatabaseCache';
$conf['cache_default_class'] = 'MemCacheDrupal';
$conf['memcache_key_prefix'] = 'icos';

// Varnish
//$conf['cache_backends'][] = 'sites/all/modules/contrib/varnish/varnish.cache.inc';
//$conf['cache_class_cache_page']  = 'VarnishCache';
//$conf['varnish_version'] = '3';

// PRODUCTION

// Error reporting
$conf['error_level'] = 0;

// Performance
$conf['cache'] = TRUE;
$conf['cache_lifetime'] = 0;
$conf['page_cache_maximum_age'] = 3600;
$conf['preprocess_css'] = TRUE;
$conf['preprocess_js'] = FALSE;

