

//::///////////////////////////////////////////////
//:: NW_S3_Alcohol.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Makes beverages fun.
  May 2002: Removed fortitude saves. Just instant intelligence loss
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:   February 2002
//:://////////////////////////////////////////////

#include "ps_class_inc"

void DrinkIt(object oTarget)
{
   // AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
   AssignCommand(oTarget,ActionSpeakStringByStrRef(10499));
}

void MakeDrunk(object oTarget, int nPoints)
{
	int iDMLevel = GetLevelByClass(CLASS_TYPE_DRUNKMASTER, oTarget);
	effect eDumb;
	
	if (GetHasSpellEffect(406, oTarget) || GetHasSpellEffect(407, oTarget) || GetHasSpellEffect(408, oTarget))
	{
		nPoints = nPoints + GetLocalInt(oTarget, "DRUNKLEVEL");
		SetLocalInt(oTarget, "DRUNKLEVEL", nPoints);
	}
	else
	{
		SetLocalInt(oTarget, "DRUNKLEVEL", nPoints);
	}
	
	int iINT = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE, TRUE);
	int iWIS = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE, TRUE);
	int iCON = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE, TRUE);

	if (iINT - nPoints < 1)
	{
		SendMessageToPC(oTarget, "<color=lightgreen>You have drank so much your brain can't figure out left from right. You are confused.");
		eDumb = EffectConfused();
	}
	else if (iWIS - nPoints < 1)
	{
		SendMessageToPC(oTarget, "<color=lightgreen>You have drank so much you will do incredibly stupid things.");
		eDumb = EffectInsane();
	}
	else if (iCON - nPoints < 1)
	{
		SendMessageToPC(oTarget, "<color=lightgreen>You have drank so much you become incredibly sick and blind drunk.");
		eDumb = EffectBlindness();
		eDumb = EffectLinkEffects(eDumb, EffectKnockdown());
	}
	else
	{
		// reset the effect
		if (GetHasSpellEffect(406, oTarget)) RemoveAnySpellEffects(406, oTarget);
		if (GetHasSpellEffect(407, oTarget)) RemoveAnySpellEffects(407, oTarget);
		if (GetHasSpellEffect(408, oTarget)) RemoveAnySpellEffects(408, oTarget);
	
		if (nPoints > 10) nPoints = 10; // cap at +10.
		
	    if (Random(100) + 1 < 80)
	        AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING));
	    else
	        AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK));
	    
	    eDumb = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nPoints);
		eDumb = EffectLinkEffects(eDumb, EffectAbilityDecrease(ABILITY_WISDOM, nPoints));
		
		if (GetHasFeat(FEAT_DRINK_LIKE_DEMON, oTarget, TRUE))
		{
			int iBonus = nPoints;
			if (iBonus > DAMAGE_BONUS_5) iBonus += 10; // fix for damage constants jumping.
			eDumb = EffectLinkEffects(eDumb, EffectTemporaryHitpoints(iDMLevel * nPoints));
			eDumb = EffectLinkEffects(eDumb, EffectDamageIncrease(iBonus, DAMAGE_TYPE_BLUDGEONING)); 
			eDumb = EffectLinkEffects(eDumb, EffectAttackIncrease(nPoints));
			if (GetHasFeat(FEAT_FOR_MEDICINAL_PURPOSES, oTarget, TRUE)) 
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(iDMLevel * 5), oTarget);
		}
	}
	
	eDumb = ExtraordinaryEffect(eDumb);
	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDumb, oTarget, 60.0 + RoundsToSeconds(iDMLevel));
 //   AssignCommand(oTarget, SpeakString(IntToString(GetAbilityScore(oTarget,ABILITY_INTELLIGENCE))));
}
void main()
{
    object oTarget = GetSpellTargetObject();
   // SpeakString("here");
    // * Beer
    if (GetSpellId() == 406)
    {
        // *burp*
        //AssignCommand(oTarget, SpeakString("Beer"));
        DrinkIt(oTarget);
//        if (FortitudeSave(oTarget, d20()+10) == TRUE)
        {
            MakeDrunk(oTarget, 1);
        }
    }
    else
    // *Wine
    if (GetSpellId() == 407)
    {
        DrinkIt(oTarget);
//        if (FortitudeSave(oTarget, d20()+10 +2) == TRUE)
        {
            MakeDrunk(oTarget, 2);
        }
    }
    else
    // * Spirits
    if (GetSpellId() == 408)
    {
        DrinkIt(oTarget);
//        if (FortitudeSave(oTarget, d20()+10) == TRUE)
        {
            MakeDrunk(oTarget, 3);
        }
     }

}