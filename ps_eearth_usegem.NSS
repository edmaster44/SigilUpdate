//Script by Dedic8ed
//Put this script OnUsed
void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

if (FortitudeSave(oPC, 25))
   {ActionCastSpellAtObject(SPELL_GREATER_STONESKIN, oPC, 1);
	SetNoticeText(oPC,"You have made a successful Fortitude check. The gem's power flows through you, imbuing your skin with the resilience of stone.");
}
else 
	{ActionCastSpellAtObject(SPELL_FLESH_TO_STONE, oPC, 1);
   SetNoticeText(oPC,"You have failed a Fortitude check! The gem's power flows through you, quickly turning you into solid stone.");
}
   
}