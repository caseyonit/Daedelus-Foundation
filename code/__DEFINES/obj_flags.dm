// Flags for the obj_flags var on /obj


#define EMAGGED (1<<0)
#define IN_USE (1<<1) // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
#define CAN_BE_HIT (1<<2) //can this be bludgeoned by items?
#define DANGEROUS_POSSESSION (1<<3) //Admin possession yes/no
#define UNIQUE_RENAME (1<<4) // can you customize the description/name of the thing?
#define SECRET_EXAMINE (1<<5) //Will never generate visible examine messages. Used for stuff like playing card hands.
#define BLOCK_Z_OUT_DOWN (1<<6)  // Should this object block z falling from loc?
#define BLOCK_Z_OUT_UP (1<<7) // Should this object block z uprise from loc?
#define BLOCK_Z_IN_DOWN (1<<8) // Should this object block z falling from above?
#define BLOCK_Z_IN_UP (1<<9) // Should this object block z uprise from below?
#define BLOCK_Z_FALL (1<<10) // Should this object block falling?
#define NO_BUILD (1<<11) // Can we build on this object?
#define PLASMAGUARD (1<<12) //Immune to plasma contamination

// If you add new ones, be sure to add them to /obj/Initialize as well for complete mapping support

// Flags for the item_flags var on /obj/item

#define BEING_REMOVED (1<<0)
#define IN_INVENTORY (1<<1) //is this item equipped into an inventory slot or hand of a mob? used for tooltips
#define FORCE_STRING_OVERRIDE (1<<2) // used for tooltips
///Used by security bots to determine if this item is safe for public use.
#define NEEDS_PERMIT (1<<3)
#define SLOWS_WHILE_IN_HAND (1<<4)
#define NO_MAT_REDEMPTION (1<<5) // Stops you from putting things like an RCD or other items into an ORM or protolathe for materials.
#define DROPDEL (1<<6) // When dropped, it calls qdel on itself
#define NOBLUDGEON (1<<7) // when an item has this it produces no "X has been hit by Y with Z" message in the default attackby()
#define ABSTRACT (1<<9) // for all things that are technically items but used for various different stuff <= wow thanks for the fucking insight sherlock
#define IMMUTABLE_SLOW (1<<10) // When players should not be able to change the slowdown of the item (Speed potions, etc)
#define IN_STORAGE (1<<11) //is this item in the storage item, such as backpack? used for tooltips
#define SURGICAL_TOOL (1<<12) //Tool commonly used for surgery: won't attack targets in an active surgical operation on help intent (in case of mistakes)
#define HAND_ITEM (1<<14) // If an item is just your hand (circled hand, slapper) and shouldn't block things like riding
#define EXAMINE_SKIP (1<<15) // Makes the Examine proc not read out this item.
#define XENOMORPH_HOLDABLE (1<<16) // A Xenomorph can hold this item.
#define NO_PIXEL_RANDOM_DROP (1<<17) //if dropped, it wont have a randomized pixel_x/pixel_y
///Can be equipped on digitigrade legs.
#define IGNORE_DIGITIGRADE (1<<18)
/// Has contextual screentips when HOVERING OVER OTHER objects
#define ITEM_HAS_CONTEXTUAL_SCREENTIPS (1 << 19)
/// Does not leave fingerprints or fibers on attack
#define NO_EVIDENCE_ON_ATTACK (1<<20)

// Flags for the clothing_flags var on /obj/item/clothing
/// SUIT and HEAD items which stop lava from hurting the wearer
#define LAVAPROTECT (1<<0)
/// SUIT and HEAD items which stop pressure damage. To stop you taking all pressure damage you must have both a suit and head item with this flag.
#define STOPSPRESSUREDAMAGE (1<<1)
/// Blocks the effect that chemical clouds would have on a mob --glasses, mask and helmets ONLY!
#define BLOCK_GAS_SMOKE_EFFECT (1<<2)
/// mask allows internals
#define MASKINTERNALS (1<<3)
/// mask filters toxins and other harmful gases
#define GAS_FILTERING (1<<4)
/// prevents syringes, parapens and hypos if the external suit or helmet (if targeting head) has this flag.
/// Example: space suits, biosuit, bombsuits, thick suits that cover your body.
#define THICKMATERIAL (1<<5)
/// The voicebox in this clothing can be toggled.
#define VOICEBOX_TOGGLABLE (1<<6)
/// The voicebox is currently turned off.
#define VOICEBOX_DISABLED (1<<7)
/// Prevents shovies against a dense object from knocking the wearer down.
#define BLOCKS_SHOVE_KNOCKDOWN (1<<8)
/// Prevents knock-off from things like hat-throwing.
#define SNUG_FIT (1<<9)
/// Hats with negative effects when worn (i.e the tinfoil hat).
#define ANTI_TINFOIL_MANEUVER (1<<10)
/// Clothes that cause a larger notification when placed on a person.
#define DANGEROUS_OBJECT (1<<11)
/// Clothes that use large icons, for applying the proper overlays like blood
#define LARGE_WORN_ICON (1<<12)
/// Clothes that block speech (i.e the muzzle). Can be applied to any clothing piece.
#define BLOCKS_SPEECH (1<<13)
/// prevents from placing on plasmaman helmet
#define STACKABLE_HELMET_EXEMPT (1<<14)
/// Usable as casting clothes by wizards (only matters for suits and headwear)
#define CASTING_CLOTHES (1<<15)
/// This head clothing can deliver air from an airtank
#define HEADINTERNALS (1<<16)
/// Does not leave fibers behind
#define FIBERLESS (1<<17)

/// Integrity defines for clothing (not flags but close enough)
#define CLOTHING_PRISTINE 0 // We have no damage on the clothing
#define CLOTHING_DAMAGED 1 // There's some damage on the clothing but it still has at least one functioning bodypart and can be equipped
#define CLOTHING_SHREDDED 2 // The clothing is useless and cannot be equipped unless repaired first

/// Flags for the pod_flags var on /obj/structure/closet/supplypod
#define FIRST_SOUNDS (1<<0) // If it shouldn't play sounds the first time it lands, used for reverse mode

/// Flags for the gun_flags var for firearms
#define TOY_FIREARM_OVERLAY (1<<0) // If update_overlay would add some indicator that the gun is a toy, like a plastic cap on a pistol
/// Currently used to identify valid guns to steal
#define NOT_A_REAL_GUN (1<<1)
/// Can't fire with akimbo
#define NO_AKIMBO (1<<2)

/// Flags for sharpness in obj/item
#define SHARP_EDGED (1<<0)
#define SHARP_POINTY (1<<1)
