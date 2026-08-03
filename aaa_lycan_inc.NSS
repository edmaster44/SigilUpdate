/*
May 30, 2024: FlattedFifth
	Removed requirement for wererat to have sneak attack from other sources
	in order to get +2d6 temp sneak dice in hybrid form.

*/

#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "ps_inc_functions"
#include "ps_inc_equipment"
#include "ps_inc_advscript"
#include "aaa_constants"
#include "nw_i0_spells"
#include "aaa_changeself_inc"
#include "x0_i0_match"
#include "ps_inc_melee"
#include "x2_inc_itemprop"

void PS_Lycan_Bite(object oPC, object oTarget, object oItem, int nSpell){
	// cannot use unless in hybrid or animal form
	int bReset = FALSE;
	if (!GetLocalInt(oItem, "Hybrid") && !GetLocalInt(oItem, "TempChange") &&
		!GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC)){
		SendMessageToPC(oPC, "You can only use this ability in hybrid or animal form");
		bReset = TRUE;
	}
	if (!PS_GetTargetInRange(oPC, oTarget, GetSpellFeatId(), FALSE)){
		SendMessageToPC(oPC, "You can only bite enemies within biting range");
		bReset = TRUE;
	}
	if (bReset){
		ResetFeatUses(oPC, GetSpellFeatId(), TRUE, TRUE);
		return;
	}
	// do a finessable melee touch attack to see if the bite hits
	int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
	int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
	int nBonus = (nDex > nStr) ? nDex - nStr : 0;
	// * These return TOUCH_ATTACK_RESULT_MISS, TOUCH_ATTACK_RESULT_HIT, or TOUCH_ATTACK_RESULT_CRITICAL
	int nAttack = TouchAttackMelee(oTarget, FALSE, nBonus);
	if (nAttack == TOUCH_ATTACK_RESULT_MISS){
		SendMessageToPC(oPC, "<c=tomato>Bite attack: Miss!</c>");
		return;
	}
	int nDamage = d10() + nStr;

	if (nAttack == TOUCH_ATTACK_RESULT_CRITICAL){
		nDamage *= 2;
		SendMessageToPC(oPC, "<c=orange>Bite attack critical hit!</c>");
	} else SendMessageToPC(oPC, "Bite attack hit!");
	
	// now apply damage and see if it's all resisted or not
	int nHP = GetCurrentHitPoints(oTarget);
	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL, FALSE);
	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell, TRUE));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	int nPostHP = GetCurrentHitPoints(oTarget);
	// if the target's DR absorbed all damage, then no bleed DOT. Exit
	if (nPostHP >= nHP){
		SendMessageToPC(oPC, "<c=tomato>Your target resisted all damage from your bite!</c>");
		return;
	} else {
		SendMessageToPC(oPC, "You've bitten your opponent for " + IntToString(nHP - nPostHP) + " damage!");
	}
	
	// constructs, elementals, incorporeal, oozes, plants, and undead do not take bleed damage
	int nRace = GetRacialType(oTarget);
	int nSub = GetSubRace(oTarget);
	if (nRace == RACIAL_TYPE_UNDEAD || nRace == RACIAL_TYPE_ELEMENTAL || nRace == RACIAL_TYPE_CONSTRUCT || 
		nRace == RACIAL_TYPE_OOZE || nRace == RACIAL_TYPE_INCORPOREAL || nSub == RACIAL_SUBTYPE_CONSTRUCT || 
		nSub == RACIAL_SUBTYPE_ELEMENTAL || nSub == RACIAL_SUBTYPE_UNDEAD || nSub == RACIAL_SUBTYPE_INCORPOREAL || 
		nSub ==  RACIAL_SUBTYPE_PLANT || nSub == RACIAL_SUBTYPE_OOZE)
			return;
	int nDot = d6();
	if (nAttack == TOUCH_ATTACK_RESULT_CRITICAL) nDot *= 2;		
	effect eDot = EffectDamageOverTime(nDot, 6.0, DAMAGE_TYPE_MAGICAL, TRUE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDot, oTarget, 18.0);
}


