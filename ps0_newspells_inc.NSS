#include "x2_inc_spellhook"
#include "aaa_constants"
#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "ps_inc_functions"
#include "nwn2_inc_spells"
#include "ps_inc_faction"
#include "x2_inc_itemprop"
#include "x2_inc_toollib"
#include "nwn2_inc_metmag"
#include "ps_inc_advscript"

/*	This is the include file for new spells for Bards, Clerics, Druids, Paladins, Rangers, and Wizards.

	//////////////////////////////////////////////////////////////////////////////////////////
	//////////					Let The Magic Begin!								//////////
	//////////////////////////////////////////////////////////////////////////////////////////	*/

void PS_Spell_DreadWord(object oPC, object oTarget, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;	}
	
    int nLevel 		= GetCasterLevel(oPC);
	effect eVis		= EffectNWN2SpecialEffectFile("sp_beshadowed_hit", oTarget);
	effect eDread	= EffectAbilityDecrease(ABILITY_CHARISMA, d3(1));
	effect eLink	= EffectLinkEffects(eVis, eDread);
	effect eFail	= EffectNWN2SpecialEffectFile("fx_b_spell_failure01", oPC);
			
	if (GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD)
	{	SendMessageToPC(oPC, "The Dread Word only effects good creatures.");
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eFail, oPC);	}
	else
	{	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
		if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oPC))
		{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);	}
	}
}

void PS_Spell_Gutwrench(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

	effect eDeath 		= EffectDeath(TRUE);
    effect eSpurt 		= EffectNWN2SpecialEffectFile("bloodspurt", oTarget);
		eDeath			= EffectLinkEffects(eDeath, eSpurt);
	effect ePuddle		= EffectNWN2SpecialEffectFile("fx_bloodstain1", oTarget);
	effect eBeam		= EffectBeam(VFX_BEAM_NECROMANCY, oTarget, BODY_NODE_CHEST);
	effect eAbsorb		= EffectNWN2SpecialEffectFile("fx_sp_vampiric_feast_hit01", oPC);
	effect eAbsHeal		= EffectTemporaryHitpoints(d6(4));
	effect eFail		= EffectNWN2SpecialEffectFile("fx_b_spell_failure", oPC);
	int nCasterLevel	= GetHitDice(oPC) / 2;
	int nSaveDC			= 10 + nCasterLevel + GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int nDamage			= d6(10);
    effect eDam			= EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, TRUE);

	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
		// Check for "no discernable anatomy"
		if (PS_GetHasDiscernableAnatomy(oTarget) == FALSE)
		{   SendMessageToPCByStrRef(oPC, 16780102);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eFail, oPC);
			return;		}
		
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {	if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oPC))
            {	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
				DelayCommand(0.5f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, ePuddle, GetLocation(oTarget), 30.0f));
				DelayCommand(0.6f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oPC, 3.0f));
				DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAbsorb, oPC));
				DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAbsHeal, oPC, HoursToSeconds(24)));	}
            else
            {	eDam = EffectLinkEffects(eDam, eSpurt);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);	}
        }
    }
}

void PS_Spell_FreezingFog(object oPC, location lTarget, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;		}

    effect eFog 		= EffectAreaOfEffect(AOE_PER_FREEZINGFOG);
	effect eRime		= EffectAreaOfEffect(AOE_PER_GREASE);
	float fDuration		= TurnsToSeconds(GetCasterLevel(oPC));

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eFog, lTarget, fDuration);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eRime, lTarget, fDuration);
}

//Checks whether the target is blind
int GetIsBlind(object oTarget) {
	effect eEffect = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffect)) {
		if (GetEffectType(eEffect) == EFFECT_TYPE_BLINDNESS)
			return TRUE;
		eEffect = GetNextEffect(oTarget);
	}
	return FALSE;
}

//Gets the effect which matches the spell id
effect GetEffectBySpellID(object oTarget, int nSpell) {
	effect eEffect = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffect)) {
		if (GetEffectSpellId(eEffect) == nSpell)
			return eEffect;
		eEffect = GetNextEffect(oTarget);
	}
	
	effect eNull;
	return eNull;
}

//Causes the actor to wander around playing dance animations
void ActionDanceWander() {
	int nRandom = d100();
	if (nRandom < 50) {
		ClearAllActions();
		PlayCustomAnimation(OBJECT_SELF, "dance01", TRUE);
	} else {
		ClearAllActions();
		PlayCustomAnimation(OBJECT_SELF, "dance02", TRUE);
	}
}

