#include "ps_inc_melee"
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"
#include "aaa_constants"


void ElementalStrike(object oPC, object oTarget, int nSpellID)
{
	
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    
    if(GetWeaponRanged(oWeapon) || !GetIsObjectValid(oWeapon))
    {
    SendMessageToPC(oPC,"You require a melee weapon to use this");
    return;
    }

    int iHit = AttemptMeleeAttackMainHand(oPC, oTarget,"ElementalStrike",1, "*2attack01", 0, nSpellID);
        
    if(iHit > 0)
    {
    int nDmg = d3(GetHighestModifier(oPC)); 
    if(iHit == 2) nDmg = FloatToInt(nDmg * 1.5);
    
    int flatfoot = FlatFooted(oPC,oTarget);
    if(flatfoot) FloatingTextStringOnCreature("*Elemental Strike (sneak attack)*", oPC, TRUE, 3.0f);
    
    effect eHurt = EffectLinkEffects(GetWeaponDamageTotal(oPC,oTarget,oWeapon,iHit,1,flatfoot), EffectDamage(nDmg, DAMAGE_TYPE_MAGICAL));    
    eHurt = EffectLinkEffects(EffectNWN2SpecialEffectFile("sp_darkness_hit"),eHurt);
    
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHurt, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedDecrease(25), oTarget, 3.0f);
    DelayCommand(0.5f,ApplyEffectToObject(DURATION_TYPE_INSTANT, eHurt, oTarget));
    }
}