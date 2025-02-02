#include "ginc_misc"
#include "kinc_silver_sword"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

// Functions

void UnhideSwordCreature(object oSword);
void HideWeapon(object oPC);
void SwordAttacks(location lTarget, object oPC, object oItem, object oSword);
void AttackSingleTarget(object oTarget, object oPC, object oItem, object oSword);
void JumpAndAttack(object oTarget, location lTarget, object oPC, object oItem, object oLastAttacked,
	object oSword);
object FindNextTarget(location lSword, object oPC, object oOriginalTarget, object oSword);
void EndAttack(object oPC, object oItem, object oSword);
void EndAttackDead(object oPC, object oItem, object oSword);
void RestoreItemAbilities(object oItem);
void RevealWeapon(object oPC, object oItem);
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
	location lTarget = GetLocation(oTarget);
    location lTargetLocation = GetSpellTargetLocation();
	int nRandom;
	int n = 1;
	
	effect eReforming = EffectNWN2SpecialEffectFile("fx_sswstorm_reform_nohilt.sef");
	effect eExplosion = EffectNWN2SpecialEffectFile("fx_magical_explosion.sef");
	effect eStart = EffectNWN2SpecialEffectFile("fx_shard_attack_reform.sef");
	effect eSword = EffectNWN2SpecialEffectFile("fx_ssword_fake_trail.sef");
	effect eEthereal = EffectEthereal();
	itemproperty ipStopAbility = ItemPropertyCastSpell(644, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
	itemproperty ipNoDamage = ItemPropertyNoDamage();
	
	object oItem = GetSilverSwordOwnedByPC(oPC);
	
	IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_CAST_SPELL, -1);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipStopAbility, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDamage, oItem);
	
	object oOldSword = GetObjectByTag("c_silver_sword_attack", n);
	
	while (GetIsObjectValid(oOldSword) == TRUE)
	{
		n = n + 1;
		DelayCommand(0.1f, DestroyObject(oOldSword));
		oOldSword = GetObjectByTag("c_silver_sword_attack", n);
	}
	
	if (GetIsObjectValid(oTarget) == TRUE)
	{
		nRandom = RandomIntBetween(1, 4);	
		object oSword = CreateObject(OBJECT_TYPE_CREATURE, "c_silver_sword_attack", lTarget);
		DelayCommand(2.8f, ChangeToStandardFaction(oSword, STANDARD_FACTION_DEFENDER));
		location lSword = GetLocation(oSword);
		AssignCommand(oSword, ClearAllActions(TRUE));
		PlayCustomOneShotAnimation(oPC, "Thrw_1attack02", 1.0);
		DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStart, oPC, 3.0f));
		DelayCommand(0.25f, HideWeapon(oPC));
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eReforming, lSword, 3.0f);
		DelayCommand(2.8f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eExplosion, lSword, 6.0f));
		DelayCommand(2.8f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSword, oSword));
		DelayCommand(3.0f, UnhideSwordCreature(oSword));
		DelayCommand(4.0f, PlayCustomLoopingAnimation(oSword, "1hS_1attack0" + IntToString(nRandom), 1.0f));
		DelayCommand(4.0f, AssignCommand(oSword, PlaySound("it_bladelg_draw01")));		
		DelayCommand(4.5f, AttackSingleTarget(oTarget, oPC, oItem, oSword));	
	}

	else
	{
		object oSword = CreateObject(OBJECT_TYPE_CREATURE, "c_silver_sword_attack", lTargetLocation);
		DelayCommand(2.8f, ChangeToStandardFaction(oSword, STANDARD_FACTION_DEFENDER));
		location lSword = GetLocation(oSword);
		AssignCommand(oSword, ClearAllActions(TRUE));
		PlayCustomOneShotAnimation(oPC, "Thrw_1attack02", 1.0);
		DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStart, oPC, 3.0f));
		DelayCommand(0.25f, HideWeapon(oPC));
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eReforming, lSword, 3.0f);
		DelayCommand(2.8f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eExplosion, lSword, 6.0f));
		DelayCommand(2.8f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSword, oSword));
		DelayCommand(3.0f, UnhideSwordCreature(oSword));
		DelayCommand(4.5f, SwordAttacks(lTargetLocation, oPC, oItem, oSword));	
	}
}

void UnhideSwordCreature(object oSword)
{
	SetScriptHidden(oSword, FALSE);
}

void HideWeapon(object oPC)
{
	int nUniqueID = GetSilverSwordUniqueId(oPC);

	RemoveEffectsFromSpell(oPC, nUniqueID);
}

