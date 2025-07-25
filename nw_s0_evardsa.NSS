//::///////////////////////////////////////////////
//:: Evards Black Tentacles: On Enter
//:: NW_S0_EvardsA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the mass of rubbery tentacles the
    target is struck by 1d4 tentacles.  Each has
    a chance to hit of 5 + 1d20. If it succeeds then
    it does 1d6 damage and the target must make
    a Fortitude Save versus paralysis or be paralyzed
    for 1 round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
//:: GZ: Removed SR, its not there by the book

#include "nw_s0_evards_inc"

void main(){

    object oTarget = GetEnteringObject();
	
		//Debug: Check if various functions that forum information reports do not work within
		// aoe scripts actually work or not
		string sName = GetName(GetAreaOfEffectCreator());
		int nTestId = GetSpellId(); // does it work and if so for last spell or this spell
		int nTestCL = GetCasterLevel(GetAreaOfEffectCreator()); // gets caster level of last spell or this spell?
		int nTestMeta = GetMetaMagicFeat(); //does it work? If so, for last spell or this spell?
		string sTestFeat;
		switch (nTestMeta){
			case METAMAGIC_NONE: sTestFeat = "None"; break;
			case METAMAGIC_EMPOWER: sTestFeat = "Empower"; break;
			case METAMAGIC_EXTEND: sTestFeat = "Extend"; break;
			case METAMAGIC_MAXIMIZE: sTestFeat = "Maximize"; break;
			case METAMAGIC_QUICKEN: sTestFeat = "Quicken"; break;
			case METAMAGIC_SILENT: sTestFeat = "Silent"; break;
			case METAMAGIC_STILL: sTestFeat = "Still"; break;
			case METAMAGIC_PERSISTENT: sTestFeat = "Persistent"; break;
			default: sTestFeat = IntToString(nTestMeta);
		}
		string sMessage = "<c=cyan>This spell was cast by " + sName;
		sMessage += "\nThe spell id is " + IntToString(nTestId);
		sMessage += "\nThe Caster Level is " + IntToString(nTestCL);
		sMessage += "\nThe Metamagic used is " + sTestFeat;
		SendMessageToPC(oTarget, sMessage);
		// end debug
	
	if (!GetIsObjectValid(oTarget) || GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
		return;
	
	object oAOE = OBJECT_SELF;
	object oCaster = GetAreaOfEffectCreator();
	
	//stores caster level as data.nCL, 
	// save dc as data.nDC
	// Metamagic as data.nMeta
	// and pure mage levels as data.nPML
	struct dEvardsData data = GetEvardsData(oAOE, oCaster);
	
    effect eParal = EffectParalyze(data.nDC, SAVING_THROW_FORT);
    effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eLink = EffectLinkEffects(eDur, eParal);
    effect eDam;
	
    int nDamage;
    int nAC = GetAC(oTarget);
    int nHits;
    int nRoll;
    float fDelay;
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)){
		DoEvardsDamage(oCaster, oTarget, data);
	}
	
}