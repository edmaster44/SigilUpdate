//************************************************************
// Mimi Fearthegn
// 7/22/19
//************************************************************
//Test scene script
//if this works out well, copy for future scenes
//************************************************************
#include "ps_inc_faction"
#include "ps_inc_flavortext"

int GetExecutionType();

string ChooseCommoner();

void DetailVictim();

object CreateCreatureAtWaypoint(string sBlueprint, string sWP);

object CreateCreatureInVicinity(string sBlueprint, string sWP);

void CreateCrowdMember(string sWP);

void CreateCrowd();

void CryerYell();

void CrowdMurmurs();

void DisperseCrowd();

void CleanUp();

void AwardExperienceForScene();

void CrowdAnimations();

void PlayNWN2CustomAnimation(object oCreature, string sAnim, int nLoop, float fSpeed);

void PlayCrowdCheers();

string CreateCommonerName();

string GetCrowdSpeakstring();

void main() {

	int nTimer = GetLocalInt(OBJECT_SELF, "SceneTimer");
	SetLocalInt(OBJECT_SELF, "SceneTimer", nTimer+1);
	//SpeakString("Timer: "+IntToString(nTimer), TALKVOLUME_SHOUT);
	
	int nDeathType = GetExecutionType();
	
	if (nTimer == 0) { //initialize on 0
		DetailVictim();
	}
	
	//Post initialization, create pamphleteer
	else if (nTimer == 1) { 
		//Create pamphleteer
		CreateCreatureAtWaypoint("ps_npc_mkpamphleteer", "wp_mkpamphleteer");
		
		//Create Whisper
		object oWhisper = CreateCreatureAtWaypoint("ps_npc_sigcommoner5", "wp_mk_snackvendor");
		SetLocalInt(oWhisper, "responses", 4);
		SetLocalString(oWhisper, "say1", "Meat pies! Can't view an execution without a hearty snack!");
		SetLocalString(oWhisper, "say2", "Limlim kabob? Fresh LimLim! Get them here!");
		SetLocalString(oWhisper, "say3", "Meat pies! Get your meat pies here!");
		SetLocalString(oWhisper, "say4", "Wash down that meat pie with a bit of Candle Brew. Special deal, today only!");
		
		object oWP = GetWaypointByTag("wp_mk_snackcart");
		object oCart = CreateObject(OBJECT_TYPE_PLACEABLE, "pl_mkfoodwagon", GetLocation(oWP));
	}
	
	//12 seconds in, gather the crowd
	else if (nTimer == 2) { 
		CreateCrowd();
	}
	
	else if (nTimer == 10) {
		object oCrowdSound = GetNearestObjectByTag("snd_mkcrowd");
		SoundObjectPlay(oCrowdSound);
	}
	
	//3 minutes in, bring out the prisoner
	else if (nTimer == 35) {
			
		object oPrisoner; 
		object oGuard1;
		object oGuard2;
		int nGender = GetLocalInt(OBJECT_SELF, "VictimGender");
		
		if (nDeathType == 1) {
			oGuard1 = CreateCreatureAtWaypoint("ps_npc_ladymercykiller", "wp_mkexit_3");
			oGuard2 = CreateCreatureAtWaypoint("ps_npc_ladymercykiller", "wp_mkexit_2");
			if (nGender == GENDER_MALE) {
				oPrisoner = CreateCreatureAtWaypoint("ps_npc_commoner1", "wp_mkexit_1");
			} else {
				oPrisoner = CreateCreatureAtWaypoint("ps_npc_commoner11", "wp_mkexit_1");
			}
			
			AssignCommand(oGuard1, ActionMoveToObject(GetWaypointByTag("wp_mkexecutioner_3")));
			AssignCommand(oGuard2, ActionMoveToObject(GetWaypointByTag("wp_mkexecutioner_4")));
			AssignCommand(oPrisoner, ActionMoveToObject(GetWaypointByTag("wp_mkvictim_2")));
			
			SetLocalString(oGuard1, "DestinationWaypoint", "wp_mkexecutioner_3");
			SetLocalString(oGuard2, "DestinationWaypoint", "wp_mkexecutioner_4");
			SetLocalString(oPrisoner, "DestinationWaypoint", "wp_mkvictim_2");
			
		} else {
			oGuard1 = CreateCreatureAtWaypoint("ps_npc_ladymercykiller", "wp_towerofwyrm_exit3");
			oGuard2 = CreateCreatureAtWaypoint("ps_npc_ladymercykiller", "wp_towerofwyrm_exit2");
			if (nGender == GENDER_MALE) {
				oPrisoner = CreateCreatureAtWaypoint("ps_npc_commoner1", "wp_towerofwyrm_exit1");
			} else {
				oPrisoner = CreateCreatureAtWaypoint("ps_npc_commoner11", "wp_towerofwyrm_exit1");
			}
			
			AssignCommand(oGuard1, ActionMoveToObject(GetWaypointByTag("wp_mkexecutioner_1")));
			AssignCommand(oGuard2, ActionMoveToObject(GetWaypointByTag("wp_mkexecutioner_2")));
			AssignCommand(oPrisoner, ActionMoveToObject(GetWaypointByTag("wp_mkvictim_1")));
			
			SetLocalString(oGuard1, "DestinationWaypoint", "wp_mkexecutioner_1");
			SetLocalString(oGuard2, "DestinationWaypoint", "wp_mkexecutioner_2");
			SetLocalString(oPrisoner, "DestinationWaypoint", "wp_mkvictim_1");
		}
		
		
		//Dress the prisoner
		object oScrubs = CreateItemOnObject("mkpinmategarb", oPrisoner);
		AssignCommand(oPrisoner, ActionEquipItem(oScrubs, INVENTORY_SLOT_CHEST));
		SetFirstName(oPrisoner, GetLocalString(OBJECT_SELF, "VictimName_First"));
		SetLastName(oPrisoner, GetLocalString(OBJECT_SELF, "VictimName_Last"));
		
		//Save these characters
		SetLocalObject(OBJECT_SELF, "MK_Executioner", oGuard1);
		SetLocalObject(OBJECT_SELF, "MK_Announcer", oGuard2);
		SetLocalObject(OBJECT_SELF, "MK_Prisoner", oPrisoner);
	
	}
	
	//5 minutes in, announce crimes
	else if (nTimer == 40) {
		
		object oAnnounce = GetLocalObject(OBJECT_SELF, "MK_Announcer");
		object oExecutioner = GetLocalObject(OBJECT_SELF, "MK_Executioner");
		object oPrisoner = GetLocalObject(OBJECT_SELF, "MK_Prisoner");
		
		//set up the crowd facing
		vector vTarget;
		if (nDeathType == 1)
			vTarget = GetPosition(GetWaypointByTag("wp_mkvictim_2"));
		else
			vTarget = GetPosition(GetWaypointByTag("wp_mkvictim_1"));
			
		AssignCommand(GetLocalObject(OBJECT_SELF, "wp_mkcrowd_1"), SetFacingPoint(vTarget));
		AssignCommand(GetLocalObject(OBJECT_SELF, "wp_mkcrowd_2"), SetFacingPoint(vTarget));
		AssignCommand(GetLocalObject(OBJECT_SELF, "wp_mkcrowd_3"), SetFacingPoint(vTarget));
		AssignCommand(GetLocalObject(OBJECT_SELF, "wp_mkcrowd_4"), SetFacingPoint(vTarget));
		AssignCommand(GetLocalObject(OBJECT_SELF, "wp_mkcrowd_5"), SetFacingPoint(vTarget));
		AssignCommand(GetLocalObject(OBJECT_SELF, "wp_mkcrowd_6"), SetFacingPoint(vTarget));
		AssignCommand(GetLocalObject(OBJECT_SELF, "wp_mkcrowd_7"), SetFacingPoint(vTarget));
		AssignCommand(GetLocalObject(OBJECT_SELF, "wp_mkcrowd_8"), SetFacingPoint(vTarget));
		AssignCommand(oExecutioner, SetFacingPoint(vTarget));
		
		string sAnnounce = GetName(oPrisoner)+" is hereby sentenced to ";
		if (nDeathType == 1)
			sAnnounce += "death by hanging ";
		else if (nDeathType == 2)
			sAnnounce += "death by beheading ";
		else 
			sAnnounce += "death by by the wyrm ";
		sAnnounce += "for the crimes of "+GetLocalString(OBJECT_SELF, "Victim_Crimes");
		AssignCommand(oAnnounce, ActionSpeakString(sAnnounce));
		
		if (d100() < 33) {
			DelayCommand(4.0f, AssignCommand(oPrisoner, ActionSpeakString("*slips a few coins to one of the guards*")));
			SetLocalInt(OBJECT_SELF, "GuardBribe", 1);
		}
		
		DelayCommand(8.0f, AssignCommand(oAnnounce, ActionSpeakString(GetName(oPrisoner)+", do you have any last words?")));
	
		
	}
	
	//minute 6, victim speach
	else if (nTimer == 42) {
	
		object oPrisoner = GetLocalObject(OBJECT_SELF, "MK_Prisoner");
		string sWords = GetLocalString(OBJECT_SELF, "Victim_LastWords");
		AssignCommand(oPrisoner, ActionSpeakString(sWords));
		DelayCommand(3.0f, CrowdMurmurs());
		DelayCommand(6.0f, CrowdMurmurs());
		
	}
	
	//execution
	else if (nTimer == 43) {
	
		object oAnnounce = GetLocalObject(OBJECT_SELF, "MK_Announcer");
		object oExecutioner = GetLocalObject(OBJECT_SELF, "MK_Executioner");
		object oPrisoner = GetLocalObject(OBJECT_SELF, "MK_Prisoner");
		
		if (nDeathType == 1) {
		
			DeleteLocalString(oAnnounce, "DestinationWaypoint");
			AssignCommand(oAnnounce, ActionMoveToObject(oPrisoner));
			DelayCommand(4.0f, AssignCommand(oAnnounce, ActionSpeakString("*places the noose around the prisoner's neck*")));
			DelayCommand(5.0f, SetLocalString(oAnnounce, "DestinationWaypoint", "wp_mkexecutioner_4"));
			AssignCommand(oExecutioner, SetFacing(90.0f));
			
			if (d100() < 50) {
				string sWords = GetLocalString(OBJECT_SELF, "Victim_LastWords_2");
				DelayCommand(9.0f, AssignCommand(oPrisoner, ActionSpeakString(sWords)));
			}
			
			object oLever = GetNearestObjectByTag("pl_mklever");
			DelayCommand(9.5f, AssignCommand(oLever, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));
			
			DelayCommand(10.0f, AssignCommand(oExecutioner, ActionSpeakString("*pulls the lever, and the trap door beneath the prisoner falls open*")));
			
			
			if (GetLocalInt(OBJECT_SELF, "GuardBribe") > 0)
				DelayCommand(12.0f, AssignCommand(oPrisoner, ActionSpeakString("*the rope snaps the prisoner's neck; death is likely near instantaneous*")));
			else {
				int nGender = GetLocalInt(OBJECT_SELF, "VictimGender");
				string sPronoun = "his";
				if (nGender == GENDER_FEMALE)
					sPronoun = "her";
					
				DelayCommand(12.0f, AssignCommand(oPrisoner, ActionSpeakString("*clutches at the rope as it tightens around "+sPronoun+" neck*")));
				DelayCommand(15.0f, AssignCommand(oPrisoner, ActionSpeakString("*struggles, slowly suffocating over the next few minutes*")));
				DelayCommand(12.0f, CrowdMurmurs());
				DelayCommand(14.0f, CrowdMurmurs());
				DelayCommand(16.0f, CrowdMurmurs());
			}
				
			DelayCommand(12.5f, AssignCommand(oLever, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
			DelayCommand(12.5f, PlayCrowdCheers());
			
		
		} else if (nDeathType == 2) {
		
			string sThing = "";
			switch (Random(2)) {
				case 0: sThing = "*lays head down on the block willingly*"; break;
				case 1: sThing = "*the guards force the prisoner down, neck on the block*"; break;
			}
		
			AssignCommand(oPrisoner, ActionSpeakString(sThing));
			PlayCustomAnimation(oPrisoner, "kemo_kneel_1i", 1, 1.0f);
							
			DelayCommand(3.0f, CrowdMurmurs());
			
			object oItem = CreateItemOnObject("ps_mk_executionersblade", oExecutioner);
			
			sThing = "";
			switch (Random(3)) {
				case 0: sThing = "*silently debates between two very large executioner's blades; which to use?*"; break;
				case 1: sThing = "*gives the executioner's blade a few test swings*"; break;
				case 3: sThing = "*readies the blade*"; break;
			}
		
			DelayCommand(6.0f, AssignCommand(oExecutioner, ActionSpeakString(sThing)));
			DelayCommand(6.5f, AssignCommand(oExecutioner, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND)));
			DelayCommand(7.0f, CrowdMurmurs());
			
			sThing = "";
			switch (Random(3)) {
				case 0: sThing = "*only partially severs the prisoners head on the first swing, and finishes with a second*"; break;
				case 1: sThing = "*lops off the prisoner's head in one clean strike*"; break;
				case 3: sThing = "*cleanly beheads the victim*"; break;
			}
			
			if (d100() < 50) {
				string sWords = GetLocalString(OBJECT_SELF, "Victim_LastWords_2");
				DelayCommand(9.0f, AssignCommand(oPrisoner, ActionSpeakString(sWords)));
			}
			
			DelayCommand(11.0f, CrowdMurmurs());
			DelayCommand(12.0f, PlayNWN2CustomAnimation(oExecutioner, "c2h_1attack03", FALSE, 1.0f));
			DelayCommand(12.0f, PlayCrowdCheers());
			
			if (GetLocalInt(OBJECT_SELF, "GuardBribe") > 0)
				DelayCommand(12.0f, AssignCommand(oExecutioner, ActionSpeakString("*lops off the prisoner's head in one clean strike*")));
			else {
				DelayCommand(12.0f, AssignCommand(oExecutioner, ActionSpeakString(sThing)));
			}
			
			AssignCommand(oPrisoner, ClearAllActions());
			DelayCommand(12.0f, PlayNWN2CustomAnimation(oPrisoner, "kneeldeath", 0, 1.0f));
			DestroyObject(oPrisoner, 13.0f);
			
			string sFirstName = GetLocalString(OBJECT_SELF, "VictimName_First");
			string sLastName = GetLocalString(OBJECT_SELF, "VictimName_Last");
			string sCrimes = GetLocalString(OBJECT_SELF, "Victim_Crimes");
			
			object oWP = GetWaypointByTag("wp_mkbloodstain");
			object oBlood = CreateObject(OBJECT_TYPE_PLACEABLE, "pl_mkbloodstain", GetLocation(oWP));
			SetFirstName(oBlood, sFirstName+" "+sLastName);
			SetDescription(oBlood, sFirstName+" "+sLastName+" - executed for "+sCrimes);
			
			DelayCommand(13.0f, CrowdMurmurs());
			DelayCommand(15.0f, CrowdMurmurs());
		
		} else {
			DelayCommand(1.0f, AssignCommand(oExecutioner, ActionSpeakString("AND THEN THE WRYM ATE EVERYONE")));
		}
		
	}
	
	//if this was a hanging, create a hanging corpse
	else if (nTimer == 47) {
		
		if (nDeathType == 1) {
			object oPrisoner = GetLocalObject(OBJECT_SELF, "MK_Prisoner");
			DestroyObject(oPrisoner, 1.0f);
			
			string sFirstName = GetLocalString(OBJECT_SELF, "VictimName_First");
			string sLastName = GetLocalString(OBJECT_SELF, "VictimName_Last");
			string sCrimes = GetLocalString(OBJECT_SELF, "Victim_Crimes");
		
			object oWP = GetWaypointByTag("wp_mk_gallowsbody");
			object oGallows = CreateObject(OBJECT_TYPE_PLACEABLE, "pl_mk_hangingbody", GetLocation(oWP));
			SetFirstName(oGallows, sFirstName+" "+sLastName);
			SetDescription(oGallows, sFirstName+" "+sLastName+" - executed for "+sCrimes);
		}
	
	}
	
	//5 minutes in, MK disperse everyone
	else if (nTimer == 50) {
	
		object oAnnounce = GetLocalObject(OBJECT_SELF, "MK_Announcer");
		object oExecutioner = GetLocalObject(OBJECT_SELF, "MK_Executioner");
		
		string sComment = "Alright, show's over. Off with you lot.";
		switch(Random(3)) {
			case 0: sComment = "Today we've seen justice done; punishment fitting a crime. Take this to heart."; break;
			case 1: sComment = "Witness here what happens to criminals. Some crimes can only be repaid in blood."; break;
			case 2: sComment = "Justice has been done! Learn from this."; break;
		}
		
		AssignCommand(oExecutioner, ActionSpeakString(sComment));
	
		sComment = "Alright, show's over. Off with you lot.";
		switch(Random(3)) {
			case 0: sComment = "Alright, show's over. Carrion crows, the lot of you. . . "; break;
			case 1: sComment = "Clear the square! Go home, all of you."; break;
			case 2: sComment = "For Justice!"; break;
		}
		
		DelayCommand(3.0f, AssignCommand(oAnnounce, ActionSpeakString(sComment)));
		
		DelayCommand(5.0f, DisperseCrowd());
		
		AwardExperienceForScene();
	
	}
	
	//MK Leave
	else if (nTimer == 55) {
	
		object oAnnounce = GetLocalObject(OBJECT_SELF, "MK_Announcer");
		object oExecutioner = GetLocalObject(OBJECT_SELF, "MK_Executioner");
		
		if (nDeathType == 1) {
			DelayCommand(4.0f, SetLocalString(oExecutioner, "DestinationWaypoint", "wp_mkexit_2"));
			DelayCommand(4.0f, SetLocalString(oAnnounce, "DestinationWaypoint", "wp_mkexit_3"));
			
			DestroyObject(oExecutioner, 8.0f);
			DestroyObject(oAnnounce, 8.0f);
		} else {
			DelayCommand(4.0f, SetLocalString(oExecutioner, "DestinationWaypoint", "wp_towerofwyrm_exit1"));
			DelayCommand(4.0f, SetLocalString(oAnnounce, "DestinationWaypoint", "wp_towerofwyrm_exit2"));
			
			DestroyObject(oExecutioner, 8.0f);
			DestroyObject(oAnnounce, 8.0f);
		}
	}
	
	//minute 6, end meeee
	else if (nTimer == 60) {
		CleanUp();
		DestroyObject(OBJECT_SELF, 3.0f);
		
		object oCrowdSound = GetNearestObjectByTag("snd_mkcrowd");
		SoundObjectStop(oCrowdSound);
	}
	
	//announce the event
	if (d100() <= 10) {
		CryerYell();
	}
	
	//Have the crowd emote!
	if (nTimer > 10 && nTimer < 40) {
		CrowdAnimations();
	}
	
	//Have the crowd make noise!
	if (nTimer > 15 && nTimer < 50 && d100() < 15) {
		CrowdMurmurs();
	}

}

void CryerYell() {

	object oCryer = GetNearestObjectByTag("ps_npc_mkpamphleteer");
	if (!GetIsObjectValid(oCryer))
		return;
		
	string sDeath = GetLocalString(OBJECT_SELF, "DeathName");
	string sFirstName = GetLocalString(OBJECT_SELF, "VictimName_First");
	string sLastName = GetLocalString(OBJECT_SELF, "VictimName_Last");
	string sCrimes = GetLocalString(OBJECT_SELF, "Victim_Crimes");
	int nDeathType = GetExecutionType();
		
	switch(Random(8)) {
		case 0: AssignCommand(oCryer, ActionSpeakString("Hear ye, hear ye! Gather 'round and hear the dark!")); break;
		case 1: AssignCommand(oCryer, ActionSpeakString("It's an execution today! Who wants a meat pie?")); break;
		case 2: AssignCommand(oCryer, ActionSpeakString("Welcome, one and all! Come and hear of the dastardly deeds of the dead-booked!")); break;
		case 3: AssignCommand(oCryer, ActionSpeakString("Read the tale of "+sFirstName+" "+sLastName+", who'll be "+sDeath+"!")); break;
		case 4: AssignCommand(oCryer, ActionSpeakString("Found guilty of "+sCrimes+" - "+sFirstName+" will be "+sDeath+" today!")); break;
		case 5: 
			if (nDeathType == 1) { 
				AssignCommand(oCryer, ActionSpeakString("There's a hanging today! Get the dark here!"));
			} else if (nDeathType == 2) { 
				AssignCommand(oCryer, ActionSpeakString("Hear ye, hear ye! Beheading today!"));
			} else { 
				AssignCommand(oCryer, ActionSpeakString(sFirstName+" "+sLastName+" DOOMED to die by the WYRM! Read about it here!"));
			} break; 
		case 6: AssignCommand(oCryer, ActionSpeakString("Execution today. You heard it here first!")); break;
		case 7: AssignCommand(oCryer, ActionSpeakString("Gather 'round and hear the dark 'bout "+sFirstName+" "+sLastName+" - a criminal most foul!")); break;
	}
	
}

void CrowdAnimations() {

	string sObj = "wp_mkcrowd_1";
	switch (Random(8)) {
		case 0: sObj = "wp_mkcrowd_1"; break;
		case 1: sObj = "wp_mkcrowd_2"; break;
		case 2: sObj = "wp_mkcrowd_3"; break;
		case 3: sObj = "wp_mkcrowd_4"; break;
		case 4: sObj = "wp_mkcrowd_5"; break;
		case 5: sObj = "wp_mkcrowd_6"; break;
		case 6: sObj = "wp_mkcrowd_7"; break;
		case 7: sObj = "wp_mkcrowd_8"; break;
	}
	
	object oWP = GetWaypointByTag(sObj);
	object oCreature = GetLocalObject(OBJECT_SELF, sObj);
	if (!GetIsObjectValid(oWP) || !GetIsObjectValid(oCreature)) 
		return;

	float fFacing = GetFacing(oWP);
	AssignCommand(oCreature, SetFacing(fFacing));
	
	string sAnim = "talkcheer";
	switch(Random(5)) {
		case 0: sAnim = "talkcheer"; break;
		case 1: sAnim = "talknormal"; break;
		case 2: sAnim = "idle"; break;
		case 3: sAnim = "talklaugh"; break;//drinkbeeridle
		case 4: sAnim = "drinkbeeridle"; break;
	}	
	
	DeleteLocalString(oCreature, "DestinationWaypoint");
	SetLocalString(oCreature, "ANIMATION", sAnim);
	PlayCustomAnimation(oCreature, sAnim, TRUE, 1.0f);
	
	if (sAnim == "drinkbeeridle") {
		effect eVFX = EffectNWN2SpecialEffectFile("fx_handr_stein");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oCreature, 18.0f);
		
		DelayCommand(8.0f, AssignCommand(oCreature, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK)));
	}
	
}

