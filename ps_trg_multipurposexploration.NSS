/* ps_trg_multipurposexploration version 1.3
This script is a multipurpose trigger OnEnter script.
It has been intended for the utility of rewarding exploration.
It is able to define what skill is being used, what the DC for that skill is.
And reward the player with a string of text, as well as item, gold and/or experience for it.
It may also be used to open a dialogue.
© Mr_Otyugh: feel free to use, copy and/or modify.  
//modified 11/26/17 to add training exp - Mimi Fearthegn
*/
#include "ps_inc_training"


void main () 
{

object oTrigger = OBJECT_SELF;
if (GetLocalInt(oTrigger, "COOLDOWN") == TRUE) return;
object oPC = GetEnteringObject();
if (!GetIsPC(oPC)) return;

//Allows setting a different respawn time.
float triggerdelay = GetLocalFloat(oTrigger, "TRIGGERDELAY");
if (triggerdelay <= 0.0f) triggerdelay = 900.0;
SetLocalInt(oTrigger, "COOLDOWN", TRUE);
DelayCommand(triggerdelay, DeleteLocalInt(oTrigger, "COOLDOWN"));



//Quest entry checks, and ability to give quest entry to progress a quest.
string questTAG = GetLocalString(oTrigger,"QUESTTAG");
int hasQuest = GetLocalInt(oTrigger,"HASQUESTENTRY");
int iQuestEntry = GetLocalInt(oPC,"NW_JOURNAL_ENTRY" + questTAG);
int giveQuest = GetLocalInt(oTrigger,"GIVEQUESTENTRY");

if (questTAG != "") {

if ( hasQuest == 0 || iQuestEntry == hasQuest ) { 
	AddJournalQuestEntry( questTAG,giveQuest,oPC,1,0,0 ); 
	}
else { 
	// Incase you lack the prequesite quest, maybe you want it to inform it. Not mandatory.
 	string failMessage = GetLocalString(oTrigger, "FAILMESSAGE");
 	SendMessageToPC(oPC, failMessage);
 	return; 
	}
}

// Ability to backtrack on quest progress for the purpose of easy puzzles.
// This is practically a quest override, so you can override earlier progress by forcing them to go backwards.
int takeQuest = GetLocalInt(oTrigger,"BACKTRACKQUEST");

if (takeQuest > 0) {
	AddJournalQuestEntry( questTAG,takeQuest,oPC,1,0,1 );
	}


/*  Define what type of skill, using the row number of skills.2da
1 = Concentration 	12 = Diplomacy   		22 = Craft Traps
2 = Disable Trap 	13 = Sleight of Hands 	23 = Bluff
4 = Heal   			14 = Search    			24 = Intimidate
5 = Hide   			15 = Set Traps   		25 = Craft Armor
6 = Listen   		16 = Spellcraft  		26 = Craft Weapon
7 = Lore   			17 = Spot   			27 = Craft Alchemy
8 = Move Silently  	18 = Taunt    			29 = Survival
9 = Open Lock  		19 = Use Magic Device
10 = Parry   		20 = Appraise
11 = Perform  		21 = Tumble
*/

int skillType = GetLocalInt(oTrigger,"SKILLTYPE");
if (skillType > 0)
{
 int skillDC = GetLocalInt(oTrigger,"SKILLDC");
 if (GetIsTrainingSkillSuccessful(oPC, skillType, skillDC) == FALSE) 
 {	
 	// Incase you fail, maybe you want it to inform it. Not mandatory.
	 	string failMessage = GetLocalString(oTrigger, "FAILMESSAGE");
 	SendMessageToPC(oPC, failMessage);
	// Dish out unresistible magic damage incase you fail a skill roll.
	int damage = GetLocalInt(oTrigger,"DAMAGE");
	if (damage > 0) ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(damage,DAMAGE_TYPE_MAGICAL,DAMAGE_POWER_NORMAL,TRUE),oPC,0.0);
	// cause ability damage to defined ability.
	// 0 = strength		| 1 = Dexterity	| 2 = Constitution
	// 3 = Intelligence	| 4 = Wisdom	| 5 = Charisma
	int abiDamageType = GetLocalInt(oTrigger,"ABIDAMTYPE");
	int abilityDamage = GetLocalInt(oTrigger,"ABIDAMAGE");
	if (abilityDamage > 0) ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectAbilityDecrease( abiDamageType,abilityDamage ),oPC,900.0);
	// cause negative levels to the person.
	int negLevel = GetLocalInt(oTrigger,"NEGATIVELEVEL");
	if ( negLevel > 0 ) ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectNegativeLevel( negLevel ),oPC,900.0);	
 	return;
 }
}

