#include "nwnx_sql"

int IsEthereal(object oTarget)
{
effect ePCEffect = GetFirstEffect(oTarget);
while(GetIsEffectValid(ePCEffect))
{
    if (GetEffectType(ePCEffect) == EFFECT_TYPE_ETHEREAL)
 {
  return TRUE;
 }
 ePCEffect = GetNextEffect(oTarget);
}
return FALSE;
}

void ToggleRooted(object oUser)
{

	if (GetLocalInt(oUser, "set_root"))
	{
		effect ePCEffect = GetFirstEffect(oUser);
		while(GetIsEffectValid(ePCEffect))
		{
	    	if (GetEffectType(ePCEffect) == EFFECT_TYPE_CUTSCENEIMMOBILIZE)
			{
				RemoveEffect(oUser, ePCEffect);
				SetLocalInt(oUser, "set_root", 0);
				DeleteLocalInt(oUser, "set_root");
				SendMessageToPC(oUser, "You are now free to move again.");
				return;
			}	
			ePCEffect = GetNextEffect(oUser);
		}
	}
	else
	{
		effect eRoot = EffectCutsceneImmobilize();
		SetLocalInt(oUser, "set_root", 1);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRoot, oUser, 10000.0f);
		SendMessageToPC(oUser, "You are now rooted in place.");
	}
}

/*=========================================================================*/

void ToggleCloseness(object oUser)
{
	int nExploit = GetLocalInt(oUser, "DoorExploitPrevent");

	if (nExploit == 1)
	{	SendMessageToPC(oUser, "You may not turn on closeness at this time.");
		return;	}
	else
	{	if(GetCollision(oUser) == TRUE)
		{	SetCollision(oUser, FALSE);
			SendMessageToPC(oUser, "You are OOCly walkable.  Please do not exploit this in RP or pvp situations.");
			SetPersistentInt(oUser, "NO_COLLISION", 1);
			return;		}
		if(GetCollision(oUser) == FALSE)
		{	SetCollision(oUser, TRUE);
			SendMessageToPC(oUser, "You are OOCly unwalkable.");
			SetPersistentInt(oUser, "NO_COLLISION", 0);
			return;		}
	}
}

/*=========================================================================*/

void ToggleFreeze(object oUser)
{
	if (GetLocalInt(oUser, "set_freeze"))
	{
		effect eFreeze = GetFirstEffect(oUser);
		while (GetIsEffectValid(eFreeze))
		{
			if (GetEffectSpellId(eFreeze) == 3000)
			{
				DeleteLocalInt(oUser, "set_freeze");
				RemoveEffect(oUser, eFreeze);
				SendMessageToPC(oUser, "Your animation is now unfrozen.");
				return;
			}
			eFreeze = GetNextEffect(oUser);	  
		}
	}
	else
	{
		SetLocalInt(oUser, "set_freeze", 1);
		effect eFreeze = SupernaturalEffect(SetEffectSpellId(EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION), 3000));
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFreeze, oUser);  
		SendMessageToPC(oUser, "Your animation is now frozen.");
	}
}

/*=========================================================================*/

