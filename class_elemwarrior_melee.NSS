#include "ps_inc_melee"
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"
#include "aaa_constants"
#include "nwn2_inc_spells"


void ElementalStrike(object oPC, object oTarget, int nSpellID)
{
	//Elemental Warrior
	int nElemWar = GetLevelByClass(CLASS_TYPE_ELEMENTAL_WARRIOR,oPC);
	//Weapon in hand
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    //Air Electrical 
	if (GetHasFeat(FEAT_ELEM_AFFINITY_AIR,oPC))
		{
		nType= DAMAGE_TYPE_ELECTRICAL;
		nSaveType = SAVING_THROW_TYPE_ALL;
		nVFXHit = VFX_HIT_SPELL_LIGHTNING;
		eStatusEffect = EffectKnockdown();	
		}    
//Earth- Acid Damage
	else if(GetHasFeat(FEAT_ELEMWAR_AFFINITY_EARTH,oPC))
			{
			nSaveType = SAVING_THROW_TYPE_ALL;	

		nVFXHit = VFX_HIT_SPELL_ACID;
		eStatusEffect = EffectKnockdown();		
			nType= DAMAGE_TYPE_ACID;
			}
	//Fire Damage 
	else if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_FIRE,oPC))
		{
		nSaveType = SAVING_THROW_TYPE_FIRE;	
		nType = DAMAGE_TYPE_FIRE;	
		nVFXHit = VFX_HIT_SPELL_FIRE;
		eStatusEffect = EffectDamage(d6(1), nDamageType);

		
		}
//Water	
	else if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_WATER,oPC))
	{
		nSaveType = SAVING_THROW_TYPE_COLD;	
		nType=DAMAGE_TYPE_COLD;
		nVFXHit = VFX_HIT_SPELL_ICE;
		eStatusEffect = EffectDazed();	
		nType=DAMAGE_TYPE_COLD;
	}	
	
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

    effect eHurt = EffectLinkEffects(GetWeaponDamageTotal(oPC,oTarget,oWeapon,iHit,1,flatfoot), EffectDamage(nDmg, nType));    
    eHurt = EffectLinkEffects(EffectVisualEffect(nVFXHit),eHurt);
    
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHurt, oTarget);
	DelayCommand(0.5f,ApplyEffectToObject(DURATION_TYPE_INSTANT, eHurt, oTarget)); 
	
	int nDC = 15 + nElemWar+GetAbilityModifier(ABILITY_CONSTITUTION) ;
	if  (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, nSaveType))
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStatusEffect, oTarget, 6.0f);

		
	}
}
}