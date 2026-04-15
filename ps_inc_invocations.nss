/*
	INCLUDE FILE FOR WARLOCK BUDDY ENABLED INVOCATIONS
	Previously, Warlock Buddy had copy-pasted spell functions for its spells, which
	meant that every time an invocation got changed, that change did not go into 
	Warlock Buddy. This include file has functions for the effect applications of
	all Warlock Buddy enabled invocations so that casting from the quick spell menu, 
	casting from hotbar, and casting via Warlock Buddy will all use the same functions.
	-FlattedFifth, April 11, 2026
*/

#include "nwn2_inc_metmag"
#include "ginc_debug"
#include "nwn2_inc_spells"
#include "nw_i0_spells"
#include "x2_inc_spellhook" 

const int SPELL_I_OTHERWORLDLY_WHISPERS = 1059;
const float HIDEOUS_DELAY = 6.0f;
const float THIRSTING_DELAY = 3.0f;


void DoHideousBlowEffect(object oCaster, int nId, int bFromBuddy){

	//Remove previous versions of this spell
	effect eEffect = GetFirstEffect( oCaster );
	while ( GetIsEffectValid(eEffect) ) {
		if (GetEffectSpellId(eEffect) == 816 ||
			GetEffectSpellId(eEffect) == 2211 ||
			GetEffectSpellId(eEffect) == 2212 ||
			GetEffectSpellId(eEffect) == 2213 ||
			GetEffectSpellId(eEffect) == 2214 ||
			GetEffectSpellId(eEffect) == 2215 ||
			GetEffectSpellId(eEffect) == 2216 ||
			GetEffectSpellId(eEffect) == 2217 ||
			GetEffectSpellId(eEffect) == 2218 ||
			GetEffectSpellId(eEffect) == 2219 ||
			GetEffectSpellId(eEffect) == 2220 ||
			GetEffectSpellId(eEffect) == 2221) {
				RemoveEffect( oCaster, eEffect );
				eEffect = GetFirstEffect( oCaster );
			} else 
				eEffect = GetNextEffect( oCaster );
	}
	
	int nMetaMagic = GetLocalInt(oCaster, "HideousMeta");
	int nDurVFX = VFX_INVOCATION_HIDEOUS_BLOW;
	switch (nMetaMagic) {
		case METAMAGIC_INVOC_DRAINING_BLAST: nDurVFX = VFX_INVOCATION_DRAINING_BLOW; break; //draining spear
		case METAMAGIC_INVOC_FRIGHTFUL_BLAST: nDurVFX = VFX_INVOCATION_FRIGHTFUL_BLOW; break; //frightful spear
		case METAMAGIC_INVOC_BESHADOWED_BLAST: nDurVFX = VFX_INVOCATION_BESHADOWED_BLOW; break; //beshadowed spear
		case METAMAGIC_INVOC_BRIMSTONE_BLAST: nDurVFX = VFX_INVOCATION_BRIMSTONE_BLOW; break; //brimstone spear
		case METAMAGIC_INVOC_HELLRIME_BLAST: nDurVFX = VFX_INVOCATION_HELLRIME_BLOW; break; //hellrime spear
		case METAMAGIC_INVOC_BEWITCHING_BLAST: nDurVFX = VFX_INVOCATION_BEWITCHING_BLOW; break; //bewitching spear
		case METAMAGIC_INVOC_NOXIOUS_BLAST: nDurVFX = VFX_INVOCATION_NOXIOUS_BLOW; break; //noxious spear
		case METAMAGIC_INVOC_VITRIOLIC_BLAST: nDurVFX = VFX_INVOCATION_VITRIOLIC_BLOW; break; //vitriolic spear
		case METAMAGIC_INVOC_UTTERDARK_BLAST: nDurVFX = VFX_INVOCATION_UTTERDARK_BLOW; break; //utterdark spear
		case METAMAGIC_INVOC_HINDERING_BLAST: nDurVFX = VFX_INVOCATION_HINDERING_BLOW; break; //hindering spear
		case METAMAGIC_INVOC_BINDING_BLAST: nDurVFX = VFX_INVOCATION_BINDING_BLOW; break; //binding spear
	}

    effect eHidBlow = EffectHideousBlow(nMetaMagic);
    effect eDur = EffectVisualEffect(nDurVFX);
    effect eLink = EffectLinkEffects(eHidBlow, eDur);
	eLink = SetEffectSpellId(eLink, SPELL_I_HIDEOUS_BLOW);
    if (!bFromBuddy)
		SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_I_HIDEOUS_BLOW, FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCaster);
}

