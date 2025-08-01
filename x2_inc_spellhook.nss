

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
#include "class_mageslayer_utils"


const int X2_EVENT_CONCENTRATION_BROKEN = 12400;


// function declarations
void PS_RemoveEffects(object oTarget, int nId = NULL, int nType = NULL, object oCreator = OBJECT_INVALID);
int PS_GetHasEffectById(object oTarget, int nId);
int X2UseMagicDeviceCheck();
int X2GetSpellCastOnSequencerItem(object oItem);
int X2RunUserDefinedSpellScript();
int GetSkipByRestoration(int nSpellId);
int X2CastOnItemWasAllowed(object oItem);
void X2BreakConcentrationSpells();
int X2GetBreakConcentrationCondition(object oPlayer);
void X2DoBreakConcentrationCheck();




//------------------------------------------------------------------------------
// PRIMARY FUNCTION
// if FALSE is returned by this function, the spell will not be cast
// the order in which the functions are called here DOES MATTER, changing it
// WILL break the crafting subsystems
//------------------------------------------------------------------------------
int X2PreSpellCastCode()
{
   object oTarget = GetSpellTargetObject();
   
   int nContinue;

   //---------------------------------------------------------------------------
   // This stuff is only interesting for player characters we assume that use
   // magic device always works and NPCs don't use the crafting feats or
   // sequencers anyway. Thus, any NON PC spellcaster always exits this script
   // with TRUE (unless they are DM possessed or in the Wild Magic Area in
   // Chapter 2 of Hordes of the Underdark.
   //---------------------------------------------------------------------------
   if (!GetIsPC(OBJECT_SELF))
   {
       if( !GetIsDMPossessed(OBJECT_SELF) && !GetLocalInt(GetArea(OBJECT_SELF), "X2_L_WILD_MAGIC"))
       {
            return TRUE;
       }
   }

   // MAGE SLAYER CHECK, call to class_mageslayer_utils
   // Let's just skip this if neither the caster nor the target is a mage slayer and move logic out to its own 
   // file so as not to clutter this for devs trying to read something else
   if (GetHasFeat(FEAT_MAGE_SLAYER_MAGICAL_ABSTINENCE, OBJECT_SELF) ||
   		GetHasFeat(FEAT_MAGE_SLAYER_MAGICAL_ABSTINENCE, oTarget))
   {
		object oItem = GetSpellCastItem();
		int nSpellId = GetSpellId();
		int nFeatId = GetSpellFeatId();
		// note that we don't return true if the spell/item is allowed because there are other checks as well.
		if (GetBypassMageSlayerRestriction(oTarget, OBJECT_SELF, oItem, nSpellId, nFeatId) == FALSE) return FALSE;
   }
   
   //---------------------------------------------------------------------------
   // Run use magic device skill check, except Mage Slayer. They had their item use check in 
   // the previous conditional so there'd be no point in just calling those same functions again.
   //---------------------------------------------------------------------------
   if (GetHasFeat(FEAT_MAGE_SLAYER_MAGICAL_ABSTINENCE, OBJECT_SELF) && 
		MAGE_SLAYER_SKIPS_UMD_FOR_ALLOWED_SCROLLS) nContinue = TRUE;
   else nContinue = X2UseMagicDeviceCheck();
   

   if (nContinue)
   {
       //-----------------------------------------------------------------------
       // run any user defined spellscript here
       //-----------------------------------------------------------------------
       nContinue = X2RunUserDefinedSpellScript();
   }

   //---------------------------------------------------------------------------
   // The following code is only of interest if an item was targeted
   //---------------------------------------------------------------------------
   if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
   {

       //-----------------------------------------------------------------------
       // Check if spell was used to trigger item creation feat
       //-----------------------------------------------------------------------
       if (nContinue) {
           nContinue = !ExecuteScriptAndReturnInt("x2_pc_craft",OBJECT_SELF);
       }

       //-----------------------------------------------------------------------
       // Check if spell was used for on a sequencer item
       //-----------------------------------------------------------------------
       if (nContinue)
       {
            nContinue = (!X2GetSpellCastOnSequencerItem(oTarget));
       }

       //-----------------------------------------------------------------------
       // * Execute item OnSpellCast At routing script if activated
       //-----------------------------------------------------------------------
       if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
       {
             SetUserDefinedItemEventNumber(X2_ITEM_EVENT_SPELLCAST_AT);
             int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oTarget),OBJECT_SELF);
             if (nRet == X2_EXECUTE_SCRIPT_END)
             {
                return FALSE;
             }
       }

	   /* Brock H. - OEI 07/05/06 - Removed for NWN2
	   
       //-----------------------------------------------------------------------
       // Prevent any spell that has no special coding to handle targetting of items
       // from being cast on items. We do this because we can not predict how
       // all the hundreds spells in NWN will react when cast on items
       //-----------------------------------------------------------------------
       if (nContinue) {
           nContinue = X2CastOnItemWasAllowed(oTarget);
       }
	   */
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
		    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
			
		}
	}

	
   return nContinue;
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

    if (!GetIsObjectValid(oItem))
    {
        return FALSE;
    }

    int nMaxSeqSpells = IPGetItemSequencerProperty(oItem); // get number of maximum spells that can be stored
    if (nMaxSeqSpells <1)
    {
        return FALSE;
    }

    if (GetIsObjectValid(GetSpellCastItem())) // spell cast from item?
    {
        // we allow scrolls
        int nBt = GetBaseItemType(GetSpellCastItem());
        if ( nBt !=BASE_ITEM_SPELLSCROLL && nBt != 105)
        {
            FloatingTextStrRefOnCreature(83373, OBJECT_SELF);
            return TRUE; // wasted!
        }
    }

    // Check if the spell is marked as hostile in spells.2da
    int nHostile = StringToInt(Get2DAString("spells","HostileSetting",GetSpellId()));
    if(nHostile ==1)
    {
        FloatingTextStrRefOnCreature(83885,OBJECT_SELF);
        return TRUE; // no hostile spells on sequencers, sorry ya munchkins :)
    }

    int nNumberOfTriggers = GetLocalInt(oItem, "X2_L_NUMTRIGGERS");
    // is there still space left on the sequencer?
    if (nNumberOfTriggers < nMaxSeqSpells)
    {
        // success visual and store spell-id on item.
        effect eVisual = EffectVisualEffect(VFX_IMP_BREACH);
        nNumberOfTriggers++;
        //NOTE: I add +1 to the SpellId to spell 0 can be used to trap failure
        int nSID = GetSpellId()+1;
        SetLocalInt(oItem, "X2_L_SPELLTRIGGER" + IntToString(nNumberOfTriggers), nSID);
        SetLocalInt(oItem, "X2_L_NUMTRIGGERS", nNumberOfTriggers);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, OBJECT_SELF);
        FloatingTextStrRefOnCreature(83884, OBJECT_SELF);
    }
    else
    {
        FloatingTextStrRefOnCreature(83859,OBJECT_SELF);
    }

    return TRUE; // in any case, spell is used up from here, so do not fire regular spellscript
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