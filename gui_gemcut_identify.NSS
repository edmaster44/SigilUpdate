#include "ps_inc_gemstones"
#include "ps_inc_functions"

void main () {

	object oPC = OBJECT_SELF;
	InitializeGemstoneBox();
	object oGem = GetLocalObject(oPC, "selected_gem");
	
	string sEffect = "gem_identify_effect";
	location lEffect = GetLocation(GetWaypointByTag("wp_gembench_effect"));
	
	int lastDone = CheckTimeStamp(oPC, "Last_Gem_Identified");
	if (lastDone < 1) {
		SendMessageToPC(oPC, "Please wait a second before identifying another gem.");
		return;
	}
	TimeStamp(oPC, "Last_Gem_Identified");
	
	if (!GetIsObjectValid(oGem)) {
		SetGUIObjectHidden(oPC, sGemScreen, "IDENTIFY_GEM", TRUE);
		return;
	}
	
	PlayCustomAnimation(oPC, "liftswordloop", FALSE, 1.0f);
	
	if (sEffect != "")
		DelayCommand(0.75f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile(sEffect), oPC));
	
	int nSize = GetCaratWeight(oGem);
	int nQuality = GetGemQuality(oGem);
	string sType = RollGemstoneType(oGem);
	//SendMessageToPC(oPC, "Debug: creating "+sType+" from "+GetTag(oGem));
	 
	object oItem = CreateItemOnObject(sType, oPC, 1);
	string sNewTag = sType+"_rough_q"+IntToString(nQuality)+"_c"+IntToString(nSize);
	if (sType == "gemstone_amber_1" || sType == "gemstone_amber_2") {
		SetTag(oItem, "ps_summoner");
	} else {
		SetTag(oItem, sNewTag);
		string sName = GetName(oItem);
		SetFirstName(oItem, "Rough "+sName+" <Color=Gray>"+GetSizeString(nSize)+"</Color>");	
	}
	
	SetItemIcon(oItem, GetItemIcon(oGem));
	SetDescription(oItem, GetGemstoneFullDescription(oItem));
	SetLocalObject(oPC, "selected_gem", oItem);
	TakeNumCraftingMaterials(oPC, GetTag(oGem), 1);
	
	//Redo the listbox
	DelayCommand(0.5f, RegenerateGemList(oPC));
	DelayCommand(0.6f, UpdateSelectedGem(oPC));

}