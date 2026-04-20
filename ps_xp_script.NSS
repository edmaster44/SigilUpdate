//V. 1.03


#include "ps_inc_onhit"
#include "nwnx_sql"
#include "ff_chat_commands"

struct PartyData{
int nMax;
float fAvg;
int nNum;
};

float GetPartyXPBonus(float fAvgLevel, float fCR, int nNum);
float GetBaseXP(float fLevel, float fCR, int nNum);
void GiveKillCopper(object oPC, float fCR);
struct PartyData GetPartyData(object oPC);
object PS_GetKiller();

void main(){
	object oDead = OBJECT_SELF;
	object oKiller = PS_GetKiller();
	if(GetIsDM(oKiller) || oKiller == OBJECT_SELF) return;
	
	string sDeathScript = GetLocalString(oDead, "DeathScript");
	if (sDeathScript != "")
		ExecuteScript(sDeathScript, oDead);
	
	  // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
	
	int nRaceDead = GetRacialType(oDead);
	int nSubDead = GetSubRace(oDead);
	int bGiveCopper = (GetLocalInt(oDead, "X2_L_NOTREASURE") == FALSE && 
		nRaceDead != RACIAL_TYPE_ANIMAL && nRaceDead != RACIAL_TYPE_BEAST &&
		nRaceDead != RACIAL_TYPE_CONSTRUCT && nRaceDead != RACIAL_TYPE_ELEMENTAL &&
		nRaceDead != RACIAL_TYPE_VERMIN && nSubDead != 23 && nSubDead != 24 &&
		nSubDead != 25 && nSubDead != 30 && nSubDead != 36 && nSubDead != 37 &&
		nSubDead != 40 && nSubDead != 44 && nSubDead != 140 && nSubDead != 141 &&
		nSubDead != 142);
	
	struct PartyData data = GetPartyData(oKiller);
	
	float fPartyLevel = IntToFloat(data.nMax) - (log(IntToFloat(data.nMax) - data.fAvg + 1.0) * 1.5);
	float fCRoriginal = GetChallengeRating(oDead);
	float fDeadHD = IntToFloat(GetHitDice(oDead));
	float fCR;
	// Several mobs have their CR set ridiculously high, the hobgoblin bosses in Clangor, for example
	// have their CR set to 99, same as The Ascended and the White Dragon. It shouldnt be CR 99 if you
	// can kill it in two rounds. If it's a really epic boss, use the higher of CR or HD. Otherwise, 
	// use the lower
	if (fDeadHD >= 40.0) fCR = (fCRoriginal > fDeadHD) ? fCRoriginal : fDeadHD;
	else fCR = (fCRoriginal > fDeadHD) ? fDeadHD : fCRoriginal;

	int nElite = StringToInt(GetLocalString(oDead,"ELITE"));
    if (nElite > 0){
        if (fPartyLevel + 5.0 < 10.0 * nElite) fCR += 3.0;
        else fCR += 2.0 - log(IntToFloat(data.nNum));
    }
	float fXP = GetBaseXP(fPartyLevel, fCR, data.nNum);

    int nLevel, nECL, nFinalXP, rp_pool, rp_bonus, bUpdateDB;
	float fLevel, fIndividualXP, fSoloXP, fPbonus;
	string sID, sDebug;
	string sXPbanking = "You have surpassed the required XP to level up.";
	sXPbanking += "\nYour XP is being calculated as though you were level ";
	
	object oArea = GetArea(oKiller);
	object oMember = GetFirstFactionMember(oKiller, TRUE);
    while(GetIsObjectValid(oMember)){
		if (oArea == GetArea(oMember) && !GetIsDM(oMember)){
		
			if (bGiveCopper) GiveKillCopper(oMember, fCR);
			rp_pool = 0;
			fIndividualXP = fXP;
			nLevel = PS_GetLevelByXP(oMember);
			if (nLevel > GetHitDice(oMember)){
				SendMessageToPC(oMember, sXPbanking + IntToString(nLevel) + ".");
			}
			fLevel = IntToFloat(nLevel);
			nECL = GetNewECL(oMember);
			fLevel += IntToFloat(nECL);
			//if the monster is higher CR than the player's level
			if (fCR >= fLevel){
				//assume that if the cr of the enemy is higher then they'd be fighting something their own size
				// if they were alone
				fSoloXP = GetBaseXP(fLevel, fLevel, 1);
				// then if the player is out of range (excluding the highest lvls ECL and including their own
				if (IntToFloat(data.nMax - MAXPARTYRANGE) > fLevel){
					// then they get xp as if the mob was the same level as them
					fIndividualXP = GetBaseXP(fLevel, fLevel, data.nNum);
				//otherwise if the player is IN range but below party average, give them a litttle boost
				} else if (fLevel < fPartyLevel ){
					fIndividualXP *= 1.025;
				}
			} else {
				fSoloXP = GetBaseXP(fLevel, fCR, 1);
			}
			// in the unlikely event that they're getting more than max, give them max
			if (fIndividualXP > MAXMONSTERXP) fIndividualXP = MAXMONSTERXP;
			
			//show the % of party xp bonus. only used if they have #KillInfo chat command on
			if (fIndividualXP > fSoloXP && data.nNum > 1) fPbonus = ((fIndividualXP - fSoloXP) / fSoloXP ) * 100.0;
			else fPbonus = 0.0;
			
			nFinalXP = PS_RoundToInt(fIndividualXP);
		
			//if the monster is not more than 10 levels below the player then the player should get 
			// at least 1 xp
			if (nFinalXP < 1 && PS_RoundToInt(fCR) >= nLevel - MAXPARTYRANGE)
				nFinalXP = 1;
			
				
			if(nFinalXP > 0){
				sID = PS_GetCharID(oMember);
				//SendMessageToPC(oPartyMember,"id:" + sID);
				SQLExecDirect("SELECT rp_pool FROM characterdata WHERE id=" + sID);
				if (SQLFetch() != SQL_ERROR) { 
					rp_pool = StringToInt(SQLGetData(1));
					if (rp_pool > 0) bUpdateDB = TRUE;
					else bUpdateDB = FALSE;
					if (rp_pool > nFinalXP){
						rp_pool -= nFinalXP;
						nFinalXP += nFinalXP;
						rp_bonus = nFinalXP;
					} else if (rp_pool > 0 ){
						nFinalXP += rp_pool;
						rp_bonus = rp_pool;
						rp_pool = 0;
					}
					if (bUpdateDB)// reduce writing to server by not updating the db if rp pool hasn't changed
						SQLExecDirect("UPDATE characterdata SET rp_pool=" + IntToString(rp_pool) + " WHERE id=" + sID); 
				} else rp_bonus = 0;
			}
			// if player is using #KillInfo chat command, which is not meant to show quest or rp xp
			if (GetLocalInt(oMember, "xpdebug")){
				sDebug = "Max level in party: " + IntToString(data.nMax);
				sDebug += "\nParty Size: " + IntToString(data.nNum);
				sDebug += "\nBase XP: " + IntToString(PS_RoundToInt(fSoloXP));
				sDebug += "\nParty XP Bonus: ";
				if (fPbonus == 0.0) sDebug += "none";
				else sDebug += PS_PrettyFloatString(fPbonus, 2) + "%";
				sDebug += "\nRP Pool Bonus: " + IntToString(rp_bonus);
				sDebug += "\nEnemy Data:\n";
				sDebug += GetCreatureInfo(oDead, oMember);
				SendMessageToPC(oMember, sDebug);
			}
			if (nFinalXP > 0) PS_GiveXPReward(oMember, nFinalXP, TRUE);
		}
		oMember = GetNextFactionMember(oKiller, TRUE);
	}
}

