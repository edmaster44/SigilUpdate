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

	int nSpellID = SPELLABILITY_ELEMWAR_MANIFESTATION;
	object oTarget	= GetSpellTargetObject();	
	effect eHaste = EffectHaste();
	effect eSlow = EffectSlow();
	
    RemoveSpellEffects(nSpellID, OBJECT_SELF, OBJECT_SELF);
	
	effect eLink;
	
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_AIR))
	{
		eLink = EffectConcealment(20, MISS_CHANCE_TYPE_NORMAL);
	}
	else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_EARTH))
	{	
		eLink =	EffectDamageReduction(15,GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL);
	}
	else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_FIRE))
	{	
			if (nLevel >= 5 ) 
		{	nShieldDamage 	= DAMAGE_BONUS_1d6 * 3;	}
		eLink = EffectDamageShield(0, nShieldDamage, DAMAGE_TYPE_FIRE);
	}
	else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_WATER))
	{	
		
		 ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eHaste,oPC, RoundsToSeconds(10));
		 ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSlow,oTarget, RoundsToSeconds(10));
			if (nLevel >= 5 ) 
		{	nShieldDamage 	= DAMAGE_BONUS_1d6 * 3;	}
		eLink = EffectDamageShield(0, nShieldDamage, DAMAGE_TYPE_ELECTRICAL);
		}

		
    effect eDur = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);	
	eLink = EffectLinkEffects(eDur, eLink);	
	eLink = SupernaturalEffect(eLink);
	eLink = SetEffectSpellId(eLink, nSpellID);

	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(10)));
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_WATER))
	{
	
	 	 DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eHaste,oPC, RoundsToSeconds(10)));
		 DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSlow,oTarget, RoundsToSeconds(10)));
	
	}
		
}