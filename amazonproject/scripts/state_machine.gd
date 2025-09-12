extends Node2D

var states: Dictionary = {}
var current_state: State 

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.Transitioned.connect(on_child_transition)
			
func _process(delta: float) -> void:
		if current_state:
			current_state.Update(delta)

func _physics_process(delta: float) -> void: 
		if current_state:
			current_state.Physics_Update(delta)
