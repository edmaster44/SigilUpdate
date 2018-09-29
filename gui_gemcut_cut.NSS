#include "ps_inc_gemstones"
#include "nw_i0_plot"

void main () {

	int failureRoll = 10;
	int okRoll = 15;
	int goodRoll = 20;
	int excellentRoll = 25;
	int epicRoll = 30;
	location lEffect = GetLocation(GetWaypointByTag("wp_gembench_effect"));
	string sEffect = "fx_hit_spark_stand";
	

	object oPC = OBJECT_SELF;
	object oGem = GetLocalObject(oPC, "selected_gem");
	if (!GetIsObjectValid(oGem) || !GetIsGemstone(oGem)) {
		SetGUIObjectHidden(oPC, sGemScreen, "CUT_GEM", TRUE);
		return;
	}
	
	PlayCustomAnimation(oPC, "forge01", FALSE, 1.0f);
	string sBaseTag = GetBaseGemTag(oGem);
	
	//SendMessageToPC(oPC, "cut the gem: "+GetName(oGem));
	int nSize = GetCaratWeight(oGem);
	int nQuality = GetGemQuality(oGem);
	
	int nRank = GetSkillRank(GEMSTONE_SKILL_ID, oPC, FALSE);
	int nRoll = d20()+nRank; 
	
	if (nRoll < failureRoll) {
		SendMessageToPC(oPC, "Cutting failure. Gemstone reduced to rubble.");
		TakeNumCraftingMaterials(oPC, GetTag(oGem), 1);
		oGem = CreateItemOnObject("gemstone_gravel", oPC);
		sEffect = "fx_wooden_explosion";
	} else if (nRoll < okRoll) {
		SendMessageToPC(oPC, "Cutting failure. Gemstone size reduced. Try again.");
		nSize -= d20();
		if (nSize < 1) 
			nSize = 1;
		SetDetailsOfGemstone(oGem, nQuality, nSize, oPC);
		sEffect = "fx_hit_spark_stand";
	} else  {
		SendMessageToPC(oPC, "Cutting success.");
		int nQ = nQuality;
		int nS = nSize;
		object oNewGem;
		if (!IsGemRough(oGem)) {
			if (nSize <= 1 || nQuality == 2) {
				SendMessageToPC(oPC, "You cannot cut this gem any further");
				sEffect = "";
			} else {
				nS = nSize-d20();
				if (nS <= 0)
					nS = d3();
					
				if (nRoll >= epicRoll) {
					nQ++;
					sEffect = "fx_hit_spark_parry";
				} else if (nQ == 0 &&nRoll >= excellentRoll) {
					nQ++;
					sEffect = "fx_hit_spark_crit";
				} else {
					SendMessageToPC(oPC, "You were not able to further improve the gem.");
				}
			}
			SetDetailsOfGemstone(oGem, nQ, nS, oPC);
		} else {
			if (nSize > 75) {
				if (nRoll >= epicRoll) {
					oNewGem = CreateItemOnObject(sBaseTag, oPC, 1);
					nQ = d3()-1;
					nS = 25-d20();
					SetDetailsOfGemstone(oNewGem, nQ, nS, oPC);
					sEffect = "fx_hit_spark_parry";
				}  
			} if (nSize > 50) {
				if (nRoll >= excellentRoll) {
					sEffect = "fx_hit_spark_crit";
					object oNewGem; 
					nQ = d3()-2;
					nS = 23-d20();
					if (nQ < 0) {
						CreateItemOnObject("gemstone_gravel", oPC);
					} else {
						oNewGem	= CreateItemOnObject(sBaseTag, oPC, 1);
						SetDetailsOfGemstone(oNewGem, nQ, nS, oPC);
					}
				}
			}
			
			nQ = 0;
			nS = nSize-d20();
			if (nS <= 0)
				nS = d6();
				
			TakeNumCraftingMaterials(oPC, GetTag(oGem), 1);
			oGem = CreateItemOnObject(sBaseTag, oPC, 1);
			SetDetailsOfGemstone(oGem, nQ, nS, oPC);
		}
		
	}
	
	SetLocalObject(oPC, "selected_gem", oGem);
	
	if (sEffect != "")
		DelayCommand(0.5f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile(sEffect), lEffect));
	
	//Redo the listbox
	DelayCommand(0.5f, RegenerateGemList(oPC));
	DelayCommand(0.6f, UpdateSelectedGem(oPC));

}