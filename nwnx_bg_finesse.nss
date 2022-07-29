#include "nwnx_bg"
#include "x2_inc_itemprop"

void main()
{
	
	// Get item from nwnx that the engine is trying to test
	// whether or not Weapon Finesse applies.
	object oWeapon = nwnx_bg_finesse_GetItem();

	// Engine seems to return 1 if for some reason this object
	// doesn't exist.  We handle this for you before firing
	// this script so no need to check GetIsObjectValid.

	// Value we will ultimately return back to NWNX.
	int bIsFinessable = 0;

	// This script runs on the creature we are testing for finesse.
	object oSelf = OBJECT_SELF;

	// First we must check if the item is a light weapon for
	// the creature wielding it.  A weapon being light or not
	// is relative to the size of the creature.

	// Exception: Whips and Rapiers are always finessable,
	// regardless of relative size.

	// You must check that the Weapon Size isn't greater than
	// Creature Size.  If it is, then you cannot finesse.
	// Creature Size gets +1 if the creature has the feat Monkey Grip.
	// EXCEPTION: Whips and Rapiers always are finessable even if this
	// relative size rule fails.

	// Luckily Rhifox did all this work for us in this function:
	bIsFinessable = IPGetIsFinessableWeapon(oSelf, oWeapon);

	// If we pass the light weapon check, we then only allow
	// certain item base types to be finessable.


	// IP function covers this, but if you wanted to add
	// a further white list you could do so like this:
	

	
		
	switch(GetBaseItemType(oWeapon))
	{

		// These two always pass.
		case BASE_ITEM_WHIP:
		case BASE_ITEM_RAPIER:

		// Finess white list:
		case 160:
		case 161:
		case 162:
		case 163:
		case 164:
		case 165:
		case 170:
		case 173:
		case 202:
		case BASE_ITEM_DAGGER:
		case BASE_ITEM_LIGHTHAMMER:
		case BASE_ITEM_LIGHTMACE:
		case BASE_ITEM_SICKLE:
		case BASE_ITEM_HANDAXE:
		case BASE_ITEM_SHORTSWORD:
		case BASE_ITEM_KUKRI:
		case BASE_ITEM_KAMA:
			bIsFinessable = 1;
		break;

		default:
			bIsFinessable = 0;		

	}
	

	// Tell NWNX whether the item object fetched by nwnx_TestForFinesse()
	// finessable or not.
	nxnx_bg_finesse_set(bIsFinessable);

}