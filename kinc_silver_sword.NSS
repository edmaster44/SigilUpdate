// kinc_silver_sword.nss
/*
	NWN2 OC Silver Sword include
*/

#include "ginc_math"


const string TAG_SILVER_SWORD = "silver_sword";


// Return Silver Sword owned by oPC
object GetSilverSwordOwnedByPC( object oPC );

// Return a unique ID used to identify silver sword spell effects
// * Unique ID based off PC's object ID
int GetSilverSwordUniqueId( object oPC );


// Return Silver Sword owned by oPC
object GetSilverSwordOwnedByPC( object oPC )
{
	object oSword = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oPC );
	
	if ( GetTag( oSword ) != TAG_SILVER_SWORD )
	{
		oSword = GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oPC );
		
		if ( GetTag( oSword ) != TAG_SILVER_SWORD )
		{
			oSword = GetItemPossessedBy( oPC, TAG_SILVER_SWORD );
		}
	}
	
	return ( oSword );
}

// Return a unique ID used to identify silver sword spell effects
// * Unique ID based off PC's object ID
int GetSilverSwordUniqueId( object oPC )
{
	return ( HexStringToInt( ObjectToString( oPC ) ) );
}