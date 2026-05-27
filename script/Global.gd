extends Node

# Variáveis que o Mob vai preencher antes da luta
var inimigo_vida_atual : int = 5
var inimigo_dano_atual : int = 1

# Você também pode salvar a vida do player aqui para ela não resetar toda vez
var player_vida_global : int = 10
var player_dano_global : int = 1
var player_dinheiro : int = 30
var pocoes : int = 1

var posicao_player : Vector2
var inimigo_certo : bool

var inimigo_instancia : Node2D = null # Guarda o 'corpo' do mob
var inimigos_derrotados = [] # Lista de nomes ou IDs
var mob_atual_nome : String = ""

var cena_pos_batalha : PackedScene = null
var caminho_fase_atual : String = ""

var lista_de_fases: Array = [
	"res://scene/fase1.tscn",
	"res://scene/fase2.tscn"
]

# Variável para não repetir a mesma fase duas vezes seguidas
var ultima_fase_index: int = -1

func carregar_proxima_fase_aleatoria():	
	if lista_de_fases.size() == 0:
		return
	
	var novo_index = randi() % lista_de_fases.size()
	
	# Garante que a nova fase não seja igual à anterior
	while novo_index == ultima_fase_index and lista_de_fases.size() > 1:
		print("test")
		novo_index = randi() % lista_de_fases.size()
	
	print(novo_index)
	
	ultima_fase_index = novo_index
	var caminho_da_fase = lista_de_fases[novo_index]
	
	print(caminho_da_fase)
	
	get_tree().change_scene_to_file(caminho_da_fase)
