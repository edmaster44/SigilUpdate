//:://////////////////////////////////////////////
/*
    On User Defined script that executes the portal spawning
	for a phrase-based portal
*/
//:://////////////////////////////////////////////
//:: Created By: Mimi Fearthegn
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////

void SpawnColothysExitPortal();
void SpawnColothysCarceriPortals();

void main () {

	int nUser = GetUserDefinedEventNumber();

    if(nUser == 1004) { 
        int nMatch = GetListenPatternNumber();

        switch(nMatch) {
		
			//Colothys Lady's Ward Exit
        	case 0076:
				SpawnColothysExitPortal();
                break;
			case 0077:
				SpawnColothysExitPortal();
                break;
				
			//Colothys Carceri Portals
        	case 0078:
				SpawnColothysCarceriPortals();
                break;
			case 0079:
				SpawnColothysCarceriPortals();
                break;

		}
	}
}

//Your escape portal from Carceri
void SpawnColothysExitPortal() {

	object oArea = GetArea(OBJECT_SELF);
	if (GetTag(oArea) != "ps_area_carceri_garden")
		return;

	object oWP = GetWaypointByTag("wp_plac_port_colothysout");
	string sPortal = "ps_plac_port_colothysout";
	
	object oPortal = CreateObject(OBJECT_TYPE_PLACEABLE, sPortal, GetLocation(oWP));
	//SpeakString("Creating portal! "+GetName(oPortal), TALKVOLUME_SHOUT);
	DestroyObject(oPortal, 60.0f);
	
	object oDoor = GetNearestObjectByTag("gardentemple_in");
	SetUseableFlag(oDoor, FALSE);
	DelayCommand(60.0f, SetUseableFlag(oDoor, TRUE));

}

//Portals to the other two layers of Carceri
void SpawnColothysCarceriPortals() {

	object oArea = GetArea(OBJECT_SELF);
	//SpeakString("Current area: "+GetTag(oArea), TALKVOLUME_SHOUT);
	if (GetTag(oArea) == "ps_area_carceri_garden") {

		object oWP = GetWaypointByTag("wp_plac_port_colothysout");
		string sPortal = "ps_plac_port_colothys-minethys";
		
		object oPortal = CreateObject(OBJECT_TYPE_PLACEABLE, sPortal, GetLocation(oWP));
		//SpeakString("Creating portal! "+GetName(oPortal), TALKVOLUME_SHOUT);
		DestroyObject(oPortal, 60.0f);
		
		oWP = GetWaypointByTag("wp_plac_port_colothyscarceri");
		sPortal = "ps_plac_port_colothys-porphatys";
		
		oPortal = CreateObject(OBJECT_TYPE_PLACEABLE, sPortal, GetLocation(oWP));
		//SpeakString("Creating portal! "+GetName(oPortal), TALKVOLUME_SHOUT);
		DestroyObject(oPortal, 60.0f);
	
		object oDoor = GetNearestObjectByTag("gardentemple_in");
		SetUseableFlag(oDoor, FALSE);
		DelayCommand(60.0f, SetUseableFlag(oDoor, TRUE));
		
	} else if (GetTag(oArea) == "ps_area_carceri_porphatys_beach") {

		object oWP = GetWaypointByTag("wp_portal_porphatys_colothys");
		string sPortal = "ps_plac_port_colothysin";
		
		object oPortal = CreateObject(OBJECT_TYPE_PLACEABLE, sPortal, GetLocation(oWP));
		DestroyObject(oPortal, 60.0f);
		
	} else if (GetTag(oArea) == "ps_area_carceri_minethys_desert") {

		object oWP = GetWaypointByTag("wp_portal_minethys-colothys");
		string sPortal = "ps_plac_port_colothysin";
		
		object oPortal = CreateObject(OBJECT_TYPE_PLACEABLE, sPortal, GetLocation(oWP));
		//SpeakString("Creating portal! "+GetName(oPortal), TALKVOLUME_SHOUT);
		DestroyObject(oPortal, 60.0f);
		
	}

}