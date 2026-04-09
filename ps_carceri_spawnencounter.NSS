

//Handles the spawning of the stone serpents or treasure chests in carceri
//nAction = 1 --> serpent encounter
//nAction = 2 --> treasure chest
//nAction = 3 --> mortal wizard encounter
//nAction = 4 --> iapetos quest reward
//nAction = 5 --> hyperion quest reward
#include "ps_inc_spawns"
#include "ps_inc_treasuregeneration"

void main (int nAction) {

	string sTag = GetTag(OBJECT_SELF);
	object oPC = GetPCSpeaker();
	
	if (nAction == 1) { //serpent encounter
	
		string sWP = "wp_stoneserpent_";
		if (sTag == "ps_carceri_rumoredtreasure1")
			sWP += "1";
		if (sTag == "ps_carceri_rumoredtreasure2")
			sWP += "2";
		if (sTag == "ps_carceri_rumoredtreasure3")
			sWP += "3";
			
		int iDiff = PS_GetDifficulty(oPC);
  		float avg = PS_GetAvgPartylevel(oPC,PS_GetMaxPartylevel(oPC));
		string mod = "";
		
		float low = IntToFloat(GetLocalInt(OBJECT_SELF,"LOW"));
  		float high = IntToFloat(GetLocalInt(OBJECT_SELF,"HIGH"));
		if(avg>low && avg<high && iDiff == DIFFNORM)
		   mod="2";
		else if(avg>=high || iDiff == DIFFHIGH || iDiff == DIFFVERY)
		   mod="3";
		
		int iEliteChance = 97;
		if (iDiff == DIFFHIGH)
		    iEliteChance = 95;
		else if (iDiff == DIFFVERY)
		    iEliteChance = 90;
			
		DelayCommand(1.0f, SpawnMonster(OBJECT_SELF, "ps_minethys_stoneserpent", GetWaypointByTag(sWP+"a"), avg, iEliteChance, mod));
		DelayCommand(1.1f, SpawnMonster(OBJECT_SELF, "ps_minethys_stoneserpent", GetWaypointByTag(sWP+"b"), avg, iEliteChance, mod));
		DelayCommand(1.2f, SpawnMonster(OBJECT_SELF, "ps_minethys_stoneserpent", GetWaypointByTag(sWP+"c"), avg, iEliteChance, mod));
		if (iDiff == DIFFVERY) {
			DelayCommand(1.3f, SpawnMonster(OBJECT_SELF, "ps_minethys_stoneserpent", GetWaypointByTag(sWP+"d"), avg, iEliteChance, mod));
			DelayCommand(1.4f, SpawnMonster(OBJECT_SELF, "ps_minethys_stoneserpent", GetWaypointByTag(sWP+"e"), avg, iEliteChance, mod));
		}
	} else if (nAction == 2) { //treasure chest
		
		int nCR = PickCRFromTreasureLevel(TREASURE_QUEST_LOW);
		object oChest = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_carceri_treasurecache", GetLocation(OBJECT_SELF));
		SetLocalInt(oChest, "CR", nCR);
		
	} else if (nAction == 3) { //wizard encounter
	
		effect eVis = EffectNWN2SpecialEffectFile("fx_teleport");
		SetScriptHidden(OBJECT_SELF, TRUE);
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(OBJECT_SELF));
		
		AssignCommand(OBJECT_SELF, ActionJumpToLocation(GetLocation(GetWaypointByTag("wp_minethys_mortal_teleportloc"))));
		
		DelayCommand(0.4f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(GetWaypointByTag("wp_minethys_mortal_teleportloc"))));
		DelayCommand(0.49f, ChangeToStandardFaction(OBJECT_SELF, STANDARD_FACTION_HOSTILE));
		DelayCommand(0.5f, SetScriptHidden(OBJECT_SELF, FALSE));
		DelayCommand(0.51f, AssignCommand(OBJECT_SELF, ActionCastSpellAtLocation(SPELL_HORRID_WILTING, GetLocation(oPC))));
		
		int iDiff = PS_GetDifficulty(oPC);
  		float avg = PS_GetAvgPartylevel(oPC,PS_GetMaxPartylevel(oPC));
		string mod = "";
		
		float low = IntToFloat(GetLocalInt(OBJECT_SELF,"LOW"));
  		float high = IntToFloat(GetLocalInt(OBJECT_SELF,"HIGH"));
		if(avg>low && avg<high && iDiff == DIFFNORM)
		   mod="2";
		else if(avg>=high || iDiff == DIFFHIGH || iDiff == DIFFVERY)
		   mod="3";
		
		int iEliteChance = 97;
		if (iDiff == DIFFHIGH)
		    iEliteChance = 95;
		else if (iDiff == DIFFVERY)
		    iEliteChance = 90;
	
		eVis = EffectNWN2SpecialEffectFile("sp_shades_summon"); 
		object oWP1 = GetWaypointByTag("wp_minethys_mortal");
		object oWP2 = GetWaypointByTag("wp_minethys_mortal_help2");
		DelayCommand(0.5f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oWP1)));
		DelayCommand(0.51f, SpawnMonster(OBJECT_SELF, "ps_carceri_farastu", oWP1, avg, iEliteChance, mod));
		DelayCommand(0.51f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oWP2)));
		DelayCommand(0.52f, SpawnMonster(OBJECT_SELF, "ps_carceri_farastu", oWP2, avg, iEliteChance, mod));
		
	} else if (nAction == 4) { //reward for Iapetos' quest
		object oPartyMember = GetFirstFactionMember(oPC, TRUE);
    	while(GetIsObjectValid(oPartyMember) == TRUE && GetArea(oPC) == GetArea(oPartyMember)) {	
		
			SendMessageToPC(oPartyMember, "<i>Well done, "+GetName(oPartyMember)+", your death will not come this day.</i>");
			effect eHeal = EffectHeal(GetMaxHitPoints(oPartyMember));
			eHeal = EffectLinkEffects(EffectNWN2SpecialEffectFile("sp_healingsting_heal01"), eHeal);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPartyMember);
			
			effect eRegen = EffectRegenerate(6, 6.0f);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegen, oPartyMember);
			
        	oPartyMember = GetNextFactionMember(oPC, TRUE);	    
		}
	} else if (nAction == 5) { //reward for Hyperion's quest
		object oPartyMember = GetFirstFactionMember(oPC, TRUE);
    	while(GetIsObjectValid(oPartyMember) == TRUE && GetArea(oPC) == GetArea(oPartyMember)) {	
		
			SendMessageToPC(oPartyMember, "<i>Well done, "+GetName(oPartyMember)+". You have honored my shrine, and in return I will give you the gift of the flame. Use it well.</i>");
			effect eVFX =  EffectNWN2SpecialEffectFile("sp_fire_aoe");
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oPartyMember);
			
			effect eShield = EffectDamageShield(5, DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eShield, oPartyMember);
			
			if (GetLocalInt(oPartyMember, "Hyperions_Reward") == 0) {
				GenerateQuestRewardOnTarget(oPartyMember, TREASURE_EPIC, TRUE);
				SetLocalInt(oPartyMember, "Hyperions_Reward", 1);
			}
			
        	oPartyMember = GetNextFactionMember(oPC, TRUE);	    
		}
	}

}