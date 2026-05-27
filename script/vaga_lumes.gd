extends CPUParticles2D

# No script onde estão os vagalumes
@onready var player = get_tree().get_first_node_in_group("player") # Garanta que o player está no grupo "player"

func _process(delta):
	if player:
		# Faz o emissor seguir o player exatamente
		global_position = player.global_position
	else:
		print("player não encontrado")
