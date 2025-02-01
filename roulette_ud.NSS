#include "ff_safevar"

//Roulette modified by Stephen Spann  (sspann@worldnet.att.net)
//originally from Charles Adam's 'Casino Bertix' module
//now includes the 00 slot, Five-Number bets, Corner Bets, and Split Bets.
//and uses SetListeningPattern() cues instead of a conversation.
#include "gm_include"

//if you've already placed any sort of bet,
//this will return the thing you have bet on
string HasAlreadyPlacedBet(object oPC);

void main() {
    int nUser = GetUserDefinedEventNumber();
	
	if (PS_GetLocalInt(OBJECT_SELF,"DEALING") > 0) {
		SpeakString ("You'll have to wait to place your bet until next round.");
		return;
	}

    if(nUser == 1004) { //OnConversation.
        int nMatch = GetListenPatternNumber();
        string sUser = IntToString(nMatch);
        int nStringLength = GetStringLength(sUser);
        string sBetType = GetStringRight(sUser, 3);
        string sBetAmount = GetStringLeft(sUser, (nStringLength - 3));
        int nBet = (StringToInt(sBetAmount));
        nMatch = StringToInt("10" + sBetType);
        object oPC = GetLastSpeaker();
	
		//Allows only one bet!
		if (PS_GetLocalInt(oPC, "iBet") > 0) {
			SpeakString ("I'm sorry, it seems you've already placed your bet. It cannot be changed.");
			return;
		}

            switch(nMatch) {
                case 10001:
                    if (GetGold(oPC) >= nBet)
                    {
						int ixFive = PS_GetLocalInt(oPC,"iFive");
                        ixFive += nBet;
                        PS_SetLocalInt(oPC,"iFive", ixFive);
                        PS_SetLocalInt(oPC,"iBet",1);
                        TakeGoldFromCreature(nBet, oPC, TRUE);
                        SpeakString (GetName(oPC)+" has placed a " + IntToString(nBet) + " gold Five-Number bet.");
                    }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10002:
                    if (GetGold(oPC) >= nBet)
                    {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a " + IntToString(nBet) + " gold bet on Reds.");
                        int ixRed = PS_GetLocalInt(oPC,"iRed");
                        ixRed += nBet;
                        PS_SetLocalInt(oPC,"iRed", ixRed);
                        PS_SetLocalInt(oPC,"iBet",1);
                    }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10003:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a " + IntToString(nBet) + " gold bet on Blacks.");
                        int ixBlack = PS_GetLocalInt(oPC,"iBlack");
                        ixBlack += nBet;
                        PS_SetLocalInt(oPC,"iBlack", ixBlack);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10004:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a " + IntToString(nBet) + " gold bet on Odds.");
                        int ixOdd = PS_GetLocalInt(oPC,"iOdd");
                        ixOdd += nBet;
                        PS_SetLocalInt(oPC,"iOdd", ixOdd);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10005:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a " + IntToString(nBet) + " gold bet on Evens.");
                        int ixEven = PS_GetLocalInt(oPC,"iEven");
                        ixEven += nBet;
                        PS_SetLocalInt(oPC,"iEven", ixEven);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10006:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a " + IntToString(nBet) + " gold bet on Highs.");
                        int ixHigh = PS_GetLocalInt(oPC,"iHigh");
                        ixHigh += nBet;
                        PS_SetLocalInt(oPC,"iHigh", ixHigh);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10007:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a " + IntToString(nBet) + " gold bet on Lows.");
                        int ixLow = PS_GetLocalInt(oPC,"iLow");
                        ixLow += nBet;
                        PS_SetLocalInt(oPC,"iLow", ixLow);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10008:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Column bet of " + IntToString(nBet) + " gold.");
                        int ixCol1 = PS_GetLocalInt(oPC,"iCol1");
                        ixCol1 += nBet;
                        PS_SetLocalInt(oPC,"iCol1", ixCol1);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10009:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Column bet of " + IntToString(nBet) + " gold.");
                        int ixCol2 = PS_GetLocalInt(oPC,"iCol2");
                        ixCol2 += nBet;
                        PS_SetLocalInt(oPC,"iCol2", ixCol2);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10010:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Column bet of " + IntToString(nBet) + " gold.");
                        int ixCol3 = PS_GetLocalInt(oPC,"iCol3");
                        ixCol3 += nBet;
                        PS_SetLocalInt(oPC,"iCol3", ixCol3);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10011:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Dozen bet of " + IntToString(nBet) + " gold.");
                        int ixDoz1 = PS_GetLocalInt(oPC,"iDoz1");
                        ixDoz1 += nBet;
                        PS_SetLocalInt(oPC,"iDoz1", ixDoz1);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10012:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Dozen bet of " + IntToString(nBet) + " gold.");
                        int ixDoz2 = PS_GetLocalInt(oPC,"iDoz2");
                        ixDoz2 += nBet;
                        PS_SetLocalInt(oPC,"iDoz2", ixDoz2);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10013:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Dozen bet of " + IntToString(nBet) + " gold.");
                        int ixDoz3 = PS_GetLocalInt(oPC,"iDoz3");
                        ixDoz3 += nBet;
                        PS_SetLocalInt(oPC,"iDoz3", ixDoz3);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10014:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Line bet of " + IntToString(nBet) + " gold.");
                        int ixLine1 = PS_GetLocalInt(oPC,"iLine1");
                        ixLine1 += nBet;
                        PS_SetLocalInt(oPC,"iLine1", ixLine1);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10015:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Line bet of " + IntToString(nBet) + " gold.");
                        int ixLine2 = PS_GetLocalInt(oPC,"iLine2");
                        ixLine2 += nBet;
                        PS_SetLocalInt(oPC,"iLine2", ixLine2);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10016:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Line bet of " + IntToString(nBet) + " gold.");
                        int ixLine3 = PS_GetLocalInt(oPC,"iLine3");
                        ixLine3 += nBet;
                        PS_SetLocalInt(oPC,"iLine3", ixLine3);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10017:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Line bet of " + IntToString(nBet) + " gold.");
                        int ixLine4 = PS_GetLocalInt(oPC,"iLine4");
                        ixLine4 += nBet;
                        PS_SetLocalInt(oPC,"iLine4", ixLine4);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10018:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Line bet of " + IntToString(nBet) + " gold.");
                        int ixLine5 = PS_GetLocalInt(oPC,"iLine5");
                        ixLine5 += nBet;
                        PS_SetLocalInt(oPC,"iLine5", ixLine5);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10019:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Line bet of " + IntToString(nBet) + " gold.");
                        int ixLine6 = PS_GetLocalInt(oPC,"iLine6");
                        ixLine6 += nBet;
                        PS_SetLocalInt(oPC,"iLine6", ixLine6);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10020:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Line bet of " + IntToString(nBet) + " gold.");
                        int ixLine7 = PS_GetLocalInt(oPC,"iLine7");
                        ixLine7 += nBet;
                        PS_SetLocalInt(oPC,"iLine7", ixLine7);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10021:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Line bet of " + IntToString(nBet) + " gold.");
                        int ixLine8 = PS_GetLocalInt(oPC,"iLine8");
                        ixLine8 += nBet;
                        PS_SetLocalInt(oPC,"iLine8", ixLine8);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10022:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Line bet of " + IntToString(nBet) + " gold.");
                        int ixLine9 = PS_GetLocalInt(oPC,"iLine9");
                        ixLine9 += nBet;
                        PS_SetLocalInt(oPC,"iLine9", ixLine9);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10023:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Line bet of " + IntToString(nBet) + " gold.");
                        int ixLine10 = PS_GetLocalInt(oPC,"iLine10");
                        ixLine10 += nBet;
                        PS_SetLocalInt(oPC,"iLine10", ixLine10);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10024:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Line bet of " + IntToString(nBet) + " gold.");
                        int ixLine11 = PS_GetLocalInt(oPC,"iLine11");
                        ixLine11 += nBet;
                        PS_SetLocalInt(oPC,"iLine11", ixLine11);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10025:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Street bet of " + IntToString(nBet) + " gold.");
                        int ixStreet1 = PS_GetLocalInt(oPC,"iStreet1");
                        ixStreet1 += nBet;
                        PS_SetLocalInt(oPC,"iStreet1", ixStreet1);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10026:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Street bet of " + IntToString(nBet) + " gold.");
                        int ixStreet2 = PS_GetLocalInt(oPC,"iStreet2");
                        ixStreet2 += nBet;
                        PS_SetLocalInt(oPC,"iStreet2", ixStreet2);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10027:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Street bet of " + IntToString(nBet) + " gold.");
                        int ixStreet3 = PS_GetLocalInt(oPC,"iStreet3");
                        ixStreet3 += nBet;
                        PS_SetLocalInt(oPC,"iStreet3", ixStreet3);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10028:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Street bet of " + IntToString(nBet) + " gold.");
                        int ixStreet4 = PS_GetLocalInt(oPC,"iStreet4");
                        ixStreet4 += nBet;
                        PS_SetLocalInt(oPC,"iStreet4", ixStreet4);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10029:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Street bet of " + IntToString(nBet) + " gold.");
                        int ixStreet5 = PS_GetLocalInt(oPC,"iStreet5");
                        ixStreet5 += nBet;
                        PS_SetLocalInt(oPC,"iStreet5", ixStreet5);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10030:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Street bet of " + IntToString(nBet) + " gold.");
                        int ixStreet6 = PS_GetLocalInt(oPC,"iStreet6");
                        ixStreet6 += nBet;
                        PS_SetLocalInt(oPC,"iStreet6", ixStreet6);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10031:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Street bet of " + IntToString(nBet) + " gold.");
                        int ixStreet7 = PS_GetLocalInt(oPC,"iStreet7");
                        ixStreet7 += nBet;
                        PS_SetLocalInt(oPC,"iStreet7", ixStreet7);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10032:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Street bet of " + IntToString(nBet) + " gold.");
                        int ixStreet8 = PS_GetLocalInt(oPC,"iStreet8");
                        ixStreet8 += nBet;
                        PS_SetLocalInt(oPC,"iStreet8", ixStreet8);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10033:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Street bet of " + IntToString(nBet) + " gold.");
                        int ixStreet9 = PS_GetLocalInt(oPC,"iStreet9");
                        ixStreet9 += nBet;
                        PS_SetLocalInt(oPC,"iStreet9", ixStreet9);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10034:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Street bet of " + IntToString(nBet) + " gold.");
                        int ixStreet10 = PS_GetLocalInt(oPC,"iStreet10");
                        ixStreet10 += nBet;
                        PS_SetLocalInt(oPC,"iStreet10", ixStreet10);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10035:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Street bet of " + IntToString(nBet) + " gold.");
                        int ixStreet11 = PS_GetLocalInt(oPC,"iStreet11");
                        ixStreet11 += nBet;
                        PS_SetLocalInt(oPC,"iStreet11", ixStreet11);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10036:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Street bet of " + IntToString(nBet) + " gold.");
                        int ixStreet12 = PS_GetLocalInt(oPC,"iStreet12");
                        ixStreet12 += nBet;
                        PS_SetLocalInt(oPC,"iStreet12", ixStreet12);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10037:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner1 = PS_GetLocalInt(oPC,"iCorner1");
                        ixCorner1 += nBet;
                        PS_SetLocalInt(oPC,"iCorner1", ixCorner1);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10038:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner2 = PS_GetLocalInt(oPC,"iCorner2");
                        ixCorner2 += nBet;
                        PS_SetLocalInt(oPC,"iCorner2", ixCorner2);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10039:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner3 = PS_GetLocalInt(oPC,"iCorner3");
                        ixCorner3 += nBet;
                        PS_SetLocalInt(oPC,"iCorner3", ixCorner3);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10040:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner4 = PS_GetLocalInt(oPC,"iCorner4");
                        ixCorner4 += nBet;
                        PS_SetLocalInt(oPC,"iCorner4", ixCorner4);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10041:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner5 = PS_GetLocalInt(oPC,"iCorner5");
                        ixCorner5 += nBet;
                        PS_SetLocalInt(oPC,"iCorner5", ixCorner5);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10042:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner6 = PS_GetLocalInt(oPC,"iCorner6");
                        ixCorner6 += nBet;
                        PS_SetLocalInt(oPC,"iCorner6", ixCorner6);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10043:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner7 = PS_GetLocalInt(oPC,"iCorner7");
                        ixCorner7 += nBet;
                        PS_SetLocalInt(oPC,"iCorner7", ixCorner7);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10044:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner8 = PS_GetLocalInt(oPC,"iCorner8");
                        ixCorner8 += nBet;
                        PS_SetLocalInt(oPC,"iCorner8", ixCorner8);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10045:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner9 = PS_GetLocalInt(oPC,"iCorner9");
                        ixCorner9 += nBet;
                        PS_SetLocalInt(oPC,"iCorner9", ixCorner9);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10046:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner10 = PS_GetLocalInt(oPC,"iCorner10");
                        ixCorner10 += nBet;
                        PS_SetLocalInt(oPC,"iCorner10", ixCorner10);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10047:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner11 = PS_GetLocalInt(oPC,"iCorner11");
                        ixCorner11 += nBet;
                        PS_SetLocalInt(oPC,"iCorner11", ixCorner11);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10048:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner12 = PS_GetLocalInt(oPC,"iCorner12");
                        ixCorner12 += nBet;
                        PS_SetLocalInt(oPC,"iCorner12", ixCorner12);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10049:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner13 = PS_GetLocalInt(oPC,"iCorner13");
                        ixCorner13 += nBet;
                        PS_SetLocalInt(oPC,"iCorner13", ixCorner13);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10050:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner14 = PS_GetLocalInt(oPC,"iCorner14");
                        ixCorner14 += nBet;
                        PS_SetLocalInt(oPC,"iCorner14", ixCorner14);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10051:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner15 = PS_GetLocalInt(oPC,"iCorner15");
                        ixCorner15 += nBet;
                        PS_SetLocalInt(oPC,"iCorner15", ixCorner15);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10052:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner16 = PS_GetLocalInt(oPC,"iCorner16");
                        ixCorner16 += nBet;
                        PS_SetLocalInt(oPC,"iCorner16", ixCorner16);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10053:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner17 = PS_GetLocalInt(oPC,"iCorner17");
                        ixCorner17 += nBet;
                        PS_SetLocalInt(oPC,"iCorner17", ixCorner17);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10054:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner18 = PS_GetLocalInt(oPC,"iCorner18");
                        ixCorner18 += nBet;
                        PS_SetLocalInt(oPC,"iCorner18", ixCorner18);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10055:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner19 = PS_GetLocalInt(oPC,"iCorner19");
                        ixCorner19 += nBet;
                        PS_SetLocalInt(oPC,"iCorner19", ixCorner19);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10056:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner20 = PS_GetLocalInt(oPC,"iCorner20");
                        ixCorner20 += nBet;
                        PS_SetLocalInt(oPC,"iCorner20", ixCorner20);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10057:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner21 = PS_GetLocalInt(oPC,"iCorner21");
                        ixCorner21 += nBet;
                        PS_SetLocalInt(oPC,"iCorner21", ixCorner21);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10058:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Corner bet of " + IntToString(nBet) + " gold.");
                        int ixCorner22 = PS_GetLocalInt(oPC,"iCorner22");
                        ixCorner22 += nBet;
                        PS_SetLocalInt(oPC,"iCorner22", ixCorner22);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10059:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix0su = PS_GetLocalInt(oPC,"i0su");
                        ix0su += nBet;
                        PS_SetLocalInt(oPC,"i0su", ix0su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10060:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix00su = PS_GetLocalInt(oPC,"i00su");
                        ix00su += nBet;
                        PS_SetLocalInt(oPC,"i00su", ix00su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10061:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix1su = PS_GetLocalInt(oPC,"i1su");
                        ix1su += nBet;
                        PS_SetLocalInt(oPC,"i1su", ix1su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10062:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix2su = PS_GetLocalInt(oPC,"i2su");
                        ix2su += nBet;
                        PS_SetLocalInt(oPC,"i2su", ix2su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10063:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix3su = PS_GetLocalInt(oPC,"i3su");
                        ix3su += nBet;
                        PS_SetLocalInt(oPC,"i3su", ix3su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10064:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix4su = PS_GetLocalInt(oPC,"i4su");
                        ix4su += nBet;
                        PS_SetLocalInt(oPC,"i4su", ix4su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10065:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix5su = PS_GetLocalInt(oPC,"i5su");
                        ix5su += nBet;
                        PS_SetLocalInt(oPC,"i5su", ix5su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10066:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix6su = PS_GetLocalInt(oPC,"i6su");
                        ix6su += nBet;
                        PS_SetLocalInt(oPC,"i6su", ix6su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10067:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix7su = PS_GetLocalInt(oPC,"i7su");
                        ix7su += nBet;
                        PS_SetLocalInt(oPC,"i7su", ix7su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10068:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix8su = PS_GetLocalInt(oPC,"i8su");
                        ix8su += nBet;
                        PS_SetLocalInt(oPC,"i8su", ix8su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10069:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix9su = PS_GetLocalInt(oPC,"i9su");
                        ix9su += nBet;
                        PS_SetLocalInt(oPC,"i9su", ix9su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10070:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix10su = PS_GetLocalInt(oPC,"i10su");
                        ix10su += nBet;
                        PS_SetLocalInt(oPC,"i10su", ix10su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10071:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix11su = PS_GetLocalInt(oPC,"i11su");
                        ix11su += nBet;
                        PS_SetLocalInt(oPC,"i11su", ix11su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10072:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix12su = PS_GetLocalInt(oPC,"i12su");
                        ix12su += nBet;
                        PS_SetLocalInt(oPC,"i12su", ix12su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10073:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix13su = PS_GetLocalInt(oPC,"i13su");
                        ix13su += nBet;
                        PS_SetLocalInt(oPC,"i13su", ix13su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10074:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix14su = PS_GetLocalInt(oPC,"i14su");
                        ix14su += nBet;
                        PS_SetLocalInt(oPC,"i14su", ix14su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10075:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix15su = PS_GetLocalInt(oPC,"i15su");
                        ix15su += nBet;
                        PS_SetLocalInt(oPC,"i15su", ix15su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10076:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix16su = PS_GetLocalInt(oPC,"i16su");
                        ix16su += nBet;
                        PS_SetLocalInt(oPC,"i16su", ix16su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10077:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix17su = PS_GetLocalInt(oPC,"i17su");
                        ix17su += nBet;
                        PS_SetLocalInt(oPC,"i17su", ix17su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10078:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix18su = PS_GetLocalInt(oPC,"i18su");
                        ix18su += nBet;
                        PS_SetLocalInt(oPC,"i18su", ix18su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10079:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix19su = PS_GetLocalInt(oPC,"i19su");
                        ix19su += nBet;
                        PS_SetLocalInt(oPC,"i19su", ix19su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10080:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix20su = PS_GetLocalInt(oPC,"i20su");
                        ix20su += nBet;
                        PS_SetLocalInt(oPC,"i20su", ix20su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10081:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix21su = PS_GetLocalInt(oPC,"i21su");
                        ix21su += nBet;
                        PS_SetLocalInt(oPC,"i21su", ix21su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10082:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix22su = PS_GetLocalInt(oPC,"i22su");
                        ix22su += nBet;
                        PS_SetLocalInt(oPC,"i22su", ix22su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10083:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix23su = PS_GetLocalInt(oPC,"i23su");
                        ix23su += nBet;
                        PS_SetLocalInt(oPC,"i23su", ix23su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10084:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix24su = PS_GetLocalInt(oPC,"i24su");
                        ix24su += nBet;
                        PS_SetLocalInt(oPC,"i24su", ix24su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10085:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix25su = PS_GetLocalInt(oPC,"i25su");
                        ix25su += nBet;
                        PS_SetLocalInt(oPC,"i25su", ix25su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10086:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix26su = PS_GetLocalInt(oPC,"i26su");
                        ix26su += nBet;
                        PS_SetLocalInt(oPC,"i26su", ix26su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10087:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix27su = PS_GetLocalInt(oPC,"i27su");
                        ix27su += nBet;
                        PS_SetLocalInt(oPC,"i27su", ix27su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10088:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix28su = PS_GetLocalInt(oPC,"i28su");
                        ix28su += nBet;
                        PS_SetLocalInt(oPC,"i28su", ix28su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10089:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix29su = PS_GetLocalInt(oPC,"i29su");
                        ix29su += nBet;
                        PS_SetLocalInt(oPC,"i29su", ix29su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10090:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix30su = PS_GetLocalInt(oPC,"i30su");
                        ix30su += nBet;
                        PS_SetLocalInt(oPC,"i30su", ix30su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10091:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix31su = PS_GetLocalInt(oPC,"i31su");
                        ix31su += nBet;
                        PS_SetLocalInt(oPC,"i31su", ix31su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10092:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix32su = PS_GetLocalInt(oPC,"i32su");
                        ix32su += nBet;
                        PS_SetLocalInt(oPC,"i32su", ix32su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10093:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix33su = PS_GetLocalInt(oPC,"i33su");
                        ix33su += nBet;
                        PS_SetLocalInt(oPC,"i33su", ix33su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10094:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix34su = PS_GetLocalInt(oPC,"i34su");
                        ix34su += nBet;
                        PS_SetLocalInt(oPC,"i34su", ix34su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10095:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix35su = PS_GetLocalInt(oPC,"i35su");
                        ix35su += nBet;
                        PS_SetLocalInt(oPC,"i35su", ix35su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10096:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Straight Up bet of " + IntToString(nBet) + " gold.");
                        int ix36su = PS_GetLocalInt(oPC,"i36su");
                        ix36su += nBet;
                        PS_SetLocalInt(oPC,"i36su", ix36su);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10097:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit1 = PS_GetLocalInt(oPC,"iSplit1");
                        ixSplit1 += nBet;
                        PS_SetLocalInt(oPC,"iSplit1", ixSplit1);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10098:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit2 = PS_GetLocalInt(oPC,"iSplit2");
                        ixSplit2 += nBet;
                        PS_SetLocalInt(oPC,"iSplit2", ixSplit2);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10099:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit3 = PS_GetLocalInt(oPC,"iSplit3");
                        ixSplit3 += nBet;
                        PS_SetLocalInt(oPC,"iSplit3", ixSplit3);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10100:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit4 = PS_GetLocalInt(oPC,"iSplit4");
                        ixSplit4 += nBet;
                        PS_SetLocalInt(oPC,"iSplit4", ixSplit4);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10101:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit5 = PS_GetLocalInt(oPC,"iSplit5");
                        ixSplit5 += nBet;
                        PS_SetLocalInt(oPC,"iSplit5", ixSplit5);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10102:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit6 = PS_GetLocalInt(oPC,"iSplit6");
                        ixSplit6 += nBet;
                        PS_SetLocalInt(oPC,"iSplit6", ixSplit6);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10103:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit7 = PS_GetLocalInt(oPC,"iSplit7");
                        ixSplit7 += nBet;
                        PS_SetLocalInt(oPC,"iSplit7", ixSplit7);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10104:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit8 = PS_GetLocalInt(oPC,"iSplit8");
                        ixSplit8 += nBet;
                        PS_SetLocalInt(oPC,"iSplit8", ixSplit8);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10105:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit9 = PS_GetLocalInt(oPC,"iSplit9");
                        ixSplit9 += nBet;
                        PS_SetLocalInt(oPC,"iSplit9", ixSplit9);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10106:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit10 = PS_GetLocalInt(oPC,"iSplit10");
                        ixSplit10 += nBet;
                        PS_SetLocalInt(oPC,"iSplit10", ixSplit10);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10107:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit11 = PS_GetLocalInt(oPC,"iSplit11");
                        ixSplit11 += nBet;
                        PS_SetLocalInt(oPC,"iSplit11", ixSplit11);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10108:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit12 = PS_GetLocalInt(oPC,"iSplit12");
                        ixSplit12 += nBet;
                        PS_SetLocalInt(oPC,"iSplit12", ixSplit12);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10109:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit13 = PS_GetLocalInt(oPC,"iSplit13");
                        ixSplit13 += nBet;
                        PS_SetLocalInt(oPC,"iSplit13", ixSplit13);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10110:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit14 = PS_GetLocalInt(oPC,"iSplit14");
                        ixSplit14 += nBet;
                        PS_SetLocalInt(oPC,"iSplit14", ixSplit14);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10111:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit15 = PS_GetLocalInt(oPC,"iSplit15");
                        ixSplit15 += nBet;
                        PS_SetLocalInt(oPC,"iSplit15", ixSplit15);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10112:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit16 = PS_GetLocalInt(oPC,"iSplit16");
                        ixSplit16 += nBet;
                        PS_SetLocalInt(oPC,"iSplit16", ixSplit16);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10113:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit17 = PS_GetLocalInt(oPC,"iSplit17");
                        ixSplit17 += nBet;
                        PS_SetLocalInt(oPC,"iSplit17", ixSplit17);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10114:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit18 = PS_GetLocalInt(oPC,"iSplit18");
                        ixSplit18 += nBet;
                        PS_SetLocalInt(oPC,"iSplit18", ixSplit18);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10115:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit19 = PS_GetLocalInt(oPC,"iSplit19");
                        ixSplit19 += nBet;
                        PS_SetLocalInt(oPC,"iSplit19", ixSplit19);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10116:
                if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit20 = PS_GetLocalInt(oPC,"iSplit20");
                        ixSplit20 += nBet;
                        PS_SetLocalInt(oPC,"iSplit20", ixSplit20);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10117:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit21 = PS_GetLocalInt(oPC,"iSplit21");
                        ixSplit21 += nBet;
                        PS_SetLocalInt(oPC,"iSplit21", ixSplit21);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10118:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit22 = PS_GetLocalInt(oPC,"iSplit22");
                        ixSplit22 += nBet;
                        PS_SetLocalInt(oPC,"iSplit22", ixSplit22);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10119:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit23 = PS_GetLocalInt(oPC,"iSplit23");
                        ixSplit23 += nBet;
                        PS_SetLocalInt(oPC,"iSplit23", ixSplit23);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10120:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit24 = PS_GetLocalInt(oPC,"iSplit24");
                        ixSplit24 += nBet;
                        PS_SetLocalInt(oPC,"iSplit24", ixSplit24);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10121:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit25 = PS_GetLocalInt(oPC,"iSplit25");
                        ixSplit25 += nBet;
                        PS_SetLocalInt(oPC,"iSplit25", ixSplit25);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10122:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit26 = PS_GetLocalInt(oPC,"iSplit26");
                        ixSplit26 += nBet;
                        PS_SetLocalInt(oPC,"iSplit26", ixSplit26);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10123:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit27 = PS_GetLocalInt(oPC,"iSplit27");
                        ixSplit27 += nBet;
                        PS_SetLocalInt(oPC,"iSplit27", ixSplit27);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10124:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit28 = PS_GetLocalInt(oPC,"iSplit28");
                        ixSplit28 += nBet;
                        PS_SetLocalInt(oPC,"iSplit28", ixSplit28);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10125:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit29 = PS_GetLocalInt(oPC,"iSplit29");
                        ixSplit29 += nBet;
                        PS_SetLocalInt(oPC,"iSplit29", ixSplit29);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10126:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit30 = PS_GetLocalInt(oPC,"iSplit30");
                        ixSplit30 += nBet;
                        PS_SetLocalInt(oPC,"iSplit30", ixSplit30);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10127:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit31 = PS_GetLocalInt(oPC,"iSplit31");
                        ixSplit31 += nBet;
                        PS_SetLocalInt(oPC,"iSplit31", ixSplit31);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10128:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit32 = PS_GetLocalInt(oPC,"iSplit32");
                        ixSplit32 += nBet;
                        PS_SetLocalInt(oPC,"iSplit32", ixSplit32);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10129:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit33 = PS_GetLocalInt(oPC,"iSplit33");
                        ixSplit33 += nBet;
                        PS_SetLocalInt(oPC,"iSplit33", ixSplit33);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10130:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit34 = PS_GetLocalInt(oPC,"iSplit34");
                        ixSplit34 += nBet;
                        PS_SetLocalInt(oPC,"iSplit34", ixSplit34);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10131:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit35 = PS_GetLocalInt(oPC,"iSplit35");
                        ixSplit35 += nBet;
                        PS_SetLocalInt(oPC,"iSplit35", ixSplit35);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10132:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit36 = PS_GetLocalInt(oPC,"iSplit36");
                        ixSplit36 += nBet;
                        PS_SetLocalInt(oPC,"iSplit36", ixSplit36);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10133:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit37 = PS_GetLocalInt(oPC,"iSplit37");
                        ixSplit37 += nBet;
                        PS_SetLocalInt(oPC,"iSplit37", ixSplit37);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10134:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit38 = PS_GetLocalInt(oPC,"iSplit38");
                        ixSplit38 += nBet;
                        PS_SetLocalInt(oPC,"iSplit38", ixSplit38);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10135:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit39 = PS_GetLocalInt(oPC,"iSplit39");
                        ixSplit39 += nBet;
                        PS_SetLocalInt(oPC,"iSplit39", ixSplit39);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10136:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit40 = PS_GetLocalInt(oPC,"iSplit40");
                        ixSplit40 += nBet;
                        PS_SetLocalInt(oPC,"iSplit40", ixSplit40);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10137:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit41 = PS_GetLocalInt(oPC,"iSplit41");
                        ixSplit41 += nBet;
                        PS_SetLocalInt(oPC,"iSplit41", ixSplit41);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10138:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit42 = PS_GetLocalInt(oPC,"iSplit42");
                        ixSplit42 += nBet;
                        PS_SetLocalInt(oPC,"iSplit42", ixSplit42);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10139:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit43 = PS_GetLocalInt(oPC,"iSplit43");
                        ixSplit43 += nBet;
                        PS_SetLocalInt(oPC,"iSplit43", ixSplit43);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10140:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit44 = PS_GetLocalInt(oPC,"iSplit44");
                        ixSplit44 += nBet;
                        PS_SetLocalInt(oPC,"iSplit44", ixSplit44);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10141:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit45 = PS_GetLocalInt(oPC,"iSplit45");
                        ixSplit45 += nBet;
                        PS_SetLocalInt(oPC,"iSplit45", ixSplit45);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10142:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit46 = PS_GetLocalInt(oPC,"iSplit46");
                        ixSplit46 += nBet;
                        PS_SetLocalInt(oPC,"iSplit46", ixSplit46);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10143:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit47 = PS_GetLocalInt(oPC,"iSplit47");
                        ixSplit47 += nBet;
                        PS_SetLocalInt(oPC,"iSplit47", ixSplit47);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10144:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit48 = PS_GetLocalInt(oPC,"iSplit48");
                        ixSplit48 += nBet;
                        PS_SetLocalInt(oPC,"iSplit48", ixSplit48);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10145:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit49 = PS_GetLocalInt(oPC,"iSplit49");
                        ixSplit49 += nBet;
                        PS_SetLocalInt(oPC,"iSplit49", ixSplit49);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10146:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit50 = PS_GetLocalInt(oPC,"iSplit50");
                        ixSplit50 += nBet;
                        PS_SetLocalInt(oPC,"iSplit50", ixSplit50);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10147:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit51 = PS_GetLocalInt(oPC,"iSplit51");
                        ixSplit51 += nBet;
                        PS_SetLocalInt(oPC,"iSplit51", ixSplit51);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10148:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit52 = PS_GetLocalInt(oPC,"iSplit52");
                        ixSplit52 += nBet;
                        PS_SetLocalInt(oPC,"iSplit52", ixSplit52);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10149:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit53 = PS_GetLocalInt(oPC,"iSplit53");
                        ixSplit53 += nBet;
                        PS_SetLocalInt(oPC,"iSplit53", ixSplit53);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10150:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit54 = PS_GetLocalInt(oPC,"iSplit54");
                        ixSplit54 += nBet;
                        PS_SetLocalInt(oPC,"iSplit54", ixSplit54);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10151:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit55 = PS_GetLocalInt(oPC,"iSplit55");
                        ixSplit55 += nBet;
                        PS_SetLocalInt(oPC,"iSplit55", ixSplit55);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10152:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit56 = PS_GetLocalInt(oPC,"iSplit56");
                        ixSplit56 += nBet;
                        PS_SetLocalInt(oPC,"iSplit56", ixSplit56);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10153:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit57 = PS_GetLocalInt(oPC,"iSplit57");
                        ixSplit57 += nBet;
                        PS_SetLocalInt(oPC,"iSplit57", ixSplit57);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10154:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit58 = PS_GetLocalInt(oPC,"iSplit58");
                        ixSplit58 += nBet;
                        PS_SetLocalInt(oPC,"iSplit58", ixSplit58);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10155:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit59 = PS_GetLocalInt(oPC,"iSplit59");
                        ixSplit59 += nBet;
                        PS_SetLocalInt(oPC,"iSplit59", ixSplit59);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10156:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit60 = PS_GetLocalInt(oPC,"iSplit60");
                        ixSplit60 += nBet;
                        PS_SetLocalInt(oPC,"iSplit60", ixSplit60);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10157:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit61 = PS_GetLocalInt(oPC,"iSplit61");
                        ixSplit61 += nBet;
                        PS_SetLocalInt(oPC,"iSplit61", ixSplit61);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;
                case 10158:
                    if (GetGold(oPC) >= nBet)
                        {
                        TakeGoldFromCreature(nBet, oPC, TRUE);
						AddHouse(nBet);
                        SpeakString (GetName(oPC)+" has placed a Split bet of " + IntToString(nBet) + " gold.");
                        int ixSplit62 = PS_GetLocalInt(oPC,"iSplit62");
                        ixSplit62 += nBet;
                        PS_SetLocalInt(oPC,"iSplit62", ixSplit62);
                        PS_SetLocalInt(oPC,"iBet",1);
                        }
                    else SpeakString (GetName(oPC)+", you don't have that much gold.");
                    break;

            }

        }
    }
	
string HasAlreadyPlacedBet(object oPC) {

	int n;
	for (n = 1; n < 63; n++) {
		string sNum = IntToString(n);
		if (PS_GetLocalInt(oPC, "iSplit"+sNum) > 0)
			return "iSplit"+sNum;
	}
	
	for (n = 1; n < 37; n++) {
		string sNum = IntToString(n);
		if (PS_GetLocalInt(oPC, "i"+sNum+"su") > 0)
			return "i"+sNum+"su";
	}
	
	for (n = 1; n < 23; n++) {
		string sNum = IntToString(n);
		if (PS_GetLocalInt(oPC, "iCorner"+sNum) > 0)
			return  "iCorner"+sNum;
	}
	
	for (n = 1; n < 13; n++) {
		string sNum = IntToString(n);
		if (PS_GetLocalInt(oPC, "iStreet"+sNum) > 0)
			return  "iStreet"+sNum;
	}
	
	for (n = 1; n < 12; n++) {
		string sNum = IntToString(n);
		if (PS_GetLocalInt(oPC, "iLine"+sNum) > 0)
			return  "iLine"+sNum;
	}
	
	for (n = 1; n < 4; n++) {
		string sNum = IntToString(n);
		if (PS_GetLocalInt(oPC, "iDoz"+sNum) > 0)
			return  "iDoz"+sNum;
	}
	
	for (n = 1; n < 4; n++) {
		string sNum = IntToString(n);
		if (PS_GetLocalInt(oPC, "iCol"+sNum) > 0)
			return  "iCol"+sNum;
	}
	
	if (PS_GetLocalInt(oPC, "iFive") > 0)
		return  "iFive";
	
	if (PS_GetLocalInt(oPC, "iRed") > 0)
		return  "iRed";
			
	if (PS_GetLocalInt(oPC, "iBlack") > 0)
		return  "iBlack";
			
	if (PS_GetLocalInt(oPC, "iOdd") > 0)
		return  "iOdd";
			
	if (PS_GetLocalInt(oPC, "iEven") > 0)
		return  "iEven";
			
	if (PS_GetLocalInt(oPC, "iHigh") > 0)
		return  "iHigh";
			
	if (PS_GetLocalInt(oPC, "iLow") > 0)
		return  "iLow";
		
	return "";

}
	
	