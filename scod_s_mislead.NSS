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

void CreateGlamer(object oCaster, location lLoc) {
	SpeakString("Creating glamer", TALKVOLUME_SHOUT);
	object oClone = CreateIllusoryClone(oCaster, GLAMER_TEMPLATE, lLoc);
	effect eShadow = EffectNWN2SpecialEffectFile("fx_shadowfiend_2");
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eShadow, oClone);
	
	AssignCommand(oClone, ActionMoveAwayFromObject(oCaster, TRUE, 100.0f));
	AssignCommand(oClone, ActionSpeakString("clone is here!", TALKVOLUME_SHOUT));
	string sImmune = "Immunity_"+IntToString(Random(10000));
	SetLocalString(oClone, "Immunity_String", sImmune);
	SetLocalFloat(oClone, "Duration", RoundsToSeconds(3));
	SetLocalObject(oClone, "Caster", oCaster);
	SetLocalInt(oClone, "SaveDC", GetSpellSaveDC());
	PS_Timestamp_UNIX(oClone, "Glamer_Timestamp");
	SetLocalInt(oClone, "Spell_ID", GetSpellId());
	
	GetAttentionOfHostiles(oClone, RADIUS_SIZE_SMALL, SPELL_MISLEAD, sImmune);
	
	SpeakString("glamer: "+GetName(oClone), TALKVOLUME_SHOUT);
	DestroyObject(oClone, RoundsToSeconds(3));
}

void main() {

	if (!X2PreSpellCastCode()) {
		return;
	}
	
	object oCaster = GetLastSpellCaster();
	SendMessageToPC(oCaster, "Casting Mislead");
	
	location lTarget = GetSpellTargetLocation();
	location lCaster = GetLocation(oCaster);
	
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND) {
        nDuration = nDuration *2; //Duration is +100%
    }
	
	//No teleporting in a dimensional anchor
	if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;
	if (GetLocalInt(oCaster, "DIMENSIONAL_ACHORED")) {
		SendMessageToPC(oCaster, "A Dimensional Anchor makes it impossible to teleport.");
		return;	
	}
	
	//Greater Invisibility Effect
	effect eImpact = EffectVisualEffect(VFX_HIT_SPELL_ILLUSION);
    effect eInvis = EffectInvisibility( INVISIBILITY_TYPE_NORMAL );
	effect eVis = EffectVisualEffect( VFX_DUR_INVISIBILITY );
    effect eCover = EffectConcealment(50);
    effect eLink = EffectLinkEffects(eVis, eCover);
    effect eOnDispell = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oCaster, SPELL_MISLEAD));
    eLink = EffectLinkEffects(eLink, eOnDispell);
    eInvis = EffectLinkEffects(eInvis, eOnDispell);
	
    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_MISLEAD, FALSE));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oCaster);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oCaster, RoundsToSeconds(nDuration));
	
	//Teleportation Effect
	effect eVis2 = EffectNWN2SpecialEffectFile("fx_shadowjump");
	AssignCommand(oCaster, ClearAllActions());
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis2, lCaster, 4.0f);
	DelayCommand(0.1f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis2, lTarget, 4.0f));
	DelayCommand(0.2f, ActionJumpToLocation(lTarget));

	//Create Glamer
	DelayCommand(0.21f, CreateGlamer(oCaster, lCaster));
}