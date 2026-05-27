extends Node2D

@onready var camera = $Camera2D
@onready var player = $player
@onready var inimigo = $inimigo
@onready var modulate_ = $CanvasModulate
@onready var music = $AudioStreamPlayer2D
@onready var hit = $hit
@onready var hit_inimigo = $hit_inimigo
@onready var efeito_dano = $EfeitoDano # Altere para o nome que você deu ao nó
@onready var menu_acoes = $CanvasLayer/Panel/MenuAcoes
@onready var menu_items = $CanvasLayer/Panel/MenuItens

var turno = 0

var certo : bool

var vida_inimigo
var vida_player

var dano_player
var dano_inimigo

var posicao_player
var posicao_inicial_player

var posicao_inimigo
var posicao_inicial_inimigo

var pos_y_original_menu : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	vida_inimigo = Global.inimigo_vida_atual 
	dano_inimigo = Global.inimigo_dano_atual
	
	vida_player = Global.player_vida_global
	dano_player = Global.player_dano_global
	
	certo = Global.inimigo_certo
	
	pos_y_original_menu = menu_acoes.position.y
	
	if camera:
		print("test")
	else: 
		pass
	print("batalha comecou")
	
	posicao_inicial_player = player.global_position
	posicao_inicial_inimigo = inimigo.global_position

	# 2. Joga eles para fora da tela (ajuste os valores se precisar)
	player.global_position.x -= 500  # Move o player bem para a esquerda
	inimigo.global_position.x += 500 # Move o inimigo bem para a direita
	
	# 3. Chama a função da animação de entrada
	animacao_entrada()
	
	music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	pass

func _on_ataque_pressed() -> void:
	ataque_player(0)
	
func _on_defender_pressed() -> void:
	print(vida_inimigo)
	
	var sorte = randi_range(1,100)
	
	if sorte > 70:
		ataque_player(1)
	else:
		processar_turno_inimigo()