void DoDarkDiscorp(object oCaster, int nId, int bFromBuddy){
	
	if (GetHasSpellEffect(1657) || GetHasSpellEffect(1721)){
		SendMessageToPC(oCaster, "You may not discorporate while Fiend Form is active.");
		return;
	}
    int nCasterLvl = GetWarlockCasterLevel(oCaster);
  
	float fDuration = TurnsToSeconds(nCasterLvl);
    fDuration = ApplyMetamagicDurationMods(fDuration);
	
	effect eBuff = EffectMovementSpeedIncrease(99); //x2 speed
	//being discorporated means undead like immunities
	eBuff = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK), eBuff); 
	eBuff = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT), eBuff); 
	eBuff = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN), eBuff);
	//50% concealment
	eBuff = EffectLinkEffects(EffectConcealment(50), eBuff); 
	eBuff = EffectLinkEffects(EffectNWN2SpecialEffectFile("fx_dark_discorporation"), eBuff);
	effect eAOE = EffectAreaOfEffect(97);
	eBuff = EffectLinkEffects(eAOE, eBuff);
	eBuff = SetEffectSpellId(eBuff, nId);
	
	if (!bFromBuddy)
		SignalEvent(oCaster, EventSpellCastAt(oCaster, nId, FALSE));
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oCaster, fDuration);
}

void DoDarkForesight(object oCaster, int nId, int bFromBuddy){

    //Declare major variables
    int nDuration = GetWarlockCasterLevel(oCaster);
    int nLimit = nDuration * 10;
	if ( nLimit > 150 )	nLimit = 150;
    int nMetaMagic = GetMetaMagicFeat();
    effect eStone = EffectDamageReduction(20, GMATERIAL_METAL_ALCHEMICAL_SILVER, nLimit, DR_TYPE_GMATERIAL);
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);	// NWN2 VFX
    effect eLink = EffectLinkEffects(eStone, eVis);
	eLink = SetEffectSpellId(eLink, nId);
   
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
		nDuration = nDuration *2; //Duration is +100%
  
	if (!bFromBuddy)
		SignalEvent(oCaster, EventSpellCastAt(oCaster, nId, FALSE));

    RemoveEffectsFromSpell(oCaster, nId);
    //Apply the linked effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, RoundsToSeconds(nDuration));
}


void DoHasteEffects(object oCaster, object oTarget, int nId, int nMetaMagic){
    int nCasterLvl  = GetWarlockCasterLevel(oCaster);
    float fDuration   = RoundsToSeconds(nCasterLvl); 

    //Check for metamagic extension
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    // Create the Effects
    effect eHaste   = EffectHaste();
    effect eDur     = EffectVisualEffect(VFX_DUR_SPELL_HASTE);
    effect eLink    = EffectLinkEffects(eHaste, eDur);
	eLink = SetEffectSpellId(eLink, nId);
		 // Remove any spells that share effects with this spell and were cast by caster
    if (GetHasSpellEffect(SPELL_HASTE, oTarget))
        PS_RemoveEffects(oTarget, SPELL_HASTE, NULL, oCaster);
    if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oTarget))
        PS_RemoveEffects(oTarget, SPELL_EXPEDITIOUS_RETREAT, NULL, oCaster);
	if (GetHasSpellEffect(nId, oTarget))
        PS_RemoveEffects(oTarget, nId, NULL, oTarget);
		
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}

void DoFleeTheScene(object oCaster, int nId, int bFromBuddy){
	int nMetaMagic = GetMetaMagicFeat();

	if (!bFromBuddy)
		SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_I_FLEE_THE_SCENE, FALSE));

    DoHasteEffects(oCaster, oCaster, nId, nMetaMagic);
	
	//Apply haste to party members
	object oArea = GetArea(oCaster);
	object oTarget = GetFirstFactionMember(oCaster, FALSE); 
	while (GetIsObjectValid(oTarget)) {
		if (GetArea(oTarget) == oArea && oTarget != oCaster)
			DoHasteEffects(oCaster, oTarget, nId, nMetaMagic );
	
		oTarget = GetNextFactionMember(oCaster, FALSE);
	}
}

