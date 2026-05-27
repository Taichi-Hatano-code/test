extends TileMapLayer

func _process(delta):
	# Faz o brilho oscilar entre 2.0 e 6.0 usando uma onda Seno
	var variacao = 4.0 + (sin(Time.get_ticks_msec() * 0.002) * 2.0)
	
	# Aplica a variação apenas no valor da cor (V)
	self_modulate.v = variacao
