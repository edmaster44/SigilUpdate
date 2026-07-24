

// i_ps_golemsum_ac
// Script created by Ceremorph 7/19/2015 for use in the Sigil: City of Doors PW
// This will be used in conjunction with the Golem Control Device created when one crafts a golem.   
// Modification by Agony_Aunt to store repawning of hench in event of server crash within time specified in function
// AllowRespawnHench in ps_inc_faction
// Reviewed by Clangeddin 28/12/2017


#include "ps_inc_golem"

string GetNonGMgolem(string sGolem);

void main()
{
	object oPC		= GetItemActivator();
	object oItem	= GetItemActivated();
	// If the PC already has a creature in the henchman slot (golem or not), it will be unsummoned (destroyed). This
	// removes the need for an unsummon widget, as well as clearing out additional henchman before creating the golem.
	// NOTE: It does NOT remove the need for the unsummon widget unless we want people just wandering around in rp
	// areas with their golems 24/7.  -FlattedFifth, July 23, 2026
	if (GetHenchman(oPC) != OBJECT_INVALID)
	{	
		object oHENCH = GetHenchman(oPC);
		RemoveHenchman(oPC, oHENCH);
		DestroyObject(oHENCH, 0.5);
	}
	
	// Collect variable from the calling item to determine what will be summonned
	// AND make sure that the resulting HD of the golem is 23 or less for non- golem masters. -FF
	string sGolem	= GetLocalString(oItem, "golem");
	location oLoc 	= GetItemActivatedTargetLocation();
	if (GetLevelByClass(77, oPC) < 1) sGolem = GetNonGMgolem(sGolem); // get reduced hd string for non gm
	

	// Create the new henchman as an object
	object oGolem = CreateObject(OBJECT_TYPE_CREATURE, sGolem, oLoc);
	DelayCommand(0.5, AdjustGolem(oPC, oGolem, oItem));			
}

string GetNonGMgolem(string sGolem){

	if (sGolem == "ps_gmg_bone_3") return "ps_gmg_bone_2";
	else if (sGolem == "ps_gmg_brain_3") return "ps_gmg_brain_2";
	else if (sGolem == "ps_gmg_crystal_3") return "ps_gmg_crystal_2";
	else if (sGolem == "ps_gmg_demon_3") return "ps_gmg_demon_2";
	else if (sGolem == "ps_gmg_hellfire_2" || sGolem == "ps_gmg_hellfire_3") return "ps_gmg_hellfire_1";
	else if (sGolem == "ps_gmg_woodwraith_3" || sGolem == "ps_gmg_woodwraith_2") return "ps_gmg_woodwraith_1";
	else if (sGolem == "ps_gmg_valor_3") return "ps_gmg_valor_2";
	
	return sGolem;
}