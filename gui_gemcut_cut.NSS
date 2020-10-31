#include "ps_inc_gemstones"
#include "nw_i0_plot"
#include "ps_inc_functions"

void PrintGemstoneQualities(object oPC, object oGem);

void main () {

	int failureRoll = 10;
	int okRoll = 15;
	int goodRoll = 20;
	int excellentRoll = 25;
	int fantasticRoll = 30;
	int epicRoll = 35;
	location lEffect = GetLocation(GetWaypointByTag("wp_gembench_effect"));
	string sEffect = "fx_hit_spark_stand";
	

	object oPC = OBJECT_SELF;
	object oGem = GetLocalObject(oPC, "selected_gem");
	
	int lastDone = CheckTimeStamp(oPC, "Last_Gem_Cut");
	if (lastDone < 1) {
		SendMessageToPC(oPC, "Please wait a moment before cutting another gem.");
		return;
	}
	TimeStamp(oPC, "Last_Gem_Cut");
	
	if (!GetIsObjectValid(oGem) || !GetIsGemstone(oGem) || !IsGemRough(oGem)) {
		SetGUIObjectHidden(oPC, sGemScreen, "CUT_GEM", TRUE);
		return;
	}

	WriteTimestampedLogEntry(GetName(oPC)+" is cutting a gem "+GetTag(oGem));
	
	PlayCustomAnimation(oPC, "forge01", FALSE, 1.0f);
	string sBaseTag = GetBaseGemTag(oGem);
	//SendMessageToPC(oPC, "base tag: "+sBaseTag+" vs. "+GetTag(oGem));
	
	int nSize = GetCaratWeight(oGem);
	if (nSize > 2) //randomly update size if its an older gemstone
		nSize = d3()-1;
	int nQuality = GetGemQuality(oGem);
	
	int nRank = GetSkillRank(GEMSTONE_SKILL_ID, oPC, FALSE);
	int nRoll = d20()+nRank; 
	
	if (nRoll < failureRoll) {
		SendMessageToPC(oPC, "Cutting failure. Gemstone reduced to rubble.");
		TakeNumCraftingMaterials(oPC, GetTag(oGem), 1);
		oGem = CreateItemOnObject("gemstone_gravel", oPC);
		sEffect = "fx_wooden_explosion";
	} else if (nRoll < okRoll) {
		if (nSize > 0) { //if the gemstone is large enough, you can afford a failure
			SendMessageToPC(oPC, "Cutting failure. Gemstone size reduced. Try again.");
			nSize -= 1;
			SetDetailsOfGemstone(oGem, nQuality, nSize, oPC);
			sEffect = "fx_hit_spark_stand";
		} else { //otherwise, gemstone is destroyed
			SendMessageToPC(oPC, "Cutting failure. Gemstone reduced to rubble.");
			TakeNumCraftingMaterials(oPC, GetTag(oGem), 1);
			oGem = CreateItemOnObject("gemstone_gravel", oPC);
			sEffect = "fx_wooden_explosion";
		}
	} else if (nRoll < goodRoll) {
		SendMessageToPC(oPC, "Cutting success. You have cut a flawed gemstone.");
		TakeNumCraftingMaterials(oPC, GetTag(oGem), 1);
		oGem = CreateItemOnObject(sBaseTag, oPC, 1);
		SetDetailsOfGemstone(oGem, 0, 1, oPC);
		sEffect = "fx_hit_spark_parry";
	} else if (nRoll < excellentRoll) {
		if (nQuality == 2) //we can't do flawless yet
			nQuality = 1;
		SendMessageToPC(oPC, "Cutting success. You have cut a "+GetQualityString(nQuality)+" gemstone.");
		TakeNumCraftingMaterials(oPC, GetTag(oGem), 1);
		oGem = CreateItemOnObject(sBaseTag, oPC, 1);
		SetDetailsOfGemstone(oGem, nQuality, 1, oPC);
		sEffect = "fx_hit_spark_parry";
	} else if (nRoll < fantasticRoll) {
		SendMessageToPC(oPC, "Cutting success. You have cut a "+GetQualityString(nQuality)+" gemstone.");
		if (nSize > 1) {
			SendMessageToPC(oPC, "You have also cut a flawed gemstone.");
			object oExtraGem = CreateItemOnObject(sBaseTag, oPC, 1);
			SetDetailsOfGemstone(oExtraGem, 0, 1, oPC);
			sEffect = "fx_hit_spark_crit";
		} else {
			sEffect = "fx_hit_spark_parry";
		}
		TakeNumCraftingMaterials(oPC, GetTag(oGem), 1);
		oGem = CreateItemOnObject(sBaseTag, oPC, 1);
		SetDetailsOfGemstone(oGem, nQuality, 1, oPC);
	} else if (nRoll < epicRoll) { //can cut up to two gems
		SendMessageToPC(oPC, "Cutting success. You have cut a "+GetQualityString(nQuality)+" gemstone.");
		if (nSize > 0) {
			int nQ = 0;
			if (nQuality == 2) 
				nQ = 1;
			SendMessageToPC(oPC, "You have also cut a "+GetQualityString(nQ)+" gemstone.");
			object oExtraGem = CreateItemOnObject(sBaseTag, oPC, 1);
			SetDetailsOfGemstone(oExtraGem, nQ, 1, oPC);
			sEffect = "fx_hit_spark_crit";
		} else {
			sEffect = "fx_hit_spark_parry";
		}
		TakeNumCraftingMaterials(oPC, GetTag(oGem), 1);
		oGem = CreateItemOnObject(sBaseTag, oPC, 1);
		SetDetailsOfGemstone(oGem, nQuality, 1, oPC);
	} else { //can cut up to three gems if you have a large flawless gem
		SendMessageToPC(oPC, "Cutting success. You have cut a "+GetQualityString(nQuality)+" gemstone.");
		if (nSize > 1) {
			int nQ = 0;
			if (nQuality == 2) 
				nQ = 1;
			SendMessageToPC(oPC, "You have also cut a "+GetQualityString(nQ)+" gemstone.");
			object oExtraGem = CreateItemOnObject(sBaseTag, oPC, 1);
			SetDetailsOfGemstone(oExtraGem, nQ, 1, oPC);
		} if (nSize > 0) {
			SendMessageToPC(oPC, "You have also cut a flawed gemstone.");
			object oExtraGem = CreateItemOnObject(sBaseTag, oPC, 1);
			SetDetailsOfGemstone(oExtraGem, 0, 1, oPC);
		}
		TakeNumCraftingMaterials(oPC, GetTag(oGem), 1);
		oGem = CreateItemOnObject(sBaseTag, oPC, 1);
		SetDetailsOfGemstone(oGem, nQuality, 1, oPC);
		sEffect = "fx_hit_spark_crit";
	}
	
	SetLocalObject(oPC, "selected_gem", oGem);
	
	if (sEffect != "")
		DelayCommand(0.5f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile(sEffect), lEffect));
	
	//Redo the listbox
	DelayCommand(0.5f, RegenerateGemList(oPC));
	DelayCommand(0.6f, UpdateSelectedGem(oPC));

}

void PrintGemstoneQualities(object oPC, object oGem) {
	
	int nSize = GetCaratWeight(oGem);
	int nQuality = GetGemQuality(oGem);
}