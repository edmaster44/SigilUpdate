

/*////////////////////////////////////////////
1 - Set Custom Tokens
2 - Kill Animal
3 - Capture Animal
4 - Let Animal Free
////////////////////////////////////////////*/
#include "ps_inc_faction"

void ClearEffects(object oTarget) {
	effect eEffect = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffect)) {
		RemoveEffect(oTarget, eEffect);
		eEffect = GetNextEffect(oTarget);
	}
}

void main (int nFunction) {

	object oPC = GetPCSpeaker();
	object oCaught = GetLocalObject(OBJECT_SELF, "target");
	SetActionMode(oPC, ACTION_MODE_STEALTH, FALSE); //break stealth, so effects can happen

	switch (nFunction) {
	
		case 1: {
			if (!GetIsObjectValid(oCaught)) {
				SetLocalInt(OBJECT_SELF, "caughtThing", 0);
				break;
			}
			SetCustomToken(2030, GetLocalString(oCaught, "TextCaught"));
			if (GetLocalString(oCaught, "TextKill") != "")
				SetLocalInt(OBJECT_SELF, "canKill", 1);
			if (GetLocalString(oCaught, "TextCapture") != "")
				SetLocalInt(OBJECT_SELF, "canCapture", 1);
			if (GetLocalString(oCaught, "TextFree") != "")
				SetLocalInt(OBJECT_SELF, "canFree", 1);
			break;
		}
		case 2: {
			SetCustomToken(2031, GetLocalString(oCaught, "TextKill"));
			int nGold = GetLocalInt(oCaught, "GoldValueKill");
			string sItem = GetLocalString(oCaught, "ItemKill");
			if (nGold > 0)
				GiveGoldToCreature(oPC, nGold, TRUE);
			if (sItem != "") {
				CreateItemOnObject(sItem, oPC);
			}
			if (GetTag(oCaught) == "ps_trap_rabbit2") { //lucky rabbit
				effect eCurse = SupernaturalEffect(EffectCurse(-4, -4, -4, -4, -4, -4));
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCurse, oPC, 6000000.0f);
			}
			effect eBlood = EffectNWN2SpecialEffectFile("fx_blood_red1_l", oCaught);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eBlood, oCaught);
			DestroyObject(oCaught, 0.1f);
			break;
		}
		case 3: {
			SetCustomToken(2032, GetLocalString(oCaught, "TextCapture"));
			int nGold = GetLocalInt(oCaught, "GoldValueCapture");
			string sItem = GetLocalString(oCaught, "ItemCapture");
			if (nGold > 0)
				GiveGoldToCreature(oPC, nGold, TRUE);
			if (GetTag(oCaught) == "ps_trap_unicorn") {
				if (GetGender(oPC) == GENDER_FEMALE && GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD) {
					CreateItemOnObject(sItem, oPC);
				} else {
					SetCustomToken(2032, "The unicorn resists your advances, and breaks free, intent on teaching you a lesson!");
					DeleteLocalObject(OBJECT_SELF, "target");
					ChangeToStandardFaction(oCaught, STANDARD_FACTION_HOSTILE);
					AssignCommand(oCaught, ActionAttack(oPC));
				}
			} else if (sItem != "") {
				CreateItemOnObject(sItem, oPC);
			}
			DestroyObject(oCaught, 0.1f);
			break;
		}
		case 4: {
			SetCustomToken(2033, GetLocalString(oCaught, "TextFree"));
			int nGold = GetLocalInt(oCaught, "GoldValueFree");
			string sItem = GetLocalString(oCaught, "ItemFree");
			if (nGold > 0)
				GiveGoldToCreature(oPC, nGold, TRUE);
			if (sItem != "") {
				CreateItemOnObject(sItem, oPC);
			}
			ClearEffects(oCaught);
			if (GetTag(oCaught) == "ps_trap_boar") {
				DeleteLocalObject(OBJECT_SELF, "target");
				location lLoc = GetLocation(oCaught);
				DestroyObject(oCaught);
				object oBoar = CreateObject(OBJECT_TYPE_CREATURE, "ps_trap_boar", lLoc);
				ChangeToStandardFaction(oBoar, STANDARD_FACTION_HOSTILE);
				AssignCommand(oBoar, ActionAttack(oPC));
			} else {
				location lOrigin = GetLocalLocation(OBJECT_SELF, "startingLoc");
				AssignCommand(oCaught, ActionMoveToLocation(lOrigin));
				DestroyObject(oCaught, 1.0f);
			}
			break;
		}
		default: {break;}
	}

}