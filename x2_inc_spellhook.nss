

//::///////////////////////////////////////////////
//:: Spell Hook Include File
//:: x2_inc_spellhook
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    This file acts as a hub for all code that
    is hooked into the nwn spellscripts'

    If you want to implement material components
    into spells or add restrictions to certain
    spells, this is the place to do it.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-06-04
//:: Updated On: 2003-10-25
//:://////////////////////////////////////////////
// ChazM 8/16/06 added workbench check to X2PreSpellCastCode()
// ChazM 8/27/06 modified  X2PreSpellCastCode() - Fire "cast spell at" event on a workbench. 
// FlattedFifth June 12, 2024. Added options to allow mage slayers to use potions and most npc 
//		store items that don't have class restrictions. Added check for "UsingPotion" local int from
//  	using a inflict wounds potion via the UNIQUE PROPERTY SELF ONLY. See x2_def_mod_act.nss and the 
//		craft potions section of x2_inc_craft.nss
// 		June 25, 2024, moved all the mage slayer logic to its own file, class_mageslayer_utils, expanded mage slayer abilities
// FlattedFifth July 30, 2024 Added function TouchRangedFeatInRange() to return whether or not a feat-based
//		spell is in touch range. NOT called from main(), this is only called from specific spell scripts as
// 		the need arises and only for feats.


//#include "x2_inc_itemprop" - Inherited from x2_inc_craft
#include "x2_inc_craft"
#include "ginc_crafting"
#include "x0_i0_spells"
#include "x2_i0_spells"
#include "ps_inc_epicsave"
#include "class_mageslayer_utils"
#include "ff_sequencer"



const int X2_EVENT_CONCENTRATION_BROKEN = 12400;


// function declarations
void ff_ShowConsumableCraftCosts(object oPC);
void ED_ApplyEffectToObject(object oCaster, int nSpellId, int bHostile, int nDurationType, effect eEffect, 
	object oTarget, float fDuration=0.0f);
int GetMissChance(object oCaster);
int GetSpellFailedBecauseMissChance(object oCaster);
void PS_RemoveEffects(object oTarget, int nId = NULL, int nType = NULL, object oCreator = OBJECT_INVALID);
int PS_GetHasEffectById(object oTarget, int nId);
int X2UseMagicDeviceCheck();
//int X2GetSpellCastOnSequencerItem(object oItem);
int X2RunUserDefinedSpellScript();
int GetSkipByRestoration(int nSpellId);
int X2CastOnItemWasAllowed(object oItem);
void X2BreakConcentrationSpells();
int X2GetBreakConcentrationCondition(object oPlayer);
void X2DoBreakConcentrationCheck();
void DebugSpells(object oCaster);
void FF_SaySpellChat(object oPC);
// for use in spells. notifies the caster after fDur seconds if an effect is no longer upon oTarget, 
// fDur = duration of spell for which you want a notification of expiration
// oTarget = the target of the spell of which you want a notification
// bShowParty = boolean. TRUE if you want the notification to be broadcast to entire party
// nId = the spell effect id. Calls GetSpellId() if you leave as -1
// oAddReceiver = additional person to whom you want to send the notification
void ReportEffectFade(float fDur, object oTarget = OBJECT_SELF, int bShowParty = FALSE, int nId = -1, object oAddReceiver = OBJECT_INVALID);
void ShowEffectFadeReport(object oCaller, object oTarget, object oAddReceiver, int nId, int bShowParty, int nTries = 0);

