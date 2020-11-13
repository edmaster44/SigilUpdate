

/*
Blade of Blood


Necromancy
Level: Blackguard 1
Components: V, S,
Casting Time: 1 swift action
Range: Touch
Target: Weapon touched
Duration: 1 round/level or until discharged
Saving Throw: None
Spell Resistance: No

*/

#include "nwn2_inc_spells"
#include "ps_inc_functions"
#include "aaa_constants"
#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "x2_inc_toollib"



const int IP_CONST_ONHIT_CASTSPELL_BLADE_OF_BLOOD = 147;
	
void main()
{
	if (!GetHasFeat(FEAT_BLACKGUARD,OBJECT_SELF))
	{ SendMessageToPC(OBJECT_SELF,"You do not walk the path of the Wicked for you to cast such a spell");
	return;
	}
	

	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;
	
	//Declar major variables
	object oPC = OBJECT_SELF;
	object oWEAPON = IPGetTargetedOrEquippedMeleeWeapon();
	
	//Run the spell if target is a valid a weapon
    if (GetIsObjectValid(oWEAPON) == FALSE) FloatingTextStrRefOnCreature(83615, oPC);
	else
    {	int nLVL = PS_GetCasterLevel(oPC);
		float fDUR = RoundsToSeconds(nLVL);
		effect eHarm = EffectDamage(5 ,DAMAGE_TYPE_MAGICAL,DAMAGE_POWER_NORMAL,TRUE);
		if (GetLastSpellCastClass() == CLASS_TYPE_PALADIN) fDUR = fDUR * 10.0;
		if (GetMetaMagicFeat() == METAMAGIC_EXTEND) fDUR = fDUR * 2.0;
		object oTARGET = GetSpellTargetObject();
        SignalEvent(oWEAPON, EventSpellCastAt(oPC, GetSpellId(), FALSE));
		effect eVFX = EffectVisualEffect(VFX_DUR_SPELL_EVIL_AURA);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, GetItemPossessor(oWEAPON), fDUR);
		IPSafeAddItemProperty(oWEAPON, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_BLADE_OF_BLOOD, nLVL), fDUR);
		IPSafeAddItemProperty(oWEAPON, ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), fDUR);
        TLVFXPillar(VFX_IMP_EVIL_HELP, GetLocation(oTARGET), 4, 0.0f, 6.0f);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHarm, oPC, 1.0f);
        DelayCommand(1.0f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), GetLocation(oTARGET)));
    }
}