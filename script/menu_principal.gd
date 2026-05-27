extends Control

@onready var menu = $"Opções/AudioStreamPlayer2D"
@onready var start = $"Opções/Start"
@onready var options = $"Opções/Options"
@onready var exit = $"Opções/Exit"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	
	var musica = $AudioStreamPlayer2D
	
	var tween = create_tween()
	tween.tween_property(musica, "volume_db", -80.0, 1.5).set_trans(Tween.TRANS_SINE)
	
	await tween.finished
	musica.stop() # Para a música de vez
	get_tree().change_scene_to_file("res://scene/test.tscn")

func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	pass # Replace with function body.


func _on_start_mouse_entered() -> void:
	menu.play()
	var tween = create_tween()
	tween.tween_property(start, "scale", Vector2(1.2, 1.2), 0.1)
	
func _on_options_mouse_entered() -> void:
	menu.play()
	var tween = create_tween()
	tween.tween_property(options, "scale", Vector2(1.2, 1.2), 0.1)

func _on_exit_mouse_entered() -> void:
	menu.play()
	var tween = create_tween()
	tween.tween_property(exit, "scale", Vector2(1.2, 1.2), 0.1)

func _on_start_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(start, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_SINE)

func _on_options_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(options, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_SINE)

func _on_exit_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(exit, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_SINE)