//------------------------------------------------------------------------------
// PRIMARY FUNCTION
// if FALSE is returned by this function, the spell will not be cast
// the order in which the functions are called here DOES MATTER, changing it
// WILL break the crafting subsystems
//------------------------------------------------------------------------------
int X2PreSpellCastCode()
{
	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	object oItem = GetSpellCastItem();
	int nSpellId = GetSpellId();
	int nFeatId = GetSpellFeatId();
	// send spell debugging info to caster if they've used the #SpellInfo chat command
	DebugSpells(oCaster);
   
   int nContinue;

   //---------------------------------------------------------------------------
   // This stuff is only interesting for player characters we assume that use
   // magic device always works and NPCs don't use the crafting feats or
   // sequencers anyway. Thus, any NON PC spellcaster always exits this script
   // with TRUE (unless they are DM possessed or in the Wild Magic Area in
   // Chapter 2 of Hordes of the Underdark.
   //---------------------------------------------------------------------------
   if (!GetIsPC(oCaster))
   {
       if( !GetIsDMPossessed(oCaster) && !GetLocalInt(GetArea(oCaster), "X2_L_WILD_MAGIC"))
       {
            return TRUE;
       }
   }

   // MAGE SLAYER CHECK, call to class_mageslayer_utils
   // Let's just skip this if neither the caster nor the target is a mage slayer and move logic out to its own 
   // file so as not to clutter this for devs trying to read something else
   if (GetHasFeat(FEAT_MAGE_SLAYER_MAGICAL_ABSTINENCE, oCaster) ||
   		GetHasFeat(FEAT_MAGE_SLAYER_MAGICAL_ABSTINENCE, oTarget))
   {
		// note that we don't return true if the spell/item is allowed because there are other checks as well.
		if (GetBypassMageSlayerRestriction(oTarget, oCaster, oItem, nSpellId, nFeatId) == FALSE) return FALSE;
   }
   
  
   // Run use magic device skill check, except Mage Slayer. They had their item use check in 
   // the previous conditional so there'd be no point in just calling those same functions again.
   if (GetHasFeat(FEAT_MAGE_SLAYER_MAGICAL_ABSTINENCE, oCaster) && 
		MAGE_SLAYER_SKIPS_UMD_FOR_ALLOWED_SCROLLS) nContinue = TRUE;
   else nContinue = X2UseMagicDeviceCheck();
   
	// run any user defined spellscript here
   if (nContinue)  nContinue = X2RunUserDefinedSpellScript();
      
   // The following code is only of interest if an item was targeted
   if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM){
       // Check if spell was used to trigger item creation feat
       if (nContinue) {
           nContinue = !ExecuteScriptAndReturnInt("x2_pc_craft", oCaster);
	   }	
		string sRef = GetResRef(oTarget);
		//casting a spell on the enchant focus or mortar and pestle shows the costs for making
		// scrolls, potions, and wands of that spell
		if (FindSubString(sRef, "ps_enchantmentf") != -1 || sRef == "mortar"){
			ff_ShowConsumableCraftCosts(oCaster); 
			return FALSE;
		}
       // Check if spell was used for on a sequencer item
       if (nContinue) nContinue = !FF_GetIsSeqAndStoreSpell(oCaster, oTarget);
       
       // * Execute item OnSpellCast At routing script if activated
       if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE){
             SetUserDefinedItemEventNumber(X2_ITEM_EVENT_SPELLCAST_AT);
             int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oTarget),oCaster);
             if (nRet == X2_EXECUTE_SCRIPT_END){
                return FALSE;
             }
       }

   }

	//---------------------------------------------------------------------------
	// The following code is only of interest if a placeable was targeted
	//---------------------------------------------------------------------------
	if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
	{	// spells going off on crafting workbenches causes to much carnage.  
		// Maybe we should have the spells actually fire in hard core mode... 
		// Although death by labratory experiment might be too much even for the hard core... ;)
		// We turn off effects for all workbenches just to avoid any confusion.
		// since the spell won't fire or signal the cast event, we do so here.
		if (IsWorkbench(oTarget))
		{
			nContinue = FALSE;
		    //Fire "cast spell at" event on a workbench. (only needed for magical workbenches currently)
		    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
			
		}
	}
	if (GetSpellFailedBecauseMissChance(oCaster)) nContinue = FALSE;
	
	if (nContinue) FF_SaySpellChat(oCaster);
   return nContinue;
}