void GiveKillCopper(object oPC, float fCR){
	int nCopper;
	// note that this is not d3(100) because that would be minimum 300. This is max 300, min 100
	if (fCR >= 90.0)  nCopper =  d3() * 100 + d8() * 10 + d8(); 
	else if (fCR < 90.0 && fCR >= 80.0) nCopper = d2() * 100 + d6() * 10 + d8();
	else if (fCR < 80.0 && fCR >= 70.0) nCopper = d2() * 100 + d4() * 10 + d6();
	else if (fCR < 70.0 && fCR >= 60.0) nCopper = d8() * 10 + d8();
	else if (fCR < 60.0 && fCR >= 50.0) nCopper = d6() * 10 + d6();
	else if (fCR < 50.0 && fCR >= 40.0) nCopper = d4() * 10 + d6();
	else if (fCR < 40.0 && fCR >= 30.0) nCopper = d3() * 10 + d4();
	else if (fCR < 30.0 && fCR >= 20.0) nCopper = d8(3);
	else if (fCR < 20.0 && fCR >= 10.0) nCopper = d10(2);
	else nCopper = d20();
	PS_GiveGoldToCreature(oPC, nCopper);
}

struct PartyData GetPartyData(object oPC){
	object oArea = GetArea(oPC);
	struct PartyData data;
	data.nMax = 0;
	data.fAvg = 0.0;
	data.nNum = 0;
	int nLvl = 0;
	int nTotal = 0;
	object oMember = GetFirstFactionMember(oPC, TRUE);
    while(GetIsObjectValid(oMember)){ 
		if (GetArea(oMember) == oArea && !GetIsDM(oMember)){
			data.nNum++;
			nLvl = PS_GetLevel(oMember);
			if (nLvl > data.nMax)
				data.nMax = nLvl;
			nTotal += nLvl;
		}
        oMember = GetNextFactionMember(oPC, TRUE);     
	}
 
