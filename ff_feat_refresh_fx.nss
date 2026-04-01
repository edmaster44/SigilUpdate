/* March 31, 2026, FlattedFifth
	My theory is that the "dispell bug" that has plagued this server forever and does not seem to exist
	anywhere else is because most players have far too many persistent feats all trying to trigger at the
	same time. So, what I've done as an experiment is made a new column in feat.2da called "Auto_Refresh"
	and copied the "IsPersistent" column into it, then set the "IsPersistent" column to **** for every feat
	except this one. Now this is the only feat that is persistent and it will cycle through the 2da looking
	for feats that the character has that are "Auto_Refresh" and run those spell ids.
	
	Also moved the AlternativeSkillStatScaling() from the rest script to here.
*/


#include "aaa_constants";
#include "x2_inc_spellhook";

//const int REFRESH_FX_FEAT = 21905; //moved to aaa_constants


void AlternativeSkillStatScaling(object oPC);

void main(){
	object oPC = OBJECT_SELF;
	AlternativeSkillStatScaling(oPC);
	
	int nMax = GetNum2DARows("feat");
	int i;
	int nId;
	for (i = 0; i <= nMax; i++){
		if (i != REFRESH_FX_FEAT){
			if (GetHasFeat(i, oPC, TRUE)){
				if (StringToInt(Get2DAString("feat", "Auto_Refresh", i)) == 1){
					nId = StringToInt(Get2DAString("feat", "SPELLID", i));
					if (nId > 0){
						AssignCommand(oPC, ActionCastSpellAtObject(nId, oPC, METAMAGIC_ANY, TRUE, 30,
						PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
					}
				}
			}
		}
	}
}

// moved from ps_rest. Put here in a persistent makes it refresh values on casting spells
void AlternativeSkillStatScaling(object oPC){

	//Remove previous effect
	if (GetHasSpellEffect(SKILL_BONUS_FX, oPC))
		PS_RemoveEffects(oPC, SKILL_BONUS_FX);
	
	int nSTR = (GetAbilityModifier(ABILITY_STRENGTH, oPC));
	int nWIS = (GetAbilityModifier(ABILITY_WISDOM, oPC));
	int nINT = (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC));
	int nCHA = (GetAbilityModifier(ABILITY_CHARISMA, oPC));
	int nDEX = (GetAbilityModifier(ABILITY_DEXTERITY, oPC));
	
	int nIntimidate = nSTR - nCHA;
	int nLore = nWIS - nINT;
	int nSearch = nWIS - nINT;
	int nHeal = nINT - nWIS;
	int nSetTrap = nINT - nDEX;
	
	effect eFX = EffectSkillIncrease(SKILL_TUMBLE, 0); //this should hopefully do nothing

	if (nSTR > nCHA)
		eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_INTIMIDATE, nIntimidate));

	if (nINT > nDEX)
		eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_SET_TRAP, nSetTrap));
		
	if (nINT > nWIS)
		eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_HEAL, nHeal));
		
	if (nWIS > nINT){
		eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_LORE, nLore));
		eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_SEARCH, nSearch));
	}

	eFX = SupernaturalEffect(eFX);
	eFX = SetEffectSpellId(eFX, SKILL_BONUS_FX);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC);	 		 
}