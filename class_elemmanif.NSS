//Elemental Manifestation
//class_elemmanif
//Made by edmaster44(DM_Odin)

#include "nwn2_inc_spells"
#include "aaa_constants"

void main()
{
object oPC = OBJECT_SELF;
int nShieldDamage = DAMAGE_BONUS_1d6;
int nLevel=GetLevelByClass(CLASS_TYPE_ELEMENTAL_WARRIOR, oPC);
	effect eDur;
int nDuration = (nLevel-1)*10;

	int nSpellID = SPELLABILITY_ELEMWAR_MANIFESTATION;
	object oTarget	= GetSpellTargetObject();	
	effect eHaste = EffectHaste();
	effect eCleanse = EffectRegenerate(3,1.0f);
	itemproperty eSlow = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_SLOW,nLevel*2);
	
    RemoveSpellEffects(nSpellID, OBJECT_SELF, OBJECT_SELF);
	
	effect eLink;
	
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_AIR,oPC))
	{ 
		effect eDur = EffectVisualEffect(925);
		eLink = EffectConcealment(10 * nLevel , MISS_CHANCE_TYPE_NORMAL);
	}
	else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_EARTH))
	{	effect eDur =EffectVisualEffect(VFX_DUR_PROT_STONESKIN);
		eLink =	EffectDamageReduction(15,GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL);
	}
	else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_FIRE,oPC))
	{	effect eDur = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
			if (nLevel >= 5 ) 
		{	nShieldDamage 	= DAMAGE_BONUS_1d6 * 3;	
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eHaste,oPC, RoundsToSeconds(nDuration)); }
		eLink = EffectDamageShield(0, nShieldDamage, DAMAGE_TYPE_FIRE);
	}
	else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_WATER,oPC))
	{	effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);	
			if (nLevel >= 5 ) 
		{	nShieldDamage 	= DAMAGE_BONUS_1d6 * 3;
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eCleanse,oPC, RoundsToSeconds(nDuration));	}
		eLink = EffectDamageShield(0, nShieldDamage, DAMAGE_TYPE_COLD);
		}

		
	eLink = EffectLinkEffects(eDur, eLink);	
	eLink = SupernaturalEffect(eLink);
	eLink = SetEffectSpellId(eLink, nSpellID);

	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration)));
	
	

}