extends Node2D
class_name entity

var life = 1
var move_speed = 3
var entity_name = "player" # we'll change this in the children on ready
var remove_entity = false # use this to count down to remove entity to save memory
var can_hurt = true # this checks if this entity can be hit

onready var ani : AnimatedSprite = $AnimatedSprite
onready var timer : Timer = $Timer

var blood_resource : PackedScene = preload("res://objects/blood_particals.tscn")

func _ready():
	timer.connect("timeout",self,"handle_removing")
	pass # Replace with function body.

func _physics_process(delta):
	if(life > 0):
		handle_movement()
	else:
		handle_death()
	
	if(remove_entity):
		handle_removing()
	
func handle_movement():
	pass
	
func handle_death():
	ani.play(entity_name + "_dead")
	if(find_node("Area2D")!=null):
		z_index = 0 # put zombie under other zombies
		find_node("Area2D").queue_free()
	pass
	
func handle_removing():
	remove_entity = true
	
	modulate.a = lerp(modulate.a,0,0.01)
	if(modulate.a < 0.1):
		queue_free()
	pass
