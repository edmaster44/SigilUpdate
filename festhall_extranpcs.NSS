//Spawn in extra Festhall npcs by sector
//they are all randomly generated
#include "ps_inc_dynamicencounters"
#include "ps_inc_functions"
#include "x0_i0_anims"
#include "ps_inc_advscript"

string GenerateRandomComments();
object CreateRandomSensate(object oWP);

void main() {

	object oPC = GetEnteringObject();
	
	if (!GetIsPC(oPC))
		return;
	
	int lastDone = CheckTimeStamp();
	if (lastDone < 600) //happens once per 10 minutes
		return;
	TimeStamp();
	
	int nSector = GetLocalInt(OBJECT_SELF, "SECTOR");
	
	object oEncounter = GetLocalObject(OBJECT_SELF, "ENCOUNTER_SPAWNED_"+IntToString(nSector));
	if (GetIsObjectValid(oEncounter)) {
		return;
	}
	
	if (nSector == 1) {
		object oWP = GetWaypointByTag("wp_festhall_sector1_npc1");
		object oSensate = CreateRandomSensate(oWP);
		SetLocalString(oSensate, "ANIMATION", "talknormal");
		
		//Save that we did this
		SetLocalObject(OBJECT_SELF, "ENCOUNTER_SPAWNED_1", oSensate);
		
		oWP = GetWaypointByTag("wp_festhall_sector1_npc2");
		oSensate = CreateRandomSensate(oWP);
		SetLocalString(oSensate, "ANIMATION", "talkcheer");
		
		oWP = GetWaypointByTag("wp_festhall_sector1_npc3");
		oSensate = CreateRandomSensate(oWP);
		SetLocalString(oSensate, "ANIMATION", "talklaugh");
		
		oWP = GetWaypointByTag("wp_festhall_sector1_npc4");
		oSensate = CreateRandomSensate(oWP);
		SetLocalString(oSensate, "ANIMATION", "kemo_sit_3i");
		
		oWP = GetWaypointByTag("wp_festhall_sector1_npc5");
		oSensate = CreateRandomSensate(oWP);
		SetLocalString(oSensate, "ANIMATION", "sitgroundidle");
		
		oWP = GetWaypointByTag("wp_festhall_sector1_npc6");
		oSensate = CreateRandomSensate(oWP);
		SetLocalString(oSensate, "ANIMATION", "talknormal02");
	}
	if (nSector == 2) {
		object oWP = GetWaypointByTag("wp_festhall_sector2_npc1");
		object oSensate = CreateRandomSensate(oWP);
		SetLocalString(oSensate, "ANIMATION", "craft01");
		SetFirstName(oSensate, "Painter");
		
		//Save that we did this
		SetLocalObject(OBJECT_SELF, "ENCOUNTER_SPAWNED_2", oSensate);
		
		oWP = GetWaypointByTag("wp_festhall_sector2_npc2");
		oSensate = CreateRandomSensate(oWP);
		SetLocalString(oSensate, "ANIMATION", "listen");
		
		oWP = GetWaypointByTag("wp_festhall_sector2_npc3");
		oSensate = CreateRandomSensate(oWP);
		SetLocalString(oSensate, "ANIMATION", "talklaugh");
	}

}

object CreateRandomSensate(object oWP) {

	WriteTimestampedLogEntry("Creating random npc in "+GetTag(GetArea(oWP)));

	int nClass = CLASS_TYPE_BARD;
	int nClassRoll = Random(4)+1;
	int nLevel = 5;
	
	//Switch between class types - largely for cosmetic purposes
	switch(nClassRoll) {
		case 1: nClass = CLASS_TYPE_BARD; break;
		case 2: nClass = CLASS_TYPE_ROGUE; break;
		case 3: nClass = CLASS_TYPE_SPIRIT_SHAMAN; break; 
		case 4: nClass = CLASS_TYPE_WIZARD; break;
	}
	
	object oNPC = CreateScaledCreatureofClass(oWP, nLevel, nClass, STANDARD_FACTION_HOSTILE);
	if (!GetIsObjectValid(oNPC)) {
		return oNPC;
	}
	
	int nGender = Random(2);
	int nRace = GetHumanoidRace(oNPC);
	int nHead = GetHeadByRace(nGender, nRace);
	int nHair = GetHairByRace(nGender, nRace);
	
	struct CreatureCoreAppearance currentAppearance = PS_GetCreatureCoreAppearance(oNPC);
	currentAppearance.Gender = nGender;
	currentAppearance.AppearanceType = nRace;
	currentAppearance.HeadVariation = nHead;
	currentAppearance.HairVariation = nHair;
	PS_SetCreatureCoreAppearance(oNPC, currentAppearance);
	
	assignProtectiveItems(oNPC, FALSE);
	makeInventoryUndroppable(oNPC);
	
	SetFirstName(oNPC, "Sensate");
	SetLastName(oNPC, "");
	SetDescription(oNPC, "A member of the Society of Sensation, enjoying themselves in the Festhall.");
	DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(100), oNPC));

	//give them animations and the conversation script
	SetCreatureScriptsToSet(oNPC, 11);
	SetLocalInt(oNPC, "responses", 5);
	SetLocalString(oNPC, "say1", GenerateRandomComments());
	SetLocalString(oNPC, "say2", GenerateRandomComments());
	SetLocalString(oNPC, "say3", GenerateRandomComments());
	SetLocalString(oNPC, "say4", GenerateRandomComments());
	SetLocalString(oNPC, "say5", GenerateRandomComments());
	
	return oNPC;
}

string GenerateRandomComments() {

	int nRand = Random(10)+1;
	switch (nRand) {
		case 1: return "Lady's Grace, Cutter.";
		case 2: return "What should I indulge in tonight? Any suggestions?";
		case 3: return "Have you ever walked on hot coals?";
		case 4: return "You simply must try the Arborean Firewine. Ask Tasha for some at the Spice Rack.";
		case 5: return "What's the chant?";
		case 6: return "I hear there's a new restaurant opening in the Guildhouse Ward.";
		case 7: return "New sensations at every turn; what more could one wish for?";
		case 8: return "If you want the very best fruit in the city, go to the market in front of the Temple of Hermes first thing in the morning.";
		case 9: return "If you haven't already, you simply must catch a show at Ren Hall. The magic shows especially are spectacular.";
		case 10: return "Watch the Spire.";
	}
	
	return "Lady's Grace, Cutter.";

}