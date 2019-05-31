//::///////////////////////////////////////////////
//:: Rainbow Dweomer (Rainbow Pattern)
//:: [scod_s_rainbow_dweomer.nss]
//:://////////////////////////////////////////////
//:: Creates pretty rainbows that follow you and fascinate creatures
//:://////////////////////////////////////////////
//:: Mimi Fearthegn
//:: Created: 2-10-2019
//:://////////////////////////////////////////////
#include "ps0_newspells_inc"
#include "ps_inc_time"
#include "x2_inc_spellhook"

void main() {

	//Spellhook script
    if (!X2PreSpellCastCode()) {
        return;
    }

	//debug code to make sure we got here
	object oCaster = OBJECT_SELF;
	
    //Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);

	//Extend Metamagic
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = nCasterLvl;
    //check meta magic for extend
    if (nMetaMagic == METAMAGIC_EXTEND) {
        nDuration *= 2;
    }
	
	object oRainbow = GetLocalObject(oCaster, "rainbow_dweomer");
	if (GetIsObjectValid(oRainbow)) {
		SendMessageToPC(oCaster, "You may not have more than one Rainbow Dweomer active at a time!");
		return;
	}
	
	effect eVis = EffectNWN2SpecialEffectFile("fx_magical_explosion");
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lTarget, 1.0f);
	
	//Set up object and variables
	oRainbow = CreateObject(OBJECT_TYPE_CREATURE, "ps_summon_rainbow", lTarget);
	SetLocalObject(oCaster, "rainbow_dweomer", oRainbow);
	SetLocalObject(oRainbow, "Caster", oCaster);
	PS_Timestamp_UNIX(oRainbow, "Rainbow_Timestamp");
	SetLocalInt(oRainbow, "Duration", nDuration);
	SetLocalInt(oRainbow, "SaveDC", GetSpellSaveDC());
	
	object oOldHench= GetHenchman(oCaster);
	if (GetIsObjectValid(oOldHench)) {
		SendMessageToPC(oCaster, "The Rainbow Dweomer acts as a henchman. You cannot have more than one henchman active.");
		RemoveHenchman(oCaster, oOldHench);
		DestroyObject(oOldHench, 0.1f);
	}
	
	DelayCommand(0.3f, AddHenchman(oCaster, oRainbow));
}