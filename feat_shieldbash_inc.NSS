#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "ps_inc_functions"
#include "ps_inc_equipment"
#include "ps_inc_advscript"
#include "nw_i0_spells"
#include "x0_i0_match"
#include "ps_inc_melee"
#include "x2_inc_itemprop"




void Shield_Bash(object oPC, object oTarget, int nSpell )
{
int nDam;
int nSize;;
object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
	
	if(GetWeaponRanged(oShield) || !GetIsObjectValid(oShield))
	{
		SendMessageToPC(oPC,"You require a Shield to use this");
		return;
	}
int nStrength = GetAbilityModifier(ABILITY_STRENGTH,OBJECT_SELF);
int shield = GetBaseItemType(oShield);
effect eStun = EffectCutsceneParalyze();
//For Damage
if(shield = BASE_ITEM_LARGESHIELD)
{nDam = d6(1) + nStrength;
nSize = 2;}
else if (shield = BASE_ITEM_TOWERSHIELD)
{nDam = d8(1)+ nStrength;
nSize = 4;}
else if (shield = BASE_ITEM_SMALLSHIELD)
{nDam = d4(1)+ nStrength;
nSize = 1;}
int nTotal = nDam + nSize;
int nSaveDC = 10 +(GetBaseAttackBonus(oPC)/2) + nTotal;
effect eHurt = EffectDamage(nTotal,DAMAGE_TYPE_BLUDGEONING,DAMAGE_POWER_NORMAL,TRUE);
int iHit = AttemptMeleeAttackMainHand(oPC, oTarget,"Shield Bash",1, "*shieldbash", 0, nSpell);
if(iHit >0)
{
 ApplyEffectToObject(DURATION_TYPE_INSTANT,eHurt,oTarget);
}

if (iHit == 2)
{
nTotal = FloatToInt(nTotal * 1.5);
ApplyEffectToObject(DURATION_TYPE_INSTANT,eHurt,oTarget);

if(!FortitudeSave(oTarget,nSaveDC,SAVING_THROW_TYPE_NONE))
{
ApplyEffectToObject(DURATION_TYPE_INSTANT,eStun,oTarget);

}

}
}


void Shield_Throw(object oPC, object oTarget, int nSpell )
{
int nDam;
int nSize;;
object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
	
	if(GetWeaponRanged(oShield) || !GetIsObjectValid(oShield))
	{
		SendMessageToPC(oPC,"You require a Shield to use this");
		return;
	}
int nStrength = GetAbilityModifier(ABILITY_STRENGTH,OBJECT_SELF);
int shield = GetBaseItemType(oShield);
effect eStun = EffectCutsceneParalyze();
//For Damage
if(shield = BASE_ITEM_LARGESHIELD)
{nDam = d6(1) + nStrength;
nSize = 2;}
else if (shield = BASE_ITEM_TOWERSHIELD)
{nDam = d8(1)+ nStrength;
nSize = 4;}
else if (shield = BASE_ITEM_SMALLSHIELD)
{nDam = d4(1)+ nStrength;
nSize = 1;}
int nTotal = nDam + nSize;
int nSaveDC = 10 +(GetBaseAttackBonus(oPC)/2) + nTotal;
effect eHurt = EffectDamage(nTotal,DAMAGE_TYPE_BLUDGEONING,DAMAGE_POWER_NORMAL,TRUE);
int iHit = AttemptMeleeAttackMainHand(oPC, oTarget,"Shield Bash",1, "*shieldbash", 1, nSpell);
if(iHit >0)
{
 ApplyEffectToObject(DURATION_TYPE_INSTANT,eHurt,oTarget);
}

if (iHit == 2)
{
nTotal = FloatToInt(nTotal * 1.5);
ApplyEffectToObject(DURATION_TYPE_INSTANT,eHurt,oTarget);

if(!FortitudeSave(oTarget,nSaveDC,SAVING_THROW_TYPE_NONE))
{
ApplyEffectToObject(DURATION_TYPE_INSTANT,eStun,oTarget);

}

}

}

void Agile_Strike(object oPC, object oTarget, int nSpell )
{
int nDam;
int nSize;;
object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
	
	if(GetWeaponRanged(oShield) || !GetIsObjectValid(oShield))
	{
		SendMessageToPC(oPC,"You require a Shield to use this");
		return;
	}
int nDex = GetAbilityModifier(ABILITY_DEXTERITY,OBJECT_SELF);
int shield = GetBaseItemType(oShield);
effect eStun = EffectKnockdown();
//For Damage
if(shield = BASE_ITEM_LARGESHIELD)
{nDam = d6(1) + nDex;
nSize = 2;}
else if (shield = BASE_ITEM_TOWERSHIELD)
{nDam = d8(1)+ nDex;
nSize = 4;}
else if (shield = BASE_ITEM_SMALLSHIELD)
{nDam = d4(1)+ nDex;
nSize = 1;}
int nTotal = nDam + nSize;
int nSaveDC = 10 +(GetBaseAttackBonus(oPC)/2) + nTotal;
effect eHurt = EffectDamage(nTotal,DAMAGE_TYPE_BLUDGEONING,DAMAGE_POWER_NORMAL,TRUE);
int iHit = AttemptMeleeAttackMainHand(oPC, oTarget,"Shield Bash",1, "*shieldbash", 0, nSpell);
if(iHit >0)
{
 ApplyEffectToObject(DURATION_TYPE_INSTANT,eHurt,oTarget);
}

if (iHit == 2)
{
nTotal = FloatToInt(nTotal * 1.5);
ApplyEffectToObject(DURATION_TYPE_INSTANT,eHurt,oTarget);

if(!FortitudeSave(oTarget,nSaveDC,SAVING_THROW_TYPE_NONE))
{
ApplyEffectToObject(DURATION_TYPE_INSTANT,eStun,oTarget);

}

}

}

void Arcane_Bash(object oPC, int nSpell)
{


}