//::///////////////////////////////////////////////
//:: Greater Ruin
//:: X2_S2_Ruin
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
// The caster deals 35d6 damage to a single target
   fort save for half damage
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 18, 2002
//:://////////////////////////////////////////////

#include "x2_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x0_I0_SPELLS"
#include "ps_inc_epicsave"
void main(){

	 // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
       
    //Declare major variables
	object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
	effect eLgSpurt	= EffectNWN2SpecialEffectFile("sp_utterdark_hit");

    float fDist = GetDistanceBetween(oCaster, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);

    int nSpellDC = PS_GetEpicSpellSaveDC();
	
    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
   
    int nDam = d12(75);
	int nRace = GetRacialType(oTarget);
	int nSub = GetSubRace(oTarget);
	if (nRace == RACIAL_TYPE_CONSTRUCT ||
		nRace == RACIAL_TYPE_ELEMENTAL ||
		nRace == RACIAL_TYPE_UNDEAD ||
		nRace == RACIAL_TYPE_INCORPOREAL ||
		nSub == RACIAL_SUBTYPE_PLANT ||
		nSub == RACIAL_SUBTYPE_CONSTRUCT ||
		nSub == RACIAL_SUBTYPE_ELEMENTAL ||
		nSub == RACIAL_SUBTYPE_UNDEAD ||
		nSub == RACIAL_SUBTYPE_INCORPOREAL)
			nDam += nDam / 2; // 1.5x damage to creatures subject to the Ruin potions

    if (MySavingThrow(SAVING_THROW_FORT,oTarget,nSpellDC,SAVING_THROW_TYPE_SPELL,oCaster)){
			if (GetIsPC(oTarget)) return;
			else nDam /= 2;
	}
	effect eDam = EffectDamage(nDam, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_PLUS_TWENTY);
	ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), GetLocation(oTarget));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(487), oTarget);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oTarget);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_BONE_MEDIUM), oTarget);
	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLgSpurt, oTarget));
	
	effect eNova = EffectVisualEffect(VFX_HIT_CLEANSING_NOVA);
	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eNova, oTarget));

}