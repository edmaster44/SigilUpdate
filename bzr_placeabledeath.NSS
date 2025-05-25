#include "ps_inc_functions"
#include "nwnx_sql"

void main()
{
	effect spawn = EffectNWN2SpecialEffectFile("fx_wooden_explosion_big", OBJECT_SELF);
	ApplyEffectToObject(0, spawn, OBJECT_SELF);
	
	/*string sTrap = GetLocalString(OBJECT_SELF, "ASSOCIATED_TRAP");
	if (sTrap != "") {
		object oTrap = GetNearestObjectByTag(sTrap);
		if (GetIsObjectValid(oTrap)) {
			SetTrapActive(oTrap, FALSE);
		}
	}*/
		
	object oKiller = GetLastKiller();
	if(GetIsDM(oKiller) || oKiller == OBJECT_SELF)
	{
		return;
	}
	object oArea = GetArea(oKiller);
	while (GetIsObjectValid(GetMaster(oKiller)))
   	{
   		oKiller=GetMaster(oKiller);
   	}
		
	object oDead = (OBJECT_SELF);

	float fCR = IntToFloat(GetLocalInt(OBJECT_SELF, "CR"));
	
	int iMAX = PS_GetMaxPartylevel(oKiller);
	float fAVG = PS_GetAvgPartylevel(oKiller, iMAX);	
	int iPartySize = PS_GetNumPC(oKiller);
	
	float fPartyXPB = 1.0 + log(IntToFloat(iPartySize))/PARTYBONUS_XP_DIVIDER;
	
	float fTooLow = 1.0;
	int iMemberlevel = 0;
	float fFinalXP = 0.0;
	int nFinalXP = 0;
	int iECL = 0;
	int rp_pool = 0;
	string sID = "";
	
	object oPartyMember = GetFirstFactionMember(oKiller, TRUE);
	
    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
		if (oArea == GetArea(oPartyMember))
		{
	    	if (GetLocalInt(OBJECT_SELF, "X2_L_NOTREASURE") == FALSE
				&& GetRacialType(OBJECT_SELF) != RACIAL_TYPE_ANIMAL
				&& GetRacialType(OBJECT_SELF) != RACIAL_TYPE_BEAST
				&& GetRacialType(OBJECT_SELF) != RACIAL_TYPE_CONSTRUCT
				&& GetRacialType(OBJECT_SELF) != RACIAL_TYPE_ELEMENTAL
				&& GetRacialType(OBJECT_SELF) != RACIAL_TYPE_VERMIN)
			{
				GiveGoldToCreature(oPartyMember,d20());
			}
			
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
			
			float fPartylevel = IntToFloat(iMAX) - (log(IntToFloat(iMAX)-fAVG+1.0) * 1.5);
			
			if(fCR>=fPartylevel)
			{
				fFinalXP = (BASEXP+(BASEXP*(fCR-fPartylevel)*CRBONUS)) * fTooLow * fPartyXPB;
			}
			else //For lower CR give xp penalty
			{
				fFinalXP = BASEXP * fTooLow * fPartyXPB / (fPartylevel - fCR + 1.0);
			}
			
			if( iECL > 0)
				fFinalXP=fFinalXP*PS_GetXPModifier(iECL);
															
			if(fFinalXP>MAXMONSTERXP) //In case someone manages to find a loophole that
				fFinalXP=MAXMONSTERXP;//gives alot of xp this limits the max xp awarded
			
			nFinalXP = FloatToInt(fFinalXP);
				
			if(nFinalXP > 0)
			{
				sID = PS_GetCharID(oPartyMember);
				SQLExecDirect("SELECT rp_pool FROM characterdata WHERE id=" + sID);
				if (SQLFetch() != SQL_ERROR) { 
					rp_pool = StringToInt(SQLGetData(1));
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