func processar_turno_inimigo():
	
	if not is_inside_tree(): return
	
	await get_tree().create_timer(0.5).timeout
	
	if not is_inside_tree(): return
	
	print("Inimigo está pensando...")
	# Aqui você pode usar um await get_tree().create_timer(1.0).timeout
	# Para dar aquele 1 segundo de suspense
	
	posicao_inimigo = posicao_inicial_inimigo + Vector2(-50,20)
	
	var tween = create_tween()
	
	tween.tween_property(inimigo, "global_position", posicao_inimigo, 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(inimigo, "global_position", posicao_inicial_inimigo, 0.3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	
	hit_inimigo.play()
	
	for i in range(4):
		var forca_shake = 15
		camera.offset = Vector2(randf_range(-forca_shake, forca_shake), randf_range(-forca_shake, forca_shake))
		modulate_.color = Color.RED
		await get_tree().create_timer(0.05).timeout # Intervalo bem curto
	
	# Volta ao normal
	camera.offset = Vector2.ZERO
	modulate_.color = Color.WHITE
	
	vida_player -= dano_inimigo
	print("Inimigo atacou! Vida Player: ", vida_player)
	
	if vida_player <= 0:
		print("Game Over!")
	else:
		await get_tree().create_timer(0.5).timeout
		turno = 0 # Devolve o turno para o player

func executar_animacao_dano():
	vida_inimigo -= 1
	
	print("Iniciando animação de dano...")
	
	# 1. Movimento de ida
	var tween = create_tween()
	posicao_player = posicao_inicial_player + Vector2(50,-20)
	tween.tween_property(player, "global_position", posicao_player, 0.1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)	
	await tween.finished
	
	# 2. Impacto e Efeito Visual
	hit.play()
	efeito_dano.global_position = inimigo.global_position
	efeito_dano.visible = true
	efeito_dano.play("default")
	
	# Lógica para esconder o efeito sem travar o código principal
	_limpar_efeito_visual()

	# 3. Movimento de volta
	var tween_voltar = create_tween()
	tween_voltar.tween_property(player, "global_position", posicao_inicial_player, 0.1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	
	await tween_voltar.finished
	print("Animação de dano concluída!")
	# Ao chegar aqui, a função termina e libera o 'await' de quem a chamou

func _limpar_efeito_visual():
	# Espera a animação do sprite acabar em "segundo plano"
	await efeito_dano.animation_finished
	efeito_dano.visible = false

func animacao_entrada():
	turno = 2 # Bloqueia os botões durante a animação
	
	var tween = create_tween()
	
	# Faz os dois virem ao mesmo tempo (parallel)
	# TRANS_BACK com EASE_OUT dá aquele efeito de "mola" no final (muito bom visualmente)
	tween.parallel().tween_property(player, "global_position", posicao_inicial_player, 0.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(inimigo, "global_position", posicao_inicial_inimigo, 0.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# Espera a animação acabar para liberar o jogo
	await tween.finished
	turno = 0 # Agora o player pode atacar!

func verificar_morte_inimigo():
	if vida_inimigo <= 0:
		if Global.mob_atual_nome != "":
			Global.inimigos_derrotados.append(Global.mob_atual_nome)
		
		var tween_morte = create_tween()
		
		# Define o ponto final (a posição atual + 300 pixels para baixo)
		var posicao_final_morte = posicao_inicial_inimigo + Vector2(0, 300)
		
		# Animação 1: Move o inimigo para baixo (0.5 segundos, suave no início e rápido no fim)
		tween_morte.tween_property(inimigo, "global_position", posicao_final_morte, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		
		# Animação 2 (Paralela): Faz o inimigo ficar invisível (Modulate Alfa para 0)
		# Nota: Para o Glow (Neon) sumir, o Alfa precisa ir a 0.
		tween_morte.parallel().tween_property(inimigo, "modulate:a", 0.0, 0.4).set_delay(0.1) # Começa um pouquinho depois
		
		# ESPERA a animação de morte acabar antes de mudar de cena!
		await tween_morte.finished
		
		if Global.mob_atual_nome != "":
			Global.inimigos_derrotados.append(Global.mob_atual_nome)
		
		if certo: # Se for o inimigo especial, vai para a cutscene
			if Global.cena_pos_batalha != null:
				print("Indo para a cena personalizada do mob...")
				get_tree().change_scene_to_packed(Global.cena_pos_batalha)
				Global.inimigo_certo = false
			else:
				print("ERRO: Mob era o 'certo', mas não tinha cena configurada!")
				get_tree().change_scene_to_file("res://scene/test.tscn") # Volta por segurança
				Global.inimigo_certo = false
		else: # Se for inimigo comum, volta para o mapa
			print("Voltando para o mapa...")
			Global.inimigo_certo = false
			get_tree().change_scene_to_file("res://scene/fase1.tscn")
		return true
			
	return false

func ataque_player(sorte):
	
	print(vida_inimigo)
	
	if turno == 0: # Vez do Player
		turno = 2
		await executar_animacao_dano()

		print("primeiro await")

		if await verificar_morte_inimigo(): return
		
		if sorte == 1:
			print("COMBO! Segundo ataque!")
			player.self_modulate = Color(10, 10, 10) 
			await executar_animacao_dano()
			player.self_modulate = Color.WHITE # Volta ao normal
			vida_inimigo -= dano_player
			if await verificar_morte_inimigo(): return
		
		processar_turno_inimigo()

func trocar_para_menu_itens():
	var tempo = 0.3 # Velocidade da animação
	var tween = create_tween().set_parallel(true) # Anima tudo ao mesmo tempo
	
	# --- 1. DESCE O MENU DE AÇÕES ---
	# Move para baixo e tira a opacidade
	tween.tween_property(menu_acoes, "modulate:a", 0.0, tempo)
	tween.tween_property(menu_acoes, "position:y", menu_acoes.position.y + 50, tempo).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	# --- 2. PREPARA O MENU DE ITENS ---
	# Garante que ele comece invisível e um pouco abaixo de onde deve ficar
	menu_items.visible = true
	menu_items.modulate.a = 0.0
	var posicao_final_itens = menu_acoes.position.y # Onde o primeiro estava
	menu_items.position.y = posicao_final_itens + 50
	
	# Espera o primeiro menu começar a sumir para subir o segundo
	await get_tree().create_timer(0.1).timeout
	
	var tween_subir = create_tween().set_parallel(true)
	# Sobe o menu de itens para a posição original e dá o fade in
	tween_subir.tween_property(menu_items, "modulate:a", 1.0, tempo)
	tween_subir.tween_property(menu_items, "position:y", posicao_final_itens, tempo).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# Esconde o primeiro menu de vez para não atrapalhar cliques
	await tween_subir.finished
	menu_acoes.visible = false

func trocar_para_menu_acoes():
	var tempo = 0.3
	var tween = create_tween().set_parallel(true)
	
	# --- 1. DESCE O MENU DE ITENS (Saindo) ---
	tween.tween_property(menu_items, "modulate:a", 0.0, tempo)
	tween.tween_property(menu_items, "position:y", menu_items.position.y + 50, tempo).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	# --- 2. SOBE O MENU DE AÇÕES (Voltando) ---
	menu_acoes.visible = true
	# menu_acoes.modulate.a = 0.0 # Opcional: garantir que comece invisível
	
	# Espera um pouquinho para o efeito de "sobreposição"
	await get_tree().create_timer(0.1).timeout
	
	var tween_subir = create_tween().set_parallel(true)
	tween_subir.tween_property(menu_acoes, "modulate:a", 1.0, tempo)
	# Retorna para a posição original (posicao_inicial_menu_acoes)
	tween_subir.tween_property(menu_acoes, "position:y",  pos_y_original_menu, tempo).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	await tween_subir.finished
	menu_items.visible = false

func _on_audio_stream_player_2d_finished() -> void:
	music.play()

func _on_button_pressed() -> void:
	trocar_para_menu_itens()


func _on_voltar_pressed() -> void:
	trocar_para_menu_acoes()
