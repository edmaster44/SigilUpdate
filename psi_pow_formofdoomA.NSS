// vfx persist line 102


#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "aaa_constants"
#include "x2_inc_itemprop"

void main()
{
	//Declare major variables
	object oManifester = GetAreaOfEffectCreator();
	object oTarget = GetEnteringObject();
	int nId = GetAreaOfEffectSpellId();
	effect eLink = CreateDoomEffectsLink();
	eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR), eLink);
	eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), eLink);
	eLink = SetEffectSpellId(eLink, nId);
	effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
	int nDC = 16 + GetAbilityModifier(ABILITY_CHARISMA, oManifester);
	if (GetTag(OBJECT_SELF) == "augmented") nDC += 2;

	if(GetIsEnemy(oTarget, oManifester) && !GetLocalInt(oTarget, "immunedoom"))
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(oManifester, SPELLABILITY_AURA_FEAR));
		//Make a saving throw check
		if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR)){
			//Apply the VFX impact and effects
			ED_ApplyEffectToObject(oManifester, nId, TRUE, DURATION_TYPE_TEMPORARY, eLink, 
				oTarget, RoundsToSeconds(d6(5)));
			PS_ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		} else {
			SetLocalInt(oTarget, "immunedoom", TRUE); //immune till next reset if passed save
		}
	}
}