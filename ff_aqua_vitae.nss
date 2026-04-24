#include "x2_inc_spellhook"

/*  WIP
	2495 = create lesser
	2497 = create reg
	2499 = create greater
	ps_potion_aqua_vitae_lssr
	ps_potion_aqua_vitae
	ps_potion_aqua_vitae_grtr




void main(){

	object oPC = OBJECT_SELF;
	int nId = GetSpellId();
	
	switch (nId){
		case 2495: case 2497: case 2499: CreateAquaVitae(oPC, nId); break;
		case 2496: case 2498: case 2500: ApplyAquaVitae(oPC, nId); break;
		default: return;
	}
}


void CreateAquaVitae(object oPC, int nId){
	string sAir, sEarth, sFire, sWater, sPower;


}

void ApplyAquaVitae(object oPC, int nId){

	if (!X2PreSpellCastCode()) return;
	
	int nAmount, nFX;
	switch (nId){
		case 2496: nAmount = 75; nFX = VFX_IMP_HEALING_S; break; //cast lesser
		case 2498: nAmount = 150; nFX = VFX_IMP_HEALING_G; break;// cast reg
		case 2500: nAmount = 225; nFX = VFX_IMP_HEALING_X; break;//cast greater
		default: return;
	}
	RemoveEffectOfType(oPC, EFFECT_TYPE_WOUNDING);
	effect eVis = EffectVisualEffect(nFX);
	effect eHeal = EffectHeal(nAmount);
	effect eLink = EffectLinkEffects(eVis, eHeal);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oPC);
}

	*/