string GetCrowdSpeakstring() {
	string sComment = "";
	if (GetLocalInt(OBJECT_SELF, "VictimGender") == GENDER_MALE) {
		switch(Random(14)) {
			case 0: sComment = "I heard he deserves this and more."; break;
			case 1: sComment = "*excited murmurring*"; break;
			case 2: sComment = "*throws a tomato at the prisoner*"; break;
			case 3: sComment = "*throws a rock at the prisoner*"; break;
			case 4: sComment = "Yeah! Make 'im dance!"; break;
			case 5: sComment = "Off with his head!"; break;
			case 6: sComment = "They should feed this one to the wyrm."; break;
			case 7: sComment = "I heard he's also guilty of "+RandomString_GenerateCrime()+", they just didn't have the evidence."; break;
			case 8: sComment = "*munches on a meat pie*"; break;
			case 9: sComment = "*flips through a pamphlet* Oooh, I didn't know THAT."; break;
			case 10: sComment = "He deserves worse than what he's getting after what he did to my brother!"; break;
			case 11: sComment = "He deserves worse than what he's getting after what he did to my sister!"; break;
			case 12: sComment = "Justice!"; break;
			case 13: sComment = "Meh."; break;
		}
	} else {
		switch(Random(14)) {
			case 0: sComment = "I heard she deserves this and more."; break;
			case 1: sComment = "*excited murmurring*"; break;
			case 2: sComment = "*throws a tomato at the prisoner*"; break;
			case 3: sComment = "*throws a rock at the prisoner*"; break;
			case 4: sComment = "Yeah! Make 'er dance!"; break;
			case 5: sComment = "Off with her head!"; break;
			case 6: sComment = "They should feed this one to the wyrm."; break;
			case 7: sComment = "I heard she's also guilty of "+RandomString_GenerateCrime()+", they just didn't have the evidence."; break;
			case 8: sComment = "*munches on a meat pie*"; break;
			case 9: sComment = "*flips through a pamphlet* Oooh, I didn't know THAT."; break;
			case 10: sComment = "She deserves worse than what she's getting after what she did to my brother!"; break;
			case 11: sComment = "She deserves worse than what she's getting after what she did to my sister!"; break;
			case 12: sComment = "Justice!"; break;
			case 13: sComment = "Meh."; break;
		}
	}
	
	return sComment;
}

