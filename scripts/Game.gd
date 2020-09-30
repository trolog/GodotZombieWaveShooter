extends Node

var text_resource = preload("res://objects/text_object.tscn")
var zombie = preload("res://objects/zombie.tscn")

var crossair = load("res://sprites/cross.png")
var wave = 3
var wave_times_this_num = 10

enum game_state{
	set_up_wave = 0,
	playing_wave= 1,
	wave_complete= 2,
	nothing = 3
}

onready var current_state = game_state.playing_wave
var player_nodes 
var player : entity

func _ready():
	Input.set_custom_mouse_cursor(crossair,Input.CURSOR_ARROW,Vector2(17,17))
	player_nodes = get_tree().get_nodes_in_group("player")
	player = player_nodes[0]
	set_up_new_wave()
	
func set_up_new_wave():
	
	for i in range(wave * wave_times_this_num):
		var zomb = zombie.instance()
		var zomb_place : Vector2
		zomb_place = Vector2(rand_range(0,1200),rand_range(0,900))
		if(zomb_place.distance_to(player.global_position) > 240):
			zomb.global_position = zomb_place
			add_child(zomb)
	
	wave += 1
	call_deferred("change_state",game_state.playing_wave)
	#player.call_deferred("can_hurt",true)

func change_state(new_state):
	if(current_state != new_state):
		if(new_state == game_state.wave_complete):
			do_wave_complete_animation()
		if(new_state == game_state.playing_wave):
			check_for_end_wave()
		if(new_state == game_state.set_up_wave):
			set_up_new_wave()
			
		current_state = new_state
		print(current_state)



func _physics_process(delta):
	handle_state_processes(current_state)
	
	if(Input.is_action_just_pressed("esc")):
		get_tree().quit()
	
func handle_state_processes(this_state):
	if(this_state == game_state.playing_wave):
		check_for_end_wave()

func check_for_end_wave():
	if(get_tree().get_nodes_in_group("zombie").size() == 0):
		change_state(game_state.wave_complete)
		
func do_wave_complete_animation():
	var text = text_resource.instance()
	text.global_position = Vector2(600,450)
	.add_child(text)
