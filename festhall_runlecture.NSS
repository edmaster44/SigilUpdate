//A script for playing the lectures in the Festhall
#include "ps_inc_functions"

int PlayLectureTooMuch(int nStage, object oPC = OBJECT_INVALID);
int PlayLectureSensoryStone(int nStage, object oPC = OBJECT_INVALID);
int PlayLecturePerspective(int nStage, object oPC = OBJECT_INVALID);
int PlayLectureInstinct(int nStage, object oPC = OBJECT_INVALID);
void MarkListeners(int nMax = 1, int nFinal = FALSE);
void PlayNextPart(object oLecture, object oPC = OBJECT_INVALID);

void main () {

	object oLecture = GetNearestObjectByTag("festhall_lectureschedule");
	object oPC = GetEnteringObject();
	
	if (!GetIsObjectValid(oLecture))  {
		SendMessageToPC(oPC, "Error: The sign is gone.");
		return;
	}
	
	if (GetLocalInt(oLecture, "LECTURE_TOPIC") <= 0) {
		SendMessageToPC(oPC, "No lecture chosen.");
		return;
	}

	DelayCommand(1.0f, PlayNextPart(oLecture));
}

void PlayNextPart(object oLecture, object oPC = OBJECT_INVALID) {

	if (GetIsObjectValid(oPC))
		SendMessageToPC(oPC, "Playing next part of lecture");

	int lastDone = CheckTimeStamp();
	if (lastDone < 12) //happens once per 12 seconds
		return;
	TimeStamp();

	if (GetIsObjectValid(oPC))
		SendMessageToPC(oPC, "Timestamp Passed");
		
	int nLecture = GetLocalInt(oLecture, "LECTURE_TOPIC");
	int nStage = GetLocalInt(oLecture, "LECTURE_STAGE");
	int nDone = FALSE;
	switch (nLecture) {
		case 1: nDone = PlayLectureTooMuch(nStage, oPC); break;
		case 2: nDone = PlayLectureSensoryStone(nStage, oPC); break;
	}
	
	SetLocalInt(oLecture, "LECTURE_STAGE", nStage+1);

	if (nDone) {
		DelayCommand(300.0f, SetLocalInt(oLecture, "LECTURE_STAGE", 0)); //reset lecture stage
	} else {
		DelayCommand(12.1f, PlayNextPart(oLecture, oPC));
	}
}

void MarkListeners(int nMax = 1, int nFinal = FALSE) {

	object oSpeaker = GetNearestObjectByTag("festhallnpc_lecturer");
	object oLecture = GetNearestObjectByTag("festhall_lectureschedule");
	int nLecture = GetLocalInt(oLecture, "LECTURE_TOPIC");
	
	object oListener = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f, GetLocation(oSpeaker), TRUE);
	while (GetIsObjectValid(oListener)) {
		
		if (GetIsPC(oListener)) {
		
			int nListened = GetLocalInt(oListener, "LECTURE_LISTENED");
			SendMessageToPC(oListener, "Incrementing listening to "+IntToString(nListened+1));
			SetLocalInt(oListener, "LECTURE_LISTENED", nListened+1);
			
			if (nFinal && GetLocalInt(oListener, "LECTURE_LISTENED") == nMax && 
				GetLocalInt(oListener, "FINISHED_LECTURE_"+IntToString(nLecture)) <= 0) {
				
				SendMessageToPC(oListener, "Experience given for listening to lecture:");
				PS_GiveXPReward(oListener, 100);
				SetLocalInt(oListener, "FINISHED_LECTURE_"+IntToString(nLecture), 1);
				DelayCommand(300.0f, SetLocalInt(oListener, "LECTURE_LISTENED", 0));
				
			}
		}
		
		oListener = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, GetLocation(oSpeaker), TRUE);
	}

}

int PlayLectureTooMuch(int nStage, object oPC = OBJECT_INVALID) {

	object oSpeaker = GetNearestObjectByTag("festhallnpc_lecturer");
	
	if (!GetIsObjectValid(oSpeaker))  {
		SendMessageToPC(oPC, "Error: No Lecturer.");
		return 0;
	}
	
	switch (nStage) {
		case 0: AssignCommand(oSpeaker, ActionSpeakString("Is there such a thing as too much of an experience?")); break;
		case 1: AssignCommand(oSpeaker, ActionSpeakString("Before Erin Montgomery became Factol, this was a question that many Sensates explored in great detail.")); break;
		case 2: AssignCommand(oSpeaker, ActionSpeakString("Is there more to be learned after the first taste? The first sight? What about the second? Third? . . the hundredth?")); break;
		case 3: AssignCommand(oSpeaker, ActionSpeakString("Many would argue that yes, every experience is differentiated by time and space. A drink this Clerk at the Fat Candle cannot be the same as one next Void at our own Spice Rack.")); break;
		case 4: AssignCommand(oSpeaker, ActionSpeakString("But I think we all know deep down that repetition does not make an experience sweeter or more poignant.")); break;
		case 5: AssignCommand(oSpeaker, ActionSpeakString("The finest Enigma becomes casual if drunk every day.")); break;
		case 6: AssignCommand(oSpeaker, ActionSpeakString("And the senses, at least for mortals, can be overwhelmed by too much stimulation.")); break;
		case 7: AssignCommand(oSpeaker, ActionSpeakString("For sensates, this is unacceptable. We seek to truly <i>live</i> in each moment, not drown in an endless parade of sensations.")); break;
		case 8: AssignCommand(oSpeaker, ActionSpeakString("To <i>experience</i> you must hone your senses, not dull them.")); break;
		case 9: AssignCommand(oSpeaker, ActionSpeakString("I challenge each of you to take time today to truly live in a moment, an ordinary moment.")); break;
		case 10: AssignCommand(oSpeaker, ActionSpeakString("Try closing your eyes, and really <i>listening</i> to the clamor of the city streets, or take a moment to dissect the scent of a flower.")); break;
		case 11: AssignCommand(oSpeaker, ActionSpeakString("Discover something new in an every day experience today. And then tomorrow, do it again.")); break;
		case 12: AssignCommand(oSpeaker, ActionSpeakString("If you practice every day, you will eventually train yourself to live in the moment.")); break;
		case 13: AssignCommand(oSpeaker, ActionSpeakString("This is what every member of the Society should strive for: To see, feel, hear, smell, taste, and <i>feel</i> every moment of every day.")); break;
	}
	
	int nMax = 13;
	MarkListeners(nMax, (nStage == nMax));
	return (nStage == nMax);
}

