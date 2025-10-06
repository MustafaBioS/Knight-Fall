extends CharacterBody3D


const SPEED = 7.0
const JUMP_VELOCITY = 4.5
var sell_dialogue = preload("res://shop.dialogue")
var sensitivity = 0.003
var cd = false
@onready var camera = $FP
@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer
@onready var HP = $HUD/HPBar
@onready var Coin = $HUD/CoinLabel
@onready var invdisplay = $HUD/TextureRect2
@onready var inv = $HUD/TextureRect2/Inventory
@onready var bottle = $bottlePurp
@onready var sword = $FP/SwordPoint


var gold = GameState.coins
var hp = 100
var mhp = 100
var damage = 30
var target = []
var inventory = GameState.inventory
@export var dialogue: DialogueResource;

func player():
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(70))

func _ready():
	HP.max_value = 100
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _attack():
	if Input.is_action_just_pressed('attack') and cd == false:
		animation_player.play("SwordSwing")
		cd = true
		timer.start()

func _update_hud():
	HP.value = hp
	Coin.text = str(gold) 

func _process(delta):
	_update_hud()
	_attack()
	_view_inv()
	_switch()
	inv.text = "\n".join(inventory)
	if Input.is_action_just_pressed('escape'):
		get_tree().quit()

func _deal_dmg():
	for enemies in target:
		enemies.hp -= damage

func buy_item(cost, item_name):
	if gold >= cost:
		gold -= cost
		inventory.append(item_name)

func _on_timer_timeout():
	cd = false

func start_sell_dialogue():
	var dialogue_instance = DialogueManager.show_dialogue_balloon(sell_dialogue)

func _switch():
	if bottle.visible == false:
		if Input.is_action_just_pressed("switch"):
			sword.visible = false
			bottle.visible = true
	elif bottle.visible == true:
		if Input.is_action_just_pressed("switch"):
			bottle.visible = false
			sword.visible = true

func _view_inv():
	if Input.is_action_just_pressed("inv"):
		invdisplay.visible = !invdisplay.visible

func _on_attack_zone_body_entered(body: Node3D) -> void:
	if body.has_method("enemy"):
		target.append(body)
func _on_attack_zone_body_exited(body: Node3D) -> void:
	if body.has_method("enemy"):
		target.erase(body)
