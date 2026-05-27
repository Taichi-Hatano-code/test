extends CharacterBody2D

@export var speed = 100

@onready var pernas = $Pernas_Sprite
@onready var tronco = $Tronco_Sprite
@onready var lamparina = $Tronco_Sprite/Node2D/PointLight2D # Certifique-se que o nome é esse na árvore de nós!
@onready var passos = $AudioStreamPlayer2D

func _ready() -> void:
	# Força o SubViewport a usar o mesmo mundo 2D do Player
	$CanvasLayer/SubViewportContainer/SubViewport.world_2d = get_viewport().find_world_2d()
	
	var cena_atual = get_tree().current_scene.scene_file_path
	if cena_atual == "res://scene/fase2.tscn":
		$CanvasLayer.hide()

func _process(delta: float) -> void:
	
	var pos_mouse = get_global_mouse_position()
	# A lamparina deve estar na mesma posição do Player (ou um pouco deslocada)
	# Se a lamparina for filha do Player, você nem precisa mexer na position, 
	# apenas na rotação:
	var direcao = pos_mouse - global_position
	lamparina.rotation = lerp_angle(lamparina.rotation, direcao.angle(), 0.01)
	
	# 3. Pulsação da luz (seu código original)
	lamparina.energy = 1.0 + sin(Time.get_ticks_msec() * 0.005) * 0.1
	
	if velocity.length() > 0:
		$Tronco_Sprite/Node2D/CPUParticles2D.lifetime = 0.5 # Segue grudado
	else:
		$Tronco_Sprite/Node2D/CPUParticles2D.lifetime = 2.0 # Fica flutuando calmo
	

func _physics_process(_delta):
	# 1. MOVIMENTAÇÃO (WASD / Setas)
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed

	# 2. TRONCO E LANTERNA (Seguem o Mouse)
	var mouse_pos = get_global_mouse_position()
	tronco.look_at(mouse_pos)
	tronco.rotation_degrees += 90 # Adiciona o desvio que você quer))
	pernas.look_at(mouse_pos)
	pernas.rotation_degrees += 90

	# 3. PERNAS (Seguem a direção do andar)
	if direction != Vector2.ZERO:
		pernas.play("Walk") # Use o nome exato que você deu no SpriteFrames
		if not passos.playing:
			passos.play()
	else:
		pernas.stop()
		passos.stop()
		pernas.frame = 0 # Opcional: faz ele parar no frame neutro
	
	var empuxo = velocity
	
	move_and_slide()
	
	# 1. Quantas coisas eu bati?
	for i in get_slide_collision_count():
		 # 2. Pega a informação da batida número 'i'
		var colisao = get_slide_collision(i)
		# 3. Quem foi o objeto que eu bati?
		var objeto = colisao.get_collider()
		
		# 4. Esse objeto sabe "ser empurrado"?
		if objeto.has_method("empurrar"):
			objeto.empurrar(empuxo)
