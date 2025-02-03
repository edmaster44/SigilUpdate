// i_ps_familiarchg_ac

/* Created by Dedic8ed 6/8/2011
	Based on i_ps_it_polymorph_ac
	This special polymorph script only applies itself to an already-summonned familiar to give it the creature
	appearance specified in the item variables.
	Set the item's variable "polymorph" to match the integer of the 2da line item of the form to be polymorphed 
	into; i.e. 27 for cow, or 32 for succubus.

	Due to its permanent nature, the polymorph will last through rests, only needing to be renewed after a
	server reset.
	
	Note to builders of Sigil: City of Doors: take note that care should be taken when choosing creatures to
	transform familiars into, as polymorph does give statistical bonuses. A frost giant or dragon familiar could
	be potentially game-breaking.
*/
void main()
{
    object oPC = GetItemActivator();
	object oItem = GetItemActivated();
    object oTarget = oPC;
	object oFamiliar = GetAssociate(3,oPC);
	int nPoly = GetLocalInt(oItem, "polymorph");
	effect ePoly = EffectPolymorph(nPoly);
    effect eVis = EffectNWN2SpecialEffectFile("sp_enlarge_person_hit");

	AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_FIREFORGET_USEITEM,1.0));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFamiliar);
	DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oFamiliar));

	AssignCommand(oTarget, ClearAllActions()); // prevents an exploit


}