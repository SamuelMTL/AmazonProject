extends CharacterBody2D

var player: Node2D
var fire_attack_component = preload("res://Components/BossAttacks/FireAttack/BossFireAttack.tscn")

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func use_fire_attack(player: Node2D):
	var amount = 5
	var radius = 120
	
	for i in amount: 
		var fire = fire_attack_component.instantiate()
		
		var offset = Vector2(
			randf_range(-radius, radius),
			randf_range(-radius, radius)
		)
		
		if offset.length() > radius:
			offset = offset.normalized() * radius
			
		fire.position = player.position + offset
		get_tree().current_scene.add_child(fire)
	
	
func _on_fire_attack_timeout() -> void:
	use_fire_attack(player)
