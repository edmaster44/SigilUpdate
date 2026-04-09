#include "x2_inc_spellhook"
#include "aaa_constants"
#include "X0_I0_SPELLS"
#include "nw_i0_spells"


void ElemWar_ImmunityAir(object oPC, int nSpell)
{

	int nElemWar = GetLevelByClass(CLASS_TYPE_ELEMENTAL_WARRIOR,oPC);
	int nAmount = 5 *nElemWar + 5 ;
	effect eDR = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nAmount,0);
 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC);
 SetEffectSpellId(eDR,nSpell);
 SendMessageToPC(oPC, "Partial Elemental Immunity to Air " + IntToString(nAmount) + " applied.");
		
		
		
}   
void ElemWar_ImmunityEarth(object oPC, int nSpell)
{
	int nElemWar = GetLevelByClass(CLASS_TYPE_ELEMENTAL_WARRIOR,oPC);
	int nAmount = 5 *nElemWar + 5 ;

	effect eDR = EffectDamageResistance(DAMAGE_TYPE_ACID, nAmount,0);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC);
 	SetEffectSpellId(eDR,nSpell);
 	SendMessageToPC(oPC, "Partial Elemental Immunity to Earth " + IntToString(nAmount) + " applied.");
	 
}

void ElemWar_ImmunityFire(object oPC, int nSpell)
	 
	 {
	 
	int nElemWar = GetLevelByClass(CLASS_TYPE_ELEMENTAL_WARRIOR,oPC);
	int nAmount = 5 *nElemWar + 5 ;

	effect eDR = EffectDamageResistance(DAMAGE_TYPE_FIRE, nAmount,0);
 	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC);
 	SetEffectSpellId(eDR,nSpell);
 	SendMessageToPC(oPC, "Partial Elemental Immunity to Fire " + IntToString(nAmount) + " applied.");
 }
	 
void ElemWar_ImmunityWater(object oPC, int nSpell)
	 
	 {
	 
	int nElemWar = GetLevelByClass(CLASS_TYPE_ELEMENTAL_WARRIOR,oPC);
	int nAmount = 5 *nElemWar + 5 ;
	effect eDR = EffectDamageResistance(DAMAGE_TYPE_COLD, nAmount,0);
 	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC);
 	SetEffectSpellId(eDR,nSpell);
 	SendMessageToPC(oPC, "Partial Elemental Immunity to Water " + IntToString(nAmount) + " applied.");
 }
	 
		