void CrowdMurmurs() {

	string sObj = "wp_mkcrowd_1";
	switch (Random(8)) {
		case 0: sObj = "wp_mkcrowd_1"; break;
		case 1: sObj = "wp_mkcrowd_2"; break;
		case 2: sObj = "wp_mkcrowd_3"; break;
		case 3: sObj = "wp_mkcrowd_4"; break;
		case 4: sObj = "wp_mkcrowd_5"; break;
		case 5: sObj = "wp_mkcrowd_6"; break;
		case 6: sObj = "wp_mkcrowd_7"; break;
		case 7: sObj = "wp_mkcrowd_8"; break;
	}
	
	object oMember = GetLocalObject(OBJECT_SELF, sObj);
	if (!GetIsObjectValid(oMember)) 
		return;
		
	string sComment = GetCrowdSpeakstring();
	AssignCommand(oMember, ActionSpeakString(sComment));

	//And have someone play a fireforget Animation
	switch (Random(8)) {
		case 0: sObj = "wp_mkcrowd_1"; break;
		case 1: sObj = "wp_mkcrowd_2"; break;
		case 2: sObj = "wp_mkcrowd_3"; break;
		case 3: sObj = "wp_mkcrowd_4"; break;
		case 4: sObj = "wp_mkcrowd_5"; break;
		case 5: sObj = "wp_mkcrowd_6"; break;
		case 6: sObj = "wp_mkcrowd_7"; break;
		case 7: sObj = "wp_mkcrowd_8"; break;
	}
	
	oMember = GetLocalObject(OBJECT_SELF, sObj);
	if (!GetIsObjectValid(oMember)) 
		return;
		
	int nAnim = ANIMATION_FIREFORGET_VICTORY1;
	switch(Random(5)) {
		case 0: nAnim = ANIMATION_FIREFORGET_VICTORY1; break;
		case 1: nAnim = ANIMATION_FIREFORGET_VICTORY3; break;
		case 2: nAnim = ANIMATION_FIREFORGET_VICTORY2; break;
		case 3: nAnim = ANIMATION_FIREFORGET_TAUNT; break;
		case 4: nAnim = ANIMATION_FIREFORGET_CHUCKLE; break;
	}
	
	DelayCommand(3.0f, AssignCommand(oMember, ActionPlayAnimation(nAnim)));

}

