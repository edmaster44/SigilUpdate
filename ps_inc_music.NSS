/**************************************/
/* Scripts for adding music switching */
/**************************************/
#include "ps_inc_time"

const int MUSIC_SWAP_TIMEOUT = 10; //time in minutes

const string MUSIC_VARIABLE = "area_music_";
const string MUSIC_NUMBER_VARIABLE = "area_music_num";
const string MUSIC_TIMESTAMP = "AREA_MUSIC_TIMESTAMP";

void SwitchMusic(object oArea, object oPC = OBJECT_INVALID);

int ShouldMusicSwitch(object oArea, object oPC = OBJECT_INVALID);

int GetNewMusicTrack(object oArea, object oPC = OBJECT_INVALID);

/**************************************/

void SwitchMusic(object oArea, object oPC = OBJECT_INVALID) {

	if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, "Switching musice. . .");

	if (ShouldMusicSwitch(oArea, oPC)) {
	
		int newTrack = GetNewMusicTrack(oArea, oPC);
		
		if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, "Track chosen: "+IntToString(newTrack));
		
		if (newTrack >= 0) {
		
			MusicBackgroundChangeDay(oArea, newTrack);
			MusicBackgroundChangeNight(oArea, newTrack);
			PS_Timestamp_UNIX(oArea, MUSIC_TIMESTAMP);
			
		}
		
	}

}

int ShouldMusicSwitch(object oArea, object oPC = OBJECT_INVALID) {

	int shouldSwitch = TRUE;

	int nMin = PS_GetTimestamp_Age_Minutes(oArea, MUSIC_TIMESTAMP);
	if (nMin < MUSIC_SWAP_TIMEOUT)
		shouldSwitch = FALSE;
		
	if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, "Num of minutes: "+IntToString(nMin));
		
	if (GetLocalInt(oArea, MUSIC_NUMBER_VARIABLE) <= 0)
		shouldSwitch = FALSE;
		
	if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, "Num of tracks to choose: "+IntToString(GetLocalInt(oArea, MUSIC_NUMBER_VARIABLE)));
		
	return shouldSwitch;

}

int GetNewMusicTrack(object oArea, object oPC = OBJECT_INVALID) {

	int nMusicNum = GetLocalInt(oArea, MUSIC_NUMBER_VARIABLE);
	
	int nNewTrack = Random(nMusicNum)+1;
	
	return GetLocalInt(oArea, MUSIC_VARIABLE+IntToString(nNewTrack));

}