void PS_Lycan_Affliction(object oPC, object oItem, int nSpell)	
{
	int nAfflict = GetLocalInt(oItem, "Lycan_Affliction");
	
	int nOldECL = PS_GetEssenceECL(oPC);
	
	if (nAfflict != 0)
	{	return;		}
	else
	{	// Clangeddin UI script.
		AddScriptParameterString("START");
		AddScriptParameterString("");
		ExecuteScriptEnhanced("gui_extra_choices", oPC);	}
	
	SetLocalString(oItem, "Template", "Lycan");
	SetLocalInt(oItem, "Lycan_Affliction", 1);  
}


// Helper feat for granting wererat sneak attack bonus
void PS_Wererat_SneakAdd(object oPC)
{
	// adds 2 dice of blackguard sneak attack. Shouldn't conflict with anything since blackguard
	// path gets normal sneak dice.
	if (GetHasFeat(2593, oPC))
	{	FeatAdd(oPC, 460, 0);
		FeatAdd(oPC, 461, 0);
		SendMessageToPC(oPC, "Wererat sneak attack feats granted while in hybrid form."); 	}
}

// Helper feat for removing wererat sneak attack bonus
void PS_Wererat_SneakRemove(object oPC)
{
	if (GetHasFeat(2593, oPC))
	{	FeatRemove(oPC, 460);
		FeatRemove(oPC, 461);
		SendMessageToPC(oPC, "Wererat sneak attack feats removed while not in hybrid form.");	}
}

void PS_Wererat_AnimalSneakApply(object oPC)
{	
	itemproperty ipSneak1 	= ItemPropertyBonusFeat(553);
	itemproperty ipSneak2	= ItemPropertyBonusFeat(554);
	object oSkin			= GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
	if (GetHasFeat(2593, oPC))
	{	IPSafeAddItemProperty(oSkin, ipSneak1, HoursToSeconds(24));
		IPSafeAddItemProperty(oSkin, ipSneak2, HoursToSeconds(24));	}
}

void PS_Lycan_HybridWeaponAdd(object oPC, object oItem)
{
	string sWeapon1, sWeapon2, sWeapon3;
	if (GetHasFeat(2592, oPC))
	{	sWeapon1		= "s3_w_werewolfbite_01";
		sWeapon2		= "s3_w_werewolfclaw_01";
		sWeapon3		= "s3_w_werewolfclaw_01";	}
	else if (GetHasFeat(2592, oPC))
	{	sWeapon1		= "s3_w_wereratbite_01";
		sWeapon2		= "s3_w_wereratclaw_01";
		sWeapon3		= "s3_w_wereratclaw_01";		}
	else if (GetHasFeat(2610, oPC))
	{	sWeapon1		= "s3_w_wereboargore_01";
		sWeapon2		= "s3_w_wereboargore_01";								}
	else if (GetHasFeat(2656, oPC))
	{	sWeapon1		= "s3_w_weretigerbite_01";
		sWeapon2		= "s3_w_weretigerclaw_01";
		sWeapon3		= "s3_w_weretigerclaw_01";	}
	else
	{	return;		}
	
	object oWeapon1		= CreateItemOnObject(sWeapon1, oPC);
	object oWeapon2		= CreateItemOnObject(sWeapon2, oPC);
	object oWeapon3		= CreateItemOnObject(sWeapon3, oPC);
	SetLocalInt(oItem, "LycanWeapons", 1);
	SendMessageToPC(oPC, "Equippable creature weapons added to inventory!");
}

