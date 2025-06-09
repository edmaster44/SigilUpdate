#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "nw_i0_spells"
#include "aaa_constants"

void main()
{
    object oPC 		= GetAreaOfEffectCreator();
    object oTarget	= GetExitingObject();

	RemoveSpellEffects(SPELLABILITY_WC_SNOWSONG, oPC, oTarget);
}