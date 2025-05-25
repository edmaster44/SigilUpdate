

// i_ps_golemsum_ac
// Script created by Ceremorph 7/19/2015 for use in the Sigil: City of Doors PW
// This will be used in conjunction with the Golem Control Device created when one crafts a golem.   
// Modification by Agony_Aunt to store repawning of hench in event of server crash within time specified in function
// AllowRespawnHench in ps_inc_faction
// Reviewed by Clangeddin 28/12/2017


#include "ps_inc_golem"

void main()
{
	object oPC		= GetItemActivator();
	object oItem	= GetItemActivated();
	// Collect variable from the calling item to determine what will be summonned
	string sGolem	= GetLocalString(oItem, "golem");
	location oLoc 	= GetItemActivatedTargetLocation();

	// If the PC already has a creature in the henchman slot (golem or not), it will be unsummoned (destroyed). This
	// removes the need for an unsummon widget, as well as clearing out additional henchman before creating the golem.
	if (GetHenchman(oPC) != OBJECT_INVALID)
	{	
		object oHENCH = GetHenchman(oPC);
		RemoveHenchman(oPC, oHENCH);
		DestroyObject(oHENCH, 0.5);
		if (GetResRef(oHENCH) == sGolem) return;
		else if (GetTag(oHENCH) == sGolem) return;
	}

	// Create the new henchman as an object
	object oGolem = CreateObject(OBJECT_TYPE_CREATURE, sGolem, oLoc);
	DelayCommand(0.5, AdjustGolem(oPC, oGolem, oItem));			
}