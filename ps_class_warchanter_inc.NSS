#include "aaa_constants"
#include "x2_inc_spellhook"
#include "ps_inc_melee"
#include "ed_bardsongsinclude"
#include "nwn2_inc_spells"

void WarChanter_SingingShout(object oPC, int nSpellID)
{
	if (!GetCanBardSing(oPC)) return;
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("ajoc_fx_sop_explode"), oPC);

	int nDuration = GetBardicClassLevelForUses(oPC);
	if (GetHasFeat(FEAT_LINGERING_SONG, oPC)) nDuration += 5;
	int iBonus = 6;
	float fRange = 18.288f; // 60 feet
	
	PS_CustomAnimation(oPC,"*rage",0);	
								
	effect eLink = EffectLinkEffects(EffectNWN2SpecialEffectFile("fx_spell_shout01"),EffectAbilityIncrease(ABILITY_STRENGTH,iBonus));
	eLink = ExtraordinaryEffect(eLink);
	ApplyEffectToGroup(oPC,nSpellID,eLink,RoundsToSeconds(nDuration), fRange, TRUE);
		
}
		
	
void WarChanter_InspireRecklessness(object oPC, int nSpellID)
{
	if (!GetCanBardSing(oPC)) return;
	int nBonus = 1;
	if(GetLevelByClass(CLASS_TYPE_WAR_CHANTER,oPC) >= 8) nBonus = 2;
	int nDuration = GetBardicClassLevelForUses(oPC);
	if (GetHasFeat(FEAT_LINGERING_SONG, oPC)) nDuration += 5;
	float fRange = 13.716f; //45 feet
	effect eAB = EffectAttackIncrease(nBonus,ATTACK_BONUS_MISC);
	effect eDam	=EffectDamageIncrease(nBonus,DAMAGE_TYPE_MAGICAL);
	effect eWill =EffectSavingThrowIncrease(SAVING_THROW_WILL,nBonus,SAVING_THROW_ALL);
	effect ePen = EffectACDecrease(1,AC_DODGE_BONUS);	
	effect eLink = EffectLinkEffects(eAB, eDam);
	eLink = EffectLinkEffects(eWill,eLink);
	eLink = EffectLinkEffects(ePen,eLink);
	eLink = ExtraordinaryEffect(eLink);
	ApplyEffectToGroup(oPC,nSpellID,eLink,RoundsToSeconds(nDuration), fRange, TRUE);
	
}

	
void WarChanter_Inspire_Toughness(object oPC, int nSpellID)
{
	if (!GetCanBardSing(oPC)) return;
	int iWarChanter = GetLevelByClass(CLASS_TYPE_WAR_CHANTER,oPC);
	int nBonus = 2;
	if (GetLevelByClass(iWarChanter,oPC) >= 6)
	{
		int Bonus =4;
	}
	nBonus *= iWarChanter;
	int nDuration = GetBardicClassLevelForUses(oPC);
	if (GetHasFeat(FEAT_LINGERING_SONG, oPC)) nDuration += 5;
	float fRange = 9.144f; // 30 feet
	effect nHP = EffectTemporaryHitpoints(nBonus);
	nHP = ExtraordinaryEffect(nHP);
	ApplyEffectToGroup(oPC,nSpellID,nHP,RoundsToSeconds(nDuration), fRange, TRUE);

}

void WarChanter_SnowSong(object oPC, int nSpellID)
{
	if (!GetCanBardSing(oPC)) return;	
   
    if (!GetHasFeat(FEAT_BARD_SONGS, oPC))
    {
        FloatingTextStrRefOnCreature(STR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS, oPC); // no more bardsong uses left
        return;
    }

	int nDuration = GetBardicClassLevelForUses(oPC);
	if (GetHasFeat(FEAT_LINGERING_SONG, oPC)) nDuration += 5;
	// FlattedFifth edit
	
	//effect eSnow = EffectNWN2SpecialEffectFile("fx_enviro_snowmedium"); // moved to vfx_persistent.2da
	effect eAOE = EffectAreaOfEffect(84); // enter and exit scripts are named in 2da, no need to put them here
	//eAOE = EffectLinkEffects(eSnow, eAOE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, RoundsToSeconds(nDuration));
	
	DecrementRemainingFeatUses(oPC, FEAT_BARD_SONGS);
	
	/* original
	int nMetaMagic = GetMetaMagicFeat(); // not used
	effect eSnow = EffectNWN2SpecialEffectFile("fx_enviro_snowmedium");
	effect eAOE = EffectAreaOfEffect(84, "ed_snowsong_a", "", "ed_snowsong_c");
	eAOE = EffectLinkEffects(eSnow, eAOE);
	float fDuration = RoundsToSeconds(nDuration);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, fDuration);
	*/

}

void SPELLABILITY_WarChanter_COMBINE_SONG(object oPC, int nSpellID)
{

	AssignCommand(oPC, ActionStartConversation(oPC, "dlg_combinesongs", TRUE));
}
