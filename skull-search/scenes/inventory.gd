extends Node2D

# A dictionary to hold item data
var items = {"nothing": 1, "jack":1, "bag":1} #define names of items and set which ones are owned by default
var currentItem = "nothing"

# Max size of the inventory
const MAX_INVENTORY_SIZE = 20

func switchCurrentItem(item_name: String):
	currentItem = item_name

# Function to add an item
func add_item(item_name: String, quantity: int = 1):
	if items.size() < MAX_INVENTORY_SIZE:
		if item_name in items:
			items[item_name] += quantity
		else:
			items[item_name] = quantity
	else:
		print("Inventory full!")

# Function to remove an item
func remove_item(item_name: String, quantity: int = 1):
	if item_name in items:
		items[item_name] -= quantity
		if items[item_name] <= 0:
			items.erase(item_name)
	else:
		print("Item not found!")
		


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("hotbar1"): 
		if items["jack"] > 0:
			switchCurrentItem("jack")
	elif Input.is_action_just_pressed("hotbar2"): 
		if items["bag"] > 0:
			switchCurrentItem("bag")
	elif Input.is_action_just_pressed("hotbar3"): 
		if items["nothing"] > 0:
			switchCurrentItem("nothing")
