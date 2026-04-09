/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat spell that gives djinn whirlwind effect */

// on enter script

#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"

void main()
{
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

//Declare major variables
	object 	oTarget			=	GetEnteringObject();
	object	oCaster			=	GetAreaOfEffectCreator();
	int		nCasterLevel	=	GetTotalLevels(oCaster, TRUE);
	effect	eKnockdown	=	 EffectKnockdown();
	
	if (GetIsObjectValid(oTarget) && spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
	{
		// strength of whirlwind increases with level of caster
		int iResist = GetAbilityScore(oTarget, ABILITY_STRENGTH) + d20();
		int iPush = nCasterLevel + d20();
		if (iPush > iResist)
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 6.0);
		}
	}
}
	
			

	
	
	