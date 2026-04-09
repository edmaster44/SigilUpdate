#include "kinc_silver_sword"
#include "nwn2_inc_spells"
#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "x2_inc_itemprop"

void ShardAttack(object oTarget, object oPC, object oItem);
void AttackResults(object oTarget, effect eDam, effect eVis);
void HideWeapon(object oPC);
void RevealWeapon(object oPC, object oItem);
void RestoreItemAbilities(object oItem);
void PlayCustomLoopingAnimation(object oObject, string sAnimationName, float fSpeed);
void PlayCustomOneShotAnimation(object oObject, string sAnimationName, float fSpeed);


void main()
{
	object oPC = OBJECT_SELF;
	object oModule = GetModule();
	object oTarget = GetSpellTargetObject();
	effect eEffect = EffectNWN2SpecialEffectFile("fx_ssword_hand.sef");
	
	object oItem = GetSilverSwordOwnedByPC(oPC);
			
	PlayCustomOneShotAnimation(oPC, "1hS_cleave", 1.3);
	DelayCommand(0.20f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 6.0f));
	DelayCommand(0.3f, ShardAttack(oTarget, oPC, oItem));
	DelayCommand(0.6f, HideWeapon(oPC));
}

void HideWeapon(object oPC)
{
	int nUniqueID = GetSilverSwordUniqueId(oPC);
	
	RemoveEffectsFromSpell(oPC, nUniqueID);
}

void ShardAttack(object oTarget, object oPC, object oItem)
{
    object oTarget = GetSpellTargetObject();
	location lSourceLoc = GetLocation( OBJECT_SELF );
	location lTarget = GetLocation( oTarget );
//    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    effect eVis;
//	effect eVis = EffectNWN2SpecialEffectFile("sp_magic_hit.sef");
    float fDelay, fTime, fTime2;
	int nPathType = PROJECTILE_PATH_TYPE_DEFAULT;
    int i;
	float fTravelTime;	
	float fTotalDelay;
	effect eEffect = EffectNWN2SpecialEffectFile("fx_shard_attack_reform.sef");		
	itemproperty ipNoDamage = ItemPropertyNoDamage();
	
	IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_CAST_SPELL, -1);
	
	AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDamage, oItem);
	
	//Apply a single damage hit for each missile instead of as a single mass
	for (i = 1; i <= 8; i++)
	{
		if (RandomIntBetween(1, 2) == 1)
		{
			eVis = EffectNWN2SpecialEffectFile("fx_ssword_attack_hit.sef");
		}
		
		else
		{
			eVis = EffectNWN2SpecialEffectFile("fx_shard_attack_hit.sef");
		}
					
		fTravelTime = GetProjectileTravelTime( lSourceLoc, lTarget, nPathType );    

		fDelay = fDelay + 0.1f; 
		
		fTotalDelay = fDelay + fTravelTime;
		
        //Roll damage
        int nDam = d3() + 1;

        //Set damage effect
        effect eDam = EffectDamage(nDam, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_PLUS_ONE);
	 
           //Apply the MIRV and damage effect
		   
		DelayCommand(fTotalDelay - 0.1, AttackResults(oTarget, eDam, eVis));
		
		DelayCommand(fDelay, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTarget, 
			995, nPathType));
		DelayCommand(fTotalDelay, SpawnSpellProjectile(oTarget, OBJECT_SELF, lTarget, lSourceLoc, 
			995, nPathType)); 
	}	 
	
	DelayCommand(fDelay + fTravelTime + fTravelTime - 0.15f, PlaySound("it_bladelg_draw01"));
	DelayCommand(fDelay + fTravelTime + fTravelTime - 0.15f,
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 6.0f));
	DelayCommand(fDelay + fTravelTime + fTravelTime - 0.15f, RevealWeapon(OBJECT_SELF, oItem));
	DelayCommand(fDelay + fTravelTime + fTravelTime - 0.15f, RestoreItemAbilities(oItem));
}

void AttackResults(object oTarget, effect eDam, effect eVis)
{
	if (TouchAttackRanged(oTarget) == TRUE)
	{
        ApplyEffectToObject(DURATION_TYPE_INSTANT, 
			eDam, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, 
			eVis, oTarget, 6.0f);	
	}
}	

void RestoreItemAbilities(object oItem)
{
	itemproperty ipSSwordAttack = ItemPropertyCastSpell(641, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
	itemproperty ipShardShield = ItemPropertyCastSpell(642, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
	itemproperty ipShardAttack = ItemPropertyCastSpell(643, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
	itemproperty ipSwordRecharge = ItemPropertyCastSpell(645, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);

	IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_NO_DAMAGE, -1);	
	IPSafeAddItemProperty(oItem, ipSwordRecharge, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	IPSafeAddItemProperty(oItem, ipSSwordAttack, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	IPSafeAddItemProperty(oItem, ipShardShield, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	IPSafeAddItemProperty(oItem, ipShardAttack, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

void RevealWeapon(object oPC, object oItem)
{	
	int nUniqueID = GetSilverSwordUniqueId(oPC);
	effect eSwordStandIn;
	effect eEffect;
	
	if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
	{
		eSwordStandIn = EffectNWN2SpecialEffectFile("fx_ssword_fake.sef");
		eEffect = SetEffectSpellId(eSwordStandIn, nUniqueID);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);
	}
	
	else if (GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) == oItem)
	{
		eSwordStandIn = EffectNWN2SpecialEffectFile("fx_ssword_fake_offh.sef");
		eEffect = SetEffectSpellId(eSwordStandIn, nUniqueID);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);
	}
}


void PlayCustomLoopingAnimation(object oObject, string sAnimationName, float fSpeed)
{
	PlayCustomAnimation(oObject, sAnimationName, 1, fSpeed);
}

void PlayCustomOneShotAnimation(object oObject, string sAnimationName, float fSpeed)
{
	PlayCustomAnimation(oObject, sAnimationName, 0, fSpeed);
}