void DoWalkUnseen(object oCaster, int nId, int bFromBuddy){

	//Declare major variables
    effect eInvis   = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eDur     = EffectVisualEffect(VFX_DUR_INVISIBILITY);
    effect eLink = EffectLinkEffects(eInvis, eDur);
	eLink = SetEffectSpellId(eLink, nId);
	
	float fDuration = HoursToSeconds(24); // Hours
	    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	RemoveEffectsFromSpell(oCaster, nId);

    if (!bFromBuddy){
		SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_INVISIBILITY, FALSE));
		effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ILLUSION);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oCaster);
	}
	//Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oCaster, fDuration);
}


void OnDispellCallback(object oCaster, int nSaveDC, float fDuration){

	if (!GetIsObjectValid(oCaster))return;
 
	location lCaster = GetLocation(oCaster);

	// Do a quick explosion effect
	effect eExplode = EffectVisualEffect( VFX_INVOCATION_ELDRITCH_AOE );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lCaster);


	int nDamageType  	= DAMAGE_TYPE_SONIC;
	int nDamagePower 	= DAMAGE_POWER_NORMAL;
	int nSaveType		= SAVING_THROW_TYPE_NONE;
	float fDistToDelay 	= 0.25f; 

	
	int nDamageAmt;
	int nSaveResult;
	float fDelay;
	effect eDmg;
	effect eStun;
	effect eDur;
	effect eDur2;
	effect eLink;

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lCaster, TRUE, OBJECT_TYPE_CREATURE );
    while (GetIsObjectValid(oTarget)){
        if (spellsIsTarget(oTarget, SPELL_TARGET_NON_ALLIED, oCaster) && oTarget != oCaster){
			
			nSaveResult = FortitudeSave(oTarget, nSaveDC, nSaveType, oCaster );
			if (nSaveResult != SAVING_THROW_CHECK_IMMUNE){
				nDamageAmt = d6(4);
				nDamageAmt	= ApplyMetamagicVariableMods( nDamageAmt, 4 * 6 );
				fDelay = GetDistanceBetweenLocations(lCaster, GetLocation(oTarget)) * fDistToDelay ;
				
				if (nSaveResult == SAVING_THROW_CHECK_FAILED ){
					eStun = EffectStunned();
					eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
					eDur2 = EffectVisualEffect(VFX_DUR_STUN);
					eLink = EffectLinkEffects(eStun, eDur);
					eLink = EffectLinkEffects(eLink, eDur2);

					// Apply effects to the currently selected target.
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
				} else if (nSaveResult == SAVING_THROW_CHECK_SUCCEEDED){
					nDamageAmt /= 2; 
				}
				eDmg = EffectDamage(nDamageAmt, nDamageType, nDamagePower);
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget));
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lCaster, TRUE, OBJECT_TYPE_CREATURE );
	}
}


void DoRetributiveInvis(object oCaster, int nId, int bFromBuddy){
	int nSaveDC = GetSpellSaveDC();
	float fDuration = RoundsToSeconds(3);	// JLR-OEI 05/08/06: Adjusted duration: PKM-OEI 08.25.06 adjusted duration again

    effect eOnDispell = EffectOnDispel(0.5f, OnDispellCallback(oCaster, nSaveDC, RoundsToSeconds(1)));
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
	effect eInvisLink = EffectLinkEffects(eInvis, eOnDispell);
	
    effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
    effect eDur = EffectVisualEffect(VFX_DUR_INVOCATION_RETRIBUTIVE_INVISIBILITY);
    effect eCover = EffectConcealment(50);
    effect eLink = EffectLinkEffects(eVis, eInvisLink);
    eLink = EffectLinkEffects(eDur, eLink);
	eLink = EffectLinkEffects(eCover, eLink);
	eLink = SetEffectSpellId(eLink, nId);
	
	if (!bFromBuddy){
		//Fire cast spell at event for the specified target
		SignalEvent(oCaster, EventSpellCastAt(oCaster, nId, FALSE));
	}
 
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);

}