void DoGrappleTarget(object oUser)
{
	object oTarget = GetPlayerCurrentTarget(oUser);
	string sPCName = GetName(oUser);
	string sTargetName = GetName(oTarget);
	string sGender = "he";
	string sGender2 = "his";
	float nDistance = GetDistanceBetween(oUser, oTarget);
	int nPCSize = GetCreatureSize(oUser);
	int nTargetSize = GetCreatureSize(oTarget);
	int nPCStr = GetAbilityModifier(ABILITY_STRENGTH, oUser);
	int nTargetStr = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
	int nPCEthereal = 0;
	int nTargetEthereal = 0;
	int nTouchResult = 0;
	
	if (GetGender(oTarget) == GENDER_FEMALE)
	{
		sGender = "she";
		sGender2 = "her";
	}
	
	string sTouchTry = sPCName + " tries to get take hold of "+ sTargetName;
	string sTouchSuccess = " and succeeds.";
	string sTouchFail = ", but is evaded.";
	string sTouchCritical = " and catches them flawlessly, easily taking them into a firm hold!";
	string sHoldSuccess = ", managing to take them into a firm hold!";
	string sHoldFail = ", but they escape reach before being grappled!";
	string sHoldTie = ", but " + sGender + " holds " + sGender2 + " ground and struggles, neither grappled or free!";
	
	if(nDistance > 2.0f)
	{
		SendMessageToPC(oUser, "You are too far from your target to try grappling them!");
		return;
	}
	nPCEthereal = IsEthereal(oUser);
	nTargetEthereal = IsEthereal(oTarget);
	if((GetRacialType(oTarget) == RACIAL_TYPE_INCORPOREAL) 
	|| (nPCEthereal != nTargetEthereal)
	|| ((GetRacialType(oTarget) == RACIAL_TYPE_INCORPOREAL) && !GetHasFeat(2031, oTarget))) // ghost warrior
	{
		SendMessageToPC(oUser, "The target (or you) is incorporeal and grappling is impossible.");
		return;
	}
	nTouchResult = TouchAttackMelee(oTarget);
	if(nTouchResult == TOUCH_ATTACK_RESULT_MISS)
	{
		AssignCommand(oUser, ActionSpeakString(sTouchTry + sTouchFail));
		return;
	}
	if(nTouchResult == TOUCH_ATTACK_RESULT_CRITICAL)
	{
		AssignCommand(oUser, ActionSpeakString(sTouchTry + sTouchCritical));
		return;
	}
	
	if(nPCSize == CREATURE_SIZE_TINY)	{ nPCSize = -8; }
	if(nPCSize == CREATURE_SIZE_SMALL)	{ nPCSize = -4; }
	if(nPCSize == CREATURE_SIZE_MEDIUM)	{ nPCSize = 0; }
	if(nPCSize == CREATURE_SIZE_LARGE)	{ nPCSize = 4; }
	if(nPCSize == CREATURE_SIZE_HUGE)	{ nPCSize = 8; }
	
	if(nTargetSize == CREATURE_SIZE_TINY)	{ nTargetSize = -8; }
	if(nTargetSize == CREATURE_SIZE_SMALL)	{ nTargetSize = -4; }
	if(nTargetSize == CREATURE_SIZE_MEDIUM)	{ nTargetSize = 0; }
	if(nTargetSize == CREATURE_SIZE_LARGE)	{ nTargetSize = 4; }
	if(nTargetSize == CREATURE_SIZE_HUGE)	{ nTargetSize = 8; }	
	
	int nPCGrappleModifier = GetBaseAttackBonus(oUser) + nPCStr + nPCSize;
	int nTargetGrappleModifier = GetBaseAttackBonus(oTarget) + nTargetStr + nTargetSize;
	int nPCHoldRoll = d20() + nPCGrappleModifier;
	int nTargetHoldRoll = d20() + nTargetGrappleModifier;
	
	if(nPCHoldRoll > nTargetHoldRoll)
	{
		AssignCommand(oUser, ActionSpeakString(sTouchTry + sTouchSuccess + sHoldSuccess +" ("+ IntToString(nPCHoldRoll) +" vs. "+ IntToString(nTargetHoldRoll) +")"));
		return;
	}
	if(nPCHoldRoll < nTargetHoldRoll)
	{
		AssignCommand(oUser, ActionSpeakString(sTouchTry + sTouchSuccess + sHoldFail +" ("+ IntToString(nPCHoldRoll) +" vs. "+ IntToString(nTargetHoldRoll) +")"));
		return;
	}
	if(nPCHoldRoll == nTargetHoldRoll)
	{
		if(nPCGrappleModifier > nTargetGrappleModifier)
		{
			AssignCommand(oUser, ActionSpeakString(sTouchTry + sTouchSuccess + sHoldSuccess +" ("+ IntToString(nPCHoldRoll) +" vs. "+ IntToString(nTargetHoldRoll) +")"));
			return;
		}
		if(nPCGrappleModifier < nTargetGrappleModifier)
		{
			AssignCommand(oUser, ActionSpeakString(sTouchTry + sTouchSuccess + sHoldFail +" ("+ IntToString(nPCHoldRoll) +" vs. "+ IntToString(nTargetHoldRoll) +")"));
			return;
		}
		if(nPCGrappleModifier == nTargetGrappleModifier)
		{
			AssignCommand(oUser, ActionSpeakString(sTouchTry + sTouchSuccess + sHoldTie +" ("+ IntToString(nPCHoldRoll) +" vs. "+ IntToString(nTargetHoldRoll) +")"));
			return;
		}
	}
}


/*=========================================================================*/

