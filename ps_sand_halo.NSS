#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"


void main()
{
if (!X2PreSpellCastCode())
   {	return;  }

object  oTarget  =  GetSpellTargetObject();
object  oCaster  =  OBJECT_SELF;
int     iBonus      =   GetAbilityModifier(ABILITY_WISDOM, oTarget);
effect  eVis  	=  EffectVisualEffect(VFX_SPELL_DUR_NATURE_AVATAR); 
effect  eArmor  	=   EffectACIncrease(iBonus, AC_SHIELD_ENCHANTMENT_BONUS);
float	fDuration	=	HoursToSeconds(GetCasterLevel(oCaster));
        fDuration   =   ApplyMetamagicDurationMods(fDuration);
effect  eDur        =   EffectVisualEffect(VFX_DUR_SPELL_SHIELD);
   int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
effect eLink = EffectLinkEffects(eArmor, eDur);

if (GetIsObjectValid(oTarget))
{
	if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
 	{
 		if (GetHasEffect(EFFECT_TYPE_POLYMORPH, oTarget))
 		{
			if (GetLevelByClass(CLASS_TYPE_MONK, oTarget) == 0)
   			{
   				RemoveEffectsFromSpell(oTarget, GetSpellId());
				RemoveEffectsFromSpell(oTarget, 629);
   				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
   			}
 		}
 		else
	 	{
   			FloatingTextStrRefOnCreature(184683, oCaster, FALSE);
   			return;
 		}
 	}
}
}
   