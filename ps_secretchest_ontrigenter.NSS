#include "ff_safevar"

///////////////////////////////////////////////////////////////
// ps_secretchest_ontrigenter
//
// 
//
//
// Author:  			Rust
// Date Created:    	26FEB2012
// Date Last Modified:	26FEB2012 for SCOD (Sigil, City of Doors)
// Last Modified By:	Rust
//
// This is a modification of a stock NWN script for creating
// secret objects using a trigger's OnEnter and a Search skill test. 
//
//
// You can use this for either containers or items. 
///////////////////////////////////////////////////////////////
/*
						
History of Changes

	25FEB2012 - Rust
		1. Added calls to destroy the secret object and the trigger
		itself after discovery.  

*/


#include "ginc_misc"

void main()
{
	object oEnteringObject	= GetEnteringObject();
	string sSecretObject	= PS_GetLocalString(OBJECT_SELF, "sSecretItem");
	string sTag				= PS_GetLocalString(OBJECT_SELF, "sSpawnTag");
	int	nSearchDC			= PS_GetLocalInt(OBJECT_SELF, "nSearchDC");
	location lLocation		= GetLocation(GetNearestObjectByTag(sTag, oEnteringObject));
	object oCreatedObject;
		
	if (!PS_IsMarkedAsDone(OBJECT_SELF) && GetIsOwnedByPlayer(oEnteringObject))
		if ((GetDetectMode(oEnteringObject)==DETECT_MODE_ACTIVE
			|| GetRacialType(oEnteringObject)==RACIAL_TYPE_ELF)
			&& GetSkillRank(SKILL_SEARCH, oEnteringObject)>=nSearchDC)
		{
			AssignCommand(oEnteringObject, PlayVoiceChat(VOICE_CHAT_LOOKHERE));
			oCreatedObject = CreateObject(OBJECT_TYPE_ITEM, sSecretObject, lLocation);
			SendMessageToPC(oEnteringObject, "You've found something of interest.");
			PS_MarkAsDone(OBJECT_SELF);
			
			// Destroy the object and ourselves  - for one time server reboot appearance only
			if (GetHasInventory(oCreatedObject))
				DestroyObject(oCreatedObject, 120.0f);
			DestroyObject(OBJECT_SELF, 180.0f);
		}
}