//chose between execution scenes
int GetExecutionType() {

	int nType = GetLocalInt(OBJECT_SELF, "ExecutionType");
	if (nType <= 0) {
		if (d100() <= 60) 
			nType = 1;
		else
			nType = 2;
		SetLocalInt(OBJECT_SELF, "ExecutionType", nType);
	}
	
	return nType;

}

void DetailVictim() {

	int nDeathType = GetExecutionType();
	int nGender = 0;
	
	if (nDeathType == 1) {
		nGender = GENDER_MALE;
	} else {
		nGender = d2();
	}

	struct character char = DetailCharacter(nGender);
	
	SetLocalInt(OBJECT_SELF, "VictimGender", char.gender);
	SetLocalString(OBJECT_SELF, "VictimName_First", char.firstname);
	SetLocalString(OBJECT_SELF, "VictimName_Last", char.lastname);
	
	SetLocalString(OBJECT_SELF, "Victim_LastWords", RandomString_LastWordsGenerator(char));
	SetLocalString(OBJECT_SELF, "Victim_LastWords_2", RandomString_LastWordsGenerator(char));
	
	string crime1 = RandomString_GenerateCrime();
	string crime2 = RandomString_GenerateCrime();
	string crime3 = RandomString_GenerateCrime();
	string sCrimes = "";
	
	int nRand = d100();
	
	if (nRand < 50) {		
		sCrimes = crime1;
	} else if (nRand < 75) {
		sCrimes = crime1+" and "+crime2;
	} else {
		sCrimes = crime1+", "+crime2+", and "+crime3;
	}
		
	SetLocalString(OBJECT_SELF, "Victim_Crimes", sCrimes);
	//SpeakString("The victims crimes are "+sCrimes, TALKVOLUME_SHOUT);
	
	string sTitle = "";
	switch(Random(5)) {
		case 0: sTitle = char.firstname+" "+char.nickname+"! Facing sentence for "+sCrimes+"!"; break;
		case 1: sTitle = "The Dastardly Deeds of "+char.firstname+" "+char.lastname; break;
		case 2: sTitle = "The Tragic Tale of "+char.firstname+" "+char.nickname; break;
		case 3: sTitle = "The Deep Dark on "+char.firstname+"!"; break;
		case 4: sTitle = char.firstname+": Facing "+char.possessivePronoun+" fate!"; break;
	}
	SetLocalString(OBJECT_SELF, "Victim_Pamphlet_Title", sTitle);
	
	string sPamphlet = "";
	
	string sDeathType = "";
	int nType = GetExecutionType();
	if (nType == 1) { //hanging
		switch(Random(4)) {
			case 0: sDeathType = "Hanging on the Leafless Tree"; break;
			case 1: sDeathType = "Facing the Rope"; break;
			case 2: sDeathType = "Dancing the Last Dance"; break;
			case 3: sDeathType = "Hanging by the Neck until Dead"; break;
		}
	} else if (nType == 2) { //beheading
		switch(Random(4)) {
			case 0: sDeathType = "Meeting the Blade of Justice"; break;
			case 1: sDeathType = "Dying by the Raven Sword"; break;
			case 2: sDeathType = "Loosing "+char.possessivePronoun+" Head"; break;
			case 3: sDeathType = "Dying by the Scythe"; break;
		}
	} else if (nType == 3) {
		sDeathType = "Dying by the Wyrm";
	}
	SetLocalString(OBJECT_SELF, "DeathName", sDeathType);
	
	//intro + crime
	switch(Random(3)) {
		case 0: sPamphlet += char.firstname+" will be "+sDeathType+" this day. But what of "+char.possessivePronoun+" past? How did "+char.pronoun+" come to this fate?"; break;
		case 1: sPamphlet += char.firstname+" "+char.nickname+" will today be "+sDeathType+" for the crimes of "+sCrimes+"."; break;
		case 2: sPamphlet += sDeathType+" - a punishment fit for "+char.firstname+", who is guilty of the crimes of "+sCrimes+"."; break;
	}
	
	//further character intro
	if (nType >= 2) {
		switch(Random(3)) {
			case 0: sPamphlet += "\n\n"+char.title+" "+char.firstname+" "+char.nickname+", who is "+char.backstory+", is entirely deserving of "+char.possessivePronoun+" fate."; break;
			case 1: sPamphlet += "\n\n"+char.firstname+" "+char.lastname+" is "+char.backstory+"."; break;
			case 2: sPamphlet += "\n\n"+char.firstname+" "+char.nickname+", hails from "+RandomString_GeneratePrimeLocation()+", and came to Sigil "+IntToString(Random(10)+1)+" years ago."; break;
		}
	} else {
		switch(Random(3)) {
			case 0: sPamphlet += "\n\n"+char.firstname+" "+char.nickname+", who is "+char.backstory+", is entirely deserving of "+char.possessivePronoun+" fate."; break;
			case 1: sPamphlet += "\n\n"+char.firstname+" "+char.lastname+" is "+char.backstory+"."; break;
			case 2: sPamphlet += "\n\n"+char.firstname+" "+char.nickname+", hails from "+RandomString_GeneratePrimeLocation()+", and came to Sigil "+IntToString(Random(10)+1)+" years ago."; break;
		}
	}
	
	//how the crime was discovered
	switch(Random(5)) {
		case 0: sPamphlet += " "+CapitalizeFirstLetter(char.possessivePronoun)+" crime was discovered through "+RandomString_HurdleGenerator()+"."; break;
		case 1: sPamphlet += " "+CapitalizeFirstLetter(char.pronoun)+" long avoided the law, but was finally caught because of "+RandomString_HurdleGenerator()+"."; break;
		case 2: sPamphlet += " "+CapitalizeFirstLetter(char.pronoun)+" is a member of the "+char.lastname+" family, who are very ashamed of what "+char.pronoun+" has become."; break;
		case 3: sPamphlet += " "+CapitalizeFirstLetter(char.pronoun)+" continues to proclaim "+char.possessivePronoun+" innocence, despite the evidence arraigned against "+char.possessivePronoun+" person."; break;
		case 4: sPamphlet += " "+CapitalizeFirstLetter(char.pronoun)+" was born in "+RandomString_GeneratePrimeLocation()+", and lived a life of continued variety, moving from "+char.possessivePronoun+" home to "+RandomString_GeneratePlanarLocation()+" and then to "+RandomString_GeneratePlanarLocation()+". "+CapitalizeFirstLetter(char.possessivePronoun)+" ill deeds caught up to him in this city."; break;
		case 5: sPamphlet += " "+CapitalizeFirstLetter(char.pronoun)+" has lived "+IntToString(Random(3)+1)+" score years, besides "+char.possessivePronoun+" childhood. "+CapitalizeFirstLetter(char.pronoun)+" was "+IntToString(Random(12)+1)+" years a 'prentice, "+IntToString(Random(5)+1)+" times a spouse, and widely called a thief."; break;
	}
	
	//The evidence against them
	switch(Random(3)) {
		case 0: sPamphlet += " The case was long and trying, and some cutters believe "+char.firstname+" "+char.lastname+" was only finally sentenced because "+char.possessivePronoun+" family ran out of money."; break;
		case 1: sPamphlet += " The villain "+char.firstname+" led the Harmonium on a long chase before they finally apprehended "+char.firstname+" in the Hive. After that, "+char.possessivePronoun+" fate was sealed; the trial was a formality."; break;
		case 2: sPamphlet += " Many still believe that "+char.firstname+" is innocent, because of the questionable evidence arraigned again them. We may never know the truth."; break;
	}
	
	//final words
	switch(Random(6)) {
		case 0: sPamphlet += "\n\n"+char.firstname+" will be survived by "+char.possessivePronoun+" brother "+RandomString_GenerateFirstName(GENDER_MALE)+" and aunt "+RandomString_GenerateFirstName(GENDER_FEMALE)+" "+char.lastname+"."; break;
		case 1: sPamphlet += "\n\nMembers of "+char.firstname+"'s family insist that the "+sCrimes+" were all a misunderstanding, and appealed the verdict "+IntToString(Random(3)+1)+" times, before the courts finally put a stop to the proceedings."; break;
		case 2: sPamphlet += "\n\n"+char.firstname+" is infamously unrepentant, which is why "+char.pronoun+" will today face the ultimate penalty!"; break;
		case 3: sPamphlet += "\n\n"+char.firstname+"'s case was decided by Black Ogustus, also known as 'The Snail', after "+IntToString(Random(10)+2)+" years of legal proceedings."; break;
		case 4: sPamphlet += "\n\nAt "+char.possessivePronoun+" trial, "+char.firstname+" famously said - '"+RandomString_LastWordsGenerator(char)+".' The Judge on "+char.possessivePronoun+" case was unmoved."; break;
		case 5: sPamphlet += "\n\nAt "+char.possessivePronoun+" trial, "+char.firstname+" famously said - '"+RandomString_LastWordsGenerator(char)+".' The entire courtroom was deeply moved."; break;
	}
	
	sPamphlet += "\n\nThis Dark is sponsored by "+RandomString_RandomBusinessGenerator()+".";
	
	SetLocalString(OBJECT_SELF, "Victim_Pamphlet", sPamphlet);
	
}

