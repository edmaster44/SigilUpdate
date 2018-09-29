/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat spell that gives ghale globe polymorph effect */

// spell script


#include "nw_i0_spells"
#include "x2_inc_spellhook" 
//#include "nwn2_inc_metmag"

const int GLOBE_POLY =  394;

void main()
{
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
		object	oCaster	= OBJECT_SELF;
		float fDuration = 60.0 * GetTotalLevels(oCaster, TRUE);
		effect ePoly = EffectPolymorph(GLOBE_POLY);
		effect eVis = EffectNWN2SpecialEffectFile(Get2DAString("polymorph", "VFX", GLOBE_POLY));
		effect eLink = ExtraordinaryEffect(EffectLinkEffects(ePoly, eVis));
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
}