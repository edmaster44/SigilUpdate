//V. 1.03

#include "ps_inc_functions"
#include "ps_inc_onhit"
#include "nwnx_sql"

struct PartyData{
int nMax;
float fAvg;
int nNum;
};

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

	
	
	float fPartyXPB = 1.0 + log(IntToFloat(data.nNum)) / PARTYBONUS_XP_DIVIDER;
    int nLevel = 0;
	int nBaseLevel = 0;
    float fFinalXP = 0.0;
    int nFinalXP = 0;
    int nECL = 0;
    int rp_pool = 0;
    string sID = "";
    int iHD;
    float fPartylevel = IntToFloat(data.nMax) - (log(IntToFloat(data.nMax) - data.fAvg + 1.0) * 1.5);
	string sMetagaming = "You have surpassed the required XP to level up.";
	sMetagaming += "\nYour XP is now being calculated as though you were level ";
	
	object oMember = GetFirstFactionMember(oKiller, TRUE);
    while(GetIsObjectValid(oMember)){
		if (oArea == GetArea(oMember) && bGiveGold){
			if (fCR >= 30.0) nGold = d8(3);
			else if (fCR < 30.0 && fCR >= 20.0) nGold = d12(2);
			else if (fCR < 20.0 && fCR >= 10.0) nGold = d10(2);
			else nGold = d20();
			PS_GiveGoldToCreature(oMember,nGold);
		}	
		
		nLevel = PS_GetLevelByXP(oMember);
		if (nLevel > GetHitDice(oMember)){
			SendMessageToPC(oMember, sMetagaming + IntToString(nLevel) + ".");
		}
		
		// if the player is below the party range (excluding highest ecl, including their own, 
		// then treat them, xp wise, same as the highest level party member
		if (data.nMax - MAXPARTYRANGE > nLevel + GetNewECL(oMember)){
			nLevel = data.nMax;
		}
		
		if(fCR >= fPartylevel){
			fFinalXP = (BASEXP + (BASEXP * (fCR - fPartylevel) * CRBONUS)) * fPartyXPB;
        } else { //For lower CR give xp penalty
			fFinalXP = BASEXP * fPartyXPB / (fPartylevel - fCR + 1.0);
        }

		if (fFinalXP > MAXMONSTERXP) fFinalXP = MAXMONSTERXP;
		
		nFinalXP = PS_RoundToInt(fFinalXP);
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
	struct PartyData data;
	data.nMax = 0;
	data.fAvg = 0.0;
	data.nNum = 0;
	int nLvl = 0;
	int nTotal = 0;
	object oMember = GetFirstFactionMember(oPC, TRUE);
    while(GetIsObjectValid(oMember)){ 
		data.nNum++;
		nLvl = PS_GetLevel(oMember);
		if (nLvl > data.nMax)
			data.nMax = nLvl;
		nTotal += nLvl;
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
/* original
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