/* Chunk management system for weather; We essentially cache a list of atoms in an area (obj or mobs)
 * that we can then reference with a key. This is better than checking them all at once.
 * I believe Mobs/items are generally more extensive to iterate than areas.
*/


#define CHUNK_SIZE 8 //8x8 is considered a chunk.

/datum/weather/chunking
	name = "Chunk System"


	var/list/chunks = list()  /// Chunk keys and atoms contained, Ex. [4_6_1], [x_y_z]
	var/list/turf_chunks = list() // Chunk keys and exposed turfs contained.

//Registering/Deregistering

// Added a helper function to validate if an atom is valid for chunking
/datum/weather/chunking/proc/is_valid_atom(atom/movable/Q)
	if(!Q || !get_area(Q) || !get_area(Q).outdoors)
		return FALSE
	return TRUE

// Updated register to use the helper function
/datum/weather/chunking/proc/register(atom/movable/Q)
	if(!is_valid_atom(Q))
		return

	var/key = get_chunk_key(Q)
	if(!(key in src.chunks))
		src.chunks[key] = list()
	src.chunks[key] += Q

// Updated unregister to handle edge cases
/datum/weather/chunking/proc/unregister(atom/movable/Q) //Keep Q for clarity
	if(!Q)
		return

	var/key = get_chunk_key(Q)
	if(key in src.chunks)
		src.chunks[key] -= Q
		if(!src.chunks[key].len)
			src.chunks -= key

//Keys and Coords

/datum/weather/chunking/proc/get_chunk_coords(atom/movable/Q) //Maybe misleading name, gets the chunk based on coords and chunk size.
	return list(
		round(Q.x / CHUNK_SIZE),
		round(Q.y / CHUNK_SIZE),
		Q.z
	)

/datum/weather/chunking/proc/get_chunk_key(atm/movable/Q) //Converts coordinates into key.
	var/list/coords = src.get_chunk_coords(Q)
	return "[coords[1]]_[coords[2]]_[coords[3]]"

//Utilities

/datum/weather/chunking/proc/update_atom_location(atom/movable/Q) //Detecting when atom moves between chunks, unregisters old, registers new.
	var/area/A = get_area(Q)
	if(!Q || !A.outdoors)
		return

	var/key_now = get_chunk_key(Q)
	if(key_now != Q.last_weather_chunk_key)
		if(Q.last_weather_chunk_key)
			unregister(Q)
		register(Q)
		Q.last_weather_chunk_key = key_now //defined where?

// Improved get_nearby_atoms to handle edge cases and optimize performance
/datum/weather/chunking/proc/get_nearby_atoms(atom/origin, radius_in_chunks = 1) //Returns combined list of atoms in square of surrounding chunks
	if(!origin)
		return list()

	var/list/center = get_chunk_coords(origin)
	var/list/results = list()

	for(var/dx = -radius_in_chunks to radius_in_chunks)
		for(var/dy = -radius_in_chunks to radius_in_chunks)
			var/x = center[1] + dx
			var/y = center[2] + dy
			var/z = center[3]
			var/key = "[x]_[y]_[z]"
			if(key in src.chunks)
				results += src.chunks[key]

	return results

// 3 by 3 grid around executed chunk, so 9 chunks total. * = chunk, x = center (also chunk)
/*

* * *
* x *
* * *

*/

// Added a utility to count total atoms in all chunks
/datum/weather/chunking/proc/count_total_atoms()
	var/total = 0
	for(var/list/atoms in src.chunks)
		total += atoms.len
	return total

// Improved get_mobs_in_chunks to avoid redundant checks
/datum/weather/chunking/proc/get_mobs_in_chunks(list/chunk_keys)
	var/list/results = list()
	for(var/key in chunk_keys)
		if(key in src.chunks)
			for(var/atom/movable/Q in src.chunks[key])
				if(ismob(Q))
					results += Q
	return results

// Improved get_objects_in_chunks to avoid redundant checks
/datum/weather/chunking/proc/get_objects_in_chunks(list/chunk_keys)
	var/list/results = list()
	for(var/key in chunk_keys)
		if(key in src.chunks)
			for(var/atom/movable/Q in src.chunks[key])
				if(isobj(Q))
					results += Q
	return results

// Added a utility to clear all chunks
/datum/weather/chunking/proc/clear_all_chunks()
	src.chunks = list()
	src.turf_chunks = list()

// Added a utility to debug chunk contents
/datum/weather/chunking/proc/debug_chunks()
	for(var/key in src.chunks)
		world.log << "Chunk [key]: [src.chunks[key].len] atoms"

//Same as above but now we're reusing logic for Turfs.
//Weather coverage will handle init turf exposure determination, and then pass it here, chunking will handle distributing it to everyone else (Profiles, Effects, Subsystem, etc)

// Improved register_exposed_turf to validate turfs
/datum/weather/chunking/proc/register_exposed_turf(turf/T)
	if(!T || !T.z || !T.blocks_weather || !get_area(T) || !get_area(T).outdoors)
		return

	var/key = get_turf_chunk_key(T)
	if(!(key in src.turf_chunks))
		src.turf_chunks[key] = list()
	src.turf_chunks[key] += T

// Improved unregister_exposed_turf to handle edge cases
/datum/weather/chunking/proc/unregister_exposed_turf(turf/T)
	if(!T)
		return

	var/key = get_turf_chunk_key(T)
	if(key in src.turf_chunks)
		src.turf_chunks[key] -= T
		if(!src.turf_chunks[key].len)
			src.turf_chunks -= key

/datum/weather/chunking/proc/get_turf_chunk_coords(turf/T)
	return list(
		round(T.x / CHUNK_SIZE),
		round(T.y / CHUNK_SIZE),
		T.Z
		)

/datum/weather/chunking/proc/get_turf_chunk_key(turf/T)
	var/list/coords = src.get_turf_chunk_coords(T)
	return "[coords[1]]_[coords[2]]_[coords[3]]"

/datum/weather/chunking/proc/get_turfs_in_chunks(list/chunk_keys)
	var/list/results = list()
	for (var/key in chunk_keys)
		if (key in src.turf_chunks)
			results += src.turf_chunks[key]
	return results

/datum/weather/chunking/proc/get_all_turf_chunk_keys()
	. = list()
	for (var/key in src.turf_chunks)
		. += key

// Added a utility to count total turfs in all chunks
/datum/weather/chunking/proc/count_total_turfs()
	var/total = 0
	for(var/list/turfs in src.turf_chunks)
		total += turfs.len
	return total

/datum/controller/subsystem/weather_chunking/proc/on_turf_created(turf/T)
	if (!T || !T.z) return

	var/turf/below = locate(T.x, T.y, T.z - 1)
	if (!below) return

	if (T.blocks_weather)
		// Turf now blocks weather; below is no longer exposed
		if (below.cover_cache != COVERED)
			below.cover_cache = COVERED
			exposed_turfs -= below
			unregister_exposed_turf(below)

		else
			return


/datum/controller/subsystem/weather_chunking/proc/on_turf_destroyed(turf/T)
	if (!T || !T.z) return

	var/turf/below = locate(T.x, T.y, T.z - 1)
	if (!below) return

	if (!T.blocks_weather)
		// Turf that was destroyed didn't block weather, no effect
		return

	// Turf that blocked weather is now gone; below might be exposed
	var/turf/above = locate(T.x, T.y, T.z)
	if (!above || !above.blocks_weather)
		if (below.cover_cache != UNCOVERED)
			below.cover_cache = UNCOVERED
			exposed_turfs |= below
			register_exposed_turf(below)
