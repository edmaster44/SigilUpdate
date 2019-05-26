//::///////////////////////////////////////////////
//:: Mislead
//:: [scod_s_mislead.nss]
//:://////////////////////////////////////////////
//:: Teleports the caster to the targetted location
//:: and creates a fake copy to distract the enemy
//:://////////////////////////////////////////////
//:: Mimi Fearthegn
//:: Created: 2-17-2019
//:://////////////////////////////////////////////
#include "ps0_newspells_inc"
#include "x2_inc_spellhook"
#include "ps_inc_time"

const string GLAMER_TEMPLATE = "ps_summon_glamer";

void CreateGlamer(object oCaster, location lLoc, float fDur) {
	object oClone = CreateIllusoryClone(oCaster, GLAMER_TEMPLATE, lLoc);
	effect eShadow = EffectNWN2SpecialEffectFile("fx_shadowfiend_2");
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eShadow, oClone);
	
	AssignCommand(oClone, ActionSpeakString("clone is here!", TALKVOLUME_SHOUT));
	string sImmune = "Immunity_"+IntToString(Random(10000));
	SetLocalString(oClone, "Immunity_String", sImmune);
	SetLocalFloat(oClone, "Duration", fDur);
	SetLocalObject(oClone, "Caster", oCaster);
	SetLocalInt(oClone, "SaveDC", GetSpellSaveDC());
	PS_Timestamp_UNIX(oClone, "Glamer_Timestamp");
	SetLocalInt(oClone, "Spell_ID", GetSpellId());
	SetLocalObject(oCaster, "Glamer", oClone);
	
	AssignCommand(oClone, ActionRandomWalk());
	
	GetAttentionOfHostiles(oClone, RADIUS_SIZE_COLOSSAL, SPELL_GLAMER, sImmune);
	SetCustomHeartbeat(oClone, 9);
	
	DestroyObject(oClone, fDur);
}

void main() {

	if (!X2PreSpellCastCode()) {
		return;
	}
	
	object oCaster = GetLastSpellCaster();
	SendMessageToPC(oCaster, "Casting Glamer");
	
	object oGlamer = GetLocalObject(oCaster, "Glamer");
	if (GetIsObjectValid(oGlamer)) {
		SendMessageToPC(oCaster, "You may not have more than one Glamer active at a time!");
		return;
	}
	
	location lTarget = GetSpellTargetLocation();
	
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND) {
        nDuration = nDuration * 2; //Duration is +100%
    }

	//Create Glamer
	CreateGlamer(oCaster, lTarget, RoundsToSeconds(nDuration));
}