//Releases minions like the beasts of the warlock invocation Call of the Beast
void ReleaseCalledCreatures(object oPC) {
	
	int nNumberCalled = GetLocalInt(oPC, "WARLOCK_ANIMALS_CALLED");
	
	if (nNumberCalled > 0) {
		SendMessageToPC(oPC, "Releasing called beasts.");
	}

	int n;
	for(n = 0; n <= nNumberCalled; n++) {
		object oSummon = GetLocalObject(oPC, "WARLOCK_ANIMAL_"+IntToString(n));
		DestroyObject(oSummon, 0.1f);
		DeleteLocalObject(oPC, "WARLOCK_ANIMAL_"+IntToString(n));
	}
	
	DeleteLocalInt(oPC, "WARLOCK_UNDEAD_CALLED");
	
	nNumberCalled = GetLocalInt(oPC, "WARLOCK_UNDEAD_CALLED");
	
	if (nNumberCalled > 0) {
		SendMessageToPC(oPC, "Releasing created undead.");
	}

	for(n = 0; n <= nNumberCalled; n++) {
		object oSummon = GetLocalObject(oPC, "WARLOCK_UNDEAD_"+IntToString(n));
		DestroyObject(oSummon, 0.1f);
		DeleteLocalObject(oPC, "WARLOCK_UNDEAD_"+IntToString(n));
	}
	
	DeleteLocalInt(oPC, "WARLOCK_UNDEAD_CALLED");

}

void DoReleaseSpells(object oPC)
{
	effect eBad = GetFirstEffect(oPC);
	
	if(GetIsInCombat(oPC) == TRUE)
	{
		SendMessageToPC(oPC, "You cannot release spells in combat.");
		return;
	}	
	
	ReleaseCalledCreatures(oPC);
	
	SendMessageToPC(oPC, "Releasing Spells");	
	while(GetIsEffectValid(eBad))
	{
	    if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
	        GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
	        GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
	        GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
	        GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
	        GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
	        GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
	        GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
	        GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
	        GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
	        GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
	        GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL ||
			GetEffectType(eBad) == EFFECT_TYPE_ARCANE_SPELL_FAILURE ||
			GetEffectType(eBad) == EFFECT_TYPE_ASSAYRESISTANCE ||
			GetEffectType(eBad) == EFFECT_TYPE_CHARMED ||
			GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
			GetEffectType(eBad) == EFFECT_TYPE_CURSE ||
			GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
			GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
			GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
			GetEffectType(eBad) == EFFECT_TYPE_DOMINATED ||
			GetEffectType(eBad) == EFFECT_TYPE_ENTANGLE ||
			GetEffectType(eBad) == EFFECT_TYPE_FRIGHTENED ||
			GetEffectType(eBad) == EFFECT_TYPE_INSANE ||
			GetEffectType(eBad) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_PETRIFY ||
			GetEffectType(eBad) == EFFECT_TYPE_POISON ||
			GetEffectType(eBad) == EFFECT_TYPE_SLEEP ||
			GetEffectType(eBad) == EFFECT_TYPE_SILENCE ||
			GetEffectType(eBad) == EFFECT_TYPE_SLOW ||
			GetEffectType(eBad) == EFFECT_TYPE_SPELL_FAILURE ||
			GetEffectType(eBad) == EFFECT_TYPE_STUNNED ||
			GetEffectType(eBad) == EFFECT_TYPE_SWARM ||
			GetEffectType(eBad) == EFFECT_TYPE_TURNED)
	        {
				eBad = GetNextEffect(oPC); 
	        }
		else
		{//Remove effect if it isn't negative
			RemoveEffect(oPC, eBad);
			eBad = GetNextEffect(oPC);
		}
	}
}

/*=========================================================================*/

void DoTouchAttackMelee(object oUser)
{
	object oTarget = GetPlayerCurrentTarget(oUser);
	string sPCName = GetName(oUser);
	string sTargetName = GetName(oTarget);
	int nResult = TouchAttackMelee(oTarget);
	float fDistance = GetDistanceBetween(oUser, oTarget);
	
	if(fDistance > 2.0f)
	{
		SendMessageToPC(oUser, "You need to be closer to your target to execute a melee touch attack.");
		return;
	}
	switch(nResult)
	{
		case TOUCH_ATTACK_RESULT_MISS:
			AssignCommand(oUser, ActionSpeakString(sPCName +" tries a Melee Touch Attack on "+ sTargetName +", but misses!"));
			break;
			
		case TOUCH_ATTACK_RESULT_HIT:
			AssignCommand(oUser, ActionSpeakString(sPCName +" tries a Melee Touch Attack on "+ sTargetName +" and hits!"));
			break;
		
		case TOUCH_ATTACK_RESULT_CRITICAL:
			AssignCommand(oUser, ActionSpeakString(sPCName +" tries a Melee Touch Attack on "+ sTargetName +" and scores a critical hit!"));
			break;
	}
}

