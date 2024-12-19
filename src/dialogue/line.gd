class_name Line
extends Label



func set_lines(_text: Dictionary) -> void:
	if _text.has("Line"):
		self.text = _text["Line"]
