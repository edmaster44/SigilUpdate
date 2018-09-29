/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

//Original ga_take_gold passed the gold to the one who initiated the convo, meaning in convo trees where
//they are the originator they get the gold back!

void main(int nGold, int bAllPartyMembers)
{

    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oTarg;

    if ( bAllPartyMembers == 0 )
    {
        TakeGoldFromCreature( nGold,oPC, TRUE, TRUE );
    }
    else    
    {// For multiple players
        oTarg = GetFirstFactionMember(oPC);
        while ( GetIsObjectValid(oTarg) )
        {
            TakeGoldFromCreature( nGold,oTarg, TRUE, TRUE);
            oTarg = GetNextFactionMember(oPC);
        }
    }

}