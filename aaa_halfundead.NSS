/*Created by edmaster44- Half-Undead */
#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "aaa_constants"
#include "nw_i0_spells"
#include "aaa_halfundead_inc"
#include "x0_i0_match"

void RunHalfUndeadScript(object oPC, int nSpellID)
{
	SetLocalInt(oPC,"HUCASTING",1); DelayCommand(1.0f,DeleteLocalInt(oPC,"HUCASTING"));
	ExecuteScript(Get2DAString("spells", "ImpactScript", nSpellID),oPC);
}

void main(){
	object oPC = OBJECT_SELF;
switch(GetSpellId()){
	case 1517:RunHalfUndeadScript(oPC,188); break; //Vampiric Touch
	case 1516:RunHalfUndeadScript(oPC,64); break; //Ghul's Bite(Based on Ghoul's Touch)
	case 1518:RunHalfUndeadScript(oPC,459); break; //Fetch's Telekenis(Based on bigby interposing hand)
	case 1513:RunHalfUndeadScript(oPC,845);break;//Detect Undead
	case 1524:RunHalfUndeadScript(oPC,54);break;//Fetch Unnerving Gaze
	}
	
		if (!X2PreSpellCastCode())
    {	return;	}

	object oTarget	= GetSpellTargetObject();
	object 	oItem	= GetItemPossessedBy(oPC,"ps_essence");
	int nSpell 		= GetSpellId();

	
	switch (nSpell)
	{
////////////////////////////////////////////////////////////////////////////////////
		case 1519 :		//Half-Undead Undead Immunity Power
		{	HalfUndeadPower(oPC, nSpell);	}		
		break; 
		
		case 1514: //Gheden Dead Nerves
		{ GhedeanDeadNerves(oPC, oItem, nSpell); }
		break;
		
		case 1512://Half Undead Skills
		{HalfUndeadSkills(oPC,nSpell);}
		break;
	}
} 