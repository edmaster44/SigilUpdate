#include "x2_inc_spellhook"
#include "aaa_constants"
#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "ps_inc_functions"
#include "nwn2_inc_spells"
#include "ps_inc_faction"
#include "x2_inc_itemprop"
#include "x2_inc_toollib"

/*	This is the include file for truename magic. It is different from normal magic in that different effects
	occur based on whether the magic is targeted on oneself, an enemy, or the ground. Many truename magic
	abilities will have four separate functions: a BASE function to be run if something is targeted in advance,
	an ALLY function if the ground is targeted, a SELF function if the caster is targeted, and an ENEMY function
	if a hostile enemy is targeted. Some, however, will only have one use.

	//////////////////////////////////////////////////////////////////////////////////////////
	//////////					Let The Magic Begin!								//////////
	//////////////////////////////////////////////////////////////////////////////////////////	*/
	
// Constants
const int CONTEXT_ALLY 		= 1;
const int CONTEXT_ENEMY 	= 2;
const int CONTEXT_NONE		= 3;

void PS_Ability_WordOfNurturing_Ally(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	int nLevel 		= GetLevelByClass(CLASS_TYPE_WORD_ARCHON_PRC, oPC);
	int nDur		= 2 + nLevel;
	effect eRegen	= EffectRegenerate(10, 6.0f);
	effect eHit		= EffectVisualEffect(SPELL_VIGOROUS_CYCLE);
	effect eDur		= EffectVisualEffect(VFX_DUR_SPELL_VIGOR);
	effect eLink	= EffectLinkEffects(eRegen, eDur);
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur));
}

//Helper function for PS_Ability_WordOfNurturing_Enemy below
void RunNurtureDamage(object oTarget, int nDur)
{
	effect eDamage	= EffectDamage(d6(3), DAMAGE_TYPE_DIVINE, DAMAGE_POWER_NORMAL, TRUE);
	effect eVis		= EffectNWN2SpecialEffectFile("fx_hit_spark_special", oTarget);
	effect eLink	= EffectLinkEffects(eDamage, eVis);	
	if (nDur == 0)
	{	return;	}
	else
	{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			nDur = (nDur - 1);
		DelayCommand(6.0f, RunNurtureDamage(oTarget, nDur));
	}
}

void PS_Ability_WordOfNurturing_Enemy(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	int nLevel		= GetLevelByClass(CLASS_TYPE_WORD_ARCHON_PRC, oPC);
	int nDur		= 2 + nLevel;
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 591));
	RunNurtureDamage(oTarget, nDur);
}

void PS_Ability_WordOfNurturing_Base(object oPC, object oTarget, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;	}

    int nCast;
    if (GetIsEnemy(oTarget))
    {   nCast = CONTEXT_ENEMY;		}
    else if (GetFactionEqual(oPC, oTarget))
    {	nCast = CONTEXT_ALLY;		}
	else if (oPC == oTarget)
	{	nCast = CONTEXT_ALLY;		}
	else
    {	nCast = CONTEXT_NONE;		}
    
    switch (nCast)
    {	case CONTEXT_ENEMY :				
			PS_Ability_WordOfNurturing_Enemy(oPC, oTarget, nSpell);
			break;	
		case CONTEXT_ALLY :			
			PS_Ability_WordOfNurturing_Ally(oPC, oTarget, nSpell);
			break;
		case CONTEXT_NONE :
			SendMessageToPC(oPC, "You may only cast this spell on a member of your party or an enemy combatant.");
			break;
	}
}

void PS_Ability_WordOfShockwave(object oPC, int nSpell)
{
    object oTarget;
    int nLevel 		= PS_GetLevel(oPC);
	int nDC 		= (15 + (nLevel/2));
    effect eProne	= EffectKnockdown();
	effect eDamage	= EffectDamage(d4(1), DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL);
    effect eHit 	= EffectNWN2SpecialEffectFile("fx_hit_spark_aoo");
	effect eLink	= EffectLinkEffects(eProne, eDamage);
		eLink		= EffectLinkEffects(eLink, eHit);
	effect eVis		= EffectNWN2SpecialEffectFile("fx_shockwave");
	float fDelay;
  
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
	 
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, GetLocation(oPC));
    while (GetIsObjectValid(oTarget))
	{	if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
	    {	fDelay = GetDistanceBetweenLocations(GetLocation(oPC), GetLocation(oTarget))/20;
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 592));
			if (FortitudeSave(oTarget, nDC) == 0)
            {	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
            }
		}
	oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation());
    }	
}

