

void main () {

	object oHolder = GetNearestObjectByTag("ps_scene_mkexecution");
	if (!GetIsObjectValid(oHolder))
		return;
		
	string sTitle = GetLocalString(oHolder, "Victim_Pamphlet_Title");
	string sContent = GetLocalString(oHolder, "Victim_Pamphlet");
	
	object oItem = CreateItemOnObject("ps_ladys_mkpamphlet", GetPCSpeaker());
	SetFirstName(oItem, "<i>"+sTitle+"</i>");
	SetDescription(oItem, sContent);
}