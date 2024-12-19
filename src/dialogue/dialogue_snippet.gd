class_name DialogueSnippet
extends Node2D


const LINE_SCENE: PackedScene = preload("res://scn/dialogue/line.tscn")
const PAGE_SCENE: PackedScene = preload("res://scn/dialogue/page.tscn")
enum States {
	PAGE_SELECTION = 0,
	LINE_SELECTION = 1,
}

@onready var NameLabel: Label = $Label
@onready var Ui: CanvasLayer = $CanvasLayer

var Pages: Array[Page]
var Labels: Array[Label]
var entire_text: String
var lines: Dictionary 
var index: int = 0
var page_index: int = 0
var active: bool = false
var current_state: States = States.PAGE_SELECTION


func set_npc(npc_name: String) -> void:
	NameLabel.text = npc_name


func set_lines(text: Dictionary) -> void:
	lines = text

	_setup_pages()

	
func _setup_pages() -> void:
	var keys: Array = lines.keys()

	for i in keys.size():
		var PageInstance: Page = PAGE_SCENE.instantiate()
		PageInstance.set_page_name(keys[i])
		PageInstance.set_page_number(i)

		Pages.append(PageInstance)
		Ui.add_child(PageInstance)

	_setup_lines()


func _setup_lines() -> void:
	for PageInstance in Pages:

		var current_page_name: String = PageInstance.get_page_name()

		for j in lines[current_page_name].size():
			var LineInstance: Line = LINE_SCENE.instantiate()
			LineInstance.position = Vector2(500, 100) + j * Vector2(0, 40)
			Labels.append(LineInstance)
			LineInstance.set_lines(lines[current_page_name][j])

			PageInstance.get_node("Lines").add_child(LineInstance)


func set_ui_visible(visibility: bool = true) -> void:
	Ui.visible = visibility


func set_active(activity: bool = true) -> void:
	active = activity


func _input(event: InputEvent) -> void:
	if active:
		match current_state:
			States.PAGE_SELECTION:
				_page_input(event)
			States.LINE_SELECTION:
				_line_input(event)


func _page_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left") or event.is_action_pressed("j"):
		page_index -= 1
	elif event.is_action_pressed("ui_right") or event.is_action_pressed("ö"):
		page_index += 1
	elif event.is_action_pressed("space"):
		current_state = States.LINE_SELECTION

	for i in Pages.size():
		if i == page_index:
			Pages[i].modulate = Color8(0, 255, 0, 255)
			Pages[i].set_lines_visible()
		else:
			Pages[i].modulate = Color8(255, 255, 255, 255)
			Pages[i].set_lines_visible(false)


func _line_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down") or event.is_action_pressed("k"):
		index += 1
	elif event.is_action_pressed("ui_up") or event.is_action_pressed("l"):
		index -= 1
	elif event.is_action_pressed("space"):
		pass
																		   
	for i in Labels.size():
		if i == index:
			Labels[i].modulate = Color8(255, 0, 0, 255)
		else:
			Labels[i].modulate = Color8(255, 255, 255, 255)


