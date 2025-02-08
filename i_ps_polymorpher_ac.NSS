#include "ff_safevar"

// i_ps_polymorpher_ac
/*	Script created by Dedic8ed for use in the Sigil: City of Doors PW
	   
This script is designed to allow items which allow the user to polymorph. Rather than creating individual scripts for
multiple items, this instead uses two variables set on the item itself, and the "Cast Spell: Unique Power" command to
activate this script. Any item using this script must have ps_polymorpher as its tag.

"polymorph" is the row number in polymorph.2da of the desired shape.
"wild" is 1 for TRUE, and 0 for False, determining if the shape counts as a wildshape. If not set, defaults to 0.
"duration" is the duration in hours of the polymorph effect. This must be set for the script to fire properly.

*/  

void main()
{
    object oPC      = GetItemActivator();
    object oItem    = GetItemActivated();
	int iPolym		= PS_GetLocalInt(oItem, "polymorph");
	int iWild		= PS_GetLocalInt(oItem, "wild");
	effect ePolym	= EffectPolymorph(iPolym, 0, iWild);
	effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
	int iDuration	= PS_GetLocalInt(oItem, "duration");
	float fDuration = HoursToSeconds(iDuration);

	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePolym,oPC, fDuration));
}