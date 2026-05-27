extends Node2D

@onready var caverna = $caverna
@onready var vitoria = $AudioStreamPlayer2D
@export var total_botoes_necessarios: int = 6 # Você define isso no Inspector
@export var tilemap_porta: TileMapLayer # Arraste seu TileMap aqui
@export var coordenadas_porta: Array[Vector2i] = [Vector2i(10, 5), Vector2i(10, 6)] # Coordenadas X,Y dos tiles da porta

var botoes_ativos_agora : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.caminho_fase_atual = scene_file_path
	
	fade_in_fase(1.5)
	
	if Global.posicao_player != Vector2.ZERO:
		$Player.global_position = Global.posicao_player
	caverna.play()
	
	$Player.global_position = $SpawnPoint.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func transicao_para_batalha():
	if has_node("CanvasLayer/BlurLayer"):
		var blur = $CanvasLayer/BlurLayer
		blur.visible = true
		
		var tween = create_tween()
		# Anima o parâmetro 'lod' para embaçar
		tween.tween_property(blur.material, "shader_parameter/lod", 3.5, 0.6)
		# Escurece a tela pela metade (cinza)
		tween.parallel().tween_property(blur, "modulate", Color(0.5, 0.5, 0.5, 1.0), 0.6)
		
		await tween.finished
	
		get_tree().change_scene_to_file("res://scene/combate.tscn")
	else:
		print("error")

func fade_in_fase(tempo: float = 1.5):
	if has_node("CanvasLayer/BlurLayer"):
		var blur = $CanvasLayer/BlurLayer
		blur.visible = true
		
		# Estado inicial: Embaçado e Escuro
		blur.material.set_shader_parameter("lod", 3.5)
		blur.modulate = Color(0.0, 0.0, 0.0, 1.0) # Começa preto total
		
		var tween = create_tween()
		# Anima para ficar nítido
		tween.tween_property(blur.material, "shader_parameter/lod", 0.0, tempo)
		# Anima para as cores voltarem ao normal
		tween.parallel().tween_property(blur, "modulate", Color(1, 1, 1, 1), tempo)
		
		await tween.finished
		blur.visible = false # Esconde para economizar processamento
	else:
		print("error")

func fade_out_total(tempo: float = 1.0):
	if has_node("CanvasLayer/BlurLayer"):
		var blur = $CanvasLayer/BlurLayer
		blur.visible = true
		var tween = create_tween()
		tween.tween_property(blur, "modulate", Color(0, 0, 0, 1), tempo)
		await tween.finished
	else:
		print("Erro: Nó de transição não encontrado!")

func verificar_puzzle():
	print("Progresso: ", botoes_ativos_agora, "/", total_botoes_necessarios)
	
	if botoes_ativos_agora >= total_botoes_necessarios:
		ganhar_puzzle()
		vitoria.play()

func ganhar_puzzle():
	print("Dungeon Resolvida! A porta se abriu.")
	# Verificação 1: O TileMapLayer foi arrastado para o Inspector?
	if tilemap_porta == null:
		print("ERRO: Você esqueceu de arrastar o TileMapLayer para a variável 'tilemap_porta' no Inspector!")
		return

	# Verificação 2: Existem coordenadas na lista?
	if coordenadas_porta.size() == 0:
		print("ERRO: A lista 'coordenadas_porta' está vazia no Inspector!")
		return

	# Se passou pelas verificações, tenta apagar
	for coord in coordenadas_porta:
		print("Tentando apagar o tile na coordenada: ", coord)
		# No TileMapLayer (Godot 4), a função correta é essa:
		tilemap_porta.set_cell(coord, -1)
	
	print("Porta processada com sucesso!")
	
	# Opcional: Tocar um som de pedra abrindo ou tremer a tela
	vitoria.play()
	# Aqui você coloca o código para abrir a porta ou tocar som de vitória

func _on_audio_stream_player_2d_finished() -> void:
	caverna.play()

func _on_botao_bloco_encaixou():
	botoes_ativos_agora += 1
	verificar_puzzle()
	print(botoes_ativos_agora)

func _on_botao_bloco_desencaixou():
	botoes_ativos_agora -= 1
	verificar_puzzle()
	print(botoes_ativos_agora)

func _on_botao_2_bloco_encaixou() -> void:
	botoes_ativos_agora += 1
	verificar_puzzle()
	print(botoes_ativos_agora)


func _on_botao_2_bloco_desencaixou() -> void:
	botoes_ativos_agora -= 1
	verificar_puzzle()
	print(botoes_ativos_agora)


func _on_botao_3_bloco_encaixou() -> void:
	botoes_ativos_agora += 1
	verificar_puzzle()
	print(botoes_ativos_agora)

func _on_botao_3_bloco_desencaixou() -> void:
	botoes_ativos_agora -= 1
	verificar_puzzle()
	print(botoes_ativos_agora)


func _on_botao_4_bloco_encaixou() -> void:
	botoes_ativos_agora += 1
	verificar_puzzle()
	print(botoes_ativos_agora)

func _on_botao_4_bloco_desencaixou() -> void:
	botoes_ativos_agora -= 1
	verificar_puzzle()
	print(botoes_ativos_agora)


func _on_botao_5_bloco_encaixou() -> void:
	botoes_ativos_agora += 1
	verificar_puzzle()
	print(botoes_ativos_agora)

func _on_botao_5_bloco_desencaixou() -> void:
	botoes_ativos_agora -= 1
	verificar_puzzle()
	print(botoes_ativos_agora)


func _on_botao_6_bloco_encaixou() -> void:
	botoes_ativos_agora += 1
	verificar_puzzle()
	print(botoes_ativos_agora)

func _on_botao_6_bloco_desencaixou() -> void:
	botoes_ativos_agora -= 1
	verificar_puzzle()
	print(botoes_ativos_agora)
