//:://////////////////////////////////////////////
/*
   Baleful Geas - Dragon Magic
   scod_s_balefulgeas.nss
*/
//:://////////////////////////////////////////////
//:: Created By: Xndar
//:: Created On: July 1st, 2014
//:://////////////////////////////////////////////
/*
rapsam2003 03/26/2018: Remove save against NPCs and
	Hexer feats increase the strength of the target.
*/

#include "x0_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "srcalc"

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

    //Declare major variables
	object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    effect eGeas = EffectDominated();
    eGeas = GetScaledEffect(eGeas, oTarget);
    effect eDur = EffectVisualEffect(VFX_HIT_SPELL_INFLICT_6);
	int nGeasDice = d4(2);
	
	//Link domination and persistant VFX
    effect eLink = EffectLinkEffects(eDur, eGeas);
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDuration = 3 + nCasterLevel/2;
	
	if (GetHasFeat(2907, OBJECT_SELF)) 
	{
		nGeasDice += 2;
		nDuration += 3 + (nCasterLevel*2);
	}
	else if (GetHasFeat(2904, OBJECT_SELF)) 
	{
		nGeasDice += 2;
		nDuration += 3 + nCasterLevel;
	}
	
	// rapsam2003: For Baleful Geas, these feats
	// increase the strength of the NPC.
	// With Fellblade's Curse: Baleful Geas
	// and Cursemaster, the total strength increase 
	// of the of the dominated should be 2d4+2.
	int nHexerBuff = 0;
	
	if (GetHasFeat(2901, OBJECT_SELF))
		nHexerBuff = d4(2);
	else if (GetHasFeat(2900, OBJECT_SELF))
		nHexerBuff = d4(1);
	else if (GetHasFeat(2899, OBJECT_SELF))
		nHexerBuff = 2;

	effect eAbilityChange;
	
	// rapsam2003: Add hexer and Geas increases.
	nHexerBuff += nGeasDice;
	
	if (nHexerBuff > 0)
		eAbilityChange = EffectAbilityIncrease(ABILITY_STRENGTH, nHexerBuff);
	else
		eAbilityChange = EffectAbilityDecrease(ABILITY_STRENGTH, nGeasDice);
	
    nDuration = GetScaledDuration(nDuration, oTarget);
	
    //Signal spell cast at event.
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1374, FALSE));
	
	// Spell Resist check.
    if (!DoWarlockMyResistSpell(oCaster, oTarget) || GetHasFeat(2907, oCaster))
    {
		// Do NOT want this cast on PCs.
		// Make a Will save, for balance.
   		if (!GetIsPC(oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
		{                    
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAbilityChange, oTarget);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
			SendMessageToPC(oCaster, "The curse dominates the affected enemy.");
		}
	}	
}