void PS_Lycan_ScaledWeaponApply(object oWeapon, object oPC)
{
	itemproperty ipEnhance1 = ItemPropertyEnhancementBonus(1);
	itemproperty ipEnhance3 = ItemPropertyEnhancementBonus(3);
	itemproperty ipEnhance5 = ItemPropertyEnhancementBonus(5);
	itemproperty ipDamage3	= ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d6);
	itemproperty ipDamage5	= ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d6);
	itemproperty ipKeen3	= ItemPropertyKeen();
	itemproperty ipMassive5	= ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d8);
	int nLevel				= PS_GetLevel(oPC);
	
	if (nLevel >= 21)
	{	IPSafeAddItemProperty(oWeapon, ipEnhance5);
		IPSafeAddItemProperty(oWeapon, ipDamage5);
		IPSafeAddItemProperty(oWeapon, ipKeen3);
		IPSafeAddItemProperty(oWeapon, ipMassive5);		}
	else if (nLevel >= 11)
	{	IPSafeAddItemProperty(oWeapon, ipEnhance3);
		IPSafeAddItemProperty(oWeapon, ipDamage3);
		IPSafeAddItemProperty(oWeapon, ipKeen3);		}
	else
	{	IPSafeAddItemProperty(oWeapon, ipEnhance1);		}
}

void PS_Lycan_ScaledWeapons(object oPC)
{
	object oWeaponR		= GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
	object oWeaponL		= GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
	object oWeaponB		= GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);

	itemproperty ipEnhance1 = ItemPropertyEnhancementBonus(1);
	itemproperty ipEnhance3 = ItemPropertyEnhancementBonus(3);
	itemproperty ipEnhance5 = ItemPropertyEnhancementBonus(5);
	itemproperty ipDamage3	= ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d6);
	itemproperty ipDamage5	= ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d6);
	itemproperty ipKeen3	= ItemPropertyKeen();
	itemproperty ipMassive5	= ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d8);
	
	if (oWeaponR != OBJECT_INVALID)
	{	DelayCommand(1.0f, PS_Lycan_ScaledWeaponApply(oWeaponR, oPC));	}
	if (oWeaponL != OBJECT_INVALID)
	{	DelayCommand(1.0f, PS_Lycan_ScaledWeaponApply(oWeaponL, oPC));	}
	if (oWeaponB != OBJECT_INVALID)
	{	DelayCommand(1.0f, PS_Lycan_ScaledWeaponApply(oWeaponB, oPC));	}
}

// Helper feat for adding and removing multiattack in animal/hybrid form
void PS_Lycan_Multiattack(object oPC, int bHasMultiattack = FALSE){
	/*
	itemproperty ipMA	= ItemPropertyBonusFeat(1315);
	object oSkin		= GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	
	IPSafeAddItemProperty(oSkin, ipMA, HoursToSeconds(24));
	*/
	if (bHasMultiattack) FeatAdd(oPC, 4000, FALSE);
	else FeatRemove(oPC, 4000);

	object oRHAND = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oLHAND = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	NaturalMultiattack(oPC, oRHAND, oLHAND);
}



void PS_Lycan_AnimalForm(object oPC, object oItem, int nSpell)
{
	int nCheck		= GetLocalInt(oItem, "Hybrid");
	int nTemp		= GetLocalInt(oItem, "TempChange");
		
    if (!X2PreSpellCastCode())
    {	return;		}
    effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
 	int nPoly;
	if (GetHasFeat(LYCAN_AFFLICTION_WEREBOAR, oPC))
	{	nPoly = POLYMORPH_WEREBOAR_ANIMFORM;	}
	else if (GetHasFeat(LYCAN_AFFLICTION_WERERAT, oPC))
	{	nPoly = POLYMORPH_WERERAT_ANIMFORM;	}
	else if (GetHasFeat(LYCAN_AFFLICTION_WERETIGER, oPC))
	{	nPoly = POLYMORPH_WERETIGER_ANIMFORM;	}
	else
	{	nPoly = POLYMORPH_WEREWOLF_ANIMFORM;	}
    effect ePoly = EffectPolymorph(nPoly, FALSE, TRUE);
		ePoly = EffectLinkEffects(ePoly, eVis);
		
	if (nCheck == 1 || nTemp == 1) 	
	{	PS_RestoreOriginalAppearance(oPC);
		PS_RefreshAppearance(oPC);
		RemoveEffectsFromSpell(oPC, 334);
		SetLocalInt(oItem, "Hybrid", 0);
		SetLocalInt(oItem, "TempChange", 0);
		PS_Wererat_SneakRemove(oPC);
		//FeatRemove(oPC, 289);
	}	

    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    AssignCommand(oPC, ClearAllActions()); // prevents an exploit
    PS_RestoreOriginalAppearance(oPC);
	PS_RefreshAppearance(oPC);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(24));
	PS_Wererat_AnimalSneakApply(oPC);
	PS_Lycan_Multiattack(oPC, TRUE);
	PS_Lycan_ScaledWeapons(oPC);
	
}