void DoSeeTheUnseen(object oCaster, int nId, int bFromBuddy){
	int nFeatDarkvision = 228;
    float fDuration = HoursToSeconds(24); 

    fDuration = ApplyMetamagicDurationMods(fDuration);

    effect eSight = EffectSeeInvisible();
	effect eBlind = EffectImmunity(IMMUNITY_TYPE_BLINDNESS);
    effect eLink = EffectLinkEffects(eSight, eBlind);
	
	//if (!bFromBuddy){
		effect eDur = EffectVisualEffect( VFX_DUR_SPELL_SEE_INVISIBILITY);
		eLink = EffectLinkEffects(eDur, eLink);
	if (!bFromBuddy){
		SignalEvent(oCaster, EventSpellCastAt(oCaster, nId, FALSE));
	}
	eLink = SetEffectSpellId(eLink, nId);
    RemoveEffectsFromSpell(oCaster, nId);

	PS_GrantFeatBySpellWithEffect(nFeatDarkvision, oCaster, eLink, fDuration);


}

void DoLeapsAndBounds(object oCaster, int nId, int bFromBuddy){
	
	int nCasterLevel = GetWarlockCasterLevel(oCaster);
	int nSkillBuff = (nCasterLevel / 2) + 5;
	
    float fDuration = HoursToSeconds(24);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int nDex = 4;
	if (nCasterLevel > 5) //Dexterity boost doesn't become 6 until you hit caster level 6
		nDex = 6;

    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, nDex);
    effect eTumble = EffectSkillIncrease(SKILL_TUMBLE, nSkillBuff);
    effect eLink = EffectLinkEffects(eDex, eTumble);
	
	//if (!bFromBuddy){
		effect eDur = EffectVisualEffect(VFX_DUR_INVOCATION_LEAPS_BOUNDS);
		eLink = EffectLinkEffects(eDur ,eLink);
	if (!bFromBuddy){
		SignalEvent(oCaster, EventSpellCastAt(oCaster, nId, FALSE));
	}
	eLink = SetEffectSpellId(eLink, nId);
	
    RemoveEffectsFromSpell(oCaster, nId);

    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oCaster, fDuration);
}


void DoOtherworldlyWhispers(object oCaster, int nId, int bFromBuddy){
	int nCasterLevel = GetWarlockCasterLevel(oCaster);
	int nSkillBuff = (nCasterLevel/2) + 5;
	
 	//float fDuration = 60.0*60.0*24.0;  // 24 hours
	float fDuration = HoursToSeconds(24);
	
    effect eLore = EffectSkillIncrease(SKILL_LORE, nSkillBuff);
	effect eSpellCraft = EffectSkillIncrease(SKILL_SPELLCRAFT, nSkillBuff);
	effect eSearch = EffectSkillIncrease(SKILL_SEARCH, nSkillBuff);
    effect eLink = EffectLinkEffects(eLore, eSpellCraft);
	eLink = EffectLinkEffects(eSearch, eLink);
	eLink = SetEffectSpellId(eLink, nId);
	
	if (!bFromBuddy)
		SignalEvent(oCaster, EventSpellCastAt(oCaster, nId, FALSE));
	
	PS_RemoveEffects(oCaster, nId);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
}

void DoEntropicWarding(object oCaster, int nId, int bFromBuddy){

	int nCasterLevel = GetWarlockCasterLevel(oCaster);
    float fDuration = TurnsToSeconds(nCasterLevel);
	int nSkillBuff = (nCasterLevel/4);
	if (nSkillBuff < 1)
		nSkillBuff = 1;
	nSkillBuff = nSkillBuff+3;

    //Check for metamagic extend
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Set the four unique armor bonuses
    effect eShield =  EffectConcealment(20, MISS_CHANCE_TYPE_VS_RANGED);
    effect eMoveSilently = EffectSkillIncrease(SKILL_MOVE_SILENTLY, nSkillBuff);
    effect eHide = EffectSkillIncrease(SKILL_HIDE, nSkillBuff);
	effect eLink = EffectLinkEffects(eShield, eMoveSilently);
    eLink = EffectLinkEffects(eHide, eLink);
  
	//if (!bFromBuddy){
		effect eDur = EffectVisualEffect(VFX_DUR_SPELL_ENTROPIC_SHIELD);
		eLink = EffectLinkEffects(eDur, eLink);
	if (!bFromBuddy){
		SignalEvent(oCaster, EventSpellCastAt(oCaster, nId, FALSE));
	}
	eLink = SetEffectSpellId(eLink, nId);

    RemoveEffectsFromSpell(oCaster, nId);
    ApplyEffectToObject(nDurType, eLink, oCaster, fDuration);
}