/*=========================================================================*/

void DoTouchAttackRanged(object oUser)
{
	object oTarget = GetPlayerCurrentTarget(oUser);
	string sPCName = GetName(oUser);
	string sTargetName = GetName(oTarget);
	int nResult = TouchAttackRanged(oTarget);
	switch(nResult)
	{
		case TOUCH_ATTACK_RESULT_MISS:
			AssignCommand(oUser, ActionSpeakString(sPCName +" tries a Ranged Touch Attack on "+ sTargetName +", but misses!"));
			break;
			
		case TOUCH_ATTACK_RESULT_HIT:
			AssignCommand(oUser, ActionSpeakString(sPCName +" tries a Ranged Touch Attack on "+ sTargetName +" and hits!"));
			break;
		
		case TOUCH_ATTACK_RESULT_CRITICAL:
			AssignCommand(oUser, ActionSpeakString(sPCName +" tries a Ranged Touch Attack on "+ sTargetName +" and scores a critical hit!"));
			break;
	}
}

/*=========================================================================*/

void DoRegularAttackMelee(object oUser)
{
	object oTarget = GetPlayerCurrentTarget(oUser);
	string sPCName = GetName(oUser);
	string sTargetName = GetName(oTarget);
	int nPCRoll = d20() + GetAbilityModifier(ABILITY_STRENGTH, oUser) + GetBaseAttackBonus(oUser);
	int nTargetAC = GetAC(oTarget);
	float fDistance = GetDistanceBetween(oUser, oTarget);
	
	if(fDistance > 2.0f)
	{
		SendMessageToPC(oUser, "You need to be closer to your target to execute a melee attack.");
		return;
	}	
	SendMessageToPC(oUser, sPCName +"'s Roll: "+ IntToString(nPCRoll) +" vs "+ sTargetName +"'s AC: "+ IntToString(nTargetAC));
	SendMessageToPC(oTarget, sPCName +"'s Roll: "+ IntToString(nPCRoll) +" vs "+ sTargetName +"'s AC: "+ IntToString(nTargetAC));
	
	if(nPCRoll >= nTargetAC)
	{
		AssignCommand(oUser, ActionSpeakString(sPCName +" tries a Melee Attack on "+ sTargetName +" and hits!"));
		return;
	}
	else
	{
		AssignCommand(oUser, ActionSpeakString(sPCName +" tries a Melee Attack on "+ sTargetName +", but misses!"));
		return;
	}
}

/*=========================================================================*/

void DoRegularAttackRanged(object oUser)
{
	object oTarget = GetPlayerCurrentTarget(oUser);
	string sPCName = GetName(oUser);
	string sTargetName = GetName(oTarget);
	int nPCRoll = d20() + GetAbilityModifier(ABILITY_DEXTERITY, oUser) + GetBaseAttackBonus(oUser);
	int nTargetAC = GetAC(oTarget);
	SendMessageToPC(oUser, sPCName +"'s Roll: "+ IntToString(nPCRoll) +" vs "+ sTargetName +"'s AC: "+ IntToString(nTargetAC));
	SendMessageToPC(oTarget, sPCName +"'s Roll: "+ IntToString(nPCRoll) +" vs "+ sTargetName +"'s AC: "+ IntToString(nTargetAC));
	
	if(nPCRoll >= nTargetAC)
	{
		AssignCommand(oUser, ActionSpeakString(sPCName +" tries a Ranged Attack on "+ sTargetName +" and hits!"));
		return;
	}
	else
	{
		AssignCommand(oUser, ActionSpeakString(sPCName +" tries a Ranged Attack on "+ sTargetName +", but misses!"));
		return;
	}
}

/*=========================================================================*/

void DoInitiative(object oUser)
{
	int nModifier = GetAbilityModifier(ABILITY_DEXTERITY, oUser);
	if(GetHasFeat(FEAT_IMPROVED_INITIATIVE , oUser))
	{
		nModifier = nModifier + 4;
	}
	int nRoll = d20();
	int nTotal = nRoll + nModifier;

	AssignCommand(oUser, ActionSpeakString("<color=#EFD4AC>Initiative Roll: "+ IntToString(nTotal) +" (Roll: "+ IntToString(nRoll) +" Modifier: "+ IntToString(nModifier) +"</c>"));
}