void PS_Ability_WordOfPeace_Ally(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}

	effect eDur		= EffectNWN2SpecialEffectFile("fx_e_soul_glow", oTarget);
    effect eSanc 	= EffectSanctuary(99);
    
    effect eLink	= EffectLinkEffects(eDur, eSanc);

    int nDuration	= 10;
	
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 594, FALSE));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));

}

string PS_WoP_RandomWaypoint()
{
 int iRandom  = Random(9);
 string sRandom;
 string sInitialRandom;
 int iTest;
 
 switch(iRandom)
 {
  case 0 : sRandom = "wp_extradim_00";  break;
  case 1 : sRandom = "wp_extradim_01";  break;
  case 2 : sRandom = "wp_extradim_02";  break;
  case 3 : sRandom = "wp_extradim_03";  break;
  case 4 : sRandom = "wp_extradim_04";  break;
  case 5 : sRandom = "wp_extradim_05";  break;
  case 6 : sRandom = "wp_extradim_06";  break;
  case 7 : sRandom = "wp_extradim_07";  break;
  case 8 : sRandom = "wp_extradim_08";  break;
 }
 return sRandom;
}

void PS_Ability_WordOfPeace_Enemy(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
    int nLevel 		= PS_GetLevel(oPC);
	int nDC 		= (15 + (nLevel/2));
	effect eVis		= EffectNWN2SpecialEffectFile("fx_teleport_new");
	effect eHold	= EffectCutsceneParalyze();
	string sRandom	= PS_WoP_RandomWaypoint();
	object oWP		= GetObjectByTag(sRandom);
	location lWP	= GetLocation(oWP);
	location lTarg	= GetLocation(oTarget);
	object oEss;
			
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 591));
	if (WillSave(oTarget, nDC) == 0)
	{	AssignCommand(oTarget, ClearAllActions(FALSE));
		SendMessageToPC(oPC, "Waypoint selected: " + sRandom + ".");
		if (!GetIsLocationValid(lWP))
		{	SendMessageToPC(oPC, "Waypoint location invalid!");		}
		if (GetIsPC(oTarget))
		{	oEss = GetItemPossessedBy(oTarget,"ps_essence");
			PS_SetLocalLocation(oEss, "ExtraDim", lTarg);
			DelayCommand(30.1f, PS_DeleteLocalLocation(oEss, "ExtraDim"));
			AssignCommand(oTarget, ClearAllActions());
			AssignCommand(oTarget, ActionJumpToLocation(lWP));
			AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHold, oTarget, 30.0f));
			SendMessageToPC(oPC, "Action assigned to target.");
			DelayCommand(30.0f, AssignCommand(oTarget, ClearAllActions()));
			DelayCommand(30.0f, AssignCommand(oTarget, ActionJumpToLocation(lTarg)));	}
		else
		{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			SendCreatureToLimbo(oTarget);
			SendMessageToPC(oPC, "Target sent elsewhere.");
			DelayCommand(30.0f, RecallCreatureFromLimboToLocation(oTarget, lTarg));
			DelayCommand(30.0f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarg));
			DelayCommand(30.0f, SendMessageToPC(oPC, "Target returned from elsewhere."));	}
	}
}

void PS_Ability_WordOfPeace_Base(object oPC, object oTarget, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;	}

    int nCast;
    if (GetIsEnemy(oTarget))
    {   nCast = CONTEXT_ENEMY;		}
    else if (GetFactionEqual(oPC, oTarget))
    {	nCast = CONTEXT_ALLY;		}
	else if (oPC == oTarget)
	{	nCast = CONTEXT_ALLY;		}
	else
    {	nCast = CONTEXT_NONE;		}
    
    switch (nCast)
    {	case CONTEXT_ENEMY :				
			PS_Ability_WordOfPeace_Enemy(oPC, oTarget, nSpell);
			break;	
		case CONTEXT_ALLY :			
			PS_Ability_WordOfPeace_Ally(oPC, oTarget, nSpell);
			break;
		case CONTEXT_NONE :
			SendMessageToPC(oPC, "You may only cast this spell on a member of your party or an enemy combatant.");
			break;
	}
}