int PlayLectureSensoryStone(int nStage, object oPC = OBJECT_INVALID) {

	object oSpeaker = GetNearestObjectByTag("festhallnpc_lecturer");
	
	if (!GetIsObjectValid(oSpeaker))  {
		SendMessageToPC(oPC, "Error: No Lecturer.");
		return 0;
	}
	
	switch (nStage) {
		case 0: AssignCommand(oSpeaker, ActionSpeakString("Sensory stones. Also known as Recorders. *he picks a round glowing orb up from his desk*")); break;
		case 1: AssignCommand(oSpeaker, ActionSpeakString("These stones, often created from semi-precious gemstones, are the treasures of the Society of Sensation.")); break;
		case 2: AssignCommand(oSpeaker, ActionSpeakString("Each one holds the full force of an experience, from the perspective of the recorder.")); break;
		case 3: AssignCommand(oSpeaker, ActionSpeakString("The viewer does not merely see what the recorder saw, or hear what the recorder heard; rather, when 'viewing' a recording it is as though <i>you</i> were there.")); break;
		case 4: AssignCommand(oSpeaker, ActionSpeakString("These marvelous stones are our opportunity to truly experience, if only for a few moments, what it is to be <i>someone else</i> in another time. Another place. Another life.")); break;
		case 5: AssignCommand(oSpeaker, ActionSpeakString("These halls hold the experiences of a thousand lifetimes: kings, paupers, factions, primers, good and evil. . . ")); break;
		case 6: AssignCommand(oSpeaker, ActionSpeakString("The recorders themselves are made floors below us, and the stones never leave the Festhall. If one is stolen, its knowledge goes with it. Once a recorder leaves the Festhall it becomes worthless.")); break;
		case 7: AssignCommand(oSpeaker, ActionSpeakString("The act of recording is easy; in fact, all of you who are Sensates experienced it when you gave your entrance donations.")); break;
		case 8: AssignCommand(oSpeaker, ActionSpeakString("The stones naturally focus the mind, allowing you to record a memory. The stone is then placed into one of the Sensoriums.")); break;
		case 9: AssignCommand(oSpeaker, ActionSpeakString("The Public Sensorium - which you no doubt passed through on your way here - holds experiences fit for the public's viewing.")); break;
		case 10: AssignCommand(oSpeaker, ActionSpeakString("The Private Sensoriums - which are open only to faction members - hold experiences that are either too delicate or too dangerous for non-sensates to view.")); break;
		case 11: AssignCommand(oSpeaker, ActionSpeakString("Because. . while the Society believes in the sharing of experiences and knowledge, it is no small thing to take in the experiences of another, and live them as though they were your own.")); break;
		case 12: AssignCommand(oSpeaker, ActionSpeakString("This is especially true in the case of recordings of mind magic or the Far Realms.")); break;
		case 13: AssignCommand(oSpeaker, ActionSpeakString("Nevertheless, I urge you to explore. Do not be afraid. Go out to the Sensoriusm and find a new experience.")); break;
		case 14: AssignCommand(oSpeaker, ActionSpeakString("Or donate one of your own. There is still much in the multiverse that has yet to be recorded.")); break;		
	}
	
	int nMax = 14;
	MarkListeners(nMax, (nStage == nMax));
	return (nStage == nMax);
}

int PlayLecturePerspective(int nStage, object oPC = OBJECT_INVALID) {

	object oSpeaker = GetNearestObjectByTag("festhallnpc_lecturer");
	
	if (!GetIsObjectValid(oSpeaker))  {
		SendMessageToPC(oPC, "Error: No Lecturer.");
		return 0;
	}
	
	switch (nStage) {
		case 1: AssignCommand(oSpeaker, ActionSpeakString("")); break;
	}
	
	int nMax = 10;
	MarkListeners(nMax, (nStage == nMax));
	return (nStage == nMax);
}

int PlayLectureInstinct(int nStage, object oPC = OBJECT_INVALID) {

	object oSpeaker = GetNearestObjectByTag("festhallnpc_lecturer");
	
	if (!GetIsObjectValid(oSpeaker))  {
		SendMessageToPC(oPC, "Error: No Lecturer.");
		return 0;
	}
	
	switch (nStage) {
		case 1: AssignCommand(oSpeaker, ActionSpeakString("")); break;
	}
	
	int nMax = 10;
	MarkListeners(nMax, (nStage == nMax));
	return (nStage == nMax);
}