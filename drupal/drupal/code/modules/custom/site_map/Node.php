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
    private $weight;
    private $sort_order;

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

    public function getWeight() {
        return $this->weight;
    }

    public function setWeight($weight) {
        $this->weight = $weight;
    }

    public function getSortOrder() {
        return $this->sort_order;
    }

    public function setSortOrder($sort_order) {
        $this->sort_order = $sort_order;
    }

    function __construct() {

    }
}