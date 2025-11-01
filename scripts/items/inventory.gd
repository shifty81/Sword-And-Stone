extends Node
class_name Inventory

## Player inventory system

signal inventory_changed()
signal item_added(item: Item, amount: int)
signal item_removed(item: Item, amount: int)

@export var max_slots: int = 40

var items: Array[Dictionary] = []  # Each entry: {item: Item, amount: int}

func _ready():
	items.resize(max_slots)
	for i in range(max_slots):
		items[i] = {"item": null, "amount": 0}

func add_item(item: Item, amount: int = 1) -> bool:
	# Try to stack with existing items
	for i in range(max_slots):
		if items[i]["item"] and items[i]["item"].item_name == item.item_name:
			var space_left = item.max_stack_size - items[i]["amount"]
			if space_left > 0:
				var add_amount = min(space_left, amount)
				items[i]["amount"] += add_amount
				amount -= add_amount
				
				if amount <= 0:
					item_added.emit(item, add_amount)
					inventory_changed.emit()
					return true
	
	# Add to empty slot
	while amount > 0:
		var empty_slot = find_empty_slot()
		if empty_slot == -1:
			return false  # Inventory full
		
		var add_amount = min(item.max_stack_size, amount)
		items[empty_slot]["item"] = item
		items[empty_slot]["amount"] = add_amount
		amount -= add_amount
	
	item_added.emit(item, amount)
	inventory_changed.emit()
	return true

func remove_item(item: Item, amount: int = 1) -> bool:
	var removed = 0
	
	for i in range(max_slots):
		if items[i]["item"] and items[i]["item"].item_name == item.item_name:
			var remove_amount = min(items[i]["amount"], amount - removed)
			items[i]["amount"] -= remove_amount
			removed += remove_amount
			
			if items[i]["amount"] <= 0:
				items[i]["item"] = null
				items[i]["amount"] = 0
			
			if removed >= amount:
				item_removed.emit(item, amount)
				inventory_changed.emit()
				return true
	
	return false

func has_item(item: Item, amount: int = 1) -> bool:
	var count = 0
	
	for i in range(max_slots):
		if items[i]["item"] and items[i]["item"].item_name == item.item_name:
			count += items[i]["amount"]
			
			if count >= amount:
				return true
	
	return false

func find_empty_slot() -> int:
	for i in range(max_slots):
		if items[i]["item"] == null:
			return i
	return -1

func get_item_at_slot(slot: int) -> Dictionary:
	if slot >= 0 and slot < max_slots:
		return items[slot]
	return {"item": null, "amount": 0}

func clear():
	for i in range(max_slots):
		items[i] = {"item": null, "amount": 0}
	inventory_changed.emit()
