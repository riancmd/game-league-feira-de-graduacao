extends CanvasLayer

@export var title_label: Label
@export var title_image: TextureRect
@export var animation_player: AnimationPlayer

func _on_show_area_title(text: String, image: Texture2D) -> void:
	if not text.is_empty():
		title_label.text = text
		title_label.show()
	else:
		title_label.hide()
	
	if image:
		title_image.texture = image
		title_image.show()
	else:
		title_image.hide()
		
	animation_player.play("show_title")
