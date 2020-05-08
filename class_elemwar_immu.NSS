#include "x2_inc_spellhook"
#include "aaa_constants"
#include "X0_I0_SPELLS"
#include "nw_i0_spells"
void main()
{
object oPC = OBJECT_SELF;
	
	int nElemWar = GetLevelByClass(CLASS_TYPE_ELEMENTAL_WARRIOR,oPC);
	int nAmount = 10 *nElemWar ;
	int nSpellId = GetSpellId();
	nSpellId=	ELEMENTAL_WARRIOR_IMMUNITY;

	
	if (!GetHasSpellEffect(nSpellId,OBJECT_SELF))
	{

	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_AIR,oPC))
		
	{	
		effect eDR = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nAmount);
		}    
	else if(GetHasFeat(FEAT_ELEMWAR_AFFINITY_EARTH,oPC))
			{
			
			effect eDR = EffectDamageResistance(DAMAGE_TYPE_ACID, nAmount);
			}
	else if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_FIRE,oPC))
		{
		
	effect eDR = EffectDamageResistance(DAMAGE_TYPE_FIRE, nAmount);
		
		}
		
	else if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_WATER,oPC))
	{
	
	effect eDR = EffectDamageResistance(DAMAGE_TYPE_COLD, nAmount);
	}	 	
	effect eDR;
	eDR = SupernaturalEffect(eDR);
	eDR = SetEffectSpellId(eDR,nSpellId);
	
	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, OBJECT_SELF));	
} 
}     