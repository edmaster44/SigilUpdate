#include "nwn2_inc_spells"
#include "ps_inc_functions"
#include "aaa_constants"
#include "nw_i0_spells"
#include "x2_inc_spellhook" 


void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
// End of Spell Cast Hook

	if (!GetHasFeat(FEAT_BLACKGUARD,OBJECT_SELF))
	{ SendMessageToPC(OBJECT_SELF,"You do not walk the path of the Wicked for you to cast such a spell");
	return;
	}
	

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nAmount = PS_GetCasterLevel(OBJECT_SELF) * 10;
    float fDuration = HoursToSeconds(GetCasterLevel(OBJECT_SELF));

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DEMONHIDE, FALSE));


    //Meta Magic
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

//Damage Reduction good. 
    effect eDR = EffectDamageReduction(5, DR_TYPE_ALIGNMENT, 0, ALIGNMENT_GOOD);	// JLR-OEI 02/14/06: NWN2 3.5 -- New Damage Reduction Rules
	effect eDRColdIron = EffectDamageReduction(5, DR_TYPE_GMATERIAL, 0, GMATERIAL_METAL_COLD_IRON);
	effect eVis1 = EffectVisualEffect( VFX_DUR_SPELL_SPIDERSKIN );
	effect eLink = EffectLinkEffects(eDR,eDRColdIron);
	eLink = EffectLinkEffects(eLink,eVis1);
	

    RemoveEffectsFromSpell(oTarget, SPELL_DEMONHIDE);

    //Apply the linked effects.
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}