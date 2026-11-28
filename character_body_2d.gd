extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var SPEED = 400.0
const JUMP_VELOCITY = -550.0
const ACCEL = 1500.0
var dead = false
var jump_multiplier = 1.0
const COYOTE_TIME = 0.30
var coyote: float = 0.0
var spawn_point = Vector2.ZERO
@export var gear_texture: Texture2D
var character_direction : Vector2
var player_gravity: float = 1000.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if is_on_floor():
		SPEED = 200
	if not is_on_floor():
		velocity.y += player_gravity * delta
		SPEED = 175

	if is_on_floor() or is_on_wall_only():
		coyote = COYOTE_TIME
	else:
		coyote -= delta

	# Handle jump
	if Input.is_action_just_pressed("ui_up") and coyote > 0:
		velocity.y = JUMP_VELOCITY * jump_multiplier
		coyote = 0.0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward (velocity.x, direction * SPEED, ACCEL * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if is_on_wall_only() and velocity.y > 0:
		player_gravity = 75
	else:
		player_gravity = get_gravity().y

	if not is_on_floor():
		sprite_2d.animation = 'jump'
	elif direction != 0:
		sprite_2d.animation = 'walk'
	else:
		sprite_2d.animation = 'idle'
	
	if global_position.y > 635:
		death()
#	var was_on_floor = is_on_floor()
	move_and_slide()
#	if not was_on_floor and is_on_floor():
#		_on_land()
		
	var isRight = velocity.x > 0
	if velocity.x != 0:
		sprite_2d.flip_h = isRight

func _ready():
	spawn_point = global_position
	player_gravity = get_gravity().y

func activate_jump_boost():
	jump_multiplier = 1.2
	
func death():
	if dead:
		return
	dead = true
	$Sprite2D.hide()
	set_physics_process(false)
	$deathring.show()
	$AnimationPlayer.play("deathani")
	$Camera2D.add_trauma(1.0)
	await get_tree().create_timer(0.8).timeout
	while not Input.is_anything_pressed():
		await get_tree().process_frame
	spawn_player(spawn_point)
	
func _process(delta: float) -> void:
	$deathring.rotation += 3 * delta

func set_checkpoint(pos):
	spawn_point = pos

func spawn_player(pos):
	#var tween = create_tween()
	#$AnimationPlayer.play_backwards("deathani")
	#tween.tween_property($deathring, "global_position", spawn_point, 0.2)
	#await tween.finished
	$Camera2D.add_trauma(0.7)
	global_position = spawn_point
	$deathring.position = Vector2.ZERO
	velocity = Vector2.ZERO
	$deathring.hide()
	var tween2 = create_tween().set_parallel(true).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	var gears: Array[Sprite2D] = []
	for i in 14:
		var g = Sprite2D.new()
		g.texture = gear_texture
		g.scale = Vector2(0.15, 0.15) # Adjust to make the gears small like pixels
		g.position = Vector2(randf_range(-75, 75), randf_range(-75, 75))
		add_child(g)
		gears.append(g)
		tween2.tween_property(g, "position", Vector2(0, -10), 0.22)
		tween2.tween_property(g, "rotation", randf_range(-4.0, 4.0), 0.22)

	await tween2.finished

	for g in gears:
		g.queue_free()
	set_physics_process(true)
	await get_tree().physics_frame
	dead = false
	$Sprite2D.show()
	
#func _on_land():
#	$Sprite2D.scale = Vector2(0.78, 0.42) # 0.6 * 1.3 and 0.6 * 0.7
#	var t = create_tween()
#	t.tween_property($Sprite2D, "scale", Vector2(0.6, 0.6), 0.2).set_trans(Tween.TRANS_ELASTIC)
	