void DoDarkOnesOwnLuck(object oCaster, int nId, int bFromBuddy){

    //Declare major variables
    float fDuration = HoursToSeconds(24);
    int nBonus = GetAbilityModifier(ABILITY_CHARISMA, oCaster);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    effect eLink = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_ALL);
	
	//if (!bFromBuddy){
		effect eDur = EffectVisualEffect(VFX_DUR_INVOCATION_DARKONESLUCK);
		eLink = EffectLinkEffects(eDur, eLink);
	if (!bFromBuddy){
		SignalEvent(oCaster, EventSpellCastAt(oCaster, nId, FALSE));
	}
    
	eLink = SetEffectSpellId(eLink, nId);
	RemoveEffectsFromSpell(oCaster, nId);
    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oCaster, fDuration);
}


void DoBeguilingInfluence(object oCaster, int nId, int bFromBuddy){

	int nCasterLevel = GetWarlockCasterLevel(oCaster);
    float fDuration = HoursToSeconds(24);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int nSkillBuff = (nCasterLevel/2) + 5;

    effect eBluff = EffectSkillIncrease(SKILL_BLUFF, 6);
    effect eDiplomacy = EffectSkillIncrease(SKILL_DIPLOMACY, 6);
    effect eIntimidate = EffectSkillIncrease(SKILL_INTIMIDATE, 6);
    effect eLink = EffectLinkEffects(eBluff, eDiplomacy);
    eLink = EffectLinkEffects(eIntimidate, eLink);
	
	//if (!bFromBuddy){
		effect eDur = EffectVisualEffect(VFX_DUR_INVOCATION_BEGUILE_INFLUENCE);
		eLink = EffectLinkEffects(eDur, eLink);
	if (!bFromBuddy){
		SignalEvent(oCaster, EventSpellCastAt(oCaster, nId, FALSE));
	}
	eLink = SetEffectSpellId(eLink, nId);
	
	RemoveEffectsFromSpell(oCaster, nId);
    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oCaster, fDuration);
}

void DoSelfOnlyInvocation(int nId, int bFromBuddy = FALSE){
	
	if (!X2PreSpellCastCode()) return;
	
	object oCaster = OBJECT_SELF;
	
	if (bFromBuddy){
		//prevent people from using WB to get around mage slayer restriction
		if (GetHasFeat(FEAT_MAGE_SLAYER_MAGICAL_ABSTINENCE, oCaster)){
			SendMessageToPC(oCaster, "Mage Slayers cannot cast spells.");
			return;
		}
		// prevent unnecessary processing with warlock buddy except for
		// hideous blow, which needs to refresh to change flavour
		if (nId != SPELL_I_HIDEOUS_BLOW){ 
			if (GetHasSpellEffect(nId))
				return;
		}
	}
		
	switch (nId){
		case SPELL_I_BEGUILING_INFLUENCE: DoBeguilingInfluence(oCaster, nId, bFromBuddy); break;
		case SPELL_I_DARK_ONES_OWN_LUCK: DoDarkOnesOwnLuck(oCaster, nId, bFromBuddy); break;
		case SPELL_I_ENTROPIC_WARDING: DoEntropicWarding(oCaster, nId, bFromBuddy); break;
		case SPELL_I_OTHERWORLDLY_WHISPERS: DoOtherworldlyWhispers(oCaster, nId, bFromBuddy); break;
		case SPELL_I_LEAPS_AND_BOUNDS: DoLeapsAndBounds(oCaster, nId, bFromBuddy); break;
		case SPELL_I_SEE_THE_UNSEEN: DoSeeTheUnseen(oCaster, nId, bFromBuddy); break;
		case SPELL_I_WALK_UNSEEN: DoWalkUnseen(oCaster, nId, bFromBuddy); break;
		case SPELL_I_RETRIBUTIVE_INVISIBILITY: DoRetributiveInvis(oCaster, nId, bFromBuddy); break;
		case SPELL_I_FLEE_THE_SCENE: DoFleeTheScene(oCaster, nId, bFromBuddy); break;
		case SPELL_I_DARK_FORESIGHT: DoDarkForesight(oCaster, nId, bFromBuddy); break;
		case SPELL_I_DARK_DISCORPORATION: DoDarkDiscorp(oCaster, nId, bFromBuddy); break;
		case SPELL_I_HIDEOUS_BLOW: DoHideousBlowEffect(oCaster, nId, bFromBuddy); break;
	}
}

