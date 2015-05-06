Features
====

## General

The description of the features contain the information of what the feature includes.

## Custom code

All the features that contain custom code are listed here with a brief explanation of the said custom code.

### Base

The base feature has custom code for unsetting the default 'node' menu callback. The URL patterns of Event, Blog post and News have date field token in them that uses the Tokens view mode of each content type. See more info [here](https://www.drupal.org/node/1143502#comment-7745613).

### Contacting

The contacting feature has custom code for hiding the relations field of taxonomy terms on the edit form since it's just noise.

### Controller

The controller feature includes custom code for hiding the end date selector for some content types, that don't need the end date. This is done in custom code so that the same date field can be used for all content types and further used for sorting etc.

### Panelized compilation page

The panelized compilation page feature has custom code for pre-selecting and hiding configuration for fieldable panels panes to make if more simple.

### Permissions

The permissions feature has custom code for preventing the deletion of the node set as the front page of the site.