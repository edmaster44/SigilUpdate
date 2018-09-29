//::///////////////////////////////////////////////
//:: Epic Gate
//:: nx_s2_epic_gate.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

	Classes: Bard, Cleric, Druid, Spirit Shaman, Wizard, Sorcerer, Warlock
	Spellcraft Required: 27
	Caster Level: Epic
	Innate Level: Epic
	School: Conjuration
	Descriptor(s): 
	Components: Verbal, Somatic
	Range: Medium
	Area of Effect / Target: Point
	Duration: 40 rounds
	Save: None
	Spell Resistance: No

	This spell opens a portal to the Lower Planes and calls forth a balor
	to assail your foes. If the demon is slain, a second one is
	immediately summoned in its place.  The strength of this conjuration
	is such that the devils are bound to your will, and you need not have
	cast Protection from Evil, or any similar spell, to prevent them from
	attacking you.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 04/11/2007
//:://////////////////////////////////////////////
// EPF 7/13/07 - changed to balor
// AFW-OEI 07/17/2007: NX1 VFX.

#include "x2_inc_spellhook"

//Epic Gate - Alternate Paragon - Outsider 3/Frenzied Berzerker 10/Divine Champion 7
const string SCOD_EPICGATE_LAWFUL_NEUTRAL 	= "ps_epicgate_ln";		//Gantrenacht
const string SCOD_EPICGATE_CHAOTIC_NEUTRAL 	= "ps_epicgate_cn";	 	//Black Slaad
const string SCOD_EPICGATE_NEUTRAL_GOOD 	= "ps_epicgate_ng"; 	//Planetar
const string SCOD_EPICGATE_NEUTRAL_EVIL 	= "ps_epicgate_ne"; 	//Akvan (Div)

const string SCOD_GATE_LAWFUL_NEUTRAL 		= "ps_gate_ln"; 		//Marut
const string SCOD_GATE_CHAOTIC_NEUTRAL 		= "ps_gate_cn"; 		//White Slaad
const string SCOD_GATE_NEUTRAL_GOOD 		= "ps_gate_ng"; 		//Astral Deva
const string SCOD_GATE_NEUTRAL_EVIL 		= "ps_gate_ne"; 		//Sepid (Div)

void main()
{
    if (!X2PreSpellCastCode())
    {	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


    float fDuration = RoundsToSeconds(40);	// Fixed 40 round duration
	location lSpellTargetLocation = GetSpellTargetLocation();
    effect eDur = EffectVisualEffect(VFX_DUR_SPELL_EPIC_GATE);
	effect eVis = EffectVisualEffect(VFX_INVOCATION_BRIMSTONE_DOOM);
	string sTemplate1 = "c_pig"; // if no valid template then default to pig
	string sTemplate2 = "c_pig"; // if no valid template then default to pig
	
	int iAlignGE = GetAlignmentGoodEvil(OBJECT_SELF);
	int iAlignLC = GetAlignmentLawChaos(OBJECT_SELF);

		if (iAlignGE == ALIGNMENT_GOOD) 
			{
				sTemplate1 = SCOD_EPICGATE_NEUTRAL_GOOD;
				sTemplate2 = SCOD_GATE_NEUTRAL_GOOD;
			}
		else if (iAlignLC == ALIGNMENT_CHAOTIC && iAlignGE == ALIGNMENT_NEUTRAL)
		 	{
				sTemplate1 = SCOD_EPICGATE_CHAOTIC_NEUTRAL;
				sTemplate2 = SCOD_GATE_CHAOTIC_NEUTRAL;
			}
		else if (iAlignLC == ALIGNMENT_CHAOTIC && iAlignGE == ALIGNMENT_EVIL)
		 	{
				sTemplate1 = SCOD_EPICGATE_CHAOTIC_NEUTRAL;
				sTemplate2 = SCOD_GATE_CHAOTIC_NEUTRAL;
			}
		else if (iAlignLC == ALIGNMENT_LAWFUL && iAlignGE == ALIGNMENT_NEUTRAL) 
			{
				sTemplate1 = SCOD_EPICGATE_LAWFUL_NEUTRAL;
				sTemplate2 = SCOD_GATE_LAWFUL_NEUTRAL;
			}
		else if (iAlignLC == ALIGNMENT_NEUTRAL && iAlignGE == ALIGNMENT_NEUTRAL) 
			{
				sTemplate1 = SCOD_EPICGATE_LAWFUL_NEUTRAL;
				sTemplate2 = SCOD_GATE_LAWFUL_NEUTRAL;
			}
		else 
			{
				sTemplate1 = SCOD_EPICGATE_NEUTRAL_EVIL;	
				sTemplate2 = SCOD_GATE_NEUTRAL_EVIL;
			}
	
	effect eSummon = EffectSwarm(FALSE, sTemplate1, sTemplate2);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDur, lSpellTargetLocation, 5.0);
	DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lSpellTargetLocation));
    DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, OBJECT_SELF, fDuration));
}