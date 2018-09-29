/*

    Companion and Monster AI

    This file contains all strings shown to the PC. (Useful for
    multilanguage support and customization.)

*/


// void main() {    }

// general strings
const string sHenchWaitAoECleared = "I'm not doing anything until these persistent spells are gone";


// companion/associate behavior options
const string sHenchPauseEveryRound			= "Puppet mode pause every round";
const string sHenchPauseEveryRoundOn		= "This character will pause every round if in puppet mode and enable pause and switch control is turned on.";
const string sHenchPauseEveryRoundOff		= "This character continue attacking the same target if in puppet mode and enable pause and switch control is turned on.";

// party options
const string sHenchWeapSwitchMess			= "Weapon switching messages (Party)";
const string sHenchWeapSwitchMessOn			= "Party members will give weapon switching messages.";
const string sHenchWeapSwitchMessOff		= "Party members will not give weapon switching messages.";

const string sHenchPuppetFollow				= "Puppet follow (Party)";
const string sHenchPuppetFollowOn			= "Party members that have puppet mode on will follow and do other activities when not in combat.";
const string sHenchPuppetFollowOff			= "Party members that have puppet mode on won't do anything unless directed.";

// global options
const string sHenchHBDetect 			= "Heartbeat detection of enemies (Global)";
const string sHenchHBSeenOnly 			= "Seen only";
const string sHenchHBDetectOn			= "Use hearing and seeing heartbeat detection.";
const string sHenchHBSeeOnlyOn			= "Use seeing heartbeat detection only.";
const string sHenchHBDetectOff			= "Disable heartbeat detection.";

const string sHenchPauseAndSwitch		= "Pause and switch control (Global)";
const string sHenchPauseAndSwitchOn		= "When puppet mode is on for a companion during combat, the game will pause and switch control to the companion when they need to do something.";
const string sHenchPauseAndSwitchOff	= "Puppet mode for a companion does not pause the game.";


// companion or henchman battle cry, called during attack
void HenchBattleCry()
{
/*
    // left in case anyone wants this
    
    string sName = GetName(OBJECT_SELF);
    // Probability of Battle Cry. MUST be a number from 1 to at least 8
    int iSpeakProb = Random(125)+1;
    if (FindSubString(sName,"Sharw") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("Take this, fool!"); break;
       case 2: SpeakString("Spare me your song and dance!"); break;
       case 3: SpeakString("To hell with you, hideous fiend!"); break;
       case 4: SpeakString("Come here. Come here I say!"); break;
       case 5: SpeakString("How dare you, impetuous beast?"); break;
       case 6: SpeakString("Pleased to meet you!"); break;
       case 7: SpeakString("Fantastic. Just fantastic!"); break;
       case 8: SpeakString("You CAN do better than this, can you not?"); break;

       default: break;
    }

    if (FindSubString(sName,"Tomi") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("Tomi's got a little present for you here!"); break;
       case 2: SpeakString("Poor sod, soon to bite the earth!"); break;
       case 3: SpeakString("Think twice before messing with Tomi!"); break;
       case 4: SpeakString("Tomi's fast; YOU are slow!"); break;
       case 5: SpeakString("Your momma raised ya to become THIS?"); break;
       case 6: SpeakString("Hey! Where's your manners!"); break;
       case 7: SpeakString("Tomi's got a BIG problem with you. Scram!"); break;
       case 8: SpeakString("You're an ugly little beastie, ain't ya?"); break;

       default: break;
    }

    if (FindSubString(sName,"Grim") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("Destruction for all!"); break;
       case 2: SpeakString("Embrace Death, and long for it!"); break;
       case 3: SpeakString("My Silent Lord comes to take you!"); break;
       case 4: SpeakString("Be still: your End approaches."); break;
       case 5: SpeakString("Prepare yourself! Your time is near!"); break;
       case 6: SpeakString("Eternal Silence engulfs you!"); break;
       case 7: SpeakString("I am at one with my End. And you?"); break;
       case 8: SpeakString("Suffering ends; but Death is eternal!"); break;
       default: break;
    }

    if (FindSubString(sName,"Dael") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("I'd spare you if you would only desist."); break;
       case 2: SpeakString("It needn't end like this. Leave us be!"); break;
       case 3: SpeakString("You attack us, only to die. Why?"); break;
       case 4: SpeakString("Must you all chase destruction? Very well!"); break;
       case 5: SpeakString("It does not please me to crush you like this."); break;
       case 6: SpeakString("Do not provoke me!"); break;
       case 7: SpeakString("I am at my wit's end with you all!"); break;
       case 8: SpeakString("Do you even know what you face?"); break;
       default: break;
    }

    if (FindSubString(sName,"Linu") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("Oooops! I nearly fell!"); break;
       case 2: SpeakString("What is your grievance? Begone!"); break;
       case 3: SpeakString("I won't allow you to harm anyone else!"); break;
       case 4: SpeakString("Retreat or feel Sehanine's wrath!"); break;
       case 5: SpeakString("By Sehanine Moonbow, you will not pass unchecked."); break;
       case 6: SpeakString("Smite you I will, though unwillingly."); break;
       case 7: SpeakString("Sehanine willing, you'll soon be undone!"); break;
       case 8: SpeakString("Have you no shame? Then suffer!"); break;
       default: break;
    }

    if (FindSubString(sName,"Boddy") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("You face a sorcerer of considerable power!"); break;
       case 2: SpeakString("I find your resistance illogical."); break;
       case 3: SpeakString("I bind the powers of the very Planes!"); break;
       case 4: SpeakString("Fighting for now, and research for later."); break;
       case 5: SpeakString("Sad to destroy a fine specimen such as yourself."); break;
       case 6: SpeakString("Your chances of success are quite low, you know?"); break;
       case 7: SpeakString("It's hard to argue with these fools."); break;
       case 8: SpeakString("Now you are making me lose my patience."); break;
       default: break;
    } */
}


// monster battle cry, called during attack
void MonsterBattleCry()
{


}