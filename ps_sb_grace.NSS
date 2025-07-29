#include "nwn2_inc_spells"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
//#include "ps_inc_functions" redundant include, its included in multiple above scripts

void main()
{
	// it's a persistent feat, it shouldn't have to check the spellhook -FlattedFifth
	/*
	if (!X2PreSpellCastCode())
	{	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
		return;
	}
	*/

	int nSbLevels = GetLevelByClass(CLASS_TYPE_SWASHBUCKLER);
	int nHpBonus = 10;
	int nSaveBonus = 1;
	int nId = GetSpellId();
	
	if(nSbLevels >= 29) {
		nSaveBonus = 4;
		nHpBonus = 80;
	}
	else if(nSbLevels >= 20) {
		nSaveBonus = 3;
		nHpBonus = 40;
	}
	else if(nSbLevels >= 11) {
		nSaveBonus = 2;
		nHpBonus = 20;
	}
	
	// We don't need to notify for this -FlattedFifth
	/*
	SendMessageToPC(OBJECT_SELF, "Applying Swashbuckler Grace: +"
		+ IntToString(nSaveBonus) + " universal save bonus and +"
		+ IntToString(nHpBonus) + " bonus hit points");
	*/
	
	// This method is proven unreliable. If multiple individual effects all have the same 
	// id then if only one of them gets eaten by the dispell bug, then checking for any with this 
	// id will still return true. More reliable method is to remove and reapply -FlattedFifth
	/*
	if(!GetHasSpellEffect(13101)) {
		effect eSaves = ExtraordinaryEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, nSaveBonus));
		effect eHp = ExtraordinaryEffect(EffectBonusHitpoints(nHpBonus));
		effect eLink = EffectLinkEffects(eSaves, eHp);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eLink), OBJECT_SELF);
	}
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHpBonus), OBJECT_SELF);
	*/
	
	effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, nSaveBonus);
	effect eHp = EffectBonusHitpoints(nHpBonus);
	eSaves = EffectLinkEffects(eHp, eSaves);
	eSaves = SupernaturalEffect(eSaves);
	eSaves = SetEffectSpellId(eSaves, nId);
	
	// if the current hp is less than the bonus, heal them up to the bonus +1 before
	// we remove and reapply the hp bonus, lest we kill the character -FlattedFifth
	int nHp = GetCurrentHitPoints();
	if (nHp < nHpBonus)
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHpBonus - nHp + 1), OBJECT_SELF);
		
	PS_RemoveEffects(OBJECT_SELF, nId);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSaves, OBJECT_SELF);

}