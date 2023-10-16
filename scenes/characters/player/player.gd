extends CharacterBody2D

@export var move_speed : float = 42.0

var doing_action : bool = false #for disabling input

@onready var sprite : Sprite2D = $Sprite
@onready var interaction_label : Label = $Interacter/InteractionLabel
@onready var interactions : Array = []

func _physics_process(_delta) -> void:
	if not doing_action:
		move_player()
		do_interaction()

func move_player() -> void:
	var move_direction : Vector2 = Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")
	
	if move_direction.x > 0 and sprite.flip_h:
		sprite.flip_h = false
	elif move_direction.x < 0 and not sprite.flip_h:
		sprite.flip_h = true
	
	velocity = move_speed * move_direction
	move_and_slide()

func update_interactions() -> void:
	if interactions:
		interaction_label.text = interactions[0].interact_text
	else:
		interaction_label.text = ""

func do_interaction() -> void:
	if interactions and Input.is_action_just_pressed("Action"):
		var current_interaction : Interaction_Area = interactions[0]
		match current_interaction.interact_type:
			"Dialogue":
				print("Dialogue: " + current_interaction.interact_value)
			"Take":
				print("Take: " + current_interaction.interact_value)

func _on_interacter_area_area_entered(area) -> void:
	interactions.insert(0, area)
	update_interactions()

func _on_interacter_area_area_exited(area) -> void:
	interactions.erase(area)
	update_interactions()