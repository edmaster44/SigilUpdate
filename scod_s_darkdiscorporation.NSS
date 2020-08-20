//:://///////////////////////////////////////////////
//:: Warlock Dark Invocation: Dark Discorporation
//:: scod_s_darkdiscorporation.nss
//::////////////////////////////////////////////////
//:: Rewritten by MimiFearthegn on 8/20/2020
//:: May want to make sure that it cannot be used with eldritch shield

#include "x2_inc_spellhook"
#include "nwn2_inc_metmag"
#include "ps_inc_functions"
#include "nwn2_inc_spells"
#include "ginc_debug"
#include "nw_i0_spells"

void main() {

    if (!X2PreSpellCastCode()) {
        return;
    }
	
	//Prevent stacking + prevent its use with eldritch shield
	//Will also need to prevent use with Word of Changing
	//811 = Eldritch Shield
	int nID = GetSpellId();
	if ( GetHasSpellEffect(nID) || GetHasSpellEffect(811) )
	{
		effect eEffect = GetFirstEffect( OBJECT_SELF );
		while ( GetIsEffectValid(eEffect) )
		{
			if ( GetEffectSpellId(eEffect) == nID || GetEffectSpellId(eEffect) == 811 )
			{
				RemoveEffect( OBJECT_SELF, eEffect );
			}
			
			eEffect = GetNextEffect( OBJECT_SELF );
		}
	}

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetWarlockCasterLevel(oCaster);
    effect eVis = EffectNWN2SpecialEffectFile("fx_kos_teleport");
    effect ePoly;
    int nPoly;
    int nMetaMagic = GetMetaMagicFeat();
	
    //Enter Metamagic conditions
	float fDuration = TurnsToSeconds( GetCasterLevel(OBJECT_SELF ) );
    fDuration = ApplyMetamagicDurationMods( fDuration );
	
	effect eBuff = EffectMovementSpeedIncrease(99); //x2 speed
	eBuff = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK), eBuff); //being discorporated means undead like immunities
	eBuff = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT), eBuff); //being discorporated means undead like immunities
	eBuff = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN), eBuff); //being discorporated means undead like immunities
	eBuff = EffectLinkEffects(EffectConcealment(50), eBuff); //50% concealment
	
	SetEffectSpellId(eBuff, nID);
	//Add vfx here
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oCaster, fDuration);
}
	
	