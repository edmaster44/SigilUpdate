#include "nwn2_inc_spells"
#include "ps_inc_functions"
#include "aaa_constants"
#include "nw_i0_spells"
#include "x2_inc_spellhook" 
/*

Your flesh becomes thick and leathery like a demon's.
This spell grants you a +1 enhancement bonus to your natural armor for every five caster levels you possess (minimum +1, maximum +6).

*/
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
    int nCasterLvl = PS_GetCasterLevel(OBJECT_SELF);
    float fDuration = TurnsToSeconds(nCasterLvl * 10);

    //effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SPIDERSKIN, FALSE));

    int nLvlBonus;
    if ( nCasterLvl < 12 ) { nLvlBonus = nCasterLvl / 3; }
    else if (nCasterLvl >= 15  )               { nLvlBonus = 5; }

    int nACBonus = 1 + nLvlBonus;

    //Check for metamagic extend
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Set the bonuses
    effect eAC = EffectACIncrease(nACBonus, AC_NATURAL_BONUS);
   // effect ePoison = EffectSavingThrowIncrease(SAVING_THROW_ALL, nPoisonSaveBonus , SAVING_THROW_TYPE_POISON);
  //  effect eHide = EffectSkillIncrease(SKILL_HIDE, nHideSkillBonus);
   // effect eDur = EffectVisualEffect( VFX_DUR_SPELL_SPIDERSKIN );
    //effect eLink = EffectLinkEffects(eAC, ePoison);
    //eLink = EffectLinkEffects(eLink, eHide);
    //eLink = EffectLinkEffects(eLink, eDur);

    RemoveEffectsFromSpell(oTarget, GetSpellId());

    //Apply the armor bonuses and the VFX impact
    ApplyEffectToObject(nDurType, eAC, oTarget, fDuration);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}