/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

//Original ga_take_gold passed the gold to the one who initiated the convo, meaning in convo trees where
//they are the originator they get the gold back!
#include "dethia_shop_sys"

void main(int nGold, int bAllPartyMembers)
{

    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oTarg;

    if ( bAllPartyMembers == 0 )
    {
		DS_TakeCoinsFromCreature(oPC, nGold);
    }
    else    
    {// For multiple players
        oTarg = GetFirstFactionMember(oPC);
        while ( GetIsObjectValid(oTarg) )
        {
			DS_TakeCoinsFromCreature(oTarg, nGold);
            oTarg = GetNextFactionMember(oPC);
        }
    }

}