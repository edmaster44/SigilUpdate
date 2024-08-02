#include "ps_inc_functions"

void main(int nXP, int bAllPartyMembers, int nLevelvaried)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	float fXP=0.0;
	int iECL=0;
	
    if ( bAllPartyMembers == 0 )
	{
	 iECL = PS_GetEssenceECL(oPC);
	 if ( nLevelvaried > 0 )
	 {
	 	fXP = nXP * 3.0 / (2+GetHitDice(oPC)+iECL) * PS_GetXPModifier(iECL);
	 }
	 else
	 {
	 	fXP = nXP * PS_GetXPModifier(iECL);
	 }
	 PS_GiveXPReward(oPC, FloatToInt(fXP) );
	}
    else
    {
        object oTarg = GetFirstFactionMember(oPC);
        while(GetIsObjectValid(oTarg))
        {
			 iECL = PS_GetEssenceECL(oTarg);
			 if ( nLevelvaried > 0 )
			 {
			 	fXP = nXP * 3.0 / (2+GetHitDice(oTarg)+iECL) * PS_GetXPModifier(iECL);
			 }
			 else
			 {
			 	fXP = nXP * PS_GetXPModifier(iECL);
			 }
			 GiveXPToCreature(oTarg, FloatToInt(fXP) );

            oTarg = GetNextFactionMember(oPC);
        }
    }

}