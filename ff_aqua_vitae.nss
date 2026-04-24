#include "x2_inc_spellhook"

/*  WIP

	ps_potion_aqua_vitae_lssr
	ps_potion_aqua_vitae
	ps_potion_aqua_vitae_grtr
*/



void main(){
	if (!X2PreSpellCastCode()) return;
	object oPC = OBJECT_SELF;
	int nId = GetSpellId();
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
	ED_ApplyEffectToObject(oPC, nId, FALSE, DURATION_TYPE_INSTANT, eLink, oPC);
}