void PS_Lycan_DR(object oPC, int nSpell)	
{
	int nLevel	= GetLevelByClass(CLASS_TYPE_LYCAN_PRC, oPC);
	int nAmount		= 5;
	if (nLevel >= 5 ) 
	{	nAmount 	= 10;	}
	
	effect eDR		= EffectDamageReduction(nAmount,GMATERIAL_METAL_ALCHEMICAL_SILVER, 0, DR_TYPE_GMATERIAL);
		eDR			= SupernaturalEffect(eDR);
		eDR			= SetEffectSpellId(eDR, nSpell);
	RemoveEffectsFromSpell(oPC, nSpell);
	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC);
	if (GetLocalInt(oPC, "lycanDR") != nAmount){
		SendMessageToPC(oPC, "Damage Reduction of " + IntToString(nAmount) + "/silver applied.");
		SetLocalInt(oPC, "lycanDR", nAmount);
	}
}

void PS_Lycan_HybridForm(object oPC, object oItem, int nSpell)
{
	int nCheck		= GetLocalInt(oItem, "Hybrid");
	int nTemp		= GetLocalInt(oItem, "TempChange");
	int nWeapons	= GetLocalInt(oItem, "LycanWeapons");
	int nAfflict;
	int nStr;
	int nDex;
	int nCon;
	if (GetHasFeat(2592, oPC))
	{	nAfflict = (GetGender(oPC) == GENDER_FEMALE) ? 171 : 1294;			//Werewolf 171 is female from og
		nStr = 10;
		nDex = 5;
		nCon = 7;	}
	else if (GetHasFeat(2593, oPC)) 
	{	nAfflict = 1045;	//Wererat
		nStr = 5;
		nDex = 10;
		nCon = 7;	}
	else if (GetHasFeat(2610, oPC)) 
	{	nAfflict = 1295;	//Wereboar
		nStr = 7;
		nDex = 5;
		nCon = 10;	}
	else if (GetHasFeat(2656, oPC)) 
	{	nAfflict = 1296;	//Weretiger
		nStr = 10;
		nDex = 7;
		nCon = 5;	}
	else 
	{	return;	}
	
	
	effect eStr 	= EffectAbilityIncrease(ABILITY_STRENGTH, nStr);
	effect eDex 	= EffectAbilityIncrease(ABILITY_DEXTERITY, nDex);
	effect eCon 	= EffectAbilityIncrease(ABILITY_CONSTITUTION, nCon);
	effect eLink 	= EffectLinkEffects(eStr, eDex);
		eLink 		= EffectLinkEffects(eLink, eCon);
		
	//int nPCLevel	= PS_GetLevel(oPC);
	int nRegen = (PS_GetLevel(oPC) >= 15) ? 2 : 1;
	eLink = EffectLinkEffects(EffectRegenerate(nRegen, 6.0), eLink);
	
	if (GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC))
	{	RemoveSpecificEffect(EFFECT_TYPE_POLYMORPH, oPC);
	}
			
	if (nCheck == 1 || nTemp == 1) 	
	{	PS_RestoreOriginalAppearance(oPC);
		PS_RefreshAppearance(oPC);
		RemoveEffectsFromSpell(oPC, nSpell);
		SetLocalInt(oItem, "Hybrid", 0);
		SetLocalInt(oItem, "TempChange", 0);
		PS_Wererat_SneakRemove(oPC);
		PS_Lycan_Multiattack(oPC, FALSE);
		//FeatRemove(oPC, 289);
	}
	else 
	{	//FeatAdd (oPC, 289, FALSE);
		
		if (GetLocalInt(oItem, "VFX_LYCAN")){
			PS_RestoreOriginalAppearance(oPC);
			string sVFXmessage = "The power of your hybrid form surges through your body, but you manage to ";
			sVFXmessage += " channel the strength without changing form.";
			SendMessageToPC(oPC, sVFXmessage);
			eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_BOND_OF_FATAL_TOUCH), eLink);
			eLink = EffectLinkEffects(EffectNWN2SpecialEffectFile("FX_DEATH_GOD_LIGHT_GREEN", oPC), eLink);
			//eLink = EffectLinkEffects(EffectNWN2SpecialEffectFile("FX_WILLOWISP_GREEN_B", oPC), eLink);
			//eLink = EffectLinkEffects(EffectNWN2SpecialEffectFile("FX_WILLOWISP_GREEN", oPC), eLink);
		} else {
			struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
			app.AppearanceType = nAfflict;
			PS_SetCreatureCoreAppearance(oPC, app);
			SetLocalInt(oItem, "TempChange", 1);
			PS_RefreshAppearance(oPC);
		}
		eLink		= SupernaturalEffect(eLink);
		SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
		SetLocalInt(oItem, "Hybrid", 1);
		PS_Wererat_SneakAdd(oPC);
	}
	
	if (nWeapons != 1)
	{	PS_Lycan_HybridWeaponAdd(oPC, oItem);	}
}