//Do the dance. Dance dance dance!
void PS_Spell_IrresistibleDance(object oTarget) {
	if (!GetHasSpellEffect(SPELL_IRRESISTIBLE_DANCE, oTarget)){
		SpeakString("No more dance!", TALKVOLUME_SHOUT);
		SetCutsceneMode(oTarget, FALSE);
		return;
	}
		
	SetCutsceneMode(oTarget, TRUE);
	SpeakString("Dance! Dance!", TALKVOLUME_SHOUT);
	AssignCommand(oTarget, ActionDanceWander());
	DelayCommand(2.0f, PS_Spell_IrresistibleDance(oTarget));
}

//Daze effect, plus -4 to listen / spot 
//properly speaking, it should go away on being damaged
//use this > scod_s_creature_distracted
effect EffectFascinate() {
	effect eFascinate = EffectDazed();
	effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 4);
	eFascinate = EffectLinkEffects(eSkill, eFascinate);
	
	effect eMind = EffectNWN2SpecialEffectFile("fx_fascinate");
	return EffectLinkEffects(eMind, eFascinate);
}

//harvested from class_arcanetrickster_mirrors and adjusted for the purposes of new illusion spells
//oCreature = creature to copy from
//sTemplate = the base template to pull the illusion from
//lLocation = location to spawn at
//Any additional vfx or domination / party adding effects are handled outside of this function
object CreateIllusoryClone(object oCreature, string sTemplate, location lLocation) {

 	object oClone = CreateObject(OBJECT_TYPE_CREATURE, sTemplate, lLocation);
	
	// Sets apperance
	SetCreatureAppearanceType(oClone, GetAppearanceType(oCreature));
	PS_SetCreatureCoreAppearance(oClone, PS_GetCreatureCoreAppearance(oCreature));
	
	effect eEffect = GetFirstEffect(oCreature);
	
	// Applies all visual effects from the user to the clone
	while (GetIsEffectValid(eEffect) == TRUE)
	{
		if (GetEffectType(eEffect) == EFFECT_TYPE_VISUALEFFECT)
		{
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oClone); 
		}
		
		eEffect = GetNextEffect(oCreature);
	}
	
	SetFirstName(oClone, GetFirstName(oCreature));
	SetLastName(oClone, GetLastName(oCreature));
	
	// Loop through inventory
	int iSlot;
	for (iSlot = INVENTORY_SLOT_CHEST; iSlot <= INVENTORY_SLOT_CARMOUR; ++iSlot)
	{
		object oItem = GetItemInSlot(iSlot ,oCreature);
		
		if (GetIsObjectValid(oItem) && GetObjectType(oItem) == OBJECT_TYPE_ITEM)
		{
			object oItemCopy = CopyItem(oItem, oClone, FALSE);
			SetDroppableFlag(oItemCopy, FALSE);
			// Remove any equiping restrictions on the item
			itemproperty prop = GetFirstItemProperty(oItemCopy);
			while (GetIsItemPropertyValid(prop))
			{
				if (GetItemPropertyType(prop) == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP
				|| GetItemPropertyType(prop) == ITEM_PROPERTY_USE_LIMITATION_CLASS
				|| GetItemPropertyType(prop) == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE
				|| GetItemPropertyType(prop) == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT)
					RemoveItemProperty(oItemCopy, prop);
					
				prop = GetNextItemProperty(oItemCopy);
			}

			AssignCommand(oClone, ActionEquipItem(oItemCopy, iSlot));
		}
	}
	
	return oClone;
}

//Gets the attention of hostile creatures and draws them to attack the caller
//Don't call constantly
void GetAttentionOfHostiles(object oCaller, float fRadius, int nSpellID = -1, string sImmuneMarker = "") {
	location lTarget = GetLocation(oCaller);
	
	//Marking that the target is effected by this spell
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_DAZE);
	if (nSpellID >= 0) {
		SetEffectSpellId(eVis, nSpellID);
	}
							
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget)) {
		
		//This is for npcs only
		if (!GetIsPC(oTarget)) {
			//Only works on hostiles
			if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaller)) {
				//Only call if you're not already doing the desired behavior
				if (GetAttackTarget(oTarget) != oCaller) {
					//Only works on creatures who haven't seen through the illusion already
					if (sImmuneMarker != "" && GetLocalInt(oTarget, sImmuneMarker) > 0) {
						AssignCommand(oTarget, ActionSpeakString("pursuing the glamer!", TALKVOLUME_SHOUT));
						AssignCommand(oTarget, ClearActions());
						AssignCommand(oTarget, ActionAttack(oCaller));
						if (nSpellID >= 0) {
							ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 9.1f);
						}
					}
				} else {
					AssignCommand(oTarget, ActionSpeakString("already attacking glamer!", TALKVOLUME_SHOUT));
					if (nSpellID >= 0) {
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 9.1f);
					}
				}
			}
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}