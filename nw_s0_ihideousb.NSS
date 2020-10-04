//::///////////////////////////////////////////////
//:: Invocation: Hideous Blow
//:: NW_S0_IHideousB.nss
//:://////////////////////////////////////////////
/*
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 26, 2005
//:://////////////////////////////////////////////
//:: AFW-OEI 07/17/2007: New Essence VFX.



// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"
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

    if (!X2PreSpellCastCode()) {
        return;
    }

    object oTarget = GetSpellTargetObject();
	int nDurVFX = VFX_INVOCATION_HIDEOUS_BLOW;
	object oCaster = OBJECT_SELF;
	
	//Remove previous versions of this spell
	effect eEffect = GetFirstEffect( oCaster );
	while ( GetIsEffectValid(eEffect) ) {
		
		SendMessageToPC(oCaster, "Shield: "+IntToString(GetEffectSpellId(eEffect)));
			
		if (GetEffectSpellId(eEffect) == 816 ||
			GetEffectSpellId(eEffect) == 2211 ||
			GetEffectSpellId(eEffect) == 2212 ||
			GetEffectSpellId(eEffect) == 2213 ||
			GetEffectSpellId(eEffect) == 2214 ||
			GetEffectSpellId(eEffect) == 2215 ||
			GetEffectSpellId(eEffect) == 2216 ||
			GetEffectSpellId(eEffect) == 2217 ||
			GetEffectSpellId(eEffect) == 2218 ||
			GetEffectSpellId(eEffect) == 2219 ||
			GetEffectSpellId(eEffect) == 2220 ||
			GetEffectSpellId(eEffect) == 2221) {
				RemoveEffect( oCaster, eEffect );
			}
				
		eEffect = GetNextEffect( oCaster );
	}
	
	int nMetaMagic;
	int nID = GetSpellId();
	
	switch (nID) {
		case 2211: nMetaMagic = METAMAGIC_INVOC_DRAINING_BLAST; nDurVFX = VFX_INVOCATION_DRAINING_BLOW; break; //draining spear
		case 2212: nMetaMagic = METAMAGIC_INVOC_FRIGHTFUL_BLAST; nDurVFX = VFX_INVOCATION_FRIGHTFUL_BLOW; break; //frightful spear
		case 2213: nMetaMagic = METAMAGIC_INVOC_BESHADOWED_BLAST; nDurVFX = VFX_INVOCATION_BESHADOWED_BLOW; break; //beshadowed spear
		case 2214: nMetaMagic = METAMAGIC_INVOC_BRIMSTONE_BLAST; nDurVFX = VFX_INVOCATION_BRIMSTONE_BLOW; break; //brimstone spear
		case 2215: nMetaMagic = METAMAGIC_INVOC_HELLRIME_BLAST; nDurVFX = VFX_INVOCATION_HELLRIME_BLOW; break; //hellrime spear
		case 2216: nMetaMagic = METAMAGIC_INVOC_BEWITCHING_BLAST; nDurVFX = VFX_INVOCATION_BEWITCHING_BLOW; break; //bewitching spear
		case 2217: nMetaMagic = METAMAGIC_INVOC_NOXIOUS_BLAST; nDurVFX = VFX_INVOCATION_NOXIOUS_BLOW; break; //noxious spear
		case 2218: nMetaMagic = METAMAGIC_INVOC_VITRIOLIC_BLAST; nDurVFX = VFX_INVOCATION_VITRIOLIC_BLOW; break; //vitriolic spear
		case 2219: nMetaMagic = METAMAGIC_INVOC_UTTERDARK_BLAST; nDurVFX = VFX_INVOCATION_UTTERDARK_BLOW; break; //utterdark spear
		case 2220: nMetaMagic = METAMAGIC_INVOC_HINDERING_BLAST; nDurVFX = VFX_INVOCATION_HINDERING_BLOW; break; //hindering spear
		case 2221: nMetaMagic = METAMAGIC_INVOC_BINDING_BLAST; nDurVFX = VFX_INVOCATION_BINDING_BLOW; break; //binding spear
	}

    effect eHidBlow = EffectHideousBlow( nMetaMagic );

    effect eDur = EffectVisualEffect( nDurVFX );
    effect eLink = EffectLinkEffects(eHidBlow, eDur);
	
	SetEffectSpellId(eLink, SPELL_I_HIDEOUS_BLOW);
	
    RemoveEffectsFromSpell(OBJECT_SELF, SPELL_I_HIDEOUS_BLOW);

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_I_HIDEOUS_BLOW, FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);
	ActionAttack( oTarget );
}