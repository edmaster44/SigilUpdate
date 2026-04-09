#include "ginc_misc"
#include "kinc_silver_sword"
#include "nw_i0_spells"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

// Functions

void ShardShield(object oTarget, object oPC, object oItem);
void ContinueEffect(object oPC, object oItem, int i, string sAOETag);
void HideWeapon(object oPC);
void EndAttack(object oPC, object oItem, string sAOETag);
void EndAttackDead(object oPC, object oItem, string sAOETag);
void RevealWeapon(object oPC, object oItem);
void RestoreItemAbilities(object oItem);
void PlayCustomLoopingAnimation(object oObject, string sAnimationName, float fSpeed);
void PlayCustomOneShotAnimation(object oObject, string sAnimationName, float fSpeed);

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
    location lTargetLocation = GetSpellTargetLocation();
	itemproperty ipStopAbility = ItemPropertyCastSpell(644, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
	itemproperty ipNoDamage = ItemPropertyNoDamage();
	
	object oItem = GetSilverSwordOwnedByPC(oPC);
	
	IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_CAST_SPELL, -1);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipStopAbility, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDamage, oItem);

	DelayCommand(0.5f, PlaySound("cb_whirlwind"));
	PlayCustomOneShotAnimation(oPC, "1hS_whirlwind", 1.0);
	DelayCommand(1.0f, ShardShield(oTarget, oPC, oItem));
}

void ShardShield(object oTarget, object oPC, object oItem)
{
	effect eExplosion = EffectNWN2SpecialEffectFile("fx_magical_explosion.sef");
	effect eShield = EffectNWN2SpecialEffectFile("fx_silver_shard_shield.sef");
	effect eACBonus = EffectACIncrease(6, AC_NATURAL_BONUS, AC_VS_DAMAGE_TYPE_ALL); 
	effect eArrowProt = EffectDamageReduction(10, 0, 0, DR_TYPE_NON_RANGED);
	effect eLinked = EffectLinkEffects(eACBonus, eArrowProt);
	
	int nUniqueID = GetSilverSwordUniqueId(oPC);

	effect eProtection = SetEffectSpellId(eLinked, nUniqueID);

	location lTarget = GetLocation(oTarget);
	int i;
	
	string sAOETag = ObjectToString(oPC) + "shard_shield_instance";
	//Now we need to see if anything with this tag already exists
	object oSelf = GetNearestObjectByTag(sAOETag);
	
	//If it exists, kill it.
	if (GetIsObjectValid(oSelf))
	{
		DestroyObject(oSelf);
	}
	
    effect eAOE = EffectAreaOfEffect(59, "", "", sAOETag);	
	
	HideWeapon(oPC);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplosion, lTarget);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eProtection, oPC, 30.0f);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield, oPC, 6.0f);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, 30.0f);
	ContinueEffect(oPC, oItem, i, sAOETag);
}

void HideWeapon(object oPC)
{
	int nUniqueID = GetSilverSwordUniqueId(oPC);

	RemoveEffectsFromSpell(oPC, nUniqueID);
}

void ContinueEffect(object oPC, object oItem, int i, string sAOETag)
{
	effect eShield2 = EffectNWN2SpecialEffectFile("fx_silver_shard_shield2.sef");	

 
	object oSelf = GetNearestObjectByTag(sAOETag);
	
	object oSlotItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);	
	
	i = i + 1;
	
    if (GetIsDead(oPC) == TRUE)
    {
		EndAttackDead(oPC, oItem, sAOETag);
        return;
    }
	
	else if (i >= 30)
	{		
		EndAttack(oPC, oItem, sAOETag);
	}
		
	else if (GetLocalInt(oItem, "SS_Stop_Ability") == 1)
	{
		EndAttack(oPC, oItem, sAOETag);
		return;
	}		
	
	else if (IsInMultiplayerConversation(oPC) == TRUE)
	{
		EndAttack(oPC, oItem, sAOETag);
		return;
	}
		
	else if (GetTag(oSlotItem) != TAG_SILVER_SWORD)
	{
		oSlotItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
		
		if (GetTag(oSlotItem) != TAG_SILVER_SWORD)
		{		
			EndAttack(oPC, oItem, sAOETag);
		}
		
		else
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield2, oPC, 6.0f);
			DelayCommand(1.0f, ContinueEffect(oPC, oItem, i, sAOETag));
		}		
	}
		
	else
	{			
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield2, oPC, 6.0f);
		DelayCommand(1.0f, ContinueEffect(oPC, oItem, i, sAOETag));
	}
}

void EndAttack(object oPC, object oItem, string sAOETag)
{
	object oSword = GetTarget("c_silver_sword");
	object oAOE = GetTarget(sAOETag);
	
	int nUniqueID = GetSilverSwordUniqueId(oPC);
		
	int n = 1;
	
	object oAOEObject = GetObjectByTag("VFX_MOB_SHARD_BARRIER", n);
	
	PrettyDebug("Tag of Object is " + GetTag(oAOEObject));
		
	while (GetIsObjectValid(oAOEObject) == TRUE)
	{
		n = n + 1;
		PrettyDebug(GetTag(oAOEObject));
		DelayCommand(0.1f, DestroyObject(oAOEObject));
		oAOEObject = GetObjectByTag("VFX_MOB_SHARD_BARRIER", n);
	}
	
	RemoveEffectsFromSpell(oPC, nUniqueID);
	
	DestroyObject(oSword);
	DestroyObject(oAOE);
	RevealWeapon(oPC, oItem);
	DelayCommand(2.5f, RestoreItemAbilities(oItem));
	SetLocalInt(oItem, "SS_Stop_Ability", 0);
}

void EndAttackDead(object oPC, object oItem, string sAOETag)
{
	object oSword = GetTarget("c_silver_sword");
	object oAOE = GetTarget(sAOETag);
	
	int n = 1;
	
	object oAOEObject = GetObjectByTag("VFX_MOB_SHARD_BARRIER", n);
			
	while (GetIsObjectValid(oAOEObject) == TRUE)
	{
		n = n + 1;
		PrettyDebug(GetTag(oAOEObject));
		DelayCommand(0.1f, DestroyObject(oAOEObject));
		oAOEObject = GetObjectByTag("VFX_MOB_SHARD_BARRIER", n);
	}
	
	DestroyObject(oSword);
	DestroyObject(oAOE);
	RevealWeapon(oPC, oItem);
	DelayCommand(2.5f, RestoreItemAbilities(oItem));
	SetLocalInt(oItem, "SS_Stop_Ability", 0);
}	

void RestoreItemAbilities(object oItem)
{
	itemproperty ipSSwordAttack = ItemPropertyCastSpell(641, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
	itemproperty ipShardShield = ItemPropertyCastSpell(642, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
	itemproperty ipShardAttack = ItemPropertyCastSpell(643, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
	itemproperty ipSwordRecharge = ItemPropertyCastSpell(645, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);

	IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_CAST_SPELL, -1);
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
	effect eSwordStandInTemp;
	effect eEffect;	
	
	if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
	{
		eSwordStandIn = EffectNWN2SpecialEffectFile("fx_ssword_fake_anim.sef");
		eEffect = SetEffectSpellId(eSwordStandIn, nUniqueID);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);
	}
	
	else if (GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) == oItem)
	{
		eSwordStandIn = EffectNWN2SpecialEffectFile("fx_ssword_fake_anim_offh.sef");
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