//Chooses a random commoner appearance
string ChooseCommoner() {

	int nRandom = Random(14);
	
	switch(nRandom) {
		case 0: return "ps_npc_commonerx";
		case 1: return "ps_npc_commoner1";
		case 2: return "ps_npc_commoner2";
		case 3: return "ps_npc_commoner3";
		case 4: return "ps_npc_commoner4";
		case 5: return "ps_npc_commoner5";
		case 6: return "ps_npc_commoner7";
		case 7: return "ps_npc_commoner8";
		case 8: return "ps_npc_commoner10";
		case 9: return "ps_npc_commoner11";
		case 10: return "ps_npc_commoner12";
		case 11: return "ps_npc_commoner13";
		case 12: return "ps_npc_commoner15";
		case 13: return "ps_npc_commoner16";
		default: return "ps_npc_commonerx";
	}
	
	return "ps_npc_commonerx";

}

//Creates a commoner npc somewhere near the waypoint given
//and then makes them move to that wp
void CreateCrowdMember(string sWP) {

	object oWP = GetWaypointByTag(sWP);
	if (!GetIsObjectValid(oWP))
		return;
		
	string sBlue = ChooseCommoner();
	object oCreature = CreateCreatureInVicinity(sBlue, sWP);
	SetFirstName(oCreature, CreateCommonerName());
	SetEventHandler(oCreature, CREATURE_SCRIPT_ON_DIALOGUE, "ps_convo_multiuse");
	SetLocalInt(oCreature, "responses", 3);
	SetLocalString(oCreature, "say1", GetCrowdSpeakstring());
	SetLocalString(oCreature, "say2", GetCrowdSpeakstring());
	SetLocalString(oCreature, "say3", GetCrowdSpeakstring());
	
	AssignCommand(oCreature, ActionMoveToLocation(GetLocation(oWP)));
	
	SetLocalObject(OBJECT_SELF, sWP, oCreature);
}

