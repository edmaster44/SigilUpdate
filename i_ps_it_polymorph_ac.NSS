

// i_ps_polymorph_ac

/* Created by Dedic8ed 5/24/2010
	Any singular polymorphing item can be used for this script, and can polymorph into any creature contained
	within the polymorph.2da file. The item's tag must be "ps_it_polymorph". Use unique resrefs to differentiate
	the items within toolset. Items should also be required to be "active only when equipped" for game balance
	purposes.

	Set the item's variable "polymorph" to match the integer of the 2da line item of the form to be polymorphed 
	into; i.e. 27 for cow, or 32 for succubus.
	
	Set the item's variable "duration" to the number of turns (60 seconds each) for the effect to last,
	i.e., 1 hour = 60 turns, while a full day = 1440 turns.
*/
void main()
{
    object oPC = GetItemActivator();
	object oItem = GetItemActivated();
    object oTarget = oPC;
	int nPoly = GetLocalInt(oItem, "polymorph");
	int nDuration = GetLocalInt(oItem, "duration");
	effect ePoly = EffectPolymorph(nPoly);
    effect eVis = EffectNWN2SpecialEffectFile("sp_enlarge_person_hit");

	AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_FIREFORGET_USEITEM,1.0));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, TurnsToSeconds(nDuration)));
	
	AssignCommand(oTarget, ClearAllActions()); // prevents an exploit


}