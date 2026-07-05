/*Created by edmaster44- Half-Undead */
#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "aaa_constants"
#include "nw_i0_spells"
#include "aaa_halfundead_inc"
#include "x0_i0_match"


void RunHalfUndeadScript(object oPC, int nSpellID){

	SetLocalInt(oPC,"HUCASTING",1);
	ExecuteScript(Get2DAString("spells", "ImpactScript", nSpellID),oPC);
	DelayCommand(1.0f,DeleteLocalInt(oPC,"HUCASTING"));
}

void main(){
	object oPC = OBJECT_SELF;
	int nSpell = GetSpellId();
	switch(nSpell){
		case 1517:RunHalfUndeadScript(oPC,188); break; //Vampiric Touch
		case 1516:RunHalfUndeadScript(oPC,64); break; //Ghul's Bite(Based on Ghoul's Touch)
		case 1518:RunHalfUndeadScript(oPC,459); break; //Fetch's Telekenis(Based on bigby interposing hand)
		case 1513:RunHalfUndeadScript(oPC,845);break;//Detect Undead
		case 1524:RunHalfUndeadScript(oPC,54);break;//Fetch Unnerving Gaze
	}
	
	object oTarget	= GetSpellTargetObject();
	object 	oItem	= GetItemPossessedBy(oPC,"ps_essence");

	switch (nSpell){

		case 1519 :	HalfUndeadPower(oPC, nSpell); break; //Half-Undead Undead Immunity Power
		
		case 1514: GhedeanDeadNerves(oPC, oItem, nSpell); break; //Gheden Dead Nerves
		
		case 1515: HalfUndeadImmunity(oPC, nSpell); break;  //Half Undead Immunities 
	
		case 1512: HalfUndeadSkills(oPC,nSpell); break; //Half Undead Skills
		/*
		case 1525: ed_halfvampirestats(oPC,nSpell); break; //Half Vampire Stats
		case 1526: ed_ghulstats(oPC,nSpell); break; //Ghul Stats
		case 1527: ed_fetchstats(oPC,nSpell); break; //Fetch Stats
		case 1528: ed_ghedenstats(oPC,nSpell); break; //Gheden Stats
		*/
	}
} 