void FF_SaySpellChat(object oPC){
	object oEss = PS_GetEssence(oPC);
	if (GetLocalInt(oEss, "spellchatoff"))return;
	int nId = GetSpellId();
	string sSpellChat = GetLocalString(oEss, "spellchat" + IntToString(nId));
	if (sSpellChat == "") return;
	
	int nChannel = CHAT_MODE_TALK;
	if (GetStringLowerCase(GetSubString(sSpellChat, 0, 2)) == "\w"){
		sSpellChat = GetStringRight(sSpellChat, GetStringLength(sSpellChat) - 2);
		nChannel = CHAT_MODE_WHISPER;
	}
	//float fDelay = StringToFloat(Get2DAString("spells", "ConjTime", nId));
	//fDelay /= 1000.0;
	//DelayCommand(fDelay -1.0, SendChatMessage(oPC, OBJECT_INVALID, nChannel, sSpellChat, FALSE));
	SendChatMessage(oPC, OBJECT_INVALID, nChannel, sSpellChat, FALSE);
}

// Use Magic Device Check.
// Returns TRUE if the Spell is allowed to be cast, either because the
// character is allowed to cast it or he has won the required UMD check
// Only active on spell scroll. Special pass for Mage Slayer if constants
// in class_mageslayer_utils.nss are set to allow scrolls for the type
// of mage slayer in question.
int X2UseMagicDeviceCheck()
{
	int nRet = ExecuteScriptAndReturnInt("x2_pc_umdcheck",OBJECT_SELF);
	return nRet;
}

//------------------------------------------------------------------------------
// Execute a user overridden spell script.
//------------------------------------------------------------------------------
int X2RunUserDefinedSpellScript()
{
    // See x2_inc_switches for details on this code
    string sScript =  GetModuleOverrideSpellscript();
    if (sScript != "")
    {
        ExecuteScript(sScript,OBJECT_SELF);
        if (GetModuleOverrideSpellScriptFinished() == TRUE)
        {
            return FALSE;
        }
    }
    return TRUE;
}


//------------------------------------------------------------------------------
// GZ: This is a filter I added to prevent spells from firing their original spell
// script when they were cast on items and do not have special coding for that
// case. If you add spells that can be cast on items you need to put them into
// des_crft_spells.2da
//------------------------------------------------------------------------------
int X2CastOnItemWasAllowed(object oItem)
{
    int bAllow = (Get2DAString(X2_CI_CRAFTING_SP_2DA,"CastOnItems",GetSpellId()) == "1");
    if (!bAllow)
    {
        FloatingTextStrRefOnCreature(83453, OBJECT_SELF); // not cast spell on item
    }
    return bAllow;

}

//------------------------------------------------------------------------------
// * This is our little concentration system for black blade of disaster
// * if the mage tries to cast any kind of spell, the blade is signaled an event to die
//------------------------------------------------------------------------------
void X2BreakConcentrationSpells()
{
    // * At the moment we got only one concentration spell, black blade of disaster

    object oAssoc = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
    if (GetIsObjectValid(oAssoc) && GetIsPC(OBJECT_SELF)) // only applies to PCS
    {
        if(GetTag(oAssoc) == "x2_s_bblade") // black blade of disaster
        {
            if (GetLocalInt(OBJECT_SELF,"X2_L_CREATURE_NEEDS_CONCENTRATION"))
            {
                SignalEvent(oAssoc,EventUserDefined(X2_EVENT_CONCENTRATION_BROKEN));
            }
        }
    }
}

