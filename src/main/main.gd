class_name Main
extends Node2D


const DIALOGUE_SCENE: PackedScene = preload(
	"res://scn/dialogue/dialogue_snippet.tscn")

@onready var FileSystem: Node2D = $FileSystem
@onready var OpenFileDialogueButton: Button = $OpenDialogue
@onready var SaveFileDialogueButton: Button = $CloseDialogue
@onready var OpenFileDialogue: FileDialog = $FileSystem/OpenDialogue
@onready var SaveFileDialogue: FileDialog = $FileSystem/SaveDialogue

var Npcs: Array[DialogueSnippet]
var index: int = 0
var can_select: bool = false


func _on_open_dialogue_pressed() -> void:
	OpenFileDialogueButton.disabled = true
	OpenFileDialogue.visible = true
	FileSystem.visible = false 


func _on_close_dialogue_pressed() -> void:
	SaveFileDialogueButton.disabled = true
	SaveFileDialogue.visible = true
	FileSystem.visible = false 


func _on_open_dialogue_file_selected(path:String) -> void:
	_load_file(path)


func _input(event: InputEvent) -> void:
	if can_select: 
		if event.is_action_pressed("ui_down") or event.is_action_pressed("k"):
			index += 1
		elif event.is_action_pressed("ui_up") or event.is_action_pressed("l"):
			index -= 1
		elif event.is_action_pressed("space"):
			can_select = false
			Npcs[index].set_active()

		for i in Npcs.size(): 
			if i == index:	
				Npcs[i].modulate = Color8(255, 0, 0, 255)
				Npcs[i].set_ui_visible()
			else: 
				Npcs[i].modulate = Color8(255, 255, 255, 255)
				Npcs[i].set_ui_visible(false)


func _load_file(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var stringed_data = file.get_as_text()
	var data: Dictionary = JSON.parse_string(stringed_data)

	var offset: int = 0

	print(data.keys())

	for key in data.keys():
		var DialogueInstance: DialogueSnippet = DIALOGUE_SCENE.instantiate()
		Npcs.append(DialogueInstance)
		add_child(DialogueInstance)
		DialogueInstance.position = Vector2(50, 100) + offset * Vector2(0, 20)
		offset += 1

		DialogueInstance.set_npc(key)
		DialogueInstance.set_lines(data[key])

	can_select = true


