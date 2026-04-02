#include "ff_applyeffect" 
//::///////////////////////////////////////////////
//:: Lesser Spell Turning
//:: NW_S0_LsSpTurn.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: [Description of File]
//:://////////////////////////////////////////////
//:: Created By: [Your Name]
//:: Created On: [date]
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

void main()
{
	object oTarget = GetSpellTargetObject();
	effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);

	PS_ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
;
}

