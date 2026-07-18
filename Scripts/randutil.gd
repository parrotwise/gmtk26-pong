extends Node


var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func randfloat(range_min: float = 0.0, range_max: float = 1.0) -> float:
	return rng.randf_range(min(range_min, range_max), max(range_min, range_max))


func randint(range_min: int = 0, range_max: int = 4294967295) -> int:
	return rng.randi_range(min(range_min, range_max), max(range_min, range_max))


func randindex(array: Array) -> int:
	return randint(0, array.size() - 1)


func randsample(array: Array) -> Variant:
	return array[randindex(array)] if array else null


func shuffle(array: Array) -> Array:
	var elements: Array = array.duplicate()
	var shuffled: Array = []
	while elements:
		shuffled.append(elements.pop_at(randindex(elements)))
	return shuffled