void PS_Lycan_BPWerewolf(object oPC, object oTarget, object oItem, int nSpell)
{
	int nIsAnimal		= GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC);
	int nIsHybrid		= GetLocalInt(oItem, "Hybrid");
	if (!nIsAnimal && !nIsHybrid){
		SendMessageToPC(oPC, "This ability is only usable in Animal or Hybrid form.");
		return;
	}
	int nDamage			= 0;
	int nAttack;
	object oWeapon		= GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	string sWeapon		= GetTag(oWeapon);
		sWeapon			= GetStringLeft(sWeapon, 4);
	int nLevel			= PS_GetLevel(oPC);
	int nStr			= GetAbilityModifier(ABILITY_STRENGTH, oPC);
	int nTargetMod		= GetAbilityModifier(ABILITY_STRENGTH, oTarget);
	int nTargetDex			= GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
	if (nTargetDex >= nTargetMod)
	{	nTargetMod = nTargetDex;	}
	int nRollPC, nRollTarget;
	effect eTrip		= EffectKnockdown();
	effect eDamage;

	if (nIsAnimal == 1)
	{	nAttack = AttemptMeleeAttackMainHand(oPC, oTarget, "Trip", 1, "1attack01", 0,nSpell);
		if (nAttack == 2)
		{	nDamage = d10(2);
			if (GetHasFeat(2390, oPC) && GetHasFeat(883))
			{	nDamage = FloatToInt(IntToFloat(nDamage) * 1.5);	}
			if (GetHasFeat(746))
			{	nDamage = nDamage + d6(1);	}
			eDamage = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL, FALSE);
			
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		}
		else if (nAttack == 1)
		{	nDamage = d10(1);	
			eDamage = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL, FALSE);
			
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		}
		else 
		{	SendMessageToPC(oPC, "Your attack missed!");
			return;	
		}
		// Trip attempt!
		nRollPC = d20(1) + nStr;
		nRollTarget = d20(1) + nTargetMod;
		if (nRollPC > nRollTarget)
		{	
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrip, oTarget, 12.0f);
			SendMessageToPC(oPC, "Success! You have tripped " + GetName(oTarget));
			SendMessageToPC(oPC, "You have been tripped by " + GetName(oPC));
		}
		else 
		{	SendMessageToPC(oPC, "Your trip attack was unsuccessful!");
			SendMessageToPC(oTarget, GetName(oPC) + "'s trip attack was unsuccessful!");
		}
	}
	else if (nIsHybrid == 1)
	{	
			nAttack = AttemptMeleeAttackMainHand(oPC, oTarget, "Trip", 1, "1attack01", 0,nSpell);
			if (nAttack == 2)
			{	if (nLevel >= 24) nDamage = d10(4) + d10(2);
				else if (nLevel >= 16) nDamage = d8(4) + d8(2);
				else if (nLevel >= 8) nDamage = d6(4) + d6(2);
				else nDamage = d10(2) + d6(2);
				if (GetHasFeat(2390, oPC) && GetHasFeat(883))
				{	nDamage = FloatToInt(IntToFloat(nDamage) * 1.5);	}
				if (GetHasFeat(746))
				{	nDamage = nDamage + d6(1);	}
				eDamage = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL, FALSE);
				
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
			}
			else if (nAttack == 1)
			{	if (nLevel >= 24) nDamage = d10(2);
				else if (nLevel >= 16) nDamage = d8(2);
				else if (nLevel >= 8) nDamage = d6(2);
				else nDamage = d10(1);
				eDamage = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL, FALSE);
				
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
			}
			else 
			{	SendMessageToPC(oPC, "Your attack missed!");
				return;	
			}
			// Trip attempt!
			nRollPC = d20(1) + nStr;
			nRollTarget = d20(1) + nTargetMod;
			if (nRollPC > nRollTarget)
			{	
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrip, oTarget, 12.0f);
				SendMessageToPC(oPC, "Success! You have tripped " + GetName(oTarget));
				SendMessageToPC(oPC, "You have been tripped by " + GetName(oPC));
			}
			else 
			{	SendMessageToPC(oPC, "Your trip attack was unsuccessful!");
				SendMessageToPC(oTarget, GetName(oPC) + "'s trip attack was unsuccessful!");
			}
		}	
}