void SwordAttacks(location lTarget, object oPC, object oItem, object oSword)
{
	object oLastAttacked;
	int i = 1;
	float fDelay = 1.0f;
	int nDamage;
	int nRandom;
	string sSoundName;
	effect eReforming = EffectNWN2SpecialEffectFile("fx_silversword_reform.sef");	
	effect eDam;
	effect eVis = EffectNWN2SpecialEffectFile("fx_ssword_rushair.sef");
	effect eVis2 = EffectNWN2SpecialEffectFile("sp_magic_hit.sef");
	location lJumpLocation;
	
	nRandom = RandomIntBetween(1, 4);		
	
	PlayCustomLoopingAnimation(oSword, "1hS_1attack0" + IntToString(nRandom), 1.0f);
	AssignCommand(oSword, PlaySound("it_bladelg_draw01"));
		
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, 
		lTarget, FALSE, OBJECT_TYPE_CREATURE);
		
	JumpAndAttack(oTarget, lTarget, oPC, oItem, oLastAttacked, oSword);
}

void AttackSingleTarget(object oTarget, object oPC, object oItem, object oSword)
{
	location lSword;
	string sSoundName;	
	effect eDam;
	effect eVis = EffectNWN2SpecialEffectFile("fx_ssword_rushair.sef");
	effect eVis2 = EffectNWN2SpecialEffectFile("sp_magic_hit.sef");	
	effect eKnockdown = EffectKnockdown();
	int nDamage;
	int nRandom;
	object oLastAttackedTarget;
	location lJumpLocation;
	float fDelay;
	int nRandomAnimation;
	string sAttackAnimation;
	int nTimesHit = PS_GetLocalInt(oSword, "TimesHit");
	
	object oSlotItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	
    if (GetIsDead(oPC) == TRUE)
    {
		EndAttackDead(oPC, oItem, oSword);
        return;
    }
	
	if (PS_GetLocalInt(oItem, "SS_Stop_Ability") == 1)
	{
		EndAttack(oPC, oItem, oSword);
		return;
	}
	
	if (IsInMultiplayerConversation(oPC) == TRUE)
	{
		EndAttack(oPC, oItem, oSword);
		return;
	}
	
	if (GetTag(oSlotItem) != TAG_SILVER_SWORD)
	{
		oSlotItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
		
		if (GetTag(oSlotItem) != TAG_SILVER_SWORD)
		{		
			EndAttack(oPC, oItem, oSword);
			return;
		}		
	}
	
    if (GetIsObjectValid(oTarget) == TRUE && nTimesHit < 30 == TRUE)
	{			
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC))
		{
			PS_SetLocalInt(oSword, "TimesHit", nTimesHit + 1);
			nTimesHit = PS_GetLocalInt(oSword, "TimesHit");
			
			nDamage = d6();		
			eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY);
			
			nRandom = RandomIntBetween(1, 4);
			
			switch(nRandom)
			{
				case 1:			
					lJumpLocation = GetBehindLocation(oTarget, 1.0f);
					break;
				case 2:			
					lJumpLocation = GetAheadLocation(oTarget, 1.0f);
					break;
				case 3:			
					lJumpLocation = GetLeftLocation(oTarget, 1.0f);
					break;
				case 4:			
					lJumpLocation = GetRightLocation(oTarget, 1.0f);
					break;
			}
			
			nRandomAnimation = RandomIntBetween(1, 11);
			
			switch(nRandomAnimation)
			{
				case 1:
					sAttackAnimation = "1hSS_1attack0" + IntToString(nRandom);
					break;
				case 2:
					sAttackAnimation = "1hS_1attack0" + IntToString(nRandom);
					break;
				case 3:
					sAttackAnimation = "C2h_1attack0" + IntToString(nRandom);
					break;
				case 4:
					sAttackAnimation = "D2h_1attack0" + IntToString(nRandom);
					break;
				case 5:
					sAttackAnimation = "O2hT_1attack0" + IntToString(nRandom);
					break;
				case 6:
					sAttackAnimation = "O2hS_1attack0" + IntToString(nRandom);
					break;
				case 7:
					sAttackAnimation = "1hS_cleave";
					break;
				case 8:
					sAttackAnimation = "C2h_cleave";
					break;
				case 9:
					sAttackAnimation = "D2h_cleave";
					break;
				case 10:
					sAttackAnimation = "1hS_whirlwind";
					break;
				case 11:
					sAttackAnimation = "C2h_whirlwind";
					break;	
			}		
			
			AssignCommand(oSword, JumpToLocation(lJumpLocation));
			AssignCommand(oSword, ActionDoCommand(PlayCustomOneShotAnimation(oSword, 
					sAttackAnimation, 1.0f)));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			
			if (nTimesHit == 1 || nTimesHit == 5 || nTimesHit == 9 || nTimesHit == 13 || 
				nTimesHit == 17 || nTimesHit == 21 || nTimesHit == 25 || nTimesHit == 29)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0f);
			}
			
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, oTarget, 3.0f);
			
		    if (MySavingThrow(SAVING_THROW_FORT, oTarget, 22) == FALSE)
            {
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 3.0f);
            }
			
			nRandom = RandomIntBetween(1, 4);
			sSoundName = "cb_sw_blade0" + IntToString(nRandom);
			AssignCommand(oSword, PlaySound(sSoundName));
		}
							
	}
				
	if (GetIsObjectValid(oTarget) == TRUE && nTimesHit < 30 == TRUE)
	{
		DelayCommand(0.25f, AttackSingleTarget(oTarget, oPC, oItem, oSword));
	}
				
	else
	{	
		EndAttack(oPC, oItem, oSword);
	}
	
	PrettyDebug("Reached the end.");
}

