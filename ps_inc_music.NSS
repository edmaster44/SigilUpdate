/**************************************/
/* Scripts for adding music switching */
/**************************************/
#include "ps_inc_time"

const int MUSIC_SWAP_TIMEOUT = 10; //time in minutes

const string MUSIC_VARIABLE = "area_music_";
const string MUSIC_NUMBER_VARIABLE = "area_music_num";
const string MUSIC_TIMESTAMP = "AREA_MUSIC_TIMESTAMP";

void SwitchMusic(object oArea);

int ShouldMusicSwitch(object oArea);

int GetNewMusicTrack(object oArea);

/**************************************/

void SwitchMusic(object oArea) {

	if (ShouldMusicSwitch(oArea)) {
	
		int newTrack = GetNewMusicTrack(oArea);
		
		if (newTrack >= 0) {
		
			MusicBackgroundChangeDay(oArea, newTrack);
			MusicBackgroundChangeNight(oArea, newTrack);
			PS_Timestamp_UNIX(oArea, MUSIC_TIMESTAMP);
			
		}
		
	}

}

int ShouldMusicSwitch(object oArea) {

	int shouldSwitch = TRUE;

	if (PS_GetTimestamp_Age_Minutes(oArea, MUSIC_TIMESTAMP) < MUSIC_SWAP_TIMEOUT)
		shouldSwitch = FALSE;
		
	if (GetLocalInt(oArea, MUSIC_NUMBER_VARIABLE) <= 0)
		shouldSwitch = FALSE;
		
	return shouldSwitch;

}

int GetNewMusicTrack(object oArea) {

	int nMusicNum = GetLocalInt(oArea, MUSIC_NUMBER_VARIABLE);
	
	int nNewTrack = Random(nMusicNum)+1;
	
	return GetLocalInt(oArea, MUSIC_VARIABLE+IntToString(nNewTrack));

}
