

//::///////////////////////////////////////////////
//:: OnUse: Sit
//:://////////////////////////////////////////////

void main()
{
    object oChair = OBJECT_SELF;
    object oSitter = GetLastUsedBy();
    location lChair = GetLocation(oChair);
    int heading = GetLocalInt(oChair, "degree");
    int PC_size = GetLocalInt(oChair, "size");
    
    //Check for Character Race with original Creature Size
    switch (PC_size)
    {
    case 0:
        //Check for Character Race with original Creature Size
        if(    	((GetRacialType(oSitter) == RACIAL_TYPE_ELF) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
    			((GetRacialType(oSitter) == RACIAL_TYPE_HALFELF) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
			    ((GetRacialType(oSitter) == RACIAL_TYPE_HALFORC) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
			    ((GetRacialType(oSitter) == RACIAL_TYPE_HUMAN) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
			    ((GetSubRace(oSitter) == RACIAL_SUBTYPE_AASIMAR) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
			    ((GetSubRace(oSitter) == RACIAL_SUBTYPE_TIEFLING) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
				((GetSubRace(oSitter) == RACIAL_SUBTYPE_AIR_GENASI) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
				((GetSubRace(oSitter) == RACIAL_SUBTYPE_EARTH_GENASI) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
				((GetSubRace(oSitter) == RACIAL_SUBTYPE_FIRE_GENASI) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
				((GetSubRace(oSitter) == RACIAL_SUBTYPE_WATER_GENASI) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
				((GetSubRace(oSitter) == RACIAL_SUBTYPE_YUANTI) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
				((GetSubRace(oSitter) == RACIAL_SUBTYPE_GRAYORC) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
				((GetSubRace(oSitter) == RACIAL_SUBTYPE_WILD_ELF) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)))
		 
        {
            //Check the heading degrees
			 float orientation = GetFacingFromLocation(lChair) + heading; // this is the opposite way!
			 orientation = 180 + orientation;
             lChair = Location(GetArea(oChair), GetPositionFromLocation(lChair), orientation);
        
            if(GetIsObjectValid(oChair) && GetIsObjectValid(oSitter))
            {
                AssignCommand(oSitter, ActionJumpToLocation(lChair));
                PlayCustomAnimation(oSitter, "sitidle", 1);
            }
        }
        else
            SpeakOneLinerConversation();
        break;

    case 1:
        //Check for Character Race with original Creature Size
        if(     ((GetRacialType(oSitter) == RACIAL_TYPE_ELF) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
    			((GetRacialType(oSitter) == RACIAL_TYPE_HALFELF) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
			    ((GetRacialType(oSitter) == RACIAL_TYPE_HALFORC) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
			    ((GetRacialType(oSitter) == RACIAL_TYPE_HUMAN) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
			    ((GetSubRace(oSitter) == RACIAL_SUBTYPE_AASIMAR) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
			    ((GetSubRace(oSitter) == RACIAL_SUBTYPE_TIEFLING) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
				((GetSubRace(oSitter) == RACIAL_SUBTYPE_AIR_GENASI) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
				((GetSubRace(oSitter) == RACIAL_SUBTYPE_EARTH_GENASI) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
				((GetSubRace(oSitter) == RACIAL_SUBTYPE_FIRE_GENASI) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
				((GetSubRace(oSitter) == RACIAL_SUBTYPE_WATER_GENASI) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)) ||
				((GetSubRace(oSitter) == RACIAL_SUBTYPE_WILD_ELF) && (GetCreatureSize(oSitter) == CREATURE_SIZE_MEDIUM)))
		    
        {
            //Check the heading degrees
			 float orientation = GetFacingFromLocation(lChair) + heading; // this is the opposite way!
			 orientation = 180 + orientation;
             lChair = Location(GetArea(oChair), GetPositionFromLocation(lChair), orientation);
        
            if(GetIsObjectValid(oChair) && GetIsObjectValid(oSitter))
            {
                AssignCommand(oSitter, ActionJumpToLocation(lChair));
                PlayCustomAnimation(oSitter, "sitidle", 1);
            }
        }
        else
            SpeakOneLinerConversation();
        break;

    default:
        //Character with no original Race and/or Creature size
        SpeakOneLinerConversation();
        break;
    }
}