void PS_Lycan_BPWereboar(object oPC, object oItem, int nSpell)
{
	int nIsAnimal		= GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC);
	int nIsHybrid		= GetLocalInt(oItem, "Hybrid");
	int nLevel			= PS_GetLevel(oPC); 
	effect eTempHP		= EffectTemporaryHitpoints(nLevel * 2);
	itemproperty ipDam	= ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, d4(2));
	object oWeapR, oWeapL;
	string sWeapR, sWeapL;
	int nFullHP			= GetMaxHitPoints(oPC);
	int nHalfHP			= (nFullHP / 2);

	if (GetCurrentHitPoints(oPC) >= nHalfHP)
	{	SendMessageToPC(oPC, "This ability is only usable if you have been damaged to lower than half of your full hit points.");
		return;	}
	if(nIsAnimal == 1)
	{	oWeapR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
		oWeapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHP, oPC, 60.0f);
		IPSafeAddItemProperty(oItem, ipDam, 60.0f);
		IPSafeAddItemProperty(oItem, ipDam, 60.0f);
	}
	else if (nIsHybrid == 1)
	{	oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		sWeapR = GetTag(oWeapR);
			sWeapR	= GetStringLeft(sWeapR, 4);
		oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
		sWeapL = GetTag(oWeapL);
			sWeapR	= GetStringLeft(sWeapR, 4);
		if (!IPGetIsCreatureEquippedWeapon(oItem))
		{	
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHP, oPC, 60.0f);
			SendMessageToPC(oPC, "Damage bonus not applied unless creature weapon(s) are equipped!");
		}
		else
		{	
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHP, oPC, 60.0f);
			if (IPGetIsCreatureEquippedWeapon(oItem))
			{	IPSafeAddItemProperty(oItem, ipDam, 60.0f);
				SendMessageToPC(oPC, "Damage bonus applied to right tusk!");	}
			if (IPGetIsCreatureEquippedWeapon(oItem))
			{	IPSafeAddItemProperty(oItem, ipDam, 60.0f);
				SendMessageToPC(oPC, "Damage Bonus applied to left tusk!");	}
		}
	}
	else
	{	SendMessageToPC(oPC, "This ability is only usable in Animal or Hybrid form.");	}
}

