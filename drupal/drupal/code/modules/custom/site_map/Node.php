<?php

/**
 *
 */
class Node {

    private $title;
    private $id;
    private $parent_id;
    private $link_path;
    private $has_children;

    public function getTitle() {
        return $this->title;
    }

    public function setTitle($title) {
        $this->title = $title;
    }

    public function getId() {
        return $this->id;
    }

    public function setId($id) {
        $this->id = $id;
    }

    public function getParentId() {
        return $this->parent_id;
    }

    public function setParentId($parent_id) {
        $this->parent_id = $parent_id;
    }

    public function getLinkPath() {
        return $this->link_path;
    }

    public function setLinkPath($link_path) {
        $this->link_path = $link_path;
    }

    public function getHasChildren() {
        return $this->has_children;
    }

    public function setHasChildren($has_children){
        $this->has_children = $has_children;
    }

    function __construct() {

    }
}