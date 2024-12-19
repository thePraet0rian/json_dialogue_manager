class_name Page
extends Node2D


@onready var NameLabel: Label = $Label
@onready var Lines: Node2D = $Lines

var page_name: String
var page_number: int


func set_page_name(_page_name: String) -> void:
	self.page_name = _page_name


func set_page_number(number: int) -> void:
	self.page_number = number


func set_lines_visible(visibility: bool = true) -> void:
	Lines.visible = visibility


func get_page_name() -> String:
	return page_name


func _ready() -> void:
	NameLabel.text = page_name
	NameLabel.position += Vector2(32, 0) * page_number
