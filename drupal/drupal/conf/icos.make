; Backend cache
; --------------

projects[varnish][version] = 1.0-beta3
projects[memcache][version] = 1.5

; -----
; Core
; -----

core = 7.0
api = 2

projects[drupal][type] = core
projects[drupal][version] = 7.35
projects[drupal][patch][728702] = https://www.drupal.org/files/issues/install-redirect-on-empty-database-728702-36.patch
projects[drupal][patch][2380361] = https://www.drupal.org/files/issues/2380361-missing-file-watchdog.patch
projects[drupal][patch][1973278] = https://www.drupal.org/files/issues/image-accommodate_missing_definition-1973278-16.patch
projects[drupal][patch][1903010] = https://www.drupal.org/files/issues/drupal-undefinedindex_fileupload-1903010-4.patch
projects[drupal][patch][2477125] = https://www.drupal.org/files/issues/drupal-vertical_tabs_focus_trigger-2477125-1.patch

; Drush make allows a default sub directory for all contributed projects.
defaults[projects][subdir] = "contrib"

; ------------------
; Development tools
; ------------------

projects[devel][version] = 1.4
projects[coffee][version] = 2.2

; -----------
; Essentials
; -----------

projects[autocache][version] = 1.4
projects[better_formats][version] = 1.0-beta1
projects[ctools][version] = 1.7
projects[content_lock][version] = 2.0
projects[context][version] = 3.6
projects[date][version] = 2.8
projects[diff][version] = 3.2
projects[features][version] = 2.4
projects[features_extra][download][branch] = 7.x-1.x
projects[features_extra][download][revision] = 7b775405b186fdc7402ed974acc3bd4f48fe9049
projects[features_extra][patch][1279928] = https://www.drupal.org/files/issues/features_extra-add-date-format-support-1279928-49.patch
projects[fences][version] = 1.0
projects[field_group][version] = 1.4
projects[jquery_update][version] = 2.5
projects[libraries][version] = 2.2
projects[link][version] = 1.3
projects[linkit][download][branch] = 7.x-3.x
projects[linkit][download][revision] = 8dba51e4111e438d0bc35a7ba19b30042acf664d
projects[menu_admin_per_menu][version] = 1.0
projects[menu_block][version] = 2.5
projects[module_filter][version] = 2.0
projects[navbar][version] = 1.6
projects[override_node_options][version] = 1.13
projects[pathauto][download][branch] = 7.x-1.x
projects[pathauto][download][revision] = 044e8285e8ae5c723699697df1600841e781ba87
projects[rules][version] = 2.9
projects[strongarm][version] = 2.0
projects[styleguide][version] = 1.1
projects[taxonomy_access_fix][version] = 2.1
projects[token][version] = 1.6
projects[views][version] = 3.10


; -------------
; Editor tools
; -------------

projects[ckeditor][download][branch] = 7.x-1.x
projects[ckeditor][download][revision] = 32f09731dcf1ca6ea78c2d9f10a49e59c2baea7b
projects[ckeditor_link][download][branch] = 7.x-2.x
projects[ckeditor_link][download][revision] = 0b3f22c8a78ed088a44d08d5fffe39589183061e
projects[ckeditor_link_file][download][branch] = 7.x-1.x
projects[ckeditor_link_file][download][revision] = 1a534cfbbe27e32e3103c757fa83d0334d3682de
projects[responsive_preview][download][branch] = 7.x-1.x
projects[responsive_preview][download][revision] = 83944f3005629f9a82125da2e8a7bb73143d6d8e
projects[responsive_preview][patch][2434913] = https://www.drupal.org/files/issues/unable_to_scroll_down-2434913-1.patch

; More information needed about these

;projects[ckeditor][patch][2341297] = https://www.drupal.org/files/issues/ckeditor_media_youtube_submit_does_nothing_2341297.patch
;projects[htmlpurifier][version] = 1.0
;projects[plupload][version] = 1.7
;projects[media_youtube][download][branch] = 7.x-2.x
;projects[media_youtube][download][revision] = 4912276298031969480d5915ea858ad0ef98df3e
;projects[multiform][version] = 1.1

; ----------
; Libraries
; ----------

; Check if these are needed

;libraries[plupload][directory_name] = plupload
;libraries[plupload][download][type] = file
;libraries[plupload][download][url] = https://github.com/moxiecode/plupload/archive/v1.5.8.zip
;libraries[plupload][patch][1903850] = https://www.drupal.org/files/issues/plupload-1_5_8-rm_examples-1903850-16.patch

