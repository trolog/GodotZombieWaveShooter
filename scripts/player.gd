#Player Script
extends entity

onready var ray_shoot : RayCast2D = $RayCast2D
onready var flash_timer : Timer = $flash/Timer

var gran : PackedScene = preload("res://objects/explode.tscn")
var player_dead = false # we'll flag this to stop repeating death related issues

func _ready():
	get_parent().get_node("background_loop").play()
	entity_name = "player"
	life = 5
	pass
	
func handle_movement():
	#angle towards the cursor while alive
	look_at(get_global_mouse_position())
	
	var move_hori = (int(Input.is_action_pressed("d")) - int(Input.is_action_pressed("a"))) * move_speed
	var move_vert = (int(Input.is_action_pressed("s")) - int(Input.is_action_pressed("w"))) * move_speed
	global_position.x += move_hori
	global_position.y += move_vert
	
	global_position.x = clamp(global_position.x,0,1200)
	global_position.y = clamp(global_position.y,0,900)
	
	if(abs(move_hori) > 0 or abs(move_vert) > 0):
		ani.play("player_walk")
	else:
		ani.play("player_idle")
		
	handle_shooting()

	pass
	
func throw_granade():
	var granade = gran.instance()
	granade.global_position = global_position
	granade.aim_dir = global_position.direction_to(get_global_mouse_position())
	get_parent().add_child(granade)

func handle_shooting():
	if(Input.is_action_just_pressed("mb_right")):
		throw_granade()
		
	if(Input.is_action_just_pressed("mb_left")):
		do_shot()
		
	if(Input.is_action_pressed("mb_left") and Input.is_action_pressed("shift")):
		do_shot()
		
	
func do_shot():
	$gunshot_sound.pitch_scale = rand_range(0.9,1.2) # adds a slight pitch change so it's not samey
	$gunshot_sound.play()
	$flash.visible = true
	flash_timer.start(0.1)
	if(ray_shoot.is_colliding()):
		#Get the zombie, make blood and start deletion timer if life < 1
		var zombie : entity = ray_shoot.get_collider().get_parent()
		create_blood(zombie)
		zombie.life -=1
		if(zombie.life < 1):
			zombie.timer.start(1)
#Creates a blood trail at the shooting size, angle from player to zombie and move it along a bit(simple)
func create_blood(zombie : entity):
	var blood_part : Particles2D = blood_resource.instance()
	get_parent().add_child(blood_part)
	#var add_vector = global_position.direction_to(zombie.global_position)
	blood_part.global_position = zombie.global_position
	blood_part.z_index = 100

	
func do_hurt():
	if(player_dead): return
	life -= 1;
	if(life == 0): player_dead = true
	$hurt_player.play()
	can_hurt = false
	modulate.a = 0.5
	yield(get_tree().create_timer(1),"timeout")
	modulate.a = 1
	can_hurt = true


func _on_Timer_timeout():
	$flash.visible = false
	pass # Replace with function body.
