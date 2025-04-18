//::///////////////////////////////////////////////
//:: Vampiric Touch
//:: NW_S0_VampTch
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    drain 1d6
    HP per 2 caster levels from the target.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
//:://////////////////////////////////////////////

/*
bugfix by Kovi 2002.07.22
- did double damage with maximize
- temporary hp was stacked
2002.08.25
- got temporary hp some immune creatures (Negative Energy Protection), lost
temporary hp against other resistant (SR, Shadow Shield)

Georg 2003-09-11
- Put in melee touch attack check, as the fixed attack bonus is now calculated correctly

*/


// (Update JLR - OEI 07/19/05) -- Changed Dmg to 1d8/per 2 lvls
// PKM-OEI 09.16.06 -- Reduced the damage back down to 1d6


#include "x0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ps_inc_functions"



void main()
{

    //--------------------------------------------------------------------------
    /*  Spellcast Hook Code
       Added 2003-06-20 by Georg
       If you want to make changes to all spells,
       check x2_inc_spellhook.nss to find out more
    */
    //--------------------------------------------------------------------------

    if (!X2PreSpellCastCode())
    {
        return;
    }
    //--------------------------------------------------------------------------
    // End of Spell Cast Hook
    //--------------------------------------------------------------------------

	int nCasterLevel;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
	int PML = GetPureMageLevels(OBJECT_SELF);
	int nFeatId = GetSpellFeatId();
	if (nFeatId == 3049){
		nCasterLevel = PS_GetLevel(OBJECT_SELF);
	} else {
		nFeatId = NULL;
		nCasterLevel= PS_GetCasterLevel(OBJECT_SELF);
	}
	
	if (!PS_GetTargetInRange(OBJECT_SELF, oTarget, nFeatId, FALSE))
		return;
		


	
    int nDDice = nCasterLevel;
	int nTouch      = TouchAttackMelee(oTarget, TRUE);
	
    if ((nDDice) == 0)
    {
        nDDice = 1;
    }


	//PKM-OEI: 05.28.07: Do critical hit damage
	if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{
		nDDice = nDDice * 2;
		PML = PML*2;
	}

    int nDamage = d3(nDDice) + d3(PML/3);
	if (nCasterLevel < 20 && !GetIsObjectValid(GetSpellCastItem())){
	nDamage = d3(20); + d3(PML/3);
	} 
  // JLR - OEI 07/19/05

    //--------------------------------------------------------------------------
    //Enter Metamagic conditions
    //--------------------------------------------------------------------------
		if (nMetaMagic == METAMAGIC_MAXIMIZE)
		{
		nDamage = nDamage + ((3*nDamage)/4);
		}
		else if (nMetaMagic == METAMAGIC_EMPOWER)
		{
		nDamage = nDamage + nDamage / 2;
		}
		
    int nDuration = nCasterLevel/2;
	

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }

    //--------------------------------------------------------------------------
    //Limit damage to max hp + 10
    //--------------------------------------------------------------------------
    int nMax = GetCurrentHitPoints(oTarget) + 10;
    if(nMax < nDamage)
    {
        nDamage = nMax;
    }

	// calcuate heal value before adding sneak damage
    effect eHeal = EffectTemporaryHitpoints(nDamage/4);

	
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) &&
            GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
            GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT &&
            !GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget))
        {


            SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_VAMPIRIC_TOUCH, FALSE));
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_VAMPIRIC_TOUCH, TRUE));
            // GZ: * GetSpellCastItem() == OBJECT_INVALID is used to prevent feedback from showing up when used as OnHitCastSpell property
            if (nTouch>0)
            {
                if(MyResistSpell(OBJECT_SELF, oTarget) == 0)
        		{
					// If applicable adds any sneak damage to total to be inflicted and reports the damage.
					nDamage += PS_AddSneakDmgToSpell(OBJECT_SELF, oTarget, DAMAGE_TYPE_NEGATIVE);
	
    				effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
    				effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
    				effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_S);
				 
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, OBJECT_SELF);
                    RemoveTempHitPoints();
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHeal, OBJECT_SELF, HoursToSeconds(nDuration));
                 }
            }
        }
    }
}