;libraries[htmlpurifier][directory_name] = htmlpurifier
;libraries[htmlpurifier][download][type] = file
;libraries[htmlpurifier][download][url] = http://htmlpurifier.org/releases/htmlpurifier-4.6.0.tar.gz

; -------------
; Maybe needed
; -------------

; Check the versions of these

;projects[admin_views][version] = 1.4
;projects[redirect][version] = 1.0-rc1
;projects[scheduler][version] = 1.3
;projects[transliteration][version] = 3.2
;projects[variable][version] = 2.5
;projects[title][version] = 1.0-alpha7
;projects[views_bulk_operations][version] = 3.2
;projects[stage_file_proxy][version] = 1.6

;projects[pathologic][version] = 2.12
;projects[rules][version] = 2.9
;projects[search_api][version] = 1.14
;projects[webform][version] = 4.7

;projects[auto_entitylabel][version] = 1.3
;projects[inline_entity_form][version] = 1.5

;projects[elements][version] = 1.4

; ---------
; Modules
; ---------

projects[backup_migrate][version] = 3.0
projects[ds][version] = 2.7
projects[ds][patch][2376377] = https://www.drupal.org/files/issues/ds27-token-fpp-undefined-2376377-1.patch
projects[entity][version] = 1.6
projects[entityreference][version] = 1.1
projects[email][version] = 1.3
projects[fieldable_panels_panes][download][branch] = 7.x-1.x
projects[fieldable_panels_panes][download][revision] = f89fb4132bd79166b28891c36e909b69caf13a40
projects[file_entity][download][branch] = 7.x-2.x
projects[file_entity][download][revision] = 3320b2bd1d6c8733c659ce59bbd89c19cdbe18cf
projects[file_lock][version] = 2.0
projects[invisimail][version] = 1.2
projects[jqeasing][version] = 1.0
projects[media][download][branch] = 7.x-2.x
projects[media][download][revision] = 64c5102774f6674d618ee30b4fac240f3c535862
projects[media][patch][1792738] = https://www.drupal.org/files/issues/media-custom_view_modes_for_wysiwyg-1792738-185.patch
projects[media][patch][2333855] = https://www.drupal.org/files/issues/media_wysiwyg-ckeditor-module-browser-tabs-2333855-7.patch
projects[minimal_share][download][branch] = 7.x-1.x
projects[minimal_share][download][revision] = d7dc57c84cfa40301a940493fa1251ff67796532
projects[panelizer][version] = 3.1
projects[panelizer][patch][2199859] = https://www.drupal.org/files/issues/panelizer-ipe-integration-fix-2199859-02.patch
projects[panels][version] = 3.5
projects[panels_extra_styles][version] = 1.1
projects[panels_mini_ipe][version] = 1.0-beta3
projects[panels_style_pack][download][branch] = 7.x-1.x
projects[panels_style_pack][download][revision] = 1b7c67d4a1e5bc2e1f9c29071ab94332ed241a92
projects[panels_style_pack][patch][1871624] = https://www.drupal.org/files/issues/panels_style_pack-Vertical%20tabs%20without%20title-1871624.patch
projects[panels_style_pack][patch][2054813] = https://www.drupal.org/files/features_tabs-2054813-1.patch
projects[panels_style_pack][patch][2139801] = https://www.drupal.org/files/issues/panels_style_pack-add_tabs_default_option-2139801-3.patch
projects[panels_style_pack][patch][2475831] = https://www.drupal.org/files/issues/panels_style_pack-styles-in-multiple-regions-2475831-empty-region-with-tabs-style-gives-an-error-2475745-6.patch
projects[panels_style_pack][patch][2476037] = https://www.drupal.org/files/issues/panels_style_pack-panel_title_visible_when_tabbed-2476037-1.patch
projects[slick][version] = 2.0-beta1
projects[slick][patch][2477509] = https://www.drupal.org/files/issues/slick-remove_make_file-2477509-1.patch
projects[telephone][version] = 1.0-alpha1
projects[views_accordion][version] = 1.1
projects[views_vertical_tabs][version] = 1.0
projects[view_unpublished][version] = 1.2
projects[cmis][version] = 1.6
projects[smtp][version] = 1.2
; --------
; Themes
; --------

projects[responsive_bartik][version] = 1.0
projects[responsive_bartik][type] = theme

projects[aurora][version] = 3.5
projects[aurora][type] = theme

projects[shiny][version] = 1.6
projects[shiny][type] = theme

; --------------------------
; Theme Aurora requirements
; --------------------------

projects[blockify][version] = 1.2
projects[elements][version] = 1.4
projects[html5_tools][version] = 1.2
projects[magic][version] = 2.2
projects[modernizr][version] = 3.4
