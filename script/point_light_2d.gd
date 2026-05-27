extends PointLight2D

var tempo = 0.0

func _process(delta):
	tempo += delta * 4.0 # Velocidade da oscilação
	# Faz a energia variar levemente usando uma função seno
	energy = 1.5 + sin(tempo) * 0.2
