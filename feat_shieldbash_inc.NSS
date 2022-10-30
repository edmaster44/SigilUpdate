#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "ps_inc_functions"
#include "ps_inc_equipment"
#include "ps_inc_advscript"
#include "nw_i0_spells"
#include "ed_wildmagic"
#include "x0_i0_match"
#include "ps_inc_melee"
#include "x2_inc_itemprop"




void Shield_Bash(object oPC, object oTarget, int nSpell )
{
int nDam;
int nSize;
int nTotal;
int nSaveDC;
object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
	
	if(GetWeaponRanged(oShield) || !GetIsObjectValid(oShield))
	{
		SendMessageToPC(oPC,"You require a Shield to use this");
		return;
	}
int nStrength = GetAbilityModifier(ABILITY_STRENGTH,OBJECT_SELF);
int shield = GetBaseItemType(oShield);
effect eStun = EffectCutsceneParalyze();
effect eStun1 = EffectParalyze();
//For Damage
if(shield = BASE_ITEM_LARGESHIELD)
{nDam = d6(9)+ nStrength ;
nSize = 2;}
else if (shield = BASE_ITEM_TOWERSHIELD)
{nDam = d6(12)+ nStrength;
nSize = 4;}
else if (shield = BASE_ITEM_SMALLSHIELD)
{nDam = d6(6)+ nStrength;
nSize = 1;}
nTotal = nSize + ((nStrength)/2);
nSaveDC = 10 +(GetBaseAttackBonus(oPC)/2) + nTotal;
if (GetHasFeat(FEAT_IMPROVED_SHIELDBASH,oPC))
{
nDam =+ d6(3);
nSaveDC = nSaveDC +4;
}
effect eHurt = EffectDamage(nDam,DAMAGE_TYPE_BLUDGEONING,DAMAGE_POWER_NORMAL,TRUE);
int iHit = AttemptMeleeAttackMainHand(oPC, oTarget,"Shield Bash",1, "*shieldbash", 0, nSpell);
float fDur = RoundsToSeconds(nSaveDC);
if(iHit >0)
{
 ApplyEffectToObject(DURATION_TYPE_INSTANT,eHurt,oTarget);
 
if(!FortitudeSave(oTarget,nSaveDC,SAVING_THROW_TYPE_NONE))
{
ApplyEffectToObject(DURATION_TYPE_INSTANT,eStun1,oTarget,fDur);

}
if (GetLocalInt(oPC, "ArcaneBashOn") == 1)
DoWildMagic(oPC, oTarget, GetSpellId());
			

}

if (iHit == 2)
{
ApplyEffectToObject(DURATION_TYPE_INSTANT,eHurt,oTarget);

if (GetLocalInt(oPC, "ArcaneBashOn") == 1)
DoWildMagic(oPC, oTarget, GetSpellId());
			

if(!FortitudeSave(oTarget,nSaveDC,SAVING_THROW_TYPE_NONE))
{
ApplyEffectToObject(DURATION_TYPE_INSTANT,eStun,oTarget,fDur);

}

}
}


void Shield_Throw(object oPC, object oTarget, int nSpell )
{
int nDam;
int nSize;
int nTotal;
int nSaveDC;
object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
	
	if(GetWeaponRanged(oShield) || !GetIsObjectValid(oShield))
	{
		SendMessageToPC(oPC,"You require a Shield to use this");
		return;
	}
int nStrength = GetAbilityModifier(ABILITY_STRENGTH,OBJECT_SELF);
int shield = GetBaseItemType(oShield);
effect eStun = EffectCutsceneParalyze();
effect eStun1 = EffectParalyze();
//For Damage
if(shield = BASE_ITEM_LARGESHIELD)
{nDam = d6(9)+nStrength ;
nSize = 2;}
else if (shield = BASE_ITEM_TOWERSHIELD)
{nDam = d6(12)+ nStrength;
nSize = 4;}
else if (shield = BASE_ITEM_SMALLSHIELD)
{nDam = d6(6)+ nStrength;
nSize = 1;}
nTotal = nSize + ((nStrength)/2);
nSaveDC = 10 +(GetBaseAttackBonus(oPC)/2) + nTotal;
if (GetHasFeat(FEAT_IMPROVED_SHIELDBASH,oPC))
{
nDam =+ d6(3);
nSaveDC = nSaveDC +4;
}
effect eHurt = EffectDamage(nDam,DAMAGE_TYPE_BLUDGEONING,DAMAGE_POWER_NORMAL,TRUE);
int iHit = AttemptMeleeAttackMainHand(oPC, oTarget,"Shield Throw",1, "*shieldbash", 1, nSpell);
float fDur = RoundsToSeconds(nSaveDC);
if(iHit >0)
{
 ApplyEffectToObject(DURATION_TYPE_INSTANT,eHurt,oTarget);
 
if(!WillSave(oTarget,nSaveDC,SAVING_THROW_TYPE_NONE))
{
ApplyEffectToObject(DURATION_TYPE_INSTANT,eStun1,oTarget,fDur);

}
if (GetLocalInt(oPC, "ArcaneBashOn") == 1)
DoWildMagic(oPC, oTarget, GetSpellId());
			

}

if (iHit == 2)
{
ApplyEffectToObject(DURATION_TYPE_INSTANT,eHurt,oTarget);

if (GetLocalInt(oPC, "ArcaneBashOn") == 1)
DoWildMagic(oPC, oTarget, GetSpellId());
			

if(!WillSave(oTarget,nSaveDC,SAVING_THROW_TYPE_NONE))
{
ApplyEffectToObject(DURATION_TYPE_INSTANT,eStun,oTarget,fDur);

}

}
}


