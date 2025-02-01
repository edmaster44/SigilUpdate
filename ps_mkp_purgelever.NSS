#include "ff_safevar"

// ps_mkp_purgelever
//
// Looks for creatures within a certain radius of a waypoint,
// then "purges" them, without doing any damage.

void main()
{
	
	PlaySound("as_sw_lever1");
	// * note that nActive == 1 does  not necessarily mean the placeable is active
	// * that depends on the initial state of the object
	int nActive = GetLocalInt (OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE");
	// * Play Appropriate Animation
	if (!nActive)
	{
		object oPC = GetLastUsedBy();
		object oWP = GetNearestObjectByTag("WP_Spellpurge");
		location lLoc = GetLocation(oWP);
		object oTarget = GetFirstObjectInShape(SHAPE_CUBE, 5.0, lLoc, FALSE, OBJECT_TYPE_CREATURE);

     	ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
		effect ePurge = EffectNWN2SpecialEffectFile("sp_virtue",oTarget);
		while (GetIsObjectValid(oTarget))
		{
			SendMessageToPC(oPC, "*Purging spell wards...*");	
			DelayCommand(1.0f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ePurge,oTarget,3.0f));
			effect eBad = GetFirstEffect(oTarget);
			while(GetIsEffectValid(eBad))
			{
	    		if (!(GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
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
					GetEffectType(eBad) == EFFECT_TYPE_TURNED))
				{
					//Remove effect if it isn't negative
					RemoveEffect(oPC, eBad);
				}	
				eBad = GetNextEffect(oPC);
				
			}
			oTarget = GetNextObjectInShape(SHAPE_CUBE, 5.0, lLoc, FALSE, OBJECT_TYPE_CREATURE);
		}
	}
	else
	{
     	ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
		SpeakString("*Recharging Purge Nodes...*",TALKVOLUME_TALK);
	}
   	// * Store New State
	PS_SetLocalInt(OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE",!nActive);

}