	data.fAvg = IntToFloat(nTotal) / IntToFloat(data.nNum);
	return data;
}

// this is not resused or used elsewhere, it's just its own function for 
// the sake of main's readability
object PS_GetKiller(){
	object oKiller = GetLastKiller();
    if (GetIsObjectValid(GetLocalObject(OBJECT_SELF, abilityCaster)))  {
        oKiller = GetLocalObject(OBJECT_SELF, abilityCaster);
    }
    if (GetIsObjectValid(GetLocalObject(oKiller, abilityCaster)))  {
        oKiller = GetLocalObject(oKiller, abilityCaster);
    }
    while (GetIsObjectValid(GetMaster(oKiller))){
        oKiller=GetMaster(oKiller);
    }
	return oKiller;
}

// add smalladditional xp bonus for group that scales based on party size
float GetPartyXPBonus(float fAvgLevel, float fCR, int nNum){
	if (nNum < 2) return 0.0;

	float fPartyBoost;
	if (fCR < fAvgLevel) fPartyBoost = 0.1;  
	else fPartyBoost = (log(fCR) / fAvgLevel) * 0.5; 
	if (fPartyBoost < 0.01) fPartyBoost = 0.01;
	
	float fPartySizeMult = 1.0 + (FloatToInt(nNum - 1.0) * 0.0625);
	if (fPartySizeMult > 1.25) fPartySizeMult = 1.25;
	return fPartyBoost * fPartySizeMult;
}

float GetBaseXP(float fLevel, float fCR, int nNum){
	// if the level (whether party average or solo) is more than 25 higher than CR, 
	// then no xp
	if (fLevel - fCR > 5.0 && nNum == 1) return 0.0;

    float fXP = BASEXP;
	
	if (fCR != fLevel){
		if(fCR > fLevel){
			// this calibrates for a lvl 30 to get BASEXP * 3 for a CR 99
			fXP *= (1.0 + (3.15 * log(1.0 + fCR / fLevel) / 2.302));
		} else { //For lower CR give xp penalty
			fXP *= pow(0.843, fLevel - fCR);
		}
	}

	if (nNum > 1)
		fXP *= 1.0 + GetPartyXPBonus(fLevel, fCR, nNum);
	
    return fXP;
}


