
#include "x2_inc_spellhook" 

int GetCloudkillAbilityDamage(){
	int nDam = d4();
    int nMetaMagic = GetMetaMagicFeat();

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE) nDam = 4;
    else if (nMetaMagic == METAMAGIC_EMPOWER) nDam += nDam / 2; 
	
	return nDam;
}


void ApplyCloudKill(object oTarget, object oCaster, int nId, int nDC){
	
	if(GetIsImmune(oTarget, IMMUNITY_TYPE_POISON)) return;
	
	int nHD = GetHitDice(oTarget);
	int nDam  =GetCloudkillAbilityDamage();
	float fDelay= GetRandomDelay(0.5, 1.5);
	
	effect eDeath = EffectDeath();
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
	effect eNeg = EffectVisualEffect( VFX_HIT_SPELL_POISON );
	effect eDam = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDam);
    eDam = SetEffectSpellId(eDam, nId);
    eDam = ExtraordinaryEffect(eDam);
	
	 //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CLOUDKILL));
	 //Make SR Check
	if(!MyResistSpell(oCaster, oTarget, fDelay)){
		//Determine spell effect based on the targets HD
		if (nHD <= 3){
			if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH)){
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
			}
		} else if (nHD >= 4 && nHD <= 6){
			//Make a save or die
			if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH, oCaster, fDelay)){
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			} else {
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget));
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget));
			}
		} else {
			if (FortitudeSave(oTarget, nDC, SAVING_THROW_TYPE_POISON, oCaster)){
				nDam = nDam / 2;
				eDam = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDam);
				eDam = SetEffectSpellId(eDam, nId);
				eDam = ExtraordinaryEffect(eDam);
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget));
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget));

			} else {	
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget));
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget));
			}
		}
	}	
}