void PS_Lycan_BPWeretiger(object oPC, object oTarget, object oItem, int nSpell)
{
	
	int nIsAnimal		= GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC);
	int nIsHybrid		= GetLocalInt(oItem, "Hybrid");
	int nDamage			= 0;
	int nRake			= 0;
	int nAttack;
	object oWeapon		= GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	string sWeapon		= GetTag(oWeapon);
		sWeapon			= GetStringLeft(sWeapon, 4);
	int nLevel			= PS_GetLevel(oPC);
	int nStr			= GetAbilityModifier(ABILITY_STRENGTH, oPC);
	int nTargetMod		= GetAbilityModifier(ABILITY_STRENGTH, oTarget);
	int nTargetDex			= GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
	if (nTargetDex >= nTargetMod)
	{	nTargetMod = nTargetDex;	}
	int nRollPC, nRollTarget;
	effect eTrip		= EffectKnockdown();
	effect eDamage, eRake, eRake2;

	if (nIsAnimal == 1)
	{	nAttack = AttemptMeleeAttackMainHand(oPC, oTarget, "Rake", 1, "1attack01", 0,nSpell);
		if (nAttack == 2)
		{	nDamage = d8(4);
			nDamage = (nDamage + (nStr * 2));
			if (GetHasFeat(2390, oPC) && GetHasFeat(883))
			{	nDamage = FloatToInt(IntToFloat(nDamage) * 1.5);	}
			if (GetHasFeat(746))
			{	nDamage = nDamage + d6(1);	}
			eDamage = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL, FALSE);
			
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		}
		else if (nAttack == 1)
		{	nDamage = d8(2);
			nDamage = (nDamage + nStr);
			eDamage = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL, FALSE);
			
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		}
		else 
		{	SendMessageToPC(oPC, "Your attack missed!");
			return;	
		}
		// Rake!
		{	nRake = d4(4);
			nRake = (nRake = nStr);
			eRake = EffectDamage(nRake, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_NORMAL, FALSE);
			
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eRake, oTarget);
			SendMessageToPC(oPC, "You rake your opponent with your back claws!");
			SendMessageToPC(oTarget, GetName(oPC) + " bites down and rakes you with their rear claws!");
			eRake2 = EffectDamage(nRake, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_NORMAL, FALSE);
			
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eRake2, oTarget);
			SendMessageToPC(oTarget, GetName(oPC) + " bites down and rakes you with their rear claws!");
		}
	}
	else if (nIsHybrid == 1)
	{	
			nAttack = AttemptMeleeAttackMainHand(oPC, oTarget, "Rake", 1, "1attack01", 0,nSpell);
			if (nAttack == 2)
			{	if (nLevel >= 24)
				{	nDamage = d10(4) + d10(2);
					nRake = d8(2);	}
				else if (nLevel >= 16)
				{	nDamage = d8(4) + d8(2);
					nRake = d6(2);	}
				else if (nLevel >= 8)
				{	nDamage = d6(4) + d6(2);
					nRake = d12(1);	}
				else 
				{	nDamage = d10(2) + d6(2);
					nRake = d10(1);	}
				if (GetHasFeat(2390, oPC) && GetHasFeat(883))
				{	nDamage = FloatToInt(IntToFloat(nDamage) * 1.5);	}
				if (GetHasFeat(746))
				{	nDamage = nDamage + d6(1);	}
				eDamage = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL, FALSE);
				
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
			}
			else if (nAttack == 1)
			{	if (nLevel >= 24)
				{	nDamage = d10(2);
					nRake = d8(2);	}
				else if (nLevel >= 16)
				{	nDamage = d8(2);
					nRake = d6(2);	}
				else if (nLevel >= 8)
				{	nDamage = d6(2);
					nRake = d12(1);	}
				else 
				{	nDamage = d10(1);
					nRake = d10(1);	}
				eDamage = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL, FALSE);
				
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
			}
			else 
			{	SendMessageToPC(oPC, "Your attack missed!");
				return;	
			}
			// Rake!
			{	nRake = d4(4);
				eRake = EffectDamage(nRake, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_NORMAL, FALSE);
				
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eRake, oTarget);
				SendMessageToPC(oPC, "You rake your opponent with your back claws!");
				SendMessageToPC(oTarget, GetName(oPC) + " bites down and rakes you with their rear claws!");
				eRake2 = EffectDamage(nRake, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_NORMAL, FALSE);
				
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eRake2, oTarget);
				SendMessageToPC(oTarget, GetName(oPC) + " bites down and rakes you with their rear claws!");
			}
		}	
	
	else
	{	SendMessageToPC(oPC, "This ability is only usable in Animal or Hybrid form.");	}
}