/* Previous tries
struct PartyData{
int nMax;
float fAvg;
int nNum;
};

int GetPCtotalCR(object oPC);
struct PartyData GetPartyData(object oPC);
object GetKiller(object oDead);
object PS_GetKiller();

void main(){
	object oDead = OBJECT_SELF;
	object oKiller = PS_GetKiller();
	if(GetIsDM(oKiller) || oKiller == OBJECT_SELF) return;
	
	
	string sDeathScript = GetLocalString(oDead, "DeathScript");
	if (sDeathScript != "")
		ExecuteScript(sDeathScript, oDead);
	
	  // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
		
	object oArea = GetArea(oKiller);
    float fCR = GetChallengeRating(oDead);
	struct PartyData data = GetPartyData(oKiller);
	
	
	
	int iElite = StringToInt(GetLocalString(oDead,"ELITE"));
    if(iElite > 0){
        if (data.fAvg + 5.0 < 10.0 * iElite) fCR += 3.0;
        else fCR += 2.0 - log(IntToFloat(data.nNum));
    } 
	
	int bGiveGold = (GetLocalInt(oDead, "X2_L_NOTREASURE") == FALSE
		&& GetRacialType(oDead) != RACIAL_TYPE_ANIMAL
		&& GetRacialType(oDead) != RACIAL_TYPE_BEAST
		&& GetRacialType(oDead) != RACIAL_TYPE_CONSTRUCT
		&& GetRacialType(oDead) != RACIAL_TYPE_ELEMENTAL
		&& GetRacialType(oDead) != RACIAL_TYPE_VERMIN);
	
	int nGold;
	int nHD = GetHitDice(oDead);
	if (nHD >= 30) nGold = d8(3);
	else if (nHD < 30 && nHD >= 20) nGold = d12(2);
	else if (nHD < 20 && nHD >= 10) nGold = d10(2);
	else nGold = d20();

	
	float fPartylevel = IntToFloat(data.nMax) - (log(IntToFloat(data.nMax) - data.fAvg + 1.0) * 1.5);
	float fPartyXPB = 1.0 + log(IntToFloat(data.nNum)) / PARTYBONUS_XP_DIVIDER;
	float fFinalXP = BASEXP;
	if (iElite > 0) fFinalXP *= 1.5;
	
	if(fCR >= fPartylevel){
		fFinalXP *= fPartyXPB;
	} else { //For lower CR give xp penalty
		fFinalXP = BASEXP * fPartyXPB / (fPartylevel - fCR + 1.0);
	}
	// the more party members there are, the better the xp
	if (data.nNum == 1) fFinalXP *= 0.25;
	else if (data.nNum == 2) fFinalXP *= 0.5;
	else if (data.nNum == 3) fFinalXP *= 0.75;
		
    int nLevel = 0;
    int nFinalXP = 0;
    int rp_pool = 0;
    string sID = "";
	string sMetagaming = "You have surpassed the required XP to level up.";
	sMetagaming += "\nYour XP is now being calculated as though you were level ";
	
	object oMember = GetFirstFactionMember(oKiller, TRUE);
    while(GetIsObjectValid(oMember)){
		if (oArea == GetArea(oMember) && bGiveGold)
			PS_GiveGoldToCreature(oMember,nGold);
			
		nLevel = PS_GetLevelByXP(oMember);
		if (nLevel > GetHitDice(oMember)){
			SendMessageToPC(oMember, sMetagaming + IntToString(nLevel) + ".");
		}
		int nECL = GetNewECL(oMember);
		// if the player is below the party range (excluding highest ecl, including their own), 
		// or they are above the party average, then treat them, xp wise, same as the highest 
		// level party member
		if (data.nMax - MAXPARTYRANGE > nLevel + nECL || FloatToInt(nLevel) > fPartylevel){
			nLevel = data.nMax;
		} else {
			fFinalXP *= fPartylevel / IntToFloat(nLevel);
		}
		
		if (fFinalXP > MAXMONSTERXP) fFinalXP = MAXMONSTERXP;
		
		nFinalXP = PS_RoundToInt(fFinalXP);
		if (nFinalXP < 1 && PS_RoundToInt(fCR) >= nLevel - MAXPARTYRANGE)
			nFinalXP = 1;
			
		if(nFinalXP > 0){
			sID = PS_GetCharID(oMember);
			//SendMessageToPC(oPartyMember,"id:" + sID);
			SQLExecDirect("SELECT rp_pool FROM characterdata WHERE id=" + sID);
			if (SQLFetch() != SQL_ERROR) { 
				rp_pool = StringToInt(SQLGetData(1));
				if (rp_pool > nFinalXP){
					rp_pool -= nFinalXP;
					nFinalXP += nFinalXP;
				} else if (rp_pool > 0 ){
					nFinalXP += rp_pool;
					rp_pool = 0;
				}
				SQLExecDirect("UPDATE characterdata SET rp_pool=" + IntToString(rp_pool) + " WHERE id=" + sID); 
			}
			PS_GiveXPReward(oMember, nFinalXP);
		} 
		oMember = GetNextFactionMember(oKiller, TRUE);
	}
}


struct PartyData GetPartyData(object oPC){
	object oArea = GetArea(oPC);
	struct PartyData data;
	data.nMax = 0;
	data.fAvg = 0.0;
	data.nNum = 0;
	int nLvl = 0;
	int nTotal = 0;
	object oMember = GetFirstFactionMember(oPC, TRUE);
    while(GetIsObjectValid(oMember)){ 
		if (GetArea(oMember) == oArea){
			data.nNum++;
			nLvl = PS_GetLevel(oMember);
			if (nLvl > data.nMax)
				data.nMax = nLvl;
			nTotal += nLvl;
		}
        oMember = GetNextFactionMember(oPC, TRUE);     
	}
 
	data.fAvg = IntToFloat(nTotal) / IntToFloat(data.nNum);
	return data;
}

object PS_GetKiller(){
	object oKiller = GetLastKiller();
    if (GetIsObjectValid(GetLocalObject(OBJECT_SELF, abilityCaster)))  {
        oKiller = GetLocalObject(OBJECT_SELF, abilityCaster);
    }
    if (GetIsObjectValid(GetLocalObject(oKiller, abilityCaster)))  {
        oKiller = GetLocalObject(oKiller, abilityCaster);
    }
    while (GetIsObjectValid(GetMaster(oKiller))){
        oKiller=GetMaster(oKiller);
    }
	return oKiller;
}



int GetPCtotalCR(object oPC){
	int nLevel = PS_GetLevel(oPC);
	//int nECL = GetNewECL(oPC);
	//int nCR = PS_RoundToInt(GetChallengeRating(oPC));
	//if (nCR < 0) nCR = 0;
	//else if (nCR > 5) nCR = 5;
	return nLevel //+ nECL + nCR;
}


void main()
{
    object oKiller = GetLastKiller();
    if(GetIsDM(oKiller) || oKiller == OBJECT_SELF)
        return;
        
    object oDead = OBJECT_SELF;

    if (GetIsObjectValid(GetLocalObject(OBJECT_SELF, abilityCaster)))  {
        oKiller = GetLocalObject(OBJECT_SELF, abilityCaster);
    }
    if (GetIsObjectValid(GetLocalObject(oKiller, abilityCaster)))  {
        oKiller = GetLocalObject(oKiller, abilityCaster);
    }
    
    object oArea = GetArea(oKiller);
    while (GetIsObjectValid(GetMaster(oKiller))){
        oKiller=GetMaster(oKiller);
    }

    float fCR = GetChallengeRating(oDead);
    
    int iMAX = PS_GetMaxPartylevel(oKiller);
    float fAVG = PS_GetAvgPartylevel(oKiller, iMAX);    
    int iPartySize = PS_GetNumPC(oKiller);
    
    int iElite = StringToInt(GetLocalString(oDead,"ELITE"));
    if(iElite > 0)
    {
        if (fAVG+5.0 < 10.0 * iElite)
            fCR = fCR + 3.0;
        else
            fCR = fCR + 2.0 - log(IntToFloat(iPartySize));
    }
    
    float fPartyXPB = 1.0 + log(IntToFloat(iPartySize))/PARTYBONUS_XP_DIVIDER;
    
    float fTooLow = 1.0;
    int nLevel = 0;
    float fFinalXP = 0.0;
    int nFinalXP = 0;
    int nECL = 0;
    int rp_pool = 0;
    string sID = "";
    int iHD;
    float fAdjustedCR;
    float fPartylevel;
    
    object oPartyMember = GetFirstFactionMember(oKiller, TRUE);
    
    while(GetIsObjectValid(oPartyMember) == TRUE){
    
        fAdjustedCR = fCR;
		int nActualLevel = PS_GetLevelByXP(oPartyMember);
		if (nActualLevel > GetHitDice(oPartyMember)){
			string sMetagaming = "You have surpassed the requied XP to level up.";
			sMetagaming += "\nYour XP is now being calculated as though you were level ";
			sMetagaming += IntToString(nActualLevel) + ".";
			SendMessageToPC(oPartyMember, sMetagaming);
		}
        
        if (oArea == GetArea(oPartyMember)){
            if (GetLocalInt(OBJECT_SELF, "X2_L_NOTREASURE") == FALSE
                && GetRacialType(OBJECT_SELF) != RACIAL_TYPE_ANIMAL
                && GetRacialType(OBJECT_SELF) != RACIAL_TYPE_BEAST
                && GetRacialType(OBJECT_SELF) != RACIAL_TYPE_CONSTRUCT
                && GetRacialType(OBJECT_SELF) != RACIAL_TYPE_ELEMENTAL
                && GetRacialType(OBJECT_SELF) != RACIAL_TYPE_VERMIN){
                PS_GiveGoldToCreature(oPartyMember,d20());
            }
            
            nLevel = PS_GetLevel(oPartyMember);
            nECL = GetNewECL(oPartyMember);
            
            
            if(nLevel < iMAX-MAXPARTYRANGE){
                //fTooLow = pow(0.9, fAVG - nLevel); //Reduce xp for those outside party range
                
                // if the pc is below lvl range, then they are awarded xp based on if the 
                // killed creature is their own level
                if (FloatToInt(fCR) > nLevel){
                    fAdjustedCR = IntToFloat(nLevel);
                    fPartylevel = fAdjustedCR;
                }
            } else fPartylevel = IntToFloat(iMAX) - (log(IntToFloat(iMAX)-fAVG+1.0) * 1.5);
            
            
            //Stop characters from getting too much xp
            if( nLevel == 30 && !ALLOW_ECL_LEVEL_30)
            {
                int xp = GetXP(oPartyMember);
                
                if ( xp > (435000-(29500-500*(nECL-1))*(nECL-1)) - 100 )
                    fTooLow = 0.0;
            }
            //
            
			// Removed level 25+ XP nerf as per Ed and Jelkia, -FlattedFifth
		
           // if(nLevel > 24) //25th level and up get xp penalty
           // {
           //     fTooLow = fTooLow * (30 - nLevel) / 6;
                //the above has lvl 30 chars getting 0 xp for lvl 30 kills, 
                // so lets set a minimum
            //    if (fTooLow < 0.05) fTooLow = 0.05;
           // }
		
            
            if(fAdjustedCR>=fPartylevel)
            {

                fFinalXP = (BASEXP+(BASEXP*(fAdjustedCR-fPartylevel)*CRBONUS)) * fTooLow * fPartyXPB;
            }
            else //For lower CR give xp penalty
            {

                fFinalXP = BASEXP * fTooLow * fPartyXPB / (fPartylevel - fAdjustedCR + 1.0);
            }
            
            if( nECL > 0)
                fFinalXP=fFinalXP*PS_GetXPModifier(nECL);
                                                            
            if(fFinalXP>MAXMONSTERXP) //In case someone manages to find a loophole that
                fFinalXP=MAXMONSTERXP;//gives alot of xp this limits the max xp awarded

                
            nFinalXP = FloatToInt(fFinalXP);
            
            //a kill should be at least 1 xp if the CR of the creature is not more than 10
            // less than the character -FlattedFifth, August 26, 2025
            if (nLevel - PS_RoundToInt(fAdjustedCR) <= MAXPARTYRANGE && nFinalXP < 1)         nFinalXP = 1;
                
            if(nFinalXP > 0)
            {
                sID = PS_GetCharID(oPartyMember);
                //SendMessageToPC(oPartyMember,"id:" + sID);
                SQLExecDirect("SELECT rp_pool FROM characterdata WHERE id=" + sID);
                if (SQLFetch() != SQL_ERROR) { 
                    rp_pool = StringToInt(SQLGetData(1));
                    //SendMessageToPC(oPartyMember,"rp_pool:" + IntToString(rp_pool));
                    if ( rp_pool > nFinalXP )
                    {
                        rp_pool -= nFinalXP;
                        nFinalXP += nFinalXP;
                    }
                    else if ( rp_pool > 0 )
                    {
                        nFinalXP += rp_pool;
                        rp_pool = 0;
                    }
                    
                    SQLExecDirect("UPDATE characterdata SET rp_pool=" + IntToString(rp_pool) + " WHERE id=" + sID); 
                }
                PS_GiveXPReward(oPartyMember, nFinalXP);
            }   
        }
        
        oPartyMember = GetNextFactionMember(oKiller, TRUE);
    }
    
}
*/