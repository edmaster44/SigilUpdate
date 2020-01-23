//
/*
   Template for an Activate item script.
   This script will run each time an item's "custom activation" is used.
   
   How to use this script:
   Item needs an item property that will cause a custom activation such as Cast Spell:Unique Power
   
*/

#include "ps_sigis_inc"

void main()
{
    object oPC      = GetItemActivator();
    object oItem    = GetItemActivated();
	
	if (GetLocalInt(oPC, "STRANGE_BOOK") > 0) {
		SendMessageToPC(oPC, "The pages of the book remain unchanged.");
		return;
	}
	
	SendMessageToPC(oPC, "There is a new page in the book. Check the item description.");
	
	string sDate = SigisDate(GetRealTime());
	
	string sResult = "A plainly bound book, filled part-way with hand written notes. The individual pages fade in and out, and the content changes day by day.\n\n"+sDate+":\n";
	int nRand = Random(15)+1;
	switch(nRand) {
		case 1: sResult += "Measure Mauric’s unit reported in. They are holding position at the old Chirper’s inn balcony by the Bazaar crater."; break;
		case 2: sResult += "Measure Takan’s unit confirmed capture and slaying of the renegade Quinn. Atheon head office has been informed."; break;
		case 3: sResult += "Dion arrested earlier today by officer Grant. Twelfth time this month that he was seen snooping around the Bazaar crater. Suspect he is in league with the Doomguard and other resistance cells. All units are on high alert for signs of rebel activity in the Ward."; break;
		case 4: sResult += "Arrest Warrant issued for Bleaknik Sylvinario, on charges of hiding rebel suspects in his Hive Ward residence. All property registered to his name has been impounded. Fated agents are taking charge of the investigation. All information must be reported directly to the Hall of Darks."; break;
		case 5: sResult += "Administrator Kadir has charged the Gatehouse with obstructing the Zephyros case. Punitive action advised."; break;
		case 6: sResult += "Measure Nuardo, you and your unit are hereby ordered to prepare for immediate deployment to the former Gate town of Vorkehan. You and your men will join the siege efforts. Be advised; resistance forces are making effective use of the fortress’s poison gases. Protective gear will be issued upon your arrival at the camp, but ensure your mages are adequately prepared to ward against air born poisons."; break;
		case 7: sResult += "Assimilation of the 76th proceeds on schedule. Measure Nefiset assures me that the breach in security responsible for the Quasit Incident has been filled."; break;
		case 8: sResult += "Measure Lana, your unit as of tomorrow is to serve as the attaché for Fated Inquisitor Havaal. Do exactly as he commands."; break;
		case 9: sResult += "Measure Kel, the renegade Signer and apostate Danae was finally put to the torch by order of Fated Inquisitor Aidan this morning. You are hereby charged with keeping her child under guard, until such time that members of the Fraternity should come to collect him. Do not under any circumstances allow the Cabal to claim custody. After Bleaknik Sylvinario’s treachery, the whole order’s loyalties and intentions are under question."; break;
		case 10: sResult += "Update: All prisoners by the name of Quinn have been executed to avoid further bureaucratic confusion."; break;
		case 11: sResult += "Digger Amyas reports a shocking lack of information on Sezim of the First Circle. Double surveillance on the Dustman."; break;
		case 12: sResult += "Measure Ban reports both Halfling refugees have been found and taken back into custody. NOTICE: The magical ring found in their possession is as yet unidentified, but considered to be extremely dangerous. All units are advised to not, under any circumstances, wear the magic ring."; break;
		case 13: sResult += "I agree with Mover Murad's assessment of the Sandstone District. Immediate action should be taken to ensure the safety of the city."; break;
		case 14: sResult += "Be it known that the order of Dustmen is hereby declared a terrorist cell. Capture or kill all known current or former members."; break;
		case 15: sResult += "Ron Alexsy is a suspected Godsman. Proceed with caution."; break;
	}
	
	sResult += "\n\n//OOC: Use the book to see today's page.";
	
	SetDescription(oItem, sResult);
	
	SetLocalInt(oPC, "STRANGE_BOOK", 1);
	
}