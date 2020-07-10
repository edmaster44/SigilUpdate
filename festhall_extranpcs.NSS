//Spawn in extra Festhall npcs by sector
//they are all randomly generated
#include "ps_inc_dynamicencounters"
#include "ps_inc_functions"
#include "x0_i0_anims"
#include "ps_inc_advscript"

string GenerateRandomComments();
object CreateRandomSensate(object oWP, object oPC = OBJECT_INVALID);
void SetLectureTopic(object oLecture);

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
	
	object oWP;
	object oSensate;
	if (nSector == 1) {
		oWP = GetWaypointByTag("wp_festhall_sector1_npc1");
		oSensate = CreateRandomSensate(oWP, oPC);
		SetLocalString(oSensate, "ANIMATION", "talknormal");
		
		//Save that we did this
		SetLocalObject(OBJECT_SELF, "ENCOUNTER_SPAWNED_1", oSensate);
		
		oWP = GetWaypointByTag("wp_festhall_sector1_npc2");
		oSensate = CreateRandomSensate(oWP, oPC);;
		SetLocalString(oSensate, "ANIMATION", "talkcheer");
		
		oWP = GetWaypointByTag("wp_festhall_sector1_npc3");
		oSensate = CreateRandomSensate(oWP, oPC);
		SetLocalString(oSensate, "ANIMATION", "talklaugh");
	}
	if (nSector == 2) {
		oWP = GetWaypointByTag("wp_festhall_sector1_npc4");
		oSensate = CreateRandomSensate(oWP, oPC);
		SetLocalString(oSensate, "ANIMATION", "sittalk01");
		
		//Save that we did this
		SetLocalObject(OBJECT_SELF, "ENCOUNTER_SPAWNED_2", oSensate);
		
		oWP = GetWaypointByTag("wp_festhall_sector1_npc5");
		oSensate = CreateRandomSensate(oWP, oPC);
		SetLocalString(oSensate, "ANIMATION", "sitgroundidle");
		
		oWP = GetWaypointByTag("wp_festhall_sector1_npc6");
		oSensate = CreateRandomSensate(oWP, oPC);
		SetLocalString(oSensate, "ANIMATION", "talknormal");
	}
	if (nSector == 3) {
		oWP = GetWaypointByTag("wp_festhall_sector2_npc1");
		oSensate = CreateRandomSensate(oWP, oPC);;
		SetLocalString(oSensate, "ANIMATION", "cooking02");
		SetFirstName(oSensate, "Painter");
		
		//Save that we did this
		SetLocalObject(OBJECT_SELF, "ENCOUNTER_SPAWNED_3", oSensate);
		
		oWP = GetWaypointByTag("wp_festhall_sector2_npc2");
		oSensate = CreateRandomSensate(oWP, oPC);
		SetLocalString(oSensate, "ANIMATION", "talknormal");
		
		oWP = GetWaypointByTag("wp_festhall_sector2_npc3");
		oSensate = CreateRandomSensate(oWP, oPC);
		SetLocalString(oSensate, "ANIMATION", "talklaugh");
	}
	if (nSector == 4) {
		oWP = GetWaypointByTag("wp_festhall_sector4_npc1");
		oSensate = CreateRandomSensate(oWP, oPC);;
		SetLocalString(oSensate, "ANIMATION", "talklaugh");
		
		//Save that we did this
		SetLocalObject(OBJECT_SELF, "ENCOUNTER_SPAWNED_4", oSensate);
		
		oWP = GetWaypointByTag("wp_festhall_sector4_npc2");
		oSensate = CreateRandomSensate(oWP, oPC);
		SetLocalString(oSensate, "ANIMATION", "talknormal");
		
		oWP = GetWaypointByTag("wp_festhall_sector4_npc3");
		oSensate = CreateRandomSensate(oWP, oPC);
		SetLocalString(oSensate, "ANIMATION", "playflute");
		
		effect eFlute = EffectNWN2SpecialEffectFile("fx_hss_flutea");
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFlute, oSensate);
		SetFirstName(oSensate, "Flute Player");
	}
	if (nSector == 5) {
		oWP = GetWaypointByTag("wp_festhall_sector5_npc1");
		oSensate = CreateRandomSensate(oWP, oPC);;
		SetLocalString(oSensate, "ANIMATION", "idle");
		
		//Save that we did this
		SetLocalObject(OBJECT_SELF, "ENCOUNTER_SPAWNED_5", oSensate);
		
		oWP = GetWaypointByTag("wp_festhall_sector5_npc2");
		oSensate = CreateRandomSensate(oWP, oPC);
		SetLocalString(oSensate, "ANIMATION", "talknormal");
		
		oWP = GetWaypointByTag("wp_festhall_sector5_npc3");
		oSensate = CreateRandomSensate(oWP, oPC);
		SetLocalString(oSensate, "ANIMATION", "talklaugh");
	}
	if (nSector == 6) {
		oWP = GetWaypointByTag("wp_festhall_sector6_npc1");
		oSensate = CreateRandomSensate(oWP, oPC);;
		SetLocalString(oSensate, "ANIMATION", "playguitar");
		
		effect eFlute = EffectNWN2SpecialEffectFile("fx_hss_mandolina");
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFlute, oSensate);
		SetFirstName(oSensate, "Lute Player");
		
		//Save that we did this
		SetLocalObject(OBJECT_SELF, "ENCOUNTER_SPAWNED_6", oSensate);
		
		object oLecture = GetNearestObjectByTag("festhall_lectureschedule");
		SetLectureTopic(oLecture);
		SetLocalInt(oLecture, "LECTURE_STAGE", 0);
	}

}

