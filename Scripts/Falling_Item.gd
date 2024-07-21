# 
#    _       _                _          _ _ _       
#   (_)     | |              ( )        (_) | |      
#    _  __ _| | _____    ___ |/ _ __ ___ _| | |_   _ 
#   | |/ _` | |/ / _ \  / _ \  | '__/ _ \ | | | | | |
#   | | (_| |   <  __/ | (_) | | | |  __/ | | | |_| |
#   | |\__,_|_|\_\___|  \___/  |_|  \___|_|_|_|\__, |
#  _/ |                                         __/ |
# |__/                                         |___/ 
# 
# [Script by Jake O'Reilly, Jul 2024]
# 
# github(https://github.com/JakeDaSpud)
# twitter(https://twitter.com/jor_gamedev)

extends RigidBody2D

# Variables

const Item_Size = preload("res://Scripts/Item_Size_Enum.gd").Item_Size;
## How many Units long this Item is
@export var item_size : Item_Size = Item_Size.SINGLE;

@export_category("Categories")
## Is this Item Sweet or Savoury
@export var is_sweet : bool = false;
## Is this Item Glass or Not
@export var is_glass : bool = false;
## Is this Item Food or Drink
@export var is_food : bool = false;
## Is this Item Short (1 Unit) or Long (3 Units)
@export var is_short : bool = false;
## Is this Item Cheese or Not
@export var is_cheese : bool = false;

var _falling_speed : float;
var _impulse_magnitude : float;
var _area_2d : Area2D;
var _should_propel : bool = false;
var _propel_direction : Vector2 = Vector2.ZERO;
const _const_divisor : float = 10;
@onready var Game_Manager : Node2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	if (Game_Manager == null):
		#print_debug("Game man was null");
		Game_Manager = get_node("/root/Main_Game").game_manager_reference as Node2D;
	
	self.collision_mask = 0b11;
	self.collision_layer = 0b11;
	
	_area_2d = self.get_node("./Area2D");
	if (_area_2d == null):
		print_debug("No Area2D Node found.");
	else:
		#print_debug("Area2D Node found.");
		_area_2d.connect("input_event", Callable(self, "_on_area_2d_input_event"));
	
	if (item_size == Item_Size.SINGLE):
		_falling_speed = 50;
		_impulse_magnitude = 3000 / _const_divisor;
	
	elif (item_size == Item_Size.DOUBLE):
		_falling_speed = 30;
		_impulse_magnitude = 2500 / _const_divisor;
	
	elif (item_size == Item_Size.TRIPLE):
		_falling_speed = 10;
		_impulse_magnitude = 2250 / _const_divisor;
	
	else:
		print_debug("How did you mess up an Enum?");
	
	self.linear_velocity = Vector2(0, _falling_speed);
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# You should NOT be there
	if (self.global_position.y > 1000 || self.global_position.y < -500):
		self.queue_free();
		Game_Manager.decrease_item_count();
	
	if (!Game_Manager.get_game_started()):
		_falling_speed = 0.0;
		self.rotation += 1 * delta;
	
	if (_should_propel):
		_propel(Vector2(_propel_direction.x, _propel_direction.y + (_falling_speed * delta)));
		#await get_tree().create_timer(0.01).timeout;
		_should_propel = false;
	else:
		_fall(delta);
	

func _fall(delta) -> void:
	self.apply_impulse(Vector2(0, _falling_speed * delta));

# Sends this Item in the parameter direction
func _propel(direction_vector : Vector2) -> void:
	Game_Manager.play_click();
	self.apply_impulse(direction_vector);
	

# Handle Mouse Inputs
func _on_area_2d_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			
			if (!Game_Manager.game_started):
				Game_Manager.game_started = true;
				Game_Manager.progress_round();
			
			#print_debug("Left mouse button clicked on Area2D");
			
			self.linear_velocity = Vector2.ZERO;
			_propel_direction = ((self.global_position - event.global_position).normalized() * _impulse_magnitude);
			#print_debug("Will propel towards ", ((self.global_position - event.global_position).normalized() * _impulse_magnitude));
			
			# Makes it so that there's no impulsing DOWNWARDS, but it's weird lol
			#if (_propel_direction.y > 0):
			#	_propel_direction.y *= -1;
			
			_should_propel = true;
	
