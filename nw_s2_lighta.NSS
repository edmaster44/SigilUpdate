//::///////////////////////////////////////////////
//:: Light (Drow/Aasimar Racial Ability)
//:: NW_S2_Light.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Applies a light source to the target for
    1 hour per level

    XP2
    If cast on an item, item will get temporary
    property "light" for the duration of the spell
    Brightness on an item is lower than on the
    continual light version.

*/

// JLR-OEI 03/16/06: For GDD Update

#include "x2_inc_spellhook"

void main(){

    if (!X2PreSpellCastCode()) return;
    

    //Declare major variables
	object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    int nDuration = PS_GetCasterLevel(OBJECT_SELF);
	int nMeta = GetMetaMagicFeat();
	int nId = GetSpellId();
	int bIsDivineLight = FALSE;
	int nRace = GetSubRace(oCaster);
	if (nId == SPELL_RACIAL_LIGHT){
		nDuration = GetTotalLevels(oCaster, TRUE); 
		if (nRace == 13 || nRace == 203) bIsDivineLight = TRUE;
	}
	
	int nSightSkillBonus = 5;
	if (nMeta == METAMAGIC_EMPOWER || bIsDivineLight) nSightSkillBonus += nSightSkillBonus / 2;
	if (nMeta == METAMAGIC_EXTEND) nDuration *= 2;
	
	effect eSearch = EffectSkillIncrease(SKILL_SEARCH, nSightSkillBonus);
	effect eSpot = EffectSkillIncrease(SKILL_SPOT, nSightSkillBonus);
	effect eArea = EffectLinkEffects(eSearch, eSpot);
	eArea = EffectLinkEffects(EffectSkillDecrease(SKILL_HIDE, 10), eArea);
	if (bIsDivineLight) eArea = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_BLINDNESS), eArea);
	eArea = SetEffectSpellId(eArea, nId); 

	float fDur = HoursToSeconds(nDuration);
	int nDarkId;
	if (GetIsObjectValid(oTarget)){
		if (bIsDivineLight) RemoveEffect(oTarget, EffectBlindness());
		effect eDark = GetFirstEffect(oTarget);
		int nCreatorRace;
		int bImmune = FALSE;
		while (GetIsEffectValid(eDark)){
			nDarkId = GetEffectSpellId(eDark);
			
			if (nDarkId == SPELL_RACIAL_DARKNESS){
				nCreatorRace = GetSubRace(GetEffectCreator(eDark));
				if (nCreatorRace == 14 || nCreatorRace == 194){
					if (bIsDivineLight){
						if (GetHitDice(oCaster) > GetHitDice(GetEffectCreator(eDark))){
							RemoveEffect(oTarget, eDark);
							eDark = GetFirstEffect(oTarget);
						} else {
							bImmune = TRUE;
							eDark = GetNextEffect(oTarget);	
						}
					} else {
						bImmune = TRUE;
						eDark = GetNextEffect(oTarget);	
					}
				} else {
					if (bIsDivineLight){
						RemoveEffect(oTarget, eDark);
						eDark = GetFirstEffect(oTarget);
					} else {
						bImmune = TRUE;
						eDark = GetNextEffect(oTarget);	
					}
				}	
			} else if (nDarkId == SPELL_DARKNESS){
				if (bIsDivineLight){
					RemoveEffect(oTarget, eDark);
					eDark = GetFirstEffect(oTarget);
				} else {
					bImmune = TRUE;
					eDark = GetNextEffect(oTarget);	
				}
			} else eDark = GetNextEffect(oTarget);		
		}
	
		if (!bImmune) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eArea, oTarget, fDur); 
	}
}