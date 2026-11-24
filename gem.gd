extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	handle_animation()

func _on_body_entered(_body: Node2D) -> void:
	queue_free()
	var gems = get_tree().get_node_count_in_group("Gems")
	if (gems-1) == 0:
		Events.level_completed.emit()

func handle_animation():
	animated_sprite_2d.play("gem_animation")