void CreateCrowd() {

	float fDelay = IntToFloat(Random(10)+1);
	
	DelayCommand(fDelay, CreateCrowdMember("wp_mkcrowd_1"));
	fDelay += IntToFloat(Random(10)+1);
	DelayCommand(fDelay, CreateCrowdMember("wp_mkcrowd_2"));
	fDelay += IntToFloat(Random(10)+1);
	DelayCommand(fDelay, CreateCrowdMember("wp_mkcrowd_3"));
	fDelay += IntToFloat(Random(10)+1);
	DelayCommand(fDelay, CreateCrowdMember("wp_mkcrowd_4"));
	fDelay += IntToFloat(Random(10)+1);
	DelayCommand(fDelay, CreateCrowdMember("wp_mkcrowd_5"));
	fDelay += IntToFloat(Random(10)+1);
	DelayCommand(fDelay, CreateCrowdMember("wp_mkcrowd_6"));
	fDelay += IntToFloat(Random(10)+1);
	DelayCommand(fDelay, CreateCrowdMember("wp_mkcrowd_7"));
	fDelay += IntToFloat(Random(10)+1);
	DelayCommand(fDelay, CreateCrowdMember("wp_mkcrowd_8"));

}

void DisperseCrowd() {

	object oCom1 = GetLocalObject(OBJECT_SELF, "wp_mkcrowd_1");
	object oCom2 = GetLocalObject(OBJECT_SELF, "wp_mkcrowd_2");
	object oCom3 = GetLocalObject(OBJECT_SELF, "wp_mkcrowd_3");
	object oCom4 = GetLocalObject(OBJECT_SELF, "wp_mkcrowd_4");
	object oCom5 = GetLocalObject(OBJECT_SELF, "wp_mkcrowd_5");
	object oCom6 = GetLocalObject(OBJECT_SELF, "wp_mkcrowd_6");
	object oCom7 = GetLocalObject(OBJECT_SELF, "wp_mkcrowd_7");
	object oCom8 = GetLocalObject(OBJECT_SELF, "wp_mkcrowd_8");
	
	string sEntrance = "";
	switch(Random(3)) {
		case 0: sEntrance = "wp_mkcrowd_entrance_1"; break;
		case 1: sEntrance = "wp_mkcrowd_entrance_2"; break;
		case 2: sEntrance = "wp_mkcrowd_entrance_3"; break;
		default: sEntrance = "wp_mkcrowd_entrance_1"; break;
	}
	
	DeleteLocalString(oCom1, "ANIMATION");
	DeleteLocalString(oCom2, "ANIMATION");
	DeleteLocalString(oCom3, "ANIMATION");
	DeleteLocalString(oCom4, "ANIMATION");
	DeleteLocalString(oCom5, "ANIMATION");
	DeleteLocalString(oCom6, "ANIMATION");
	DeleteLocalString(oCom7, "ANIMATION");
	DeleteLocalString(oCom8, "ANIMATION");
	
	object oWP = GetWaypointByTag(sEntrance);
	
	DelayCommand(2.0f, SetLocalString(oCom1, "DestinationWaypoint", sEntrance));
	DelayCommand(2.0f, AssignCommand(oCom1, ActionMoveToObject(oWP)));
	
	DelayCommand(5.0f, SetLocalString(oCom3, "DestinationWaypoint", sEntrance));
	DelayCommand(5.0f, AssignCommand(oCom3, ActionMoveToObject(oWP)));
	
	DelayCommand(6.0f, SetLocalString(oCom5, "DestinationWaypoint", sEntrance));
	DelayCommand(6.0f, AssignCommand(oCom5, ActionMoveToObject(oWP)));
	
	switch(Random(3)) {
		case 0: sEntrance = "wp_mkcrowd_entrance_1"; break;
		case 1: sEntrance = "wp_mkcrowd_entrance_2"; break;
		case 2: sEntrance = "wp_mkcrowd_entrance_3"; break;
		default: sEntrance = "wp_mkcrowd_entrance_1"; break;
	}
	
	oWP = GetWaypointByTag(sEntrance);
	
	DelayCommand(8.0f, SetLocalString(oCom2, "DestinationWaypoint", sEntrance));
	DelayCommand(8.0f, AssignCommand(oCom2, ActionMoveToObject(oWP)));
	
	DelayCommand(10.0f, SetLocalString(oCom4, "DestinationWaypoint", sEntrance));
	DelayCommand(10.0f, AssignCommand(oCom4, ActionMoveToObject(oWP)));
	
	DelayCommand(10.0f, SetLocalString(oCom6, "DestinationWaypoint", sEntrance));
	DelayCommand(10.0f, AssignCommand(oCom6, ActionMoveToObject(oWP)));
	
	DelayCommand(10.0f, SetLocalString(oCom7, "DestinationWaypoint", sEntrance));
	DelayCommand(10.0f, AssignCommand(oCom7, ActionMoveToObject(oWP)));
	
	DelayCommand(10.0f, SetLocalString(oCom8, "DestinationWaypoint", sEntrance));
	DelayCommand(10.0f, AssignCommand(oCom8, ActionMoveToObject(oWP)));
	

	DestroyObject(oCom1, 10.0f);
	DestroyObject(oCom2, 12.0f);
	DestroyObject(oCom3, 14.0f);
	DestroyObject(oCom4, 16.0f);
	DestroyObject(oCom5, 18.0f);
	DestroyObject(oCom6, 20.0f);
	DestroyObject(oCom7, 22.0f);
	DestroyObject(oCom8, 24.0f);
}

