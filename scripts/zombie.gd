extends entity

var player : entity

onready var moan_timer : Timer = $moan_timer
onready var moan_sound : AudioStreamPlayer = $moan_sound
var moan_frequency = [5,15] # min time, max time

export(Array, AudioStream) var sounds

func _ready():
	moan_timer.connect("timeout",self,"moan_timeout")
	moan_timer.start(rand_range(1,moan_frequency[1]))
	life = 3
	move_speed = rand_range(0.5,2)
	entity_name = "zombie" + str(randi()%3+1) # so this is either zombie1 or zombie2
	
	var player_nodes = get_tree().get_nodes_in_group("player")
	player = player_nodes[0] #get player from group player
	
	ani.speed_scale = rand_range(0.9,1.1) #makes the animation less jaring
	pass # Replace with function body.

func handle_movement():
	ani.play(entity_name + "_walk")
	
	look_at(player.global_position)
	
	global_position = global_position.move_toward(player.global_position,move_speed)
	
	if(global_position.distance_to(player.global_position) < 50):
		if(player.can_hurt):
			player.do_hurt()
	
func moan_timeout():
	if(life > 0):
		moan_sound.stream = sounds[randi()%4]
		moan_sound.pitch_scale = rand_range(0.2,1.6)
		moan_sound.play()
		moan_timer.start(rand_range(moan_frequency[0],moan_frequency[1]))
	