//------------------------------------------------------------------------------
// being hit by any kind of negative effect affecting the caster's ability to concentrate
// will cause a break condition for concentration spells
//------------------------------------------------------------------------------
int X2GetBreakConcentrationCondition(object oPlayer)
{
     effect e1 = GetFirstEffect(oPlayer);
     int nType;
     int bRet = FALSE;
     while (GetIsEffectValid(e1) && !bRet)
     {
        nType = GetEffectType(e1);

        if (nType == EFFECT_TYPE_STUNNED || nType == EFFECT_TYPE_PARALYZE ||
            nType == EFFECT_TYPE_SLEEP || nType == EFFECT_TYPE_FRIGHTENED ||
            nType == EFFECT_TYPE_PETRIFY || nType == EFFECT_TYPE_CONFUSED ||
            nType == EFFECT_TYPE_DOMINATED || nType == EFFECT_TYPE_POLYMORPH)
         {
           bRet = TRUE;
         }
                    e1 = GetNextEffect(oPlayer);
     }
    return bRet;
}

void X2DoBreakConcentrationCheck()
{
    object oMaster = GetMaster();
    if (GetLocalInt(OBJECT_SELF,"X2_L_CREATURE_NEEDS_CONCENTRATION"))
    {
         if (GetIsObjectValid(oMaster))
         {
            int nAction = GetCurrentAction(oMaster);
            // master doing anything that requires attention and breaks concentration
            if (nAction == ACTION_DISABLETRAP || nAction == ACTION_TAUNT ||
                nAction == ACTION_PICKPOCKET || nAction ==ACTION_ATTACKOBJECT ||
                nAction == ACTION_COUNTERSPELL || nAction == ACTION_FLAGTRAP ||
                nAction == ACTION_CASTSPELL || nAction == ACTION_ITEMCASTSPELL)
            {
                SignalEvent(OBJECT_SELF,EventUserDefined(X2_EVENT_CONCENTRATION_BROKEN));
            }
            else if (X2GetBreakConcentrationCondition(oMaster))
            {
                SignalEvent(OBJECT_SELF,EventUserDefined(X2_EVENT_CONCENTRATION_BROKEN));
            }
         }
    }	
}

//got tired of having to write both signal event and apply effect, so made a wrapper that does both
void ED_ApplyEffectToObject(object oCaster, int nSpellId, int bHostile, int nDurationType, effect eEffect, 
	object oTarget, float fDuration=0.0f){
	
	SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, bHostile));
	ApplyEffectToObject(nDurationType, eEffect, oTarget, fDuration);
}

// More robust way to remove effects. Specify either the id, the type, the creator, or any combination
// to remove all effects that match those criteria. If you do not specify any critera, all effects
// are removed. -FlattedFifth, Nov 24, 2024
void PS_RemoveEffects(object oTarget, int nId = NULL, int nType = NULL, object oCreator = OBJECT_INVALID){
	effect eEff = GetFirstEffect(oTarget);
	int bIdMatch;
	int bTypeMatch;
	int bCreatorMatch;
	while (GetIsEffectValid(eEff)){
		if (nId == NULL || nId == GetEffectSpellId(eEff)) bIdMatch = TRUE;
		else bIdMatch = FALSE;
		
		if (nType == NULL || nType == GetEffectType(eEff)) bTypeMatch = TRUE;
		else bTypeMatch = FALSE;
		
		if (oCreator == OBJECT_INVALID || oCreator == GetEffectCreator(eEff)) bCreatorMatch = TRUE;
		else bCreatorMatch = FALSE;
		
		if (bIdMatch && bTypeMatch && bCreatorMatch){
			RemoveEffect(oTarget, eEff);
			eEff = GetFirstEffect(oTarget);
		} else eEff = GetNextEffect(oTarget);
	}
}

int PS_GetHasEffectById(object oTarget, int nId){
	effect eEff = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEff)){
		if (nId == GetEffectSpellId(eEff)) return TRUE;
		eEff = GetNextEffect(oTarget);
	}
	return FALSE;
}