void CleanUp() {
	
	object oCryer = GetNearestObjectByTag("ps_npc_mkpamphleteer");
	if (GetIsObjectValid(oCryer)) {
		DestroyObject(oCryer);
	}
	
	//Whisper
	object oWhisper = GetNearestObjectByTag("ps_npc_sigcommoner5");
	if (GetIsObjectValid(oWhisper) && GetArea(oWhisper) == GetArea(OBJECT_SELF)) {
		DestroyObject(oWhisper);
	}
	
	object oCart = GetNearestObjectByTag("pl_mkfoodwagon");
	if (GetIsObjectValid(oCart)) {
		DestroyObject(oCart);
	}
	
	object oGallows = GetNearestObjectByTag("pl_mk_hangingbody");
	if (GetIsObjectValid(oGallows)) {
		DestroyObject(oGallows, 360.0f);
	}
	
	object oBlood = GetNearestObjectByTag("pl_mkbloodstain");
	if (GetIsObjectValid(oBlood)) {
		DestroyObject(oBlood, 360.0f);
	}

}

//Creates an associated create, and then saves it on this object
//for cleanup later; returns object invalid if WP isn't valid
object CreateCreatureAtWaypoint(string sBlueprint, string sWP) {

	int nNumber = GetLocalInt(OBJECT_SELF, "NumberOfNPCs");

