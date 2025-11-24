extends Control

@onready var menu_buttons = $"MenuButtons"
# Tela de Ajustes (usar no Menu de Pause)
@onready var ajustes_scene = $"AjustesScene"

func _ready() -> void:
	var background = ajustes_scene.get_node("Background")
	var back_btn = ajustes_scene.get_node("MainMenuButton")
	# Ocultar background da Tela de Ajustes
	background.texture = null
	
	if back_btn:
		back_btn.next_scene = ""
		back_btn.click_finished.connect(_on_voltar_dos_ajustes)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		# Garantir Tela de Ajustes FECHADA antes de abrir Menu de Pause
		if ajustes_scene.visible:
			_on_voltar_dos_ajustes()
		else:
			get_tree().paused = true
			visible = true

func _on_continuar_pressed() -> void:
	await get_tree().create_timer(0.3).timeout # Delay pro som do botão
	visible = false
	get_tree().paused = false

func _on_ajustes_pressed() -> void:
	await get_tree().create_timer(0.3).timeout
	menu_buttons.visible = false
	ajustes_scene.visible = true

func _on_sair_pressed() -> void:
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()

# Sair da Tela de Ajustes (e ir para Menu de Pause)
func _on_voltar_dos_ajustes() -> void:
	menu_buttons.visible = true
	ajustes_scene.visible = false
