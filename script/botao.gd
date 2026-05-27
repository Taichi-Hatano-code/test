extends Area2D

@export var textura_normal: Texture2D
@export var textura_pressionado: Texture2D
@onready var click = $click

signal bloco_encaixou    # Grita: "Soma 1!"
signal bloco_desencaixou # Grita: "Subtrai 1!"

@export var id_esperado: String = "Bloco"

var pressionado = false

func _ready():
	if textura_normal:
		$Sprite2D.texture = textura_normal

func _on_body_entered(body: Node2D) -> void:
	
	# Verificamos se o que entrou na área é o Bloco
	if "id_identidade" in body and body.id_identidade == id_esperado:
		if not pressionado:
			pressionado = true
			$Sprite2D.texture = textura_pressionado
			bloco_encaixou.emit() # Avisa que somou
			click.play()
		
		print("O bloco correto: ", id_esperado, " chegou!")
	else:
		$Sprite2D.texture = textura_pressionado
		click.play()
		print("Bloco errado! Eu espero o: ", id_esperado)

func _on_body_exited(body: Node2D) -> void:
	if "id_identidade" in body and body.id_identidade == id_esperado:
		if pressionado:
			pressionado = false
			$Sprite2D.texture = textura_normal
			bloco_desencaixou.emit()
	else:
		$Sprite2D.texture = textura_normal
