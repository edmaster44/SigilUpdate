//::///////////////////////////////////////////////
//:: Undead Graft
//:: X2_S2_UndGraft1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Pale Master may use their undead arm to paralyze
    foes for 1d6+2 rounds on a successful melee touch attack

    Save is 10 + Characterlevel /2 + Int or Cha Mod


    Elves immune to this effect
    TaB pg 66;
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 05, 2003
//:: Updated On: 2003-07-24, Georg Zoeller (added elf immunity, touch attack check, fixed duration)
//:://////////////////////////////////////////////


#include "NW_I0_SPELLS"
#include "ps_inc_functions"

void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    //object oCaster = GetCurrentHitPoints(OBJECT_SELF);
    int nCasterLvl = PS_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
	int nHD		   = GetTotalLevels(OBJECT_SELF, TRUE);
	int nChar	   = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
	int nInt       = GetAbilityModifier(ABILITY_INTELLIGENCE, OBJECT_SELF);
    int nRounds    = nHD;
	int nDC;
	
	//Calculate DC
	
	if (nChar	>=	nInt)
	{
			nDC = 10 + nHD/2 + nChar;	  
	}	
	else
	{
			nDC = 10 + nHD/2 + nInt;
	}

    //Declare effects
 
    effect ePara = EffectParalyze(nDC, SAVING_THROW_FORT);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur3 = EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
    eDur = EffectLinkEffects(eDur2,eDur);
    eDur = EffectLinkEffects(eDur3,eDur);

    //Link effects
    effect eLink = EffectLinkEffects(ePara, eDur);
    if (TouchAttackMelee(oTarget,TRUE)>0)
    {
        //GZ: whimpy elves are not effected by this spell, aarrg
        if (GetRacialType(oTarget) !=  RACIAL_TYPE_ELF)
        {
            //Signal spell cast at event
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Saving Throw
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
            {
                //Apply effects to target and caster
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nRounds));
            }
        }
        else
        {
            FloatingTextStrRefOnCreature(85591,oTarget,FALSE);
            FloatingTextStrRefOnCreature(85591,OBJECT_SELF,FALSE);
        }
    } else
    {
         // * GZ: According to TaB missed attacks are not wasted.
         int nId = GetSpellId();

         if (nId == 625)
         {
             IncrementRemainingFeatUses(OBJECT_SELF,892);
         }
            else if (nId == 626 )
         {
             IncrementRemainingFeatUses(OBJECT_SELF,893);
         }
    }
}