// Called by all 3 divine restoration spells, psi restoration, and restore other.
// Returns TRUE if restoration spell should NOT remove these effects that contain
// some negative aspect.
int GetSkipByRestoration(int nSpellId){
	
	switch (nSpellId){
		case 489: return TRUE; // half dragon
		case 803: return TRUE; // Grey Dwarf enlarge
		case 1254: return TRUE; // ectoplasmic form
		case 1257: return TRUE;	// Racial cold vulnerability
		case 1258: return TRUE; // Racial fire vulnerability
		case 1442: return TRUE; // Giant
		case 1514: return TRUE; // Gheadan dead nerves skill penalties
		case 1515: return TRUE; // Half Undead
		case 1900: return TRUE; // Rakshasa
		case 1927: return TRUE; // Dervish dance
		case 2000: return TRUE; // Background: Stern
		case 2001: return TRUE; // Background: Misdirector
		case 2002: return TRUE; // Background: Tinker
		case 2003: return TRUE; // Background: Naturalist
		case 2004: return TRUE; // Background: Amicable
		case 2629: return TRUE; // Red and Brass Dragons
		case 2663: return TRUE; // White and Silver Dragons
		case 2881: return TRUE; // Stalwart defender stance
		case 4004: return TRUE;	// Winter Wolf 1
		case 4005: return TRUE; // Winter Wolf 2
		case 4018: return TRUE; // Treant
		case -9444: return TRUE; // effects from ps_inc_equipment
		case 14709: return TRUE; // considered strike, methodical defense, staff fighting
		case SPELL_LIGHT: return TRUE;
		case SPELL_DARKNESS: return TRUE;
		case SPELL_ENLARGE_PERSON: return TRUE;
		case SPELL_IRON_BODY: return TRUE;
		case SPELL_RIGHTEOUS_MIGHT: return TRUE;
		case SPELL_STONE_BODY: return TRUE;
		default: return FALSE;
	}
	return FALSE;
}


int GetMissChance(object oCaster){

	if (GetIsImmune(oCaster, IMMUNITY_TYPE_BLINDNESS)) return 0;
	
	int nReturn = 0;
	int nMiss = 0;
    effect eEff = GetFirstEffect(oCaster);
    while (GetIsEffectValid(eEff)){
		nMiss = 0;
        if (GetEffectType(eEff) == EFFECT_TYPE_MISS_CHANCE){
            nMiss = GetEffectInteger(eEff, 0);
        } else if (GetEffectType(eEff) == EFFECT_TYPE_BLINDNESS){
			nMiss = BLINDNESS_MISS_CHANCE;
		}
		if (nMiss > nReturn) nReturn = nMiss;
        eEff = GetNextEffect(oCaster);
    }
    return nReturn;
}

//Check to see if a targeted spell fails due to the caster being unable to see
int GetSpellFailedBecauseMissChance(object oCaster){

	if (!B_TARGETED_SPELLS_FAIL_FOR_BLINDNESS_AND_MISSCHANCE)
		return FALSE; // if this functionality is turned off in aaa_constants, the caster does not fail
		
	int nMiss = GetMissChance(oCaster);
	// if caster does not have a miss chance, then ofc they don't fail. Values greater than 100 or less than 0 are invalid
	if (nMiss <= 0 || nMiss > 100) return FALSE;
	
    object oTarget = GetSpellTargetObject();
	location lTarget = GetSpellTargetLocation();
	
	if (GetIsObjectValid(oTarget)){
		if (oTarget == oCaster) return FALSE; // if the caster is casting at themself, then they dont fail
	} else {
		if (GetIsObjectValid(GetAreaFromLocation(lTarget))){
			if (GetDistanceBetweenLocations(GetLocation(oCaster), lTarget) <= 0.1)
				return FALSE; // if the caster is targeting their own location, then they don't fail
		} else return FALSE; // if the target is invalid AND the area from location is invalid, spell has no target so they don't fail
	}
	
	int nRoll = d100();
	
	// if they roll low and have blind fight, they get another chance
	if (nRoll <= nMiss && GetHasFeat(FEAT_BLIND_FIGHT, oCaster)) nRoll = d100();
	
	if (nRoll <= nMiss){
		SendMessageToPC(oCaster, "Spell disrupted due to difficulty seeing target");
		return TRUE; // caster rolled lower than their miss chance % so they failed
	}
	return FALSE; //otherwise they do not fail
}


