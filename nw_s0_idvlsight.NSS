//::///////////////////////////////////////////////
//:: Invocation: Devil's Sight
//:: NW_S0_IDvlSight.nss
//:://////////////////////////////////////////////
/*
    Caster gains Darkvision/Ultravision for 24 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 19, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: AFW-OEI 11/20/2006: Change from Darkvision -> Ultravision.  TTP #20413
//:: JLR - OEI 08/24/05 -- Metamagic changes
//:: Mimi Fearthegn 7/26/20 - Redoing this spell entirely, now Eldritch Shield

#include "nwn2_inc_spells"
#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nw_i0_invocatns"

void main() {

	/* 
	  Spellcast Hook Code 
	  Added 2003-06-23 by GeorgZ
	  If you want to make changes to all spells,
	  check x2_inc_spellhook.nss to find out more
	  
	*/
    if (!X2PreSpellCastCode()) {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
	object oCaster = OBJECT_SELF;
	int nCasterLevel = GetWarlockCasterLevel(oCaster);
    float fDuration = HoursToSeconds(24);
	
	int nEldritchDice = GetEldritchBlastLevel(oCaster)/4;
	if (nEldritchDice <= 0) nEldritchDice = 1;
	
	int nDamageType = DAMAGE_TYPE_MAGICAL;
	int hasSpecial = FALSE;
	effect eSpecial;
	
    int nMetaMagic = GetMetaMagicFeat();
	if (nMetaMagic) {
		hasSpecial = TRUE;
		if (METAMAGIC_INVOC_DRAINING_BLAST) {
			eSpecial = EffectImmunity(IMMUNITY_TYPE_SLOW);
			eSpecial = EffectLinkEffects(eSpecial, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
		} else if (METAMAGIC_INVOC_FRIGHTFUL_BLAST) {
			eSpecial = EffectImmunity(IMMUNITY_TYPE_FEAR);
		} else if (METAMAGIC_INVOC_BESHADOWED_BLAST) {
			eSpecial = EffectImmunity(IMMUNITY_TYPE_BLINDNESS);
			eSpecial = EffectLinkEffects(eSpecial, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
			eSpecial = EffectLinkEffects(eSpecial, EffectConcealment(20, MISS_CHANCE_TYPE_VS_RANGED));
		} else if (METAMAGIC_INVOC_BRIMSTONE_BLAST) {
			eSpecial = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100);
			eSpecial = EffectLinkEffects(eSpecial, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 20));
			eSpecial = EffectLinkEffects(eSpecial, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 20));
			eSpecial = EffectLinkEffects(eSpecial, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 20));
			nDamageType = DAMAGE_TYPE_FIRE;
		} else if (METAMAGIC_INVOC_HELLRIME_BLAST) {
			eSpecial = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100);
			eSpecial = EffectLinkEffects(eSpecial, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 20));
			eSpecial = EffectLinkEffects(eSpecial, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 20));
			eSpecial = EffectLinkEffects(eSpecial, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 20));
			nDamageType = DAMAGE_TYPE_COLD;
		} else if (METAMAGIC_INVOC_BEWITCHING_BLAST) {
			eSpecial = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
		} else if (METAMAGIC_INVOC_NOXIOUS_BLAST) {
			eSpecial = EffectImmunity(IMMUNITY_TYPE_DISEASE);
			eSpecial = EffectLinkEffects(eSpecial, EffectImmunity(IMMUNITY_TYPE_POISON));
			eSpecial = EffectLinkEffects(eSpecial, EffectImmunity(IMMUNITY_TYPE_SAVING_THROW_DECREASE));
		} else if (METAMAGIC_INVOC_VITRIOLIC_BLAST) {
			eSpecial = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 100);
			eSpecial = EffectLinkEffects(eSpecial, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 20));
			eSpecial = EffectLinkEffects(eSpecial, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 20));
			eSpecial = EffectLinkEffects(eSpecial, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 20));
			nDamageType = DAMAGE_TYPE_ACID;
		} else if (METAMAGIC_INVOC_UTTERDARK_BLAST) {
			eSpecial = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
			eSpecial = EffectLinkEffects(eSpecial, EffectImmunity(IMMUNITY_TYPE_DEATH));
			eSpecial = EffectLinkEffects(eSpecial, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
			nDamageType = DAMAGE_TYPE_NEGATIVE;
		} else if (METAMAGIC_INVOC_HINDERING_BLAST) {
			eSpecial = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100);
			eSpecial = EffectLinkEffects(eSpecial, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
			eSpecial = EffectLinkEffects(eSpecial, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 20));
			eSpecial = EffectLinkEffects(eSpecial, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 20));
			eSpecial = EffectLinkEffects(eSpecial, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 20));
			nDamageType = DAMAGE_TYPE_ELECTRICAL;
		} else if (METAMAGIC_INVOC_BINDING_BLAST) {
			eSpecial = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
			eSpecial = EffectLinkEffects(eSpecial, EffectImmunity(IMMUNITY_TYPE_STUN));
			eSpecial = EffectLinkEffects(eSpecial, EffectImmunity(IMMUNITY_TYPE_SLOW));
			eSpecial = EffectLinkEffects(eSpecial, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
		} 
	}
	
	//Approximating 1/4 of your blast damage (imperfect, but close enough!)
	int nRandom = DAMAGE_BONUS_1;
	if (nEldritchDice > 5) //24d6
		nRandom = DAMAGE_BONUS_2d12;
	else if (nEldritchDice > 4) //20d6
		nRandom = DAMAGE_BONUS_2d10;
	else if (nEldritchDice > 3) //16d6
		nRandom = DAMAGE_BONUS_2d8;
	else if (nEldritchDice > 2) //12d6
		nRandom = DAMAGE_BONUS_2d6;
	else if (nEldritchDice > 1) //8d6
		nRandom = DAMAGE_BONUS_2d4;
	else if (nEldritchDice > 0) //4d6
		nRandom = DAMAGE_BONUS_1d4;
	
	effect eShield = EffectDamageShield(nEldritchDice, nRandom, nDamageType);
	if (hasSpecial) {
		eShield = EffectLinkEffects(eShield, eSpecial);
	}
	
	SetEffectSpellId(eShield, GetSpellId());
	
    RemoveEffectsFromSpell(oCaster, GetSpellId());
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield, oCaster, fDuration);
	
}