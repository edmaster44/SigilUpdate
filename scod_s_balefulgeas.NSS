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
	int nDrainDice = d4(2);
	
	//Link domination and persistant VFX
    effect eLink = EffectLinkEffects(eDur, eGeas);
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDuration = 3 + nCasterLevel/2;
	
	if (GetHasFeat(2907, OBJECT_SELF)) {
		nDrainDice = d4(3);
		nDuration = 3 + (nCasterLevel*2);
	}
	else if (GetHasFeat(2904, OBJECT_SELF)) {
		nDrainDice = d4(3);
		nDuration = 3 + nCasterLevel;
	}
	
	// rapsam2003: For Baleful Geas, these feats
	// increase the strength of the NPC.
	int nHexerBuff = 0;
	
	if (GetHasFeat(2901, OBJECT_SELF))
		nHexerBuff = d4(2);
	else if (GetHasFeat(2900, OBJECT_SELF))
		nHexerBuff = d4(1);
	else if (GetHasFeat(2899, OBJECT_SELF))
		nHexerBuff = 2;

	effect eAbilityChange;
	
	if (nHexerBuff > 0)
		eAbilityChange = EffectAbilityIncrease(ABILITY_STRENGTH, nHexerBuff);
	else
		eAbilityChange = EffectAbilityDecrease(ABILITY_STRENGTH, nDrainDice);
	
    nDuration = GetScaledDuration(nDuration, oTarget);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1374, FALSE));
    //Make sure the target is a monster
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Make SR Check
		if (GetHasFeat(2907, OBJECT_SELF) || !DoWarlockMyResistSpell(OBJECT_SELF, oTarget))
		{
			//Make a Will Save
     		if (!GetIsPC(oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
  			{                    
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAbilityChange, oTarget);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
				SendMessageToPC(oCaster, "The curse dominates the affected enemy.");
			}
		}
	}
}