void DebugSpells(object oCaster){
	if (!GetLocalInt(oCaster, "spelldebug")) return;
	
	int nId = GetSpellId();
	int nNameRef = StringToInt(Get2DAString("spells", "NAME", nId));
	string sDebug = GetStringByStrRef(nNameRef);
	sDebug += "\nID: " + IntToString(nId);
	sDebug += "\n Script: " + Get2DAString("spells", "ImpactScript", nId) + ")";
	sDebug += "\nClass: ";
	int nClass = GetLastSpellCastClass();
	if (nClass == CLASS_TYPE_INVALID){
		sDebug += "Undefined";
		sDebug += "\nCL: " + IntToString(PS_GetCasterLevel(oCaster));
	} else {
		nNameRef = StringToInt(Get2DAString("classes", "Name", nClass));
		sDebug += GetStringByStrRef(nNameRef);
		sDebug += "\nCL: " + IntToString(PS_GetCasterLevel(oCaster, nClass));
	}
	if (GetLocalInt(oCaster, "IsTester"))
		sDebug += "\nCL for Engine: " + IntToString(GetCasterLevel(oCaster));
	int nDC;
	int nInnate = StringToInt(Get2DAString("spells", "Innate", nId));
	if (nInnate >= 10) nDC =  PS_GetEpicSpellSaveDC();
	else nDC = GetSpellSaveDC();
	sDebug += "\nBase Save DC: " + IntToString(nDC);

	nId = GetSpellFeatId(); //reuse this variable since we're done with it
	if (nId != 0){
		sDebug += "\nSpell Feat Id: " + IntToString(nId);
		nNameRef = StringToInt(Get2DAString("feat", "FEAT", nId));
		sDebug += "\nSpell Feat Name: " + GetStringByStrRef(nNameRef);
	}
	SendMessageToPC(oCaster, sDebug);
}


void ff_ShowConsumableCraftCosts(object oPC){
	int nId = GetSpellId();
	int nLevel = CIGetSpellInnateLevel(nId, FALSE);
	int nCost = CIGetCraftGPCost(oPC, nLevel, X2_CI_SCRIBESCROLL_COSTMODIFIER);
	string sCost = GetCurrencyFeedback(nCost, FALSE, FALSE, TRUE);
	string sMessage = GetSpellName(nId) + ":\n";
	sMessage += "Scroll cost: " + sCost + "\n";
	
	int bHarmful = StringToInt(Get2DAString("spells", "HostileSetting", nId));
	if (!bHarmful){
		if (nLevel <= 6){
			nCost = CIGetCraftGPCost(oPC, nLevel, X2_CI_BREWPOTION_COSTMODIFIER);
			sCost = GetCurrencyFeedback(nCost, FALSE, FALSE, TRUE);
			sMessage += "Potion cost: " + sCost + "\n";
		}
		nCost = CIGetCraftGPCost(oPC, nLevel, X2_CI_SEQUENCER_COSTMODIFIER);
		sCost = GetCurrencyFeedback(nCost, FALSE, FALSE, TRUE);
		sMessage += "Sequencer Potion cost: " + sCost + "\n";
	}
	
	if (nLevel <= 4){
		nCost = CIGetCraftGPCost(oPC, nLevel, X2_CI_CRAFTWAND_COSTMODIFIER);
		sCost = GetCurrencyFeedback(nCost, FALSE, FALSE, TRUE);
		sMessage += "Wand cost: " + sCost;
	}
	
	SendMessageToPC(oPC, sMessage);
}

