extends StaticBody2D

@export var som_customizado : AudioStream
@export var vida_maxima : int = 10
@export var dano_ataque : int = 2
@export var certo : bool = false
@export var proxima_scene = PackedScene
@onready var timer = $Timer
@onready var player = null
@onready var raio = $RayCast2D
@onready var audio_player = $AudioStreamPlayer2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
	if name in Global.inimigos_derrotados:
		queue_free()
	
	if som_customizado:
		audio_player.stream = som_customizado
	# 1. Configura o tempo para 3 segundos
	timer.wait_time = 3.0
	# 2. Garante que ele comece a contar
	timer.autostart = true 
	timer.start()
	
	# 3. CONEXÃO CRUCIAL: Diz ao Timer para rodar sua função quando acabar
	timer.timeout.connect(_on_timer_timeout)
	
	timer.start()

func _process(_delta):
	if not player:
		player = get_tree().get_first_node_in_group("player")
		return
		
		# Faz o raio apontar exatamente para o jogador
	raio.target_position = to_local(player.global_position)
		
		# Verifica se o raio bateu em algo (a parede) antes de chegar no player
	if raio.is_colliding():
			# Tem algo no caminho! Vamos abafar o som.
			# Opção A: Diminuir o volume
		audio_player.volume_db = -15 
			# Opção B (Melhor): Se você criou o Audio Bus "Abafado" como expliquei antes:
		audio_player.bus = "Abafado"
	else:
			# Caminho livre! Som total.
		audio_player.volume_db = 0
		audio_player.bus = "Master"
		
func _on_timer_timeout():
	# Só dá o play se o som não estiver rodando (opcional)
	# ou simplesmente dá o play para reiniciar o som a cada 3s
	audio_player.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		
		print("Player detectado!")
		
		# 1. Para o movimento do player
		body.set_physics_process(false)
		
		# 2. Salva os dados no Global para a cena de combate usar
		Global.posicao_player = body.global_position # Salva onde o player estava
		Global.mob_atual_nome = name
		Global.inimigo_vida_atual = vida_maxima
		Global.inimigo_dano_atual = dano_ataque
		Global.inimigo_certo = certo # Define se é o Boss/Inimigo certo
		
		Global.cena_pos_batalha = proxima_scene
		
		# 3. Pede para a cena principal (Mundo) rodar a transição
		var mapa = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
		if mapa.has_method("transicao_para_batalha"):
			print("A chamar transição no Mundo...")
			mapa.transicao_para_batalha()
		else:
			print("ERRO: Mundo não tem a função. A mudar cena direto...")
			# Segurança: se o mapa não tiver o método, muda a cena direto
			get_tree().change_scene_to_file("res://scene/Batalha.tscn")

func transicao_para_batalha():
	# Torna o ColorRect visível (caso o tenhas escondido)
	$CanvasLayer/BlurLayer.visible = true
	
	var tween = create_tween()
	# Faz o desfoque (lod) ir de 0 para 3.5 em 0.6 segundos
	tween.tween_property($CanvasLayer/BlurLayer.material, "shader_parameter/lod", 3.5, 0.6)
	
	# Opcional: Escurecer um pouco o fundo também
	tween.parallel().tween_property($CanvasLayer/BlurLayer, "modulate", Color(0.7, 0.7, 0.7, 1.0), 0.6)
	
	await tween.finished
	get_tree().change_scene_to_file("res://scene/Batalha.tscn")

func passar_de_fase():
	if certo:
		Global.inimigo_certo = certo
