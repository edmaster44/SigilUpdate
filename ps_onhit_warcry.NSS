//::///////////////////////////////////////////////
//:: War Cry
//:: NW_S0_WarCry
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The bard lets out a terrible shout that gives
    him a +2 bonus to attack and damage and causes
    fear in all enemies that hear the cry
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////

#include "X2_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ps_inc_onhit" 

void main()
{

    //Declare major variables
    location lTarget = GetLocation(OBJECT_SELF);
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
    int nLevel = GetCasterLevel(oCaster);
	int nDC = GetOnHitAbilityDC(OBJECT_SELF);
	int nID = GetOnHitAbilityID(OBJECT_SELF);
    effect eAttack = EffectAttackIncrease(2);
    effect eDamage = EffectDamageIncrease(2, DAMAGE_TYPE_SLASHING);
    effect eFear = EffectFrightened();
	
    effect eLOS = EffectVisualEffect(VFX_HIT_AOE_SONIC);
	effect eBuf = EffectVisualEffect ( VFX_DUR_SPELL_WAR_CRY );
	effect eVisFear = EffectVisualEffect (VFX_DUR_SPELL_CAUSE_FEAR);
    effect eLink = EffectLinkEffects(eAttack, eDamage);
	eLink = EffectLinkEffects(eLink, eBuf);
	eFear = EffectLinkEffects (eFear, eVisFear);
	
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLOS, OBJECT_SELF);
    //Determine enemies in the radius around the bard
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster) && oTarget != oCaster)
        {
           SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_WAR_CRY));
           //Make SR and Will saves
           if(!OnHitResistSpell(oCaster, oTarget)  && !OnHitSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR, oCaster))
            {
                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, RoundsToSeconds(4)));
				string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> frightens "+GetName(oTarget)+"</color>";
				DelayCommand(0.01, SendMessageToPC(oCaster, sReport));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
    //Apply bonus and VFX effects to bard.
    RemoveSpellEffects(nID,oCaster,oCaster);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF); //PMils OEI 07.08.06- NWN1 stuff, in NWN2 we're trying to not use the hit fx for buffs
	DelayCommand(0.01f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, RoundsToSeconds(nLevel)));
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_WAR_CRY, FALSE));
}