void ShowEffectFadeReport(object oCaller, object oTarget, object oAddReceiver, int nId, int bShowParty, int nTries = 0){
	if (nTries >= 5) return; // bail if we checked 5x for the effect and it's still there
	//bail if either the object that had the effect or if both possible message receivers are gone
	if (!GetIsObjectValid(oTarget) || (!GetIsObjectValid(oCaller) && !GetIsObjectValid(oAddReceiver))) return;
	
	// if the effect we're looking for to notify absence of is still present, try again in 1/2 second
	if (PS_GetHasEffectById(oTarget, nId)){
		DelayCommand(0.5, ShowEffectFadeReport(oCaller, oTarget, oAddReceiver, nId, bShowParty, nTries = 0));
	} else {
		string sNameRef = Get2DAString("spells", "Name", nId);
		if (sNameRef == "" || sNameRef == "****") return;
		string sName = GetStringByStrRef(StringToInt(sNameRef));
		sName += " Fades";
		if (GetIsObjectValid(oCaller))
			FloatingTextStringOnCreature(sName, oCaller, bShowParty);
		if (GetIsObjectValid(oAddReceiver))
			FloatingTextStringOnCreature(sName, oAddReceiver, bShowParty);
	}
}

void ReportEffectFade(float fDur, object oTarget = OBJECT_SELF, int bShowParty = FALSE, int nId = -1, object oAddReceiver = OBJECT_INVALID){
	if (nId == -1) nId = GetSpellId();
	DelayCommand(fDur + 0.1, ShowEffectFadeReport(OBJECT_SELF, oTarget, oAddReceiver, nId, bShowParty));
}

/*

//------------------------------------------------------------------------------
// Created Brent Knowles, Georg Zoeller 2003-07-31
// Returns TRUE (and charges the sequencer item) if the spell
// ... was cast on an item AND
// ... the item has the sequencer property
// ... the spell was non hostile
// ... the spell was not cast from an item
// in any other case, FALSE is returned an the normal spellscript will be run
//------------------------------------------------------------------------------
int X2GetSpellCastOnSequencerItem(object oItem)
{
	
	// not a valid item
    if (!GetIsObjectValid(oItem))
    {
        return FALSE;
    }
	// not a sequencer
    int nMaxSeqSpells = IPGetItemSequencerProperty(oItem); // get number of maximum spells that can be stored
    if (nMaxSeqSpells <1)
    {
        return FALSE;
    }
	



    int nNumberOfTriggers = GetLocalInt(oItem, "X2_L_NUMTRIGGERS");
    // is there still space left on the sequencer?
    if (nNumberOfTriggers < nMaxSeqSpells)
    {
		// sequencer pots need coin to store the spell, 
		// if they can't pay they can't play
		if (FF_GetIsOldSequencerPot(oItem)){
			if (!FF_PayForSequencerPot(oItem, OBJECT_SELF))
				return FALSE;
		}
        // success visual and store spell-id on item.
        effect eVisual = EffectVisualEffect(VFX_IMP_BREACH);
        nNumberOfTriggers++;
        //NOTE: I add +1 to the SpellId to spell 0 can be used to trap failure
        int nSID = GetSpellId()+1;
        SetLocalInt(oItem, "X2_L_SPELLTRIGGER" + IntToString(nNumberOfTriggers), nSID);
        SetLocalInt(oItem, "X2_L_NUMTRIGGERS", nNumberOfTriggers);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, OBJECT_SELF);
        FloatingTextStrRefOnCreature(83884, OBJECT_SELF);
		
		// if it's a sequencer pot rename it to reflect spell(s) stored
		if (FF_GetIsOldSequencerPot(oItem))
			RenameOldSequencerPot(oItem, OBJECT_SELF);
    }
    else
    {
        FloatingTextStrRefOnCreature(83859,OBJECT_SELF);
    }
	
    return TRUE; // in any case, spell is used up from here, so do not fire regular spellscript
	
}
*/