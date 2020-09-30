extends AnimatedSprite

var count = 0
func _ready():
	playing = true

func _on_AnimatedSprite_frame_changed():
	count += 1
	if(count == 2):
		Game.change_state(Game.game_state.set_up_wave)
		queue_free()
	
	pass # Replace with function body.
