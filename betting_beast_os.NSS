//::///////////////////////////////////////////////
//:: Default: On Spawn In
//:: NW_C2_DEFAULT9
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    On spawn in script that sets listening patterns
	for the "bear baiting"
*/
//:://////////////////////////////////////////////
//:: Created By: Mimi Fearthegn
//:: Created On: July 18, 2015
//:://////////////////////////////////////////////
#include "NW_O2_CONINCLUDE"
#include "NW_I0_GENERIC"
#include "gm_include"

void main()
{
    SetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT);      //OPTIONAL BEHAVIOR - Fire User Defined Event 1004

    SetListeningPatterns();    // Goes through and sets up which shouts the NPC will listen to.
    SetListening(OBJECT_SELF, TRUE);
	
    SetListenPattern(OBJECT_SELF, "10 on "+DEINONYCHUS, 0071);
    SetListenPattern(OBJECT_SELF, "50 on "+DEINONYCHUS, 0072);
    SetListenPattern(OBJECT_SELF, "100 on "+DEINONYCHUS, 0073);
    SetListenPattern(OBJECT_SELF, "500 on "+DEINONYCHUS, 0074);
    SetListenPattern(OBJECT_SELF, "1000 on "+DEINONYCHUS, 0075);
	
    SetListenPattern(OBJECT_SELF, "10 on "+SPIDER, 0061);
    SetListenPattern(OBJECT_SELF, "50 on "+SPIDER, 0062);
    SetListenPattern(OBJECT_SELF, "100 on "+SPIDER, 0063);
    SetListenPattern(OBJECT_SELF, "500 on "+SPIDER, 0064);
    SetListenPattern(OBJECT_SELF, "1000 on "+SPIDER, 0065);
	
    SetListenPattern(OBJECT_SELF, "10 on "+LION, 0051);
    SetListenPattern(OBJECT_SELF, "50 on "+LION, 0052);
    SetListenPattern(OBJECT_SELF, "100 on "+LION, 0053);
    SetListenPattern(OBJECT_SELF, "500 on "+LION, 0054);
    SetListenPattern(OBJECT_SELF, "1000 on "+LION, 0055);
	
    SetListenPattern(OBJECT_SELF, "10 on "+TIGER, 0041);
    SetListenPattern(OBJECT_SELF, "50 on "+TIGER, 0042);
    SetListenPattern(OBJECT_SELF, "100 on "+TIGER, 0043);
    SetListenPattern(OBJECT_SELF, "500 on "+TIGER, 0044);
    SetListenPattern(OBJECT_SELF, "1000 on "+TIGER, 0045);
	
    SetListenPattern(OBJECT_SELF, "10 on "+NIGHTMARE, 0031);
    SetListenPattern(OBJECT_SELF, "50 on "+NIGHTMARE, 0032);
    SetListenPattern(OBJECT_SELF, "100 on "+NIGHTMARE, 0033);
    SetListenPattern(OBJECT_SELF, "500 on "+NIGHTMARE, 0034);
    SetListenPattern(OBJECT_SELF, "1000 on "+NIGHTMARE, 0035);
	
    SetListenPattern(OBJECT_SELF, "10 on "+DISPLACER_BEAST, 0021);
    SetListenPattern(OBJECT_SELF, "50 on "+DISPLACER_BEAST, 0022);
    SetListenPattern(OBJECT_SELF, "100 on "+DISPLACER_BEAST, 0023);
    SetListenPattern(OBJECT_SELF, "500 on "+DISPLACER_BEAST, 0024);
    SetListenPattern(OBJECT_SELF, "1000 on "+DISPLACER_BEAST, 0025);
	
    SetListenPattern(OBJECT_SELF, "10 on "+BEAR, 0011);
    SetListenPattern(OBJECT_SELF, "50 on "+BEAR, 0012);
    SetListenPattern(OBJECT_SELF, "100 on "+BEAR, 0013);
    SetListenPattern(OBJECT_SELF, "500 on "+BEAR, 0014);
    SetListenPattern(OBJECT_SELF, "1000 on "+BEAR, 0015);
	
    SetListenPattern(OBJECT_SELF, "10 on "+WOLF, 0001);
    SetListenPattern(OBJECT_SELF, "50 on "+WOLF, 0002);
    SetListenPattern(OBJECT_SELF, "100 on "+WOLF, 0003);
    SetListenPattern(OBJECT_SELF, "500 on "+WOLF, 0004);
    SetListenPattern(OBJECT_SELF, "1000 on "+WOLF, 0005);
}