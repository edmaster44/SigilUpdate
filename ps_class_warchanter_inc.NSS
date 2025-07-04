#include "aaa_constants"
#include "x2_inc_spellhook"
#include "ps_inc_melee"
#include "ed_bardsongsinclude"

void WarChanter_SingingShout(object oPC, int nSpellID)
{
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("ajoc_fx_sop_explode"), oPC);

	int iWC = GetLevelByClass(CLASS_TYPE_WAR_CHANTER,oPC);
	int iBonus = 6;
	
	PS_CustomAnimation(oPC,"*rage",0);	
								
	effect eLink = EffectLinkEffects(EffectNWN2SpecialEffectFile("fx_spell_shout01"),EffectAbilityIncrease(ABILITY_STRENGTH,iBonus));
	ApplyEffectToGroup(oPC,nSpellID,eLink,180.0f);
		
	}
		
	
void WarChanter_InspireRecklessness(object oPC, int nSpellID)
{

int nBonus = 1;
int iWarChanter = GetLevelByClass(CLASS_TYPE_WAR_CHANTER,oPC);
if(iWarChanter > 8) nBonus = 2;
effect eAB = EffectAttackIncrease(nBonus,ATTACK_BONUS_MISC);
effect eDam	=EffectDamageIncrease(nBonus,DAMAGE_TYPE_MAGICAL);
effect eWill =EffectSavingThrowIncrease(SAVING_THROW_WILL,nBonus,SAVING_THROW_ALL);
effect ePen = EffectACDecrease(1,AC_DODGE_BONUS);	
effect eLink = EffectLinkEffects(eAB, eDam);
eLink = EffectLinkEffects(eWill,eLink);
eLink = EffectLinkEffects(ePen,eLink);

ApplyEffectToGroup(oPC,nSpellID,eLink,180.0f);
	
}

	
void WarChanter_Inspire_Toughness(object oPC, int nSpellID)
{
int iWarChanter = GetLevelByClass(CLASS_TYPE_WAR_CHANTER,oPC);
int nBonus = 2;
if (GetLevelByClass(iWarChanter,oPC)>6)
{
	int Bonus =4;
}
int nTotal = iWarChanter * nBonus;
effect nHP = EffectTemporaryHitpoints(nBonus);
ApplyEffectToGroup(oPC,nSpellID,nHP,180.0f);

}

void WarChanter_SnowSong(object oPC, int nSpellID)
{


	int nDuration = 20;
	// FlattedFifth edit
	
	//effect eSnow = EffectNWN2SpecialEffectFile("fx_enviro_snowmedium"); // moved to vfx_persistent.2da
	effect eAOE = EffectAreaOfEffect(84); // enter and exit scripts are named in 2da, no need to put them here
	//eAOE = EffectLinkEffects(eSnow, eAOE);
	float fDuration = RoundsToSeconds(nDuration);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, fDuration);
	
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

