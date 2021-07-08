//::///////////////////////////////////////////////
//:: Gate
//:: NW_S0_Gate.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: Summons a Balor to fight for the caster.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: AFW-OEI 05/31/2006:
//::	Update creature blueprint (to Horned Devil).
//:: BDF-OEI 8/02/2006:
//::	Renamed CreateBalor to CreateOutsider and added a DCR to kickstart attack on the summoner
//:: EPF 8/20/07
//::	Removed check for protection from evil - the requirement is not actually part of 3.5E rules, and can cause problems
//:: 	if the summoned creature attacks non-plot NPCs,which it will do if they are Defender or Merchant.

void CreateOutsider();
#include "x2_inc_spellhook" 
#include "nw_i0_generic"

//Gate - Alternate Paragon - Outsider 3/Frenzied Berzerker 10/Divine Champion 7
const string SCOD_GATE_LAWFUL_NEUTRAL 	= "ps_gate_ln"; 		//Marut
const string SCOD_GATE_CHAOTIC_NEUTRAL 	= "ps_gate_cn"; 		//White Slaad
const string SCOD_GATE_NEUTRAL_GOOD 	= "ps_gate_ng"; 		//Astral Deva
const string SCOD_GATE_NEUTRAL_EVIL 	= "ps_gate_ne"; 		//Sepid (Div)

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


    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    effect eVis = EffectVisualEffect( VFX_DUR_GATE );
	effect eVis2 = EffectVisualEffect( VFX_INVOCATION_BRIMSTONE_DOOM );
    //Make metamagic extend check
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;	//Duration is +100%
    }
    location lSpellTargetLOC = GetSpellTargetLocation();

    int iAlignGE = GetAlignmentGoodEvil(OBJECT_SELF);
	int iAlignLC = GetAlignmentLawChaos(OBJECT_SELF);
	string sTemplate = "c_pig"; // if no valid template then default to pig

		if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_GATE_NEUTRAL_GOOD;
		else if (iAlignGE == ALIGNMENT_NEUTRAL && iAlignLC != ALIGNMENT_CHAOTIC) sTemplate = SCOD_GATE_LAWFUL_NEUTRAL;
		else if (iAlignGE == ALIGNMENT_NEUTRAL && iAlignLC == ALIGNMENT_CHAOTIC) sTemplate = SCOD_GATE_CHAOTIC_NEUTRAL;
		else if (iAlignGE == ALIGNMENT_EVIL && iAlignLC == ALIGNMENT_CHAOTIC) sTemplate = SCOD_GATE_CHAOTIC_NEUTRAL;
		else sTemplate = SCOD_GATE_NEUTRAL_EVIL;	
		
    float fSeconds = TurnsToSeconds(nDuration);
    effect eSummon = EffectSummonCreature(sTemplate, VFX_INVOCATION_BRIMSTONE_DOOM, 3.0);
	DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lSpellTargetLOC, fSeconds));
	ApplyEffectAtLocation ( DURATION_TYPE_TEMPORARY, eVis, lSpellTargetLOC, 5.0);
}

void CreateOutsider()
{
	object oCaster = OBJECT_SELF;
	object oOutsider = CreateObject(OBJECT_TYPE_CREATURE, "c_summ_devilhorn", GetSpellTargetLocation());
	AssignCommand( oOutsider, DetermineCombatRound(oCaster) );
}