void Agile_Strike(object oPC, object oTarget, int nSpell )
{
int nDam;
int nSize;
int nTotal;
int nSaveDC;
object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
	
	if(GetWeaponRanged(oShield) || !GetIsObjectValid(oShield))
	{
		SendMessageToPC(oPC,"You require a Shield to use this");
		return;
	}
int nDex = GetAbilityModifier(ABILITY_DEXTERITY,OBJECT_SELF);
int shield = GetBaseItemType(oShield);
effect eKD = EffectKnockdown();
//For Damage
if(shield = BASE_ITEM_LARGESHIELD)
{nDam = d6(9)+ nDex ;
nSize = 2;}
else if (shield = BASE_ITEM_TOWERSHIELD)
{nDam = d6(12)+ nDex;
nSize = 4;}
else if (shield = BASE_ITEM_SMALLSHIELD)
{nDam = d6(6)+ nDex;
nSize = 1;}
nTotal = nSize + ((nDex)/2);
nSaveDC = 10 +(GetBaseAttackBonus(oPC)/2) + nTotal;
if (GetHasFeat(FEAT_IMPROVED_SHIELDBASH,oPC))
{
nDam =+ d6(3);
nSaveDC = nSaveDC +4;
}
effect eHurt = EffectDamage(nDam,DAMAGE_TYPE_BLUDGEONING,DAMAGE_POWER_NORMAL,TRUE);
int iHit = AttemptMeleeAttackMainHand(oPC, oTarget,"Agile Strike",1, "*shieldbash", 0, nSpell);
float fDur = RoundsToSeconds(nSaveDC);
if(iHit >0)
{
 ApplyEffectToObject(DURATION_TYPE_INSTANT,eHurt,oTarget);
 
if(!ReflexSave(oTarget,nSaveDC,SAVING_THROW_TYPE_NONE))
{
ApplyEffectToObject(DURATION_TYPE_INSTANT,eKD,oTarget,fDur);

}
if (GetLocalInt(oPC, "ArcaneBashOn") == 1)
DoWildMagic(oPC, oTarget, GetSpellId());
			

}

if (iHit == 2)
{
ApplyEffectToObject(DURATION_TYPE_INSTANT,eHurt,oTarget);

if (GetLocalInt(oPC, "ArcaneBashOn") == 1)
DoWildMagic(oPC, oTarget, GetSpellId());
			

if(!ReflexSave(oTarget,nSaveDC,SAVING_THROW_TYPE_NONE))
{
ApplyEffectToObject(DURATION_TYPE_INSTANT,eKD,oTarget,fDur);

}

}

}

void DeactivateArcaneBash(object oPC, int id, int idneeded)
{
	AssignCommand(oPC, ClearAllActions());

	if (id != GetLocalInt(oPC, "ArcaneBashId") && idneeded == 1 || GetLocalInt(oPC, "ArcaneBashOn") == 0)
		return;
	if (GetLocalInt(oPC, "ArcaneBashOn") == 1)
		FloatingTextStringOnCreature("*Arcane Bash Deactivated!*", oPC, TRUE, 3.0f);
		DeleteLocalInt(oPC, "ArcaneBashOn");

	RemoveAnySpellEffects(SPELLFEAT_ARCANEBASH, oPC);

}


void Arcane_Bash(object oPC, int nSpell)
{

RemoveAnySpellEffects(SPELLFEAT_ARCANEBASH, oPC);

	AssignCommand(oPC, ClearAllActions());

	if (GetLocalInt(oPC, "ArcaneBashOn") == 1)
	{
		SendMessageToPC(oPC, "Arcane Bash is already activated. Please wait 45 seconds.");
		return;
	}

	effect eVfx = EffectNWN2SpecialEffectFile("sp_bewilderment");
	eVfx = SetEffectSpellId(eVfx, nSpell);
	eVfx = ExtraordinaryEffect(eVfx);

	if (nSpell == SPELLFEAT_ARCANEBASH)
		FloatingTextStringOnCreature("*Arcane Bash Activated!*", oPC, TRUE, 3.0f);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVfx, oPC, 45.0f);

	int id = Random(1000);

	if (nSpell == SPELLFEAT_ARCANEBASH)
		SetLocalInt(oPC, "ArcaneBashOn", 1);
	SetLocalInt(oPC, "ArcaneBashId", id);

	DelayCommand(45.0f, DeactivateArcaneBash(oPC, id, 1));	
	
}