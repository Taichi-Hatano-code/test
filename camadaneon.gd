extends TileMap

# No seu camada_neon.gd
func _process(_delta):
	var pulso = 5.0 + (sin(Time.get_ticks_msec() * 0.002) * 3.0)
	# Isso mantém a cor original do tile, mas aumenta a intensidade (brilho)
	self_modulate = Color(pulso, pulso, pulso, 1.0)
