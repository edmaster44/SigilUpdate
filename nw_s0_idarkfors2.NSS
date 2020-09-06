#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "ps_inc_functions"

void DarkForesight(object oPC)
{
    RemoveEffectsFromSpell(oPC, SPELL_I_DARK_FORESIGHT);

    int nDuration = GetWarlockCasterLevel(oPC);
    int nLimit = nDuration * 10;
	if ( nLimit > 150 )	nLimit = 150;
    effect eStone = EffectDamageReduction( 20, GMATERIAL_METAL_ALCHEMICAL_SILVER, nLimit, DR_TYPE_GMATERIAL );		// 3.5 DR approximation
	eStone = SetEffectSpellId(eStone, SPELL_I_DARK_FORESIGHT);
   
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_PREMONITION, FALSE));
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStone, oPC, RoundsToSeconds(nDuration));
}

void RefreshDarkForesight(object oPC)
{
	if (GetLocalInt(oPC,"DarkForesight")==FALSE) return;
	
	if (!GetIsInCombat()) DarkForesight(oPC);
	DelayCommand(6.0, RefreshDarkForesight(oPC));
}

void main()
{
	object oPC = OBJECT_SELF;

    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	RefreshDarkForesight(oPC);
}