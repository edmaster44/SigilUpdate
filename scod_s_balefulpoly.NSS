//:://////////////////////////////////////////////
/*
   Baleful Polymorph - Warlock Spell
   scod_s_balefulpoly.NSS
*/
//:://////////////////////////////////////////////
//:: Created By: Mimi Fearthegn
//:: Created On: Februrary 2nd, 2015
//:://////////////////////////////////////////////
/*
rapsam2003 03/26/2018: Remove save against NPCs and
	Hexer feats decrease the BAB of the target.
*/

#include "x0_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "srcalc"
 
void main() {

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

    //Declare major variables
    int nSpell = GetSpellId();
	
	// constrain to allowed values
	if(nSpell<1680 || nSpell>1685)
		nSpell=1680 + Random(5); // set default as random (instead of cow)
	
	object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect( VFX_DUR_POLYMORPH );
    effect ePoly;
    int nPoly = POLYMORPH_TYPE_CHICKEN;
    int nMetaMagic = GetMetaMagicFeat();
	effect	eCurse;
	int nMod = 3;
	int nTargetBABOriginal = GetTRUEBaseAttackBonus(oTarget);
	int nTargetBABNew = nTargetBABOriginal;

	if (GetHasFeat(FEAT_HEXEN_HEXER_3, OBJECT_SELF))
		nTargetBABNew -= 6;
	else if (GetHasFeat(FEAT_HEXEN_HEXER_2, OBJECT_SELF))
		nTargetBABNew -= 4;
	else if (GetHasFeat(FEAT_HEXEN_HEXER_1, OBJECT_SELF))
		nTargetBABNew -= 2;
	
	// Adjust attacks per round.
	if ((nTargetBABNew > 0) && (nTargetBABOriginal > nTargetBABNew))
	{
		if (nTargetBABNew <= 29)
			SetBaseAttackBonus(6, oTarget); // 6 attacks per round
		if (nTargetBABNew <= 25)
			SetBaseAttackBonus(5, oTarget); // 5 attacks per round
		if (nTargetBABNew <= 20)
			SetBaseAttackBonus(4, oTarget); // 4 attacks per round
		if (nTargetBABNew <= 15)
			SetBaseAttackBonus(3, oTarget); // 3 attacks per round
		if (nTargetBABNew <= 10)
			SetBaseAttackBonus(2, oTarget); // 2 attacks per round
		if (nTargetBABNew <= 5)
			SetBaseAttackBonus(1, oTarget); // A single attack per round
	}
		
    int nDuration = PS_GetCasterLevel(OBJECT_SELF);
	
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND) {
        nDuration = nDuration *2; //Duration is +100%
    }

    //Determine Polymorph subradial type
    if(nSpell == 1681)
    {
        nPoly = 168; //Pig
    }
    else if (nSpell == 1682)
    {
        nPoly = 40; //Chicken
    }
    else if (nSpell == 1683)
    {
        nPoly = 177; //Weasel
    }
    else if (nSpell == 1684)
    {
        nPoly = 403; //Rabbit
    }
    else if (nSpell == 1685)
    {
        nPoly = 171; //Bat
    }
    ePoly = EffectPolymorph(nPoly);
	ePoly = EffectLinkEffects( ePoly, eVis );
	
	if (GetHasFeat(FEAT_HEXEN_HEXER_3, OBJECT_SELF))
		nMod = 4;
	if (GetHasFeat(FEAT_HEXEN_BALEFUL_POLYMORPH, OBJECT_SELF))
		nDuration = nDuration*2;
		
	eCurse   = EffectCurse(0, 0, 0, nMod, nMod, nMod);
		
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1680, TRUE));

    //Apply the VFX impact and effects
    AssignCommand(oTarget, ClearAllActions()); // Prevents an exploit
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        // Make SR Check
        if (GetHasFeat(FEAT_HEXEN_CURSEMASTER, OBJECT_SELF) || !DoWarlockMyResistSpell(OBJECT_SELF, oTarget))
        {
		 	// Make a Fort Save
            if (!GetIsPC(oTarget) && !MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC())) {
			
    				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, TurnsToSeconds(nDuration));
					
					if (GetHasFeat(FEAT_HEXEN_BALEFUL_POLYMORPH, OBJECT_SELF) {
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oTarget, TurnsToSeconds(nDuration));
					}
					
					// Make a Will Save vs. the mental effects
					if (!GetIsPC(oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC())) {
						eCurse = SupernaturalEffect(eCurse);
            			ApplyEffectToObject(1, eCurse, oTarget, TurnsToSeconds(nDuration));
					}
					
			} else if (GetIsPC(oTarget) && GetHasFeat(FEAT_HEXEN_BALEFUL_POLYMORPH, OBJECT_SELF)) {
			
				if (!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC())) {
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oTarget, TurnsToSeconds(nDuration));
				}
					
			}
		}
	}
}