void JumpAndAttack(object oTarget, location lTarget, object oPC, object oItem, object oLastAttacked, 
	object oSword)
{
	object oOriginalTarget;
	location lSword;
	location lPC;
	string sSoundName;	
	effect eDam;
	effect eVis = EffectNWN2SpecialEffectFile("fx_ssword_rushair.sef");
	effect eVis2 = EffectNWN2SpecialEffectFile("sp_magic_hit.sef");	
	effect eKnockdown = EffectKnockdown();
	int nDamage;
	int nRandom;
	int nRandomAnimation;
	string sAttackAnimation;
	location lJumpLocation;
	float fDelay;
	int nTimesHit = PS_GetLocalInt(oSword, "TimesHit");
	
	object oSlotItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	
    if (GetIsDead(oPC) == TRUE)
    {
		EndAttackDead(oPC, oItem, oSword);
        return;
    }
	
	if (PS_GetLocalInt(oItem, "SS_Stop_Ability") == 1)
	{
		EndAttack(oPC, oItem, oSword);
		return;
	}
	
	if (IsInMultiplayerConversation(oPC) == TRUE)
	{
		EndAttack(oPC, oItem, oSword);
		return;
	}
	
	if (GetTag(oSlotItem) != TAG_SILVER_SWORD)
	{
		oSlotItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
		
		if (GetTag(oSlotItem) != TAG_SILVER_SWORD)
		{		
			EndAttack(oPC, oItem, oSword);
			return;
		}		
	}
	
