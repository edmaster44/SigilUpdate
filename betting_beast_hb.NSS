#include "ff_safevar"

//::///////////////////////////////////////////////
//:: Default: On Spawn In
//:: NW_C2_DEFAULT9
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Heartbeat script that gets listening patterns
	for the "bear baiting"
*/
//:://////////////////////////////////////////////
//:: Created By: Mimi Fearthegn
//:: Created On: July 18, 2015
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"
#include "gm_include"

string PickFighter(int pos);
void DecideWinner(string sMon1, string sMon2);
void EndFight(string sWinner, float odds);

void main()
{
	int TIMER=1;
	string WINNER = PS_GetLocalString(OBJECT_SELF, "Winner");
	int FIGHTING = PS_GetLocalInt(OBJECT_SELF, "FIGHTING");
	
	string sFighter1 = PS_GetLocalString(OBJECT_SELF, "MONSTER1");
	string sFighter2 = PS_GetLocalString(OBJECT_SELF, "MONSTER2");
	
    if(GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT)) {
	
        SignalEvent(OBJECT_SELF, EventUserDefined(1001));
		
    }
	
	if (FIGHTING)
		return;
	else if (WINNER != "") {
		
		EndFight(WINNER, BEAST_ODDS);

		PS_DeleteLocalString(OBJECT_SELF, "Winner");
		PS_DeleteLocalString(OBJECT_SELF, "MONSTER1");
		PS_DeleteLocalString(OBJECT_SELF, "MONSTER2");
		PS_DeleteLocalString(OBJECT_SELF, "POTENTIAL_WINNER");
		
		SpeakString("The "+WINNER+" has won! Gather around to receive your rewards!");

		return;
	} else if (sFighter1 == "" || sFighter2 == "") {

		sFighter1 = PickFighter(1);
		sFighter2 = PickFighter(2);
		PS_SetLocalString(OBJECT_SELF, "MONSTER1", sFighter1);
		PS_SetLocalString(OBJECT_SELF, "MONSTER2", sFighter2);
		DecideWinner(sFighter1, sFighter2);
	}
	
	if(TIMER)
    {
        if(PS_GetLocalInt(OBJECT_SELF,"BAITING") < (TIMER * 20))
        {
        	PS_SetLocalInt(OBJECT_SELF,"BAITING",
            PS_GetLocalInt(OBJECT_SELF,"BAITING")+1);
            return;
        }
        PS_DeleteLocalInt(OBJECT_SELF,"BAITING");
		
        SpeakString ("And here we go! The fight begins!");
		PS_SetLocalInt(OBJECT_SELF, "FIGHTING", 1);
        ExecuteScript("betting_beast_fight", OBJECT_SELF);
    }
}

string PickFighter(int pos) {
	int rand = Random(4);
	if (pos == 1) {
		if (rand == 0)
			return BEAR;
		else if (rand == 1)
			return DISPLACER_BEAST;
		else if (rand == 2)
			return LION;
		else
			return SPIDER;
	}
	else if (pos == 2) {
		if (rand == 0)
			return WOLF;
		else if (rand == 1)
			return NIGHTMARE;
		else if (rand == 2)
			return TIGER;
		else
			return DEINONYCHUS;
	}
	return "";
}

void DecideWinner(string sMon1, string sMon2) {
	
	int rand = Random(2);
	if (rand == 1)
		PS_SetLocalString(OBJECT_SELF, "POTENTIAL_WINNER", sMon1);
	else
		PS_SetLocalString(OBJECT_SELF, "POTENTIAL_WINNER", sMon2);

}

void EndFight(string sWinner, float odds) {
	object oPC = GetFirstPC();
	while(GetIsObjectValid(oPC)) {
	
		if (GetArea(oPC) == GetArea(OBJECT_SELF))
		{
		
			string betOn = PS_GetLocalString(oPC, "BEAST_BET_ON");

			int nBet = FloatToInt(IntToFloat(PS_GetLocalInt(oPC, "BEAST_BET"))*odds);
			if (betOn == sWinner) {
				SpeakString("Congratulations, "+GetName(oPC)+", you've won "+IntToString(nBet)+"!");
				PS_SetLocalInt(oPC, "GAMBLE_WON", PS_GetLocalInt(oPC, "GAMBLE_WON")+nBet);
				GiveGoldToCreature(oPC, nBet);
			}
			
			PS_DeleteLocalString(oPC, "BEAST_BET_ON");
			PS_DeleteLocalInt(oPC, "BEAST_BET");
		}

		oPC = GetNextPC();
		
	}
}