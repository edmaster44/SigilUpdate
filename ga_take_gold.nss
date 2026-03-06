// ga_take_gold
/*
    This takes gold from a player
        nGold    	= The amount of gold to take
        bAllPartyMembers     = If set to 1 it takes gold from all PCs in party (MP only)
*/
// FAB 4/28/05
// MDiekmann 4/9/07 -- using GetFirst and NextFactionMember() instead of GetFirst and NextPC(), changed nAllPCs to bAllPartyMembers
#include "ps_inc_financial"

void main(int nGold, int bAllPartyMembers)
{

    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oTarg;

    if ( bAllPartyMembers == 0 )
    {
        PS_TakeGoldFromCreature(nGold, oPC);
    }
    else    
    {// For multiple players
        oTarg = GetFirstFactionMember(oPC);
        while ( GetIsObjectValid(oTarg) )
        {
            PS_TakeGoldFromCreature( nGold,oTarg );
            oTarg = GetNextFactionMember(oPC);
        }
    }

}