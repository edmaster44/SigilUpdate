//::///////////////////////////////////////////////
//:: Magic Cirle Against Good
//:: NW_S0_CircGoodA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Add basic protection from good effects to
    entering allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 20, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{




    object oTarget = GetEnteringObject();

//    if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    if(GetIsObjectValid(oTarget))
    {
		if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
        {
			int nAOE = GetAreaOfEffectSpellId(oTarget);
            if (nAOE == SPELL_DARKNESS || nAOE == SPELL_I_DARKNESS || nAOE == SPELL_SHADOW_CONJURATION_DARKNESS || nAOE == 1915 || nAOE == SPELLABILITY_AS_DARKNESS || nAOE == SPELLABILITY_DARKNESS || nAOE == SPELLABILITY_DARKNESS_RACIAL || nAOE == 2636) //auras have permanent AOE object
            {
                DestroyObject(oTarget);
            }
        }
		
     }
}