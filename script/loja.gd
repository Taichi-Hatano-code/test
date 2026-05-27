extends Node2D

@onready var camera = $Camera2D
@onready var music = $AudioStreamPlayer2D
@onready var menu_items = $CanvasLayer/Panel/MenuItens

var dinheiro
var pocoes
var player_dano
var player_vida

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	if camera:
		print("test")
	else: 
		pass
	print("batalha comecou")
	
	dinheiro = Global.player_dinheiro
	pocoes = Global.pocoes
	player_dano = Global.player_dano_global
	player_vida = Global.player_vida_global
	
	print(dinheiro)
	
	music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	pass

func _on_audio_stream_player_2d_finished() -> void:
	music.play()

func _on_pocao_pressed() -> void:
	if dinheiro >= 5:
		pocoes = pocoes + 1
		Global.pocoes = pocoes
		dinheiro = dinheiro - 5
		Global.player_dinheiro = dinheiro
	print(dinheiro)
	print("pocoes")
	print(Global.pocoes)

func _on_dano_pressed() -> void:
	if dinheiro >= 15:
		player_dano = player_dano + 2
		Global.player_dano_global = player_dano
		dinheiro = dinheiro - 15
		Global.player_dinheiro = dinheiro
	print(dinheiro)
	print("dano")
	print(Global.player_dano_global)

func _on_vida_pressed() -> void:
	if dinheiro >= 15:
		player_vida = player_vida + 2
		Global.player_vida_global = player_vida
		dinheiro = dinheiro - 15
		Global.player_dinheiro = dinheiro
	print(dinheiro)
	print("vida")
	print(Global.player_vida_global)

func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/fase1.tscn")
