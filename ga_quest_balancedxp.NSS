#include "ps_inc_functions"
#include "nwnx_sql"

void main (float fCR) {
	object oPC = GetLastSpeaker();
	
	int BASEQUESTXP = 100;
	int iMAX = PS_GetMaxPartylevel(oPC);
	float fAVG = PS_GetAvgPartylevel(oPC, iMAX);	
	int iPartySize = PS_GetNumPC(oPC);
	
	float fPartyXPB = 1.0 + log(IntToFloat(iPartySize))/PARTYBONUS_XP_DIVIDER;
	
	float fTooLow = 1.0;
	int iMemberlevel = 0;
	float fFinalXP = 0.0;
	int nFinalXP = 0;
	int iECL = 0;
	int rp_pool = 0;
	string sID = "";
	
	object oPartyMember = GetFirstFactionMember(oPC, TRUE);
	
    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
		if (GetArea(oPC) == GetArea(oPartyMember))
		{	
			iMemberlevel = PS_GetLevel(oPartyMember);
			iECL = iMemberlevel - GetHitDice(oPartyMember);
			
			if(iMemberlevel<iMAX-MAXPARTYRANGE)
			{
				fTooLow = pow(0.9, fAVG - iMemberlevel); //Reduce xp for those outside party range
			}
			else
			{
				fTooLow = 1.0;
			}
			
			//Stop characters from getting too much xp
			if( iMemberlevel == 30 )
			{
				int xp = GetXP(oPartyMember);
				
				if ( xp > (435000-(29500-500*(iECL-1))*(iECL-1)) - 100 )
					fTooLow = 0.0;
			}
			//
			
			if(iMemberlevel > 24) //25th level and up get xp penalty
			{
				fTooLow = fTooLow * (30 - iMemberlevel) / 6;
			}
			
			//20110625: new xp fix, calculate a leven that the party is considered as
			float fPartylevel = IntToFloat(iMAX) - (log(IntToFloat(iMAX)-fAVG+1.0) * 1.5);
			
			//**if(fCR>=fAVG) //For higher CR creatures give a xp bonus
			//***if(fCR>=IntToFloat(iMAX))
			if(fCR>=fPartylevel)
			{
				//**fFinalXP = (BASEQUESTXP+(BASEQUESTXP*(fCR-fAVG)*CRBONUS)) * fTooLow * fPartyXPB;
				//***fFinalXP = (BASEQUESTXP+(BASEQUESTXP*(fCR-IntToFloat(iMAX))*CRBONUS)) * fTooLow * fPartyXPB;
				fFinalXP = (BASEQUESTXP+(BASEQUESTXP*(fCR-fPartylevel)*CRBONUS)) * fTooLow * fPartyXPB;
			}
			else //For lower CR give xp penalty
			{
				//**fFinalXP = BASEQUESTXP * fTooLow * fPartyXPB / (fAVG - fCR + 1.0);
				fFinalXP = BASEQUESTXP * fTooLow * fPartyXPB / (fPartylevel - fCR + 1.0);
			}
			
			if( iECL > 0)
				fFinalXP=fFinalXP*PS_GetXPModifier(iECL);
															
			if(fFinalXP>MAXMONSTERXP) //In case someone manages to find a loophole that
				fFinalXP=MAXMONSTERXP;//gives alot of xp this limits the max xp awarded
			
			nFinalXP = FloatToInt(fFinalXP);
				
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
				GiveXPToCreature(oPartyMember, nFinalXP);
			}	
		}
			
		//ugly debuginfo	
		//SendMessageToPC(oPC,GetName(oPC)+"'s XP Base: "+IntToString(BASEQUESTXP)+" CR: "
		//	+FloatToString(fCR)+" Low Level Penalty "+FloatToString(fTooLow)+" Party Bonus: "
		//	+FloatToString(fPartyXPB)+" Avg Level: "+FloatToString(fAVG));
		
        oPartyMember = GetNextFactionMember(oPC, TRUE);
    }
}
