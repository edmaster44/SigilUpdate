#include "nwn2_inc_spells"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_functions"

void main()
{
	if (!X2PreSpellCastCode())
	{	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
		return;
	}

	int nSbLevels = GetLevelByClass(CLASS_TYPE_SWASHBUCKLER);
	int nHpBonus = 10;
	int nSaveBonus = 1;
	
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

	SendMessageToPC(OBJECT_SELF, "Applying Swashbuckler Grace: +"
		+ IntToString(nSaveBonus) + " universal save bonus and +"
		+ IntToString(nHpBonus) + " bonus hit points");

	if(!GetHasSpellEffect(13101)) {
		effect eSaves = ExtraordinaryEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, nSaveBonus));
		effect eHp = ExtraordinaryEffect(EffectBonusHitpoints(nHpBonus));
		effect eLink = EffectLinkEffects(eSaves, eHp);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eLink), OBJECT_SELF);
	}
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHpBonus), OBJECT_SELF);
}