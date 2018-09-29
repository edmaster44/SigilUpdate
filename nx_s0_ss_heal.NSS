// Healing Ability Script for NX1 Silver Sword of Gith
// Adds combination Greater Restoration and Regeneration spell to sword.
// CGaw OEI 6/19/07

#include "x2_inc_spellhook" 
#include "ginc_misc"
#include "ginc_debug"

void PlayCustomLoopingAnimation(object oObject, string sAnimationName, float fSpeed);
void PlayCustomOneShotAnimation(object oObject, string sAnimationName, float fSpeed);
void Meditate1(object oPC);
void Meditate2(object oPC);
void Meditate3(object oPC);
void RestoreCharges(object oPC);

// return TRUE if the effect created by a supernatural force and can't be dispelled by spells
int GetIsSupernaturalCurse(effect eEff);

void CastSpell()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER);

    effect eBad = GetFirstEffect(oTarget);
    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
        if ((GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
            GetEffectType(eBad) == EFFECT_TYPE_CURSE ||
            GetEffectType(eBad) == EFFECT_TYPE_DISEASE ||
            GetEffectType(eBad) == EFFECT_TYPE_POISON ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eBad) == EFFECT_TYPE_CHARMED ||
            GetEffectType(eBad) == EFFECT_TYPE_DOMINATED ||
            GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
            GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
            GetEffectType(eBad) == EFFECT_TYPE_FRIGHTENED ||
            GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eBad) == EFFECT_TYPE_SLOW ||
            GetEffectType(eBad) == EFFECT_TYPE_STUNNED) &&
            GetEffectSpellId(eBad) != SPELL_ENLARGE_PERSON &&
            GetEffectSpellId(eBad) != SPELL_RIGHTEOUS_MIGHT &&
            GetEffectSpellId(eBad) != SPELL_STONE_BODY &&
            GetEffectSpellId(eBad) != SPELL_IRON_BODY &&
            GetEffectSpellId(eBad) != 803)
        {
            //Remove effect if it is negative.
            //if(!GetIsSupernaturalCurse(eBad))	// HOTU-SPECIFIC
               RemoveEffect(oTarget, eBad);
			eBad = GetFirstEffect(oTarget);
        }
		else
        	eBad = GetNextEffect(oTarget);
    }
    if(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
    {
        //Apply the VFX impact and effects
        int nHeal = GetMaxHitPoints(oTarget) - GetCurrentHitPoints(oTarget);
        effect eHeal = EffectHeal(nHeal);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_RESTORATION, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
	
    int nRegenAmt = GetMaxHitPoints(oTarget) / 10;
    if ( nRegenAmt < 1 )
    {
        nRegenAmt = 1;
    }
    effect eRegen = EffectRegenerate(nRegenAmt, 6.0);
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_G);
    effect eDur = EffectVisualEffect(VFX_DUR_REGENERATE);
    effect eLink = EffectLinkEffects(eRegen, eDur);


    float fDuration = RoundsToSeconds(10); //GetCasterLevel(OBJECT_SELF);


 //   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Apply effects and VFX
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

int GetIsSupernaturalCurse(effect eEff)
{
    object oCreator = GetEffectCreator(eEff);
    if(GetTag(oCreator) == "q6e_ShaorisFellTemple")
        return TRUE;
    return FALSE;
}




void main()
{
	object oCaster = OBJECT_SELF;
	
	Meditate1(oCaster);
}

void Meditate1(object oPC)
{
	effect eEffect = EffectNWN2SpecialEffectFile("fx_shard_rip.sef");
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 4.0f);
	PlayCustomLoopingAnimation(oPC, "%", 1.0f);
	PlayCustomOneShotAnimation(oPC, "kneeldown", 1.0f);
	DelayCommand(0.8f, PlayCustomLoopingAnimation(oPC, "kneelbow", 0.5f));
	DelayCommand(1.0f, Meditate2(oPC));
}

void Meditate2(object oPC)
{		
	effect eEffect = EffectNWN2SpecialEffectFile("fx_shard_rip.sef");
	effect eEffect2 = EffectNWN2SpecialEffectFile("sp_divination_cast.sef");
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 4.0f);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect2, oPC);
	DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect2, oPC));
	DelayCommand(1.0f, Meditate3(oPC));
}


void Meditate3(object oPC)
{
	effect eEffect2 = EffectNWN2SpecialEffectFile("sp_divination_cast.sef");
		
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect2, oPC);
		
	DelayCommand(1.0f, RestoreCharges(oPC));
}


void RestoreCharges(object oPC)
{
	effect eVis = EffectNWN2SpecialEffectFile("fx_shard_attack_reform.sef");
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
	PlayCustomLoopingAnimation(oPC, "%", 1.0f);
	PlayCustomOneShotAnimation(oPC, "kneelup", 1.0f);
		
	CastSpell();
}
	
void PlayCustomLoopingAnimation(object oObject, string sAnimationName, float fSpeed)
{
	PlayCustomAnimation(oObject, sAnimationName, 1, fSpeed);
}

void PlayCustomOneShotAnimation(object oObject, string sAnimationName, float fSpeed)
{
	PlayCustomAnimation(oObject, sAnimationName, 0, fSpeed);
}