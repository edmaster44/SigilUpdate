#include "ps_inc_melee"
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"
#include "aaa_constants"
#include "nwn2_inc_spells"

//Elemental Strike
void ElementalStrike(object oPC, object oTarget, int nSpell )
{

		int nType;
		int nSaveType;
		effect nVFXHit;
		effect eDamage;
		effect eStatusEffect;
		int nDmg;
		int nDamageType;
	//Elemental Warrior
	int nElemWar = GetLevelByClass(CLASS_TYPE_ELEMENTAL_WARRIOR,oPC);
    //Air Electrical 

	
		if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_AIR,oPC))
		{
		nType= DAMAGE_TYPE_ELECTRICAL;
		nSaveType = SAVING_THROW_TYPE_ALL;
		nVFXHit = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
		eStatusEffect = EffectKnockdown();
			
		}    
//Earth- Acid Damage
	else if(GetHasFeat(FEAT_ELEMWAR_AFFINITY_EARTH,oPC))
			{
			nSaveType = SAVING_THROW_TYPE_ALL;	

		nVFXHit = EffectVisualEffect(VFX_HIT_SPELL_ACID);
		eStatusEffect = EffectKnockdown();		
			nType= DAMAGE_TYPE_ACID;
			}
	//Fire Damage 
	else if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_FIRE,oPC))
		{
		nSaveType = SAVING_THROW_TYPE_FIRE;	
		nType = DAMAGE_TYPE_FIRE;	
		nVFXHit = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
		eStatusEffect = EffectDamage(d6(1), nDamageType);

		
		}
//Water	
	else if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_WATER,oPC))
	{
		nSaveType = SAVING_THROW_TYPE_COLD;	
		nType=DAMAGE_TYPE_COLD;
		nVFXHit = EffectVisualEffect(VFX_HIT_SPELL_ICE);
		eStatusEffect = EffectDazed();	
		nType=DAMAGE_TYPE_COLD;
	}	
	SendMessageToPC(oPC, "Attempting Melee Strike");	 
    int flatfoot = FlatFooted(oPC,oTarget);
    if(flatfoot)
	{
	 FloatingTextStringOnCreature("*Elemental Strike (sneak attack)*", oPC, TRUE, 3.0f);
	 nDmg = d6(6)*2;
    }
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
	
	if(GetWeaponRanged(oWeapon) || !GetIsObjectValid(oWeapon))
	{
	SendMessageToPC(oPC,"You require a melee weapon to use this");
	return;
	}
    int iHit = AttemptMeleeAttackMainHand(oPC, oTarget,"ElementalStrikes",1, "*whirlwind", 0,nSpell);
    
    if(iHit >0)
    {

   	int nDmg = d6(6);
	eDamage = EffectDamage(nDmg, nType, DAMAGE_POWER_NORMAL, FALSE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, nVFXHit, oTarget);
	}
    if(iHit == 2)
	{
	nDmg = d6(8);
	eDamage = EffectDamage(nDmg, nType, DAMAGE_POWER_NORMAL, TRUE);
	int nDC = 15 + nElemWar+GetAbilityModifier(ABILITY_CONSTITUTION) ;
	if  (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, nSaveType))
	{	 ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStatusEffect, oTarget, 6.0f);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, nVFXHit, oTarget);
	 }
	 }	
}
