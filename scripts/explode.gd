extends AnimatedSprite

var aim_dir
var spd = 15 

func _physics_process(delta):
	spd = lerp(spd,0,0.05)
	global_position += aim_dir * spd
	
	if(frame > 10 and frame < 20):
		for zombie in get_tree().get_nodes_in_group("zombie"):
			if(global_position.distance_to(zombie.global_position) < 130):
				zombie.life = 0
				zombie.timer.start(1)
	
	if(spd < 0.04):
		if(animation != "explode"):
			$explode_sound.pitch_scale = rand_range(0.9,1.1)
			$explode_sound.play()
			play("explode")

func _on_AnimatedSprite_animation_finished():
	if(animation == "explode"):
		queue_free()
	pass # Replace with function body.
