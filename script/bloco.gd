extends CharacterBody2D

@export var textura_bloco: Texture2D
@export var friccao: float = 0.15

@export var id_identidade: String = "Bloco"

func _ready():
	# Quando o jogo começa, ele coloca a imagem que você escolheu no Sprite
	if textura_bloco:
		$Sprite2D.texture = textura_bloco

func _physics_process(delta: float) -> void:
	velocity = lerp(velocity, Vector2.ZERO, friccao)
	move_and_slide()

# Função que o Player vai chamar para empurrar
func empurrar(velocidade_do_player: Vector2):
	# O 0.5 serve para a pedra ser mais lenta que o player
	var direcao = velocidade_do_player.normalized()
	velocity = direcao * 120
