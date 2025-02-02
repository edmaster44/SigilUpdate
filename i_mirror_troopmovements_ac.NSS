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
	int nRand = Random(27)+1;
	switch(nRand) {
		case 1: sResult += "Measure Mauric’s unit reported in. They are holding position at the old Chirper’s inn balcony by the Bazaar crater."; break;
		case 2: sResult += "Measure Takan’s unit confirmed capture and slaying of the renegade Quinn. Atheon head office has been informed."; break;
		case 3: sResult += "Dion arrested earlier today by officer Grant. Twelfth time this month that he was seen snooping around the Bazaar crater. Suspect he is in league with the Doomguard and other resistance cells. All units are on high alert for signs of rebel activity in the Ward."; break;
		case 4: sResult += "Arrest Warrant issued for Bleaknik Sylvinario, on charges of hiding rebel suspects in his Hive Ward residence. All property registered to his name has been impounded. Fated agents are taking charge of the investigation. All information must be reported directly to the Hall of Darks."; break;
		case 5: sResult += "Administrator Kadir has charged the Gatehouse with obstructing the Zephyros case. Punitive action advised."; break;
		case 6: sResult += "Measure Nuardo, you and your unit are hereby ordered to prepare for immediate deployment to the former Gate town of Vorkehan. You and your men will join the siege efforts. Be advised; resistance forces are making effective use of the fortress’s poison gases. Protective gear will be issued upon your arrival at the camp, but ensure your mages are adequately prepared to ward against air born poisons."; break;
		case 7: sResult += "Assimilation of the 76th proceeds on schedule. Measure Nefiset assures me that the breach in security responsible for the Quasit Incident has been filled."; break;
		case 8: sResult += "Measure Lana, your unit as of tomorrow is to serve as the attaché for Fated Inquisitor Havaal. Do exactly as he commands."; break;
		case 9: sResult += "Update: All prisoners by the name of Quinn have been executed to avoid further bureaucratic confusion."; break;
		case 10: sResult += "Digger Amyas reports a shocking lack of information on Sezim of the First Circle. Double surveillance on the Dustman."; break;
		case 11: sResult += "Measure Ban reports both Halfling refugees have been found and taken back into custody. NOTICE: The magical ring found in their possession is as yet unidentified, but considered to be extremely dangerous. All units are advised to not, under any circumstances, wear the magic ring."; break;
		case 12: sResult += "I agree with Mover Murad's assessment of the Sandstone District. Immediate action should be taken to ensure the safety of the city."; break;
		case 13: sResult += "Be it known that the order of Dustmen is hereby declared a terrorist cell. Capture or kill all known current or former members."; break;
		case 14: sResult += "Ron Alexsy is a suspected Godsman. Proceed with caution."; break;
		case 15: sResult += "Athaon Hobard has submitted an official complaint about the actions of the Sign of One Factotum Sankar. There is confusion on jurisdiction; please advise.";
		case 16: sResult += "I personally believe that Factor Nirmala is well qualified to be high priest of Aoskar, though of course I bow to the wisdom of the god.";
		case 17: sResult += "Factotum Sankar strongly believes that Athaon Hobard is not acting in the best interests of the current order. His evidence has been forwarded to the Barracks.";
		case 18: sResult += "Package received. Residence Building CW-4056 lock down confirmed. All civilians cleared. Zone is ready for Signer agents to begin rift working. \n\nPS: I understand that Caex is Mover Reina's favorite pet, but the next time I catch him trying to reach for a ration pouch, I am going to skin him and turn him into a new boot..."; break;
		case 19: sResult += "Measure Tsarov reported in earlier today. He confirmed the presence of known terror agent Katherine Clearwater around the old Infirmary, formally part of the Hive before the Great Push last year. I hereby request a formal warrant to bring in the proprietors for questioning."; break;
		case 20: sResult += "By order of Fated Inquisitor Katani, your unit is ordered to move in on the Sunnyside Primary School, over on the edge of Hive Sector AV-21. All civilians- adult or child- are to be held until the arrival of Katani. Likewise, all possessions are to be confiscated for full auditing. Command suspects one of the children's parents to be an agent of the Terror Cells, but lacks intel on which one, so do not let a single one of them out of your sight."; break;
		case 21: sResult += "Earlier today, the Office of Civic and Social Affairs declared their final ruling on the matter of clothing deemed to be too revealing. According to Superintendent Lance Maserby, it was 'A tough question. I mean, I like the sight of a tiefer lass's behind with nothing but a wee string to cover up same as any man, but I know that some berks are concerned about it  being too shocking, or in some cases, vulgar. In the end, I think we can reach a compromise.'"+
							"\n\nThat compromise, it seems, is to create a strict guideline on when or where it will be allowed. Thus, as of today, the following rules on revealing clothing will be enforced:"+
							"\n1) Clothing that reveals bare skin above the knee and below the neck is permitted only in the case of female elves and tieflings. Some human females may apply for exceptions."+
							"\n2) Non-humanoid sentients are strictly prohibited from wearing revealing clothing. "+
							"\n3) Giants are likewise prohibited, as are Paelyreons. "+
							"\n4) Dances performed with such articles may only be enacted in the presence of Superintendent Maserby. "+
							"'I think,' he continued, 'That it is in everyone's best interest to follow these new guidelines. I know for sure that I will personally feel much better going forward!'"; break;
		case 22: sResult += "All units be on the alert. As you know, tonight Superintendent Maserby of the Office of Civic and Social Affairs will be hosting his annual Gala event in the Lady's Ward at his estate. As you are also aware, his role in public communications since his promotion in the former Civic Festhall has made him a  primary target in the eyes of the Terror Cells. Praetor Factol Pentar does not suspect any special danger tonight, but all the same, keep sharp."; break;
		case 23: sResult += "Confirmation just came in earlier; Notary Tavia engaged and eliminated the Terror Agent Sharon Raynsford. Unfortunately, the Notary was unable to apprehend Raynsford's fey slave, though her unit suspects it has fled into one of the Beastland portals. Command does not feel the need to pursue at this time. Nonetheless, all units are advised to keep on the lookout, and capture the creature alive if possible. The slave is described as having blue hair, a face of elven appearance, and somewhat short in height."; break;
		case 24: sResult += "Notify all units, that if any of the following wyrms are found, they are to be terminated immediately. They are a failed experiment. Names following:"+
							"\n- Sartorixfaeisthiliar \n- Kilitariax \n- Xujja \n- Ephimerra \n- Kregorothax \n- Fiirkronsshtra";break;
	 	case 25: sResult += "Keep an eye out for a small masked dark elf, who goes by the name Miniasen. She is not of our side, but the Seer wishes to see her."; break;
		case 26: sResult += "Our intelligence informs us that Inquisitor Aidan is dead; the bastards killed him, probably for sport. Inquisitor Havaal will be taking over his duties permanently. We can only hope that Mover Reina does not meet the same fate."; break;
		case 27: sResult += "Given the increased enemy presence in the old Market Ward, I suggest an increase in guards; particularly ones with true seeing. Furthermore, I await clearance for an assault on their Bazaar. I believe that if we send in a small team of our best we will be able to do great damage without repeating the mistakes of the first assault. \n-Measure Belladonna Goldworthy"; break;
	}
	
	sResult += "\n\n//OOC: Use the book to see today's page.";
	
	SetDescription(oItem, sResult);
	
	SetLocalInt(oPC, "STRANGE_BOOK", 1);
	
}