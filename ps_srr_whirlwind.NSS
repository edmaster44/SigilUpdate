/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat spell that gives djinn whirlwind effect */

// spell script


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

	//Declare major variables
	//Also prevent stacking
	
		object	oCaster		=	OBJECT_SELF;
		string	sSelf		=	ObjectToString(oCaster) + IntToString(GetSpellId());
		object	oSelf		=	GetNearestObjectByTag(sSelf);
		effect	eAOE		=	EffectAreaOfEffect(70, "", "", "", sSelf);
		effect 	eVis		=	EffectVisualEffect(881);
		float	fDuration	=	RoundsToSeconds(GetTotalLevels(oCaster, 1));
	
	//Link effects
		effect	eLink		=	EffectLinkEffects(eAOE, eVis);
		effect eConceal	=	EffectConcealment(10);
		eLink = ExtraordinaryEffect(EffectLinkEffects(eLink, eConceal));
		
	//Destroy the object if it already exists before creating a new one
	
		if (GetIsObjectValid(oSelf))
		{
			DestroyObject(oSelf);
		}
		
	//Generate the object
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
}