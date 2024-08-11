/*

Hell's Power
(Book of Vile Darkness)

Conjuration (Creation) [Evil]
Level: Blackguard 3
Components: V, S, M, Devil
Casting Time: 1 action
Range: Personal
Target: Caster
Duration: 10 minutes/level
The caster summons evil energy from the Nine Hells and bathes himself in its power.
The caster gains a +2 deflection bonus to Armor Class(A maximum of +6), as well as the Same Damage Resistence a being from Hell Gains. Damage Reduction Silver 10

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

		if (!GetHasFeat(FEAT_BLACKGUARD,OBJECT_SELF))
	{ SendMessageToPC(OBJECT_SELF,"You do not walk the path of the Wicked for you to cast such a spell");
	return;
	}
	
	  object oTarget = GetSpellTargetObject();
    int nCasterLvl = PS_GetCasterLevel(OBJECT_SELF);
    float fDuration = TurnsToSeconds(nCasterLvl * 10);
	int nSpellId = GetSpellId();


    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HELLSPOWER, FALSE));

    int nLvlBonus = nCasterLvl / 3;
    if ( nLvlBonus > 5) nLvlBonus = 5;

 
	//Check for metamagic extend
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	effect eAC = EffectACIncrease(nLvlBonus + 1, AC_ARMOUR_ENCHANTMENT_BONUS);
	
	//Wrong argument order. The material and the type are reveresed. Should be 
	// (int nAmount, int nDRSubType=DAMAGE_POWER_NORMAL, int nLimit=0, int nDRType=DR_TYPE_MAGICBONUS);
	//effect eDRColdIron = EffectDamageReduction(nSilver, DR_TYPE_GMATERIAL, 0, GMATERIAL_METAL_ALCHEMICAL_SILVER);
	effect eDR = EffectDamageReduction(10, GMATERIAL_METAL_ALCHEMICAL_SILVER, 0, DR_TYPE_GMATERIAL);
	effect eLink = EffectLinkEffects(eDR, eAC);
	
	eLink = SetEffectSpellId(eLink, nSpellId);
	
    RemoveEffectsFromSpell(oTarget, nSpellId);
	
	ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
	
	}