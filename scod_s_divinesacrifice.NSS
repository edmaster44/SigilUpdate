/*
Divine Sacrifice
(Book of Exalted Deeds)

Necromancy
Level: Champion of Gwynharwyf 1, Paladin 1,
Components: V, S,
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 round/level or until discharged

You can sacrifice life force to increase the damage you deal.
When you cast the spell, you can sacrifice up to 10 of your hit points.
For every 2 hp you sacrifice, on your next successful attack you deal +1d6 damage, to a maximum of +5d6 on that attack.
Your ability to deal this extra damage ends when you successfully attack or when the spell duration ends.
Sacrificed hit points count as normal lethal damage, even if you have the regeneration ability.

*/

#include "aaa_constants"
#include "nwn2_inc_spells"
#include "ps_inc_functions"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oPC = OBJECT_SELF;
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_DIVINE_FAVOR);
        float fDuration = TurnsToSeconds(1); 
    int nScale = (PS_GetCasterLevel(OBJECT_SELF) /5);
	 if (nScale < 1)
        nScale = 1;
	  effect eDamage = EffectDamageIncrease(d6(nScale)  , DAMAGE_TYPE_MAGICAL);
	  effect eHarm = EffectDamage(nScale * 2 ,DAMAGE_TYPE_MAGICAL,DAMAGE_POWER_NORMAL,TRUE);
	  effect eLink = EffectLinkEffects(eDamage, eHarm);
	  int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	  
	  
	  ApplyEffectToObject(nDurType, eLink, oPC, fDuration);
	  
}