#include "ff_safevar"

///////////////////////////////////////////////////////////////
// ps_floortrap-triggered-respawn
//
// Floor (trigger) trap OnTriggered function. 
//
// Respawns traps and configures them according to variables
// held within them or a matching waypoint (for floor traps).
//
// Also applies the trap's stock damage since NWN2 won't do it for us  
//
//
// Author:  			ADnD'R (slackersupreme@rocketmail.com)
// Date Created:    	12MAY2010 for SCOD (Sigil, City of Doors)
// Last Modified By:	ADnD'R
// Date Last Modified:	17MAY2010
///////////////////////////////////////////////////////////////
/*
						
History of Changes

	26FEB2012 - Rust
	1. Now checks local variable TRAP_RECOVERABLE_PERCENTAGE to see if, with
	disarmable traps, if the new one can be recovered as well. 



	17MAY2010 - ADnD'R
	
	1. Added processing to determine if we're dealing with a trap trigger (and waypoint)
	or if we're a placeable or door. So now this function can work with all three. 


*/




#include "ps_scod_lib_traps"

void RespawnIdenticalTrap(object oTrapObject, location lTrap_Location, int nTrapType, float fSize, 
	string sTrapTag, int nTrapDC, int nDetectDC, int bIsDisarmable, int bIsRecoverable, string sKeyTag )
{
	
	object oNewTrap;
	int nMyObjectType = GetObjectType(oTrapObject);
	
	if (nMyObjectType == OBJECT_TYPE_WAYPOINT || nMyObjectType == -1)	
		oNewTrap = CreateTrapAtLocation( nTrapType,lTrap_Location, fSize, sTrapTag,STANDARD_FACTION_HOSTILE,
			"ps_trap-disarmed-respawn", "ps_trap-triggered-respawn"); 
	else if (nMyObjectType == OBJECT_TYPE_PLACEABLE || nMyObjectType == OBJECT_TYPE_DOOR)
	{
		 CreateTrapOnObject(nTrapType, oTrapObject, STANDARD_FACTION_HOSTILE,
			"ps_trap-disarmed-respawn", "ps_trap-triggered-respawn");
		
		oNewTrap = oTrapObject; 
			
	}
	else //fatal
		return; 
		
					
	if (!GetIsObjectValid(oNewTrap)) /// fatal
	{	
		return;
	}	
	// Set trap parameters
	SetTrapActive(oNewTrap, TRUE);
		
	////////////////
	// Detection
	///////////////
	if (nDetectDC == -1)  //not detectable
		SetTrapDetectable(oNewTrap, FALSE);
	else
	{
		SetTrapDetectable(oNewTrap, TRUE);	
		SetTrapDetectDC(oNewTrap, nDetectDC);
	}
	SetTrapDisarmable(oNewTrap, bIsDisarmable);
	SetTrapRecoverable(oNewTrap, bIsRecoverable);
	SetTrapKeyTag(oNewTrap, sKeyTag);
	SetTrapOneShot(oNewTrap, TRUE); //should always be TRUE
}


void main ()
{
	//object oMe = OBJECT_SELF;
	object oMyArea = GetArea(OBJECT_SELF);
	int nTrapType = GetTrapBaseType(OBJECT_SELF);
	
	//First we hit the PC(s) with the trap impact before anything else	
	string sImpactScript=Get2DAString("traps","TrapScript", nTrapType);
    ExecuteScript(sImpactScript,OBJECT_SELF);
		
	//First, if we're still trapped - a repeatable trap - we need do nothing more
	if (GetIsTrapped(OBJECT_SELF))
		return;
	
	
	
	// Get my particulars now

	// If there's a corresponding waypoint with "wp_"+[our tag], then we're
	// a floor (trigger) trap attempting to respawn. If not, then we're a placeable
	// or a door.
	object oTrapConfiguredObject;	 
	int nMyType = GetObjectType(OBJECT_SELF);
	
	if (nMyType == OBJECT_TYPE_TRIGGER)
		oTrapConfiguredObject = GetObjectByTag("wp_"+GetTag(OBJECT_SELF));
	else
		oTrapConfiguredObject = OBJECT_SELF;  //we're a placeable or a door

	if (oTrapConfiguredObject == OBJECT_INVALID)  //fatal
		return;	

					
	// If TRAP_TYPE is configured on us, get that,
	// otherwise, get whatever type we're configured to currently
	string sTrapType = PS_GetLocalString(oTrapConfiguredObject, "TRAP_TYPE");
	if (sTrapType == "")	
		nTrapType = GetTrapBaseType(OBJECT_SELF);
	else if (sTrapType == "TRAP_BASE_TYPE_RANDOM")
	{
		string sRandom = PS_GetLocalString(oTrapConfiguredObject, "TRAP_STRENGTH");		
		nTrapType =  GetRandomTrapBaseType(StringTrapStrengthToInt(sRandom));		
	}
	else /// configured but not random
		nTrapType = StringTrapBaseTypeToInt(sTrapType);
				
	// Trap size - builder defined, or defaults to 2.0f
	float fTrapSize = PS_GetLocalFloat(oTrapConfiguredObject, "TRAP_SIZE");	
	
		
	// We have to reference an associated waypoint as trying to grab or store
	// the triggers location is outraced by it's death. ugh! 
	location lMyLocation = GetLocation(oTrapConfiguredObject);
		
	string sMyTag = GetTag(OBJECT_SELF);
	int nDC = GetTrapDisarmDC(OBJECT_SELF);
	int bIsDetectable = GetTrapDetectable(OBJECT_SELF);
	int nDetectDC = -1;
	if (bIsDetectable == TRUE)
		nDetectDC = GetTrapDetectDC(OBJECT_SELF);
	int bIsDisarmable = GetTrapDisarmable(OBJECT_SELF);
	string sTrapKeyTag = GetTrapKeyTag(OBJECT_SELF);

	//// Recoverable?
	int bIsRecoverable = FALSE;
	if (bIsDisarmable && d100() < PS_GetLocalInt(oTrapConfiguredObject, "TRAP_RECOVERABLE_PERCENTAGE"))
		bIsRecoverable = TRUE;

	
	// ask the Area to respawn us after TRAP_RESPAWN_DELAY time has passed
	// Note that this variable is set on the WAYPOINT, not the area or the trap!//

	float fRespawnDelay = PS_GetLocalFloat(oTrapConfiguredObject, "TRAP_RESPAWN_DELAY");
	if (fRespawnDelay == 0.0f)
		fRespawnDelay = 600.0f;  // defaults to 10 minutes	
	
				
	AssignCommand(oMyArea, DelayCommand(fRespawnDelay, 
		RespawnIdenticalTrap(oTrapConfiguredObject, lMyLocation, nTrapType,
			 (fTrapSize == 0.0 ? 2.0f : fTrapSize), 
				sMyTag, nDC, nDetectDC, bIsDisarmable, bIsRecoverable, sTrapKeyTag)));

}