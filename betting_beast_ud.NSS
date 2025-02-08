#include "ff_safevar"

//Roulette modified by Stephen Spann  (sspann@worldnet.att.net)
//originally from Charles Adam's 'Casino Bertix' module
//now includes the 00 slot, Five-Number bets, Corner Bets, and Split Bets.
//and uses SetListeningPattern() cues instead of a conversation.
#include "gm_include"

void MakeBet(object oPC, int nBet, string nCreature);

void main() {
    int nUser = GetUserDefinedEventNumber();
	
	if (PS_GetLocalInt(OBJECT_SELF,"FIGHTING") > 0) {
		SpeakString ("You'll have to wait to place your bet until next round.");
		return;
	}		

    if(nUser == 1004) { //OnConversation.
        int nMatch = GetListenPatternNumber();
        object oPC = GetLastSpeaker();
		int nBet = 10;

        switch(nMatch) {
			//************************************************
			//Wolf Bet
			//************************************************
        	case 0001:
				MakeBet(oPC, 10, WOLF);
                break;
			case 0002:
				nBet = 50;
				MakeBet(oPC, 50, WOLF);
                break;
			case 0003:
				MakeBet(oPC, 100, WOLF);
                break;
			case 0004:
				MakeBet(oPC, 500, WOLF);
                break;
			case 0005:
				MakeBet(oPC, 1000, WOLF);
                break;
			//************************************************
			//Bear Bet
			//************************************************
        	case 0011:
				MakeBet(oPC, 10, BEAR);
                break;
			case 0012:
				nBet = 50;
				MakeBet(oPC, 50, BEAR);
                break;
			case 0013:
				MakeBet(oPC, 100, BEAR);
                break;
			case 0014:
				MakeBet(oPC, 500, BEAR);
                break;
			case 0015:
				MakeBet(oPC, 1000, BEAR);
                break;
			//************************************************
			//Displacer Beast Bet
			//************************************************
        	case 0021:
				MakeBet(oPC, 10, DISPLACER_BEAST);
                break;
			case 0022:
				nBet = 50;
				MakeBet(oPC, 50, DISPLACER_BEAST);
                break;
			case 0023:
				MakeBet(oPC, 100, DISPLACER_BEAST);
                break;
			case 0024:
				MakeBet(oPC, 500, DISPLACER_BEAST);
                break;
			case 0025:
				MakeBet(oPC, 1000, DISPLACER_BEAST);
                break;
			//************************************************
			//Nightmare Beast Bet
			//************************************************
        	case 0031:
				MakeBet(oPC, 10, NIGHTMARE);
                break;
			case 0032:
				nBet = 50;
				MakeBet(oPC, 50, NIGHTMARE);
                break;
			case 0033:
				MakeBet(oPC, 100, NIGHTMARE);
                break;
			case 0034:
				MakeBet(oPC, 500, NIGHTMARE);
                break;
			case 0035:
				MakeBet(oPC, 1000, NIGHTMARE);
                break;
			//************************************************
			//Tiger Bet
			//************************************************
        	case 0041:
				MakeBet(oPC, 10, TIGER);
                break;
			case 0042:
				nBet = 50;
				MakeBet(oPC, 50, TIGER);
                break;
			case 0043:
				MakeBet(oPC, 100, TIGER);
                break;
			case 0044:
				MakeBet(oPC, 500, TIGER);
                break;
			case 0045:
				MakeBet(oPC, 1000, TIGER);
                break;
			//************************************************
			//Lion Bet
			//************************************************
        	case 0051:
				MakeBet(oPC, 10, LION);
                break;
			case 0052:
				nBet = 50;
				MakeBet(oPC, 50, LION);
                break;
			case 0053:
				MakeBet(oPC, 100, LION);
                break;
			case 0054:
				MakeBet(oPC, 500, LION);
                break;
			case 0055:
				MakeBet(oPC, 1000, LION);
                break;
			//************************************************
			//Spider Bet
			//************************************************
        	case 0061:
				MakeBet(oPC, 10, SPIDER);
                break;
			case 0062:
				nBet = 50;
				MakeBet(oPC, 50, SPIDER);
                break;
			case 0063:
				MakeBet(oPC, 100, SPIDER);
                break;
			case 0064:
				MakeBet(oPC, 500, SPIDER);
                break;
			case 0065:
				MakeBet(oPC, 1000, SPIDER);
                break;
			//************************************************
			//Deinonychus Bet
			//************************************************
        	case 0071:
				MakeBet(oPC, 10, DEINONYCHUS);
                break;
			case 0072:
				nBet = 50;
				MakeBet(oPC, 50, DEINONYCHUS);
                break;
			case 0073:
				MakeBet(oPC, 100, DEINONYCHUS);
                break;
			case 0074:
				MakeBet(oPC, 500, DEINONYCHUS);
                break;
			case 0075:
				MakeBet(oPC, 1000, DEINONYCHUS);
                break;
        }
    }
}

void MakeBet(object oPC, int nBet, string sCreature) {

	string sFighter1 = PS_GetLocalString(OBJECT_SELF, "MONSTER1");
	string sFighter2 = PS_GetLocalString(OBJECT_SELF, "MONSTER2");
	if (GetArea(oPC) != GetArea(OBJECT_SELF)) {
		return;
	}
	if (PS_GetLocalInt(OBJECT_SELF,"FIGHTING") > 0) {
		SpeakString ("You'll have to wait to place your bet until next round.");
		return;
	}
	if (PS_GetLocalInt(oPC, "BEAST_BET") > (MAXBET-nBet)) {
		SpeakString("I'm sorry, "+GetName(oPC)+" you cannot bet more than "+IntToString(MAXBET)+" jink.");
		return;
	}
	if (PS_GetLocalString(oPC, "BEAST_BET_ON") != "" && PS_GetLocalString(oPC, "BEAST_BET_ON") != sCreature) {
		SpeakString("I'm sorry, "+GetName(oPC)+" you've already decided to bet on the "+PS_GetLocalString(oPC, "BEAST_BET_ON")+", and cannot change your bet.");
		return;
	}
	if (sCreature != sFighter1 && sCreature != sFighter2) {
		SpeakString("I'm sorry, "+GetName(oPC)+" the "+sCreature+" is not fighting in this round.");
		return;
	}
	
    if (GetGold(oPC) >= nBet)
    {
     	TakeGoldFromCreature(nBet, oPC, TRUE);
		AddHouse(nBet);
        SpeakString (GetName(oPC)+" has placed a "+IntToString(nBet)+" jink bet on the "+sCreature+"!");
		int amountBet = PS_GetLocalInt(oPC, "BEAST_BET");
		PS_SetLocalString(oPC, "BEAST_BET_ON", sCreature);
		PS_SetLocalInt(oPC, "BEAST_BET", amountBet+nBet);
    }
    else 
	 	SpeakString (GetName(oPC)+", you don't have that much gold.");
}