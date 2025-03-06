#include "x2_inc_switches"

/*
const string VAR_NUMBEROFSPELLS = "numberofspells";
const string VAR_SPELL1 = "spell1";
const string VAR_SPELL2 = "spell2";
const int CHANNELS_SPELL = 9999;
const int CLASS_TYPE_SPELLSWORD = 117;
const int CHANNELS_SPELL_2 = 9999;

void FireSpellWeaving(string sScriptName, object oCaster, int nWovenSpellId)
{
	SetLocalInt(oCaster,"ChannelSpell",1);
	// because 0 is a valid spellid...
	SetLocalInt(oCaster, "CHANNELSPELL_SECONDARY", 1);
	SetLocalInt(oCaster, "SCHANNELSPELL_SECONDARY_SPELLID", nWovenSpellId);
	ExecuteScript(sScriptName, oCaster);
	DelayCommand(2.0f,DeleteLocalInt(oCaster,"ChannelSpell"));
}



int GetIsArcaneSpell(int iSpellID)
{
	string sArcane = Get2DAString("spells","Wiz_Sorc",iSpellID);
	if(sArcane == "") return FALSE;
	else return TRUE;
}


void DoSpellChannel(object oCaster, int iSpellID, int iSpellFeat)
{

object oWeaponL		= GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
int iSpellLevel = GetSpellLevel(iSpellID);

if (!GetHasFeat(9999,oCaster)) return;

//Get Weapon on left hand slot
if (!GetIsObjectValid(oWeaponL))
	{
		SendMessageToPC(oCaster, "You are missing a Valid Weapon in the left hand, please weild one so you may channel your spells into it.");
		return;
	}
//Deal with weaving spells into your weapon
if (GetSpellTargetObject() == oWeaponL)


if (GetIsObjectValid(GetSpellCastItem()))
		{
			SendMessageToPC(oCaster, "You may only weave spells cast from a spellbook");
			SetModuleOverrideSpellScriptFinished();
			return;
		}
		
if (iSpellFeat != 0)
		{
			SendMessageToPC(oCaster, "You cannot channel feats.");
			SetModuleOverrideSpellScriptFinished();
			return;
		}

if(!GetIsArcaneSpell(iSpellID))
		{
			SendMessageToPC(oCaster, "You can only channel Arcane Spells.");
			SetModuleOverrideSpellScriptFinished();
			return;
		}
	effect eUnweave = SupernaturalEffect(SetEffectSpellId(EffectVisualEffect(-1), UNWEAVE_EFFECT));

	int nNumberOfSpells = GetLocalInt(oWeapon, VAR_NUMBEROFSPELLS);
		switch (nNumberOfSpells)
		{
			case 0 :
				if  (GetLevelByClass(CLASS_TYPE_SPELLSWORD,oCaster) <4 )
				{
					SetLocalInt(oWeapon, VAR_SPELL1, iSpellID);
					SetLocalInt(oWeapon, VAR_NUMBEROFSPELLS, 1);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eUnweave, oCaster, TurnsToSeconds(15));
					SendMessageToPC(oCaster, "Spell Channeled successfully.");
					SetModuleOverrideSpellScriptFinished();
					return;
				}
			case 1: 
					if  (GetLevelByClass(CLASS_TYPE_SPELLSWORD,oCaster) > 9 )
					{
					SetLocalInt(oWeapon, VAR_SPELL2, iSpellID);
					SetLocalInt(oWeapon, VAR_NUMBEROFSPELLS, 2);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eUnweave, oCaster, TurnsToSeconds(15));
					SendMessageToPC(oCaster, "Spell Channeled successfully.");
					SetModuleOverrideSpellScriptFinished();
					return;
				}
				default :
			{
				SendMessageToPC(oCaster, "ERROR IN SPELLWEAVING. PLEASE SUBMIT A BUG REPORT.");
				SetModuleOverrideSpellScriptFinished();
				return;
			}

			else 
	{
		// if already in a weave, don't weave an additional time (Stops infinite loops)
		if (GetHasSpellEffect(SPELLWEAVING_EFFECT, oCaster))
		{
			effect eEffect = GetFirstEffect(oCaster);
			while (GetIsEffectValid(eEffect))
			{
				if (GetEffectSpellId(eEffect) == SPELLWEAVING_EFFECT)
				{
					//SendMessageToPC(oCaster, "Debug: You have Spellweaving Effect Already. Aborting.");
					RemoveEffect(oCaster, eEffect);
					return;
				}
				eEffect = GetNextEffect(oCaster);
			}
		}
		
		effect eWeaving = SetEffectSpellId(EffectVisualEffect(-1), SPELLWEAVING_EFFECT);
												

}				