void SetLectureTopic(object oLecture) {

	switch (Random(2)+1) {
		case 1: SetFirstName(oLecture, "Lecture Hall\n<i>The Danger of Too Much</i>"); SetLocalInt(oLecture, "LECTURE_TOPIC", 1); break;
		case 2: SetFirstName(oLecture, "Lecture Hall\n<i>What is a Sensory Stone?</i>"); SetLocalInt(oLecture, "LECTURE_TOPIC", 2); break;
		case 3: SetFirstName(oLecture, "Lecture Hall\n<i>A Matter of Perspective</i>"); SetLocalInt(oLecture, "LECTURE_TOPIC", 3); break;
		case 4: SetFirstName(oLecture, "Lecture Hall\n<i>Instinct: A Sixth Sense?</i>"); SetLocalInt(oLecture, "LECTURE_TOPIC", 4); break;
	}

}

object CreateRandomSensate(object oWP, object oPC = OBJECT_INVALID) {

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
	ChangeToStandardFaction(oNPC, STANDARD_FACTION_COMMONER);
	
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
	
	if (GetIsObjectValid(oPC)) {
		SendMessageToPC(oPC, "Spawning at: "+GetTag(oWP));
		SendMessageToPC(oPC, "AppearanceType: "+IntToString(nRace)+"\nHead: "+IntToString(nHead)+"\nHair: "+IntToString(nHair));
	}
	
	SetFirstName(oNPC, "Sensate");
	SetLastName(oNPC, "");
	SetDescription(oNPC, "A member of the Society of Sensation, enjoying themselves in the Festhall.");
	//SetDescription(oNPC, "AppearanceType: "+IntToString(nRace)+"\nHead: "+IntToString(nHead)+"\nHair: "+IntToString(nHair));
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

	int nRand = Random(20)+1;
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
		case 11: return "Now is what matters. <i>Right</i> now, this moment, this experience. . . ";
		case 12: return "There's truth in everything. Pleasure, pain. Good and evil. Don't limit your experience. <i>Know</i>.";
		case 13: return "Keep an open mind - try something new!";
		case 14: return "Allow yourself to relax, let your inhibitions go. We can open up new worlds for you.";
		case 15: return "Relax, have a little fun. Pleasure is the balm that keeps the fevered rage at bay.";
		case 16: return "Have you ever been to Arborea? <i>Such</i> a lovely place.";
		case 17: return "And you simply must try the roasted crickets at the Fat Candle. They're so nutty and crunchy!";
		case 18: return "Stay a while, tell us your story.";
		case 19: return "Stop. Close your eyes. Take a breath. Just let yourself <i>experience</i> the moment.";
		case 20: return "Mmm. . . do you hear it? The music wafting down from the theaters. Entrancing.";
	}
	
	return "Lady's Grace, Cutter.";

}