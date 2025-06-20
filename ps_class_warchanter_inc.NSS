#include "aaa_constants"
#include "x2_inc_spellhook"
#include "ps_inc_melee"

void WarChanter_SingingShout(object oPC, int nSpellID)
{
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("ajoc_fx_sop_explode"), oPC);

	int iWC = GetLevelByClass(CLASS_TYPE_WAR_CHANTER,oPC);
	int iBonus = 6;
	
	PS_CustomAnimation(oPC,"*rage",0);	
								
	effect eLink = EffectLinkEffects(EffectNWN2SpecialEffectFile("fx_spell_shout01"),EffectAbilityIncrease(ABILITY_STRENGTH,iBonus));
		
	}
		
	
void WarChanter_InspireRecklessness(object oPC, int nSpellID)
{

int nBonus = 1;
int iWarChanter = GetLevelByClass(CLASS_TYPE_WAR_CHANTER,oPC);
if(iWarChanter > 8) nBonus = 2;
effect eAB = EffectAttackIncrease(nBonus,ATTACK_BONUS_MISC);
effect eDam	=EffectDamageIncrease(nBonus,DAMAGE_TYPE_MAGICAL);
effect eLink = EffectLinkEffects(eAB, eDam);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	
}

	
void WarChanter_Inspire_Toughness(object oPC, int nSpellID)
{

}

void WarChanter_SnowSong(object oPC, int nSpellID)
{


	int nDuration = 20;
	int nMetaMagic = GetMetaMagicFeat();
	effect eSnow = EffectNWN2SpecialEffectFile("fx_enviro_snowmedium");
	effect eAOE = EffectAreaOfEffect(71, "ed_snowsong_a", "", "ed_snowsong_c");
	eAOE = EffectLinkEffects(eSnow, eAOE);
	float fDuration = RoundsToSeconds(nDuration);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, fDuration);
}
int CountFactionMembers(object oCaster)
{
	object oFaction = GetFirstFactionMember(oCaster); int iCount;
	while(GetIsObjectValid(oFaction))
	{
		if(GetArea(oFaction) == GetArea(oCaster) && !GetIsDead(oFaction)) iCount++;
		if(iCount >= 2) return 2;
			
		oFaction = GetNextFactionMember(oCaster);
	}
		
	return iCount;
}
void SPELLABILITY_WarChanter_COMBINE_SONG(object oPC, int nSpellID)
{}