	object oWP = GetWaypointByTag(sWP);
	if (!GetIsObjectValid(oWP))
		return OBJECT_INVALID;

	object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sBlueprint, GetLocation(oWP));
	
	//save this creature for later cleanup
	SetLocalObject(OBJECT_SELF, "Creature_"+IntToString(nNumber), oCreature);
	SetLocalInt(OBJECT_SELF, "NumberOfNPCs", nNumber+1);
	
	return oCreature;
}

//Creates an associated create, and then saves it on this object
//for cleanup later; returns object invalid if WP isn't valid
object CreateCreatureInVicinity(string sBlueprint, string sWP) {

	int nNumber = GetLocalInt(OBJECT_SELF, "NumberOfNPCs");
	
	//SpeakString("creating creature "+sBlueprint+" at "+sWP, TALKVOLUME_SHOUT);

	object oWP = GetWaypointByTag(sWP);
	if (!GetIsObjectValid(oWP))
		return OBJECT_INVALID;
		
	string sEntrance = "";
	switch(Random(3)) {
		case 0: sEntrance = "wp_mkcrowd_entrance_1"; break;
		case 1: sEntrance = "wp_mkcrowd_entrance_2"; break;
		case 2: sEntrance = "wp_mkcrowd_entrance_3"; break;
		default: sEntrance = "wp_mkcrowd_entrance_1"; break;
	}

	object oEntrance = GetWaypointByTag(sEntrance);
	if (!GetIsObjectValid(oEntrance))
		return OBJECT_INVALID;

	object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sBlueprint, GetLocation(oEntrance));
	
	//SpeakString("Creature created: "+GetName(oCreature), TALKVOLUME_SHOUT);
	
	//save this creature for later cleanup
	SetLocalObject(OBJECT_SELF, "Creature_"+IntToString(nNumber), oCreature);
	SetLocalInt(OBJECT_SELF, "NumberOfNPCs", nNumber+1);
	
	AssignCommand(oCreature, ActionMoveToLocation(GetLocation(oWP)));
	SetLocalString(oCreature, "DestinationWaypoint", sWP);
	
	return oCreature;
}

void AwardExperienceForScene() {

	int nExp = 100;

	object oPC = GetFirstPC();
	while (GetIsObjectValid(oPC)) {
	
		if (GetArea(oPC) == GetArea(OBJECT_SELF)) {
			SendMessageToPC(oPC, "<i>Experience awarded for viewing the execution.</i>");
			GiveXPToCreature(oPC, nExp);
		}
		oPC = GetNextPC();
	
	}

}

void PlayNWN2CustomAnimation(object oCreature, string sAnim, int nLoop, float fSpeed) {
	PlayCustomAnimation(oCreature, sAnim, nLoop, fSpeed);
}

void PlayCrowdCheers() {

	object oCom1 = GetLocalObject(OBJECT_SELF, "wp_mkcrowd_1");
	object oCom2 = GetLocalObject(OBJECT_SELF, "wp_mkcrowd_2");
	object oCom3 = GetLocalObject(OBJECT_SELF, "wp_mkcrowd_3");
	object oCom4 = GetLocalObject(OBJECT_SELF, "wp_mkcrowd_4");
	object oCom5 = GetLocalObject(OBJECT_SELF, "wp_mkcrowd_5");
	object oCom6 = GetLocalObject(OBJECT_SELF, "wp_mkcrowd_6");
	object oCom7 = GetLocalObject(OBJECT_SELF, "wp_mkcrowd_7");
	object oCom8 = GetLocalObject(OBJECT_SELF, "wp_mkcrowd_8");
	
	int nAnim = ANIMATION_FIREFORGET_VICTORY1;
	switch(Random(3)) {
		case 0: nAnim = ANIMATION_FIREFORGET_VICTORY1; break;
		case 1: nAnim = ANIMATION_FIREFORGET_VICTORY2; break;
		case 2: nAnim = ANIMATION_FIREFORGET_VICTORY3; break;
	}
	
	AssignCommand(oCom1, ActionPlayAnimation(nAnim));
	DelayCommand(3.0f, AssignCommand(oCom3, ActionPlayAnimation(nAnim)));
	DelayCommand(6.0f, AssignCommand(oCom5, ActionPlayAnimation(nAnim)));
	
	switch(Random(3)) {
		case 0: nAnim = ANIMATION_FIREFORGET_VICTORY1; break;
		case 1: nAnim = ANIMATION_FIREFORGET_VICTORY2; break;
		case 2: nAnim = ANIMATION_FIREFORGET_VICTORY3; break;
	}
	
	DelayCommand(1.0f, AssignCommand(oCom2, ActionPlayAnimation(nAnim)));
	DelayCommand(3.0f, AssignCommand(oCom4, ActionPlayAnimation(nAnim)));
	DelayCommand(5.0f, AssignCommand(oCom6, ActionPlayAnimation(nAnim)));
	
	switch(Random(3)) {
		case 0: nAnim = ANIMATION_FIREFORGET_VICTORY1; break;
		case 1: nAnim = ANIMATION_FIREFORGET_VICTORY2; break;
		case 2: nAnim = ANIMATION_FIREFORGET_VICTORY3; break;
	}
	
	AssignCommand(oCom7, ActionPlayAnimation(nAnim));
	DelayCommand(4.0f, AssignCommand(oCom8, ActionPlayAnimation(nAnim)));

}

string CreateCommonerName() {

	switch(Random(14)) {
		case 0: return "Some Berk";
		case 1: return "Experienced Cutter";
		case 2: return "Blood of Note";
		case 3: return "Professional Grandstander";
		case 4: return "Enthusiastic Onlooker";
		case 5: return "A Body";
		case 6: return "Bored Fellow";
		case 7: return "Wagger";
		case 8: return "Distinguished Personage";
		case 9: return "Some Fellow";
		case 10: return "Berk";
		case 11: return "Cutter";
		case 12: return "Blood"; 
		case 13: return "Cully";
	}
	return "Some Berk";

}