//Decide what kind of message you want the trigger to tell if successful
string message = GetLocalString(oTrigger, "MESSAGE");
// If successful, give this much gold. Not mandatory.
int gold = GetLocalInt(oTrigger,"GOLD");
// If successful skill roll, give specific item by tag & quantity. Not mandatory.
string itemTAG = GetLocalString(oTrigger,"ITEMTAG");
int quantity = GetLocalInt(oTrigger,"ITEMQUANTITY");
if (quantity < 1) quantity = 1;
// Define how much exp a person can get by succeeding a skill roll.
int exp = GetLocalInt(oTrigger,"EXP");
// Triggers a conversation if the "convo" string is not empty.
string convo = GetLocalString(oTrigger,"CONVO");
// Perhaps you'd like to port people? This ports people to waypoint by tag.
// if "waypoint" is not an empty string and "destination" is a valid object then it will.	
string waypoint = GetLocalString(oTrigger,"WP");
object destination = GetWaypointByTag(waypoint);
// This allows to create an effect to a waypoint. It will despawn within (default 30 seconds).
string waypointeff = GetLocalString(oTrigger,"WPEFF");
object destinationeff = GetWaypointByTag(waypointeff);
string aEffect = GetLocalString(oTrigger,"EFFECT");
float effDur = GetLocalFloat(oTrigger,"EFFECTDURATION");
if (effDur <= 0.0f) effDur = 30.0;

if (aEffect != "") {
	CreateObject( OBJECT_TYPE_PLACED_EFFECT,aEffect,GetLocation(destinationeff),0,"" );
	object bEffect = GetNearestObjectByTag(aEffect);
	DestroyObject(bEffect,effDur);
	}
	
// This allows to create a placeable to a waypoint. It will despawn within (default 300 seconds).
string waypointpla = GetLocalString(oTrigger,"WPPLA");
object destinationpla = GetWaypointByTag(waypointpla);
string placeable = GetLocalString(oTrigger,"PLACEABLE");
float plaDur = GetLocalFloat(oTrigger,"PLADURATION");
if (plaDur <= 0.0f) plaDur = 300.0;

if (placeable != "") {
	CreateObject( OBJECT_TYPE_PLACEABLE,placeable,GetLocation(destinationpla) );
	DestroyObject(GetNearestObjectByTag(placeable),plaDur);
	}

// This allows to create a creature to a waypoint. It will despawn within (default 300 seconds).
string waypointcre = GetLocalString(oTrigger,"WPCRE");
object destinationcre = GetWaypointByTag(waypointcre);
string creature = GetLocalString(oTrigger,"CREATURE");
float creDur = GetLocalFloat(oTrigger,"CREDURATION");
if (creDur <= 0.0f) creDur = 300.0;

if (creature != "") {
	CreateObject( OBJECT_TYPE_CREATURE,creature,GetLocation(destinationcre) );
	DestroyObject(GetNearestObjectByTag(creature),creDur);
	}

if (exp > 0) GiveXPToCreature(oPC, exp);
if (gold > 0) GiveGoldToCreature(oPC, gold, TRUE);
if (message != "") SendMessageToPC(oPC, message);
if (convo != "") AssignCommand(oPC, ActionStartConversation(oPC, convo, TRUE, FALSE));
if (itemTAG != "") CreateItemOnObject(itemTAG, oPC, quantity);
if (waypoint != "") AssignCommand(oPC, JumpToObject(destination));

}