    if (GetIsObjectValid(oTarget) == TRUE && nTimesHit < 30 == TRUE)
	{			
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC) == TRUE)
//		if (GetIsEnemy(oTarget, oPC) == TRUE)
		{
			PrettyDebug("Enemy evaluation is " + IntToString(GetIsEnemy(oTarget, oPC)));
			PS_SetLocalInt(oSword, "NoTargetsFound", 0);
			PS_SetLocalInt(oSword, "TimesHit", nTimesHit + 1);
			nTimesHit = PS_GetLocalInt(oSword, "TimesHit");
										
			if (oLastAttacked == oTarget)
			{
				PrettyDebug("Last attcked is same as current target.");
				nDamage = d6();
			}
			
			else
			{
				nDamage = d6(6);		
			}	
			
			eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY);
			
			nRandom = RandomIntBetween(1, 4);
			
			switch(nRandom)
			{
				case 1:			
					lJumpLocation = GetBehindLocation(oTarget, 1.0f);
					break;
				case 2:			
					lJumpLocation = GetAheadLocation(oTarget, 1.0f);
					break;
				case 3:			
					lJumpLocation = GetLeftLocation(oTarget, 1.0f);
					break;
				case 4:			
					lJumpLocation = GetRightLocation(oTarget, 1.0f);
					break;
			}
			
			nRandomAnimation = RandomIntBetween(1, 11);
			
			switch(nRandomAnimation)
			{
				case 1:
					sAttackAnimation = "1hSS_1attack0" + IntToString(nRandom);
					break;
				case 2:
					sAttackAnimation = "1hS_1attack0" + IntToString(nRandom);
					break;
				case 3:
					sAttackAnimation = "C2h_1attack0" + IntToString(nRandom);
					break;
				case 4:
					sAttackAnimation = "D2h_1attack0" + IntToString(nRandom);
					break;
				case 5:
					sAttackAnimation = "O2hT_1attack0" + IntToString(nRandom);
					break;
				case 6:
					sAttackAnimation = "O2hS_1attack0" + IntToString(nRandom);
					break;
				case 7:
					sAttackAnimation = "1hS_cleave";
					break;
				case 8:
					sAttackAnimation = "C2h_cleave";
					break;
				case 9:
					sAttackAnimation = "D2h_cleave";
					break;
				case 10:
					sAttackAnimation = "1hS_whirlwind";
					break;
				case 11:
					sAttackAnimation = "C2h_whirlwind";
					break;	
			}
			
			AssignCommand(oSword, JumpToLocation(lJumpLocation));
			AssignCommand(oSword, ActionDoCommand(PlayCustomOneShotAnimation(oSword, 
					sAttackAnimation, 1.0f)));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			
			if (nTimesHit == 1 || nTimesHit == 5 || nTimesHit == 9 || nTimesHit == 13 || 
				nTimesHit == 17 || nTimesHit == 21 || nTimesHit == 25 || nTimesHit == 29)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0f);
			}
			
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, oTarget, 3.0f);
			
		    if (MySavingThrow(SAVING_THROW_FORT, oTarget, 20) == FALSE)
            {
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 3.0f);
            }
			
			nRandom = RandomIntBetween(1, 4);
			sSoundName = "cb_sw_blade0" + IntToString(nRandom);
			AssignCommand(oSword, PlaySound(sSoundName));

			oLastAttacked = oTarget;
		}
							
	}
		
	oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, 
		lTarget, FALSE, OBJECT_TYPE_CREATURE);	
		
	if (GetIsObjectValid(oTarget) == FALSE && nTimesHit < 30 == TRUE)
	{
		PrettyDebug(IntToString(nTimesHit));
		lSword = GetLocation(oSword);
		
		oOriginalTarget = oTarget;
		
		oTarget = FindNextTarget(lSword, oPC, oOriginalTarget, oSword);
		
		lTarget = lSword;
			
		if (GetIsObjectValid(oTarget) == FALSE)
		{
			lPC = GetLocation(oPC);
			oTarget = FindNextTarget(lSword, oPC, oOriginalTarget, oSword);
			lTarget = lPC;
		}	
		
		if (GetIsObjectValid(oTarget) == FALSE)
		{
			lPC = GetLocation(oPC);
			PrettyDebug("Ending attack 1.");
			EndAttack(oPC, oItem, oSword);
		}		
		
		else
		{
			if (PS_GetLocalInt(oSword, "NoTargetsFound") == 0)
			{
				PS_SetLocalInt(oSword, "NoTargetsFound", 1);
				DelayCommand(0.25f, JumpAndAttack(oTarget, lTarget, oPC, oItem, oLastAttacked, oSword));				
			}	

			else
			{
				JumpAndAttack(oTarget, lTarget, oPC, oItem, oLastAttacked, oSword);	
			}		
		}		
	}	
	
	else if (nTimesHit >= 30 == TRUE)
	{	
		PrettyDebug("Ending attack 3.");
		EndAttack(oPC, oItem, oSword);
	}
	
	else
	{	
		PrettyDebug("Starting JumpandAttack again 2.");
		DelayCommand(0.25f, JumpAndAttack(oTarget, lTarget, oPC, oItem, oLastAttacked, oSword));
	}
	
	PrettyDebug("Reached the end.");
}	

object FindNextTarget(location lSword, object oPC, object oOriginalTarget, object oSword)
{
	object oTarget;
	location lSword = GetLocation(oSword);
	
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, 
		lSword, FALSE, OBJECT_TYPE_CREATURE);

	while (GetIsObjectValid(oTarget) == TRUE)
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC) == TRUE &&
			oOriginalTarget != oTarget)
		{
			return oTarget;
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, 
			lSword, FALSE, OBJECT_TYPE_CREATURE);
	}
	
	return OBJECT_INVALID;	
}				

void EndAttack(object oPC, object oItem, object oSword)
{
	SetScriptHidden(oSword, TRUE);
	DelayCommand(0.2f, DestroyObject(oSword));
	RevealWeapon(oPC, oItem);
	DelayCommand(2.5f, RestoreItemAbilities(oItem));
	PS_SetLocalInt(oItem, "SS_Stop_Ability", 0);
}	

void EndAttackDead(object oPC, object oItem, object oSword)
{
	SetScriptHidden(oSword, TRUE);
	DelayCommand(0.2f, DestroyObject(oSword));
	RevealWeapon(oPC, oItem);
	DelayCommand(2.5f, RestoreItemAbilities(oItem));
	PS_SetLocalInt(oItem, "SS_Stop_Ability", 0);
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
	effect eSwordStandInTemp;
	effect eSwordStandIn;
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