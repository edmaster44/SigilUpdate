

//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT7
/*
  Default OnDeath event handler for NPCs.

  Adjusts killer's alignment if appropriate and
  alerts allies to our death. 
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////
// chazm 5/6/05 added DeathScript
// ChazM 7/28/05 removed call to user defined event for onDeath
// ChazM - 1/26/07 - EvenFlw modifications
// ChazM -5/17/07 - Spirits don't drop crafting items, removed re-equip weapon code

#include "x2_inc_compon"
#include "x0_i0_spawncond"
#include "ps_inc_scriptcall"

void SpawnSpecificItem(object oKiller){
	object oPC = oKiller;
	object oItem;
	if (!GetIsPC(oPC)) oPC = GetMaster(oPC);
	if (!GetIsPC(oPC)) oPC = GetFirstFactionMember(oPC);
	if (!GetIsPC(oPC)) return;
	location lLoc = GetLocation(OBJECT_SELF);
	string sRef = "";
	int nRace = GetSubRace(OBJECT_SELF);
	if (FindSubString(GetTag(OBJECT_SELF), "ps_creature_ascended") != -1){//niflheim boss The Ascended
		sRef = "ps_key_mystery"; //always drops key to antechamber
	} else if (nRace == 40){ // incorporeal
		switch (d3()){
			case 1: sRef = "n2_crft_dist028"; break;//ghostly essence 
			case 2: sRef = "n2_crft_dist017"; break;//ghost residue
			case 3: sRef = "n2_crft_dist027"; break;//shadow residue
		}
	} else if (nRace == 137){ //ghoul
		switch(d2()){
			case 1: sRef = "n2_crft_dist015"; break; //ghoul claws
			case 2: sRef = "n2_crft_dist016"; break;//ghast claws
		}
	} else if (nRace == 159){ //vampire
		sRef = "n2_crft_dist035"; //vamp tooth
	}
	if (sRef == "ps_key_mystery"){
		oItem = CreateItemOnObject(sRef, oPC);
		FloatingTextStringOnCreature("You found a key!", oPC, FALSE); 
		return;
	}
	object oArea = GetArea(oPC);
	object oMember = GetFirstFactionMember(oPC, TRUE);
	while(GetIsObjectValid(oMember)){ 
		if (GetArea(oMember) == oArea && !GetIsDM(oMember)){
			if (d2() == 1){
				oItem = CreateItemOnObject(sRef, oPC);
				FloatingTextStringOnCreature("You salvaged something from your kill!", oMember, FALSE); 
			}
		}
		oMember = GetNextFactionMember(oPC, TRUE);  
	}
}

void main()
{
	object oKiller = GetLastKiller();
	SpawnSpecificItem(oKiller);
	ExecuteScript("ps_xp_script",OBJECT_SELF);

	string sDeathScript = GetLocalString(OBJECT_SELF, "DeathScript");
	if (sDeathScript != "")
		ExecuteScript(sDeathScript, OBJECT_SELF);

	
    int nClass = GetLevelByClass(CLASS_TYPE_COMMONER);
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
	

    // If we're a good/neutral commoner,
    // adjust the killer's alignment evil
    if(nClass > 0 && (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL))
    {
        AdjustAlignment(oKiller, ALIGNMENT_EVIL, 5);
    }
	
	//PS_WP_DeathDealer(oKiller);

    // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
	
	//Old Craft Drop - remove later?
	//if (!GetIsSpirit(OBJECT_SELF))
    //	craft_drop_items(oKiller);
	
}