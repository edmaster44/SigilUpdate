#include "ff_safevar"

//Put this script OnEnter
void ps_delayspawnMino()
{
	
	object oWPmino1 = GetObjectByTag("wp_bjevent_minotaur1");
	object oWPmino2 = GetObjectByTag("wp_bjevent_minotaur2");
	object oWPmino3 = GetObjectByTag("wp_bjevent_minotaur3");
	object oWPmino4 = GetObjectByTag("wp_bjevent_minotaur4");
	
	object oFlee = GetObjectByTag("wp_bjevent_flee");
	
	location lWPmino1 = GetLocation(oWPmino1);
	location lWPmino2 = GetLocation(oWPmino2);
	location lWPmino3 = GetLocation(oWPmino3);
	location lWPmino4 = GetLocation(oWPmino4);

	object oSpawn1 = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_minotaur1", lWPmino1);
	object oSpawn2 = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_minotaur1", lWPmino2);
	object oSpawn3 = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_minotaur1", lWPmino3);	
	object oSpawn4 = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_minotaur1", lWPmino4);
	
	DelayCommand(1.0, AssignCommand(oSpawn1, ActionMoveAwayFromObject(oFlee, FALSE, 5.0)));
	DelayCommand(1.0, AssignCommand(oSpawn2, ActionMoveAwayFromObject(oFlee, FALSE, 5.0)));
	DelayCommand(1.0, AssignCommand(oSpawn3, ActionMoveAwayFromObject(oFlee, FALSE, 5.0)));
	DelayCommand(1.0, AssignCommand(oSpawn4, ActionMoveAwayFromObject(oFlee, FALSE, 5.0)));
   
}

void ps_delayspawnWyvn()
{
	object oWPwyver = GetObjectByTag("wp_bjevent_blightwyvern");

	location lWPwyver = GetLocation(oWPwyver);

	object oSpawnW = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_blightwyvern", lWPwyver);	
}

void main()
{

object oPC = GetEnteringObject();
object oTrigger = GetObjectByTag("ps_bjevent_trigger"); 

if (PS_GetLocalInt(oTrigger, "Used") != TRUE)

{
if (!GetIsPC(oPC)) return;

	object oSpeaker = GetObjectByTag("ps_bjevent_hoxun");
	object oDoor1 = GetObjectByTag("ps_bjevent_east");	
	object oCheers = GetObjectByTag("ps_bjevent_cheers");
	object oWyvscr = GetObjectByTag("ps_bjevent_wyvscr");
	object oHoxun = GetObjectByTag("wp_bjevent_hoxmove");

	PS_SetLocalInt(oTrigger,"Used",TRUE);
	
	DelayCommand(4.0, AssignCommand(oSpeaker, ActionSpeakString
		("Berks, cutters, and bloods of all shape an' sort... I'm Barl Hoxun, and welcome to this week's Special Fight Night at the Bottle & Jug!")));
	DelayCommand(10.0, AssignCommand(oSpeaker, ActionSpeakString
		("Tonight, we bring you special bloodsport, a combat between beings fearful in their own right and not to be trifled with!")));
	DelayCommand(16.0, AssignCommand(oSpeaker, ActionSpeakString
		("Introducing first... the sourge of the seas of Krynn, warriors without peer, I give you... The Blood Sea Minotaurs!")));


	DelayCommand(20.0, AssignCommand(oDoor1, ActionOpenDoor(oDoor1)));

	DelayCommand(24.0, ps_delayspawnMino());
	
	DelayCommand(28.0,AssignCommand(oDoor1, ActionCloseDoor(oDoor1)));
	
	DelayCommand(28.0, AssignCommand(oSpeaker, ActionSpeakString
		("They fight for access to a portal leading to their home, to return terror to the oceans of Krynn! Let's give a hand to these stalwart Primes!")));
	
	DelayCommand(28.0, SoundObjectSetPosition(oCheers, GetPosition(oPC)));
	DelayCommand(28.1, SoundObjectPlay(oCheers));

	DelayCommand(34.0, AssignCommand(oSpeaker, ActionSpeakString
		("And their opponent... for the first time ever at the Bottle & Jug, a rare beast from one of the most inhospitable places in the multiverse. I give you...")));	
	
	object oDoor2 = GetObjectByTag("ps_bjevent_west");
	DelayCommand(34.0, AssignCommand(oDoor2, ActionOpenDoor(oDoor2)));
	DelayCommand(35.5, SoundObjectPlay(oWyvscr));
	
	DelayCommand(36.0, AssignCommand(oSpeaker, ActionMoveToObject(oHoxun, FALSE)));

	DelayCommand(40.0, AssignCommand(oSpeaker, ActionSpeakString
		("The Gehennan Blightwyvern! Let the battle begin!")));
		
	DelayCommand(42.0, ps_delayspawnWyvn());
	DelayCommand(44.0,AssignCommand(oDoor2, ActionCloseDoor(oDoor2)));
	
}
}