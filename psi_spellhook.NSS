//::///////////////////////////////////////////////
//:: Spell Hook Include File
//:: prc_psi_splhook
//:://////////////////////////////////////////////
/*

    This file acts as a hub for all code that
    is hooked into the psionic spellscripts

*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 20-10-2004
//:://////////////////////////////////////////////

#include "x2_inc_craft"
#include "x2_inc_spellhook"
#include "aaa_constants"


// This function holds all functions that are supposed to run before the actual
// spellscript gets run. If this functions returns FALSE, the spell is aborted
// and the spellscript will not run
int PsiPrePowerCastCode();


//------------------------------------------------------------------------------
// if FALSE is returned by this function, the spell will not be cast
// the order in which the functions are called here DOES MATTER, changing it
// WILL break the crafting subsystems
//------------------------------------------------------------------------------


int PsiPrePowerCastCode()
{
	// send spell debugging info to caster if they've used the #SpellInfo chat command

	
	object oManifestor = OBJECT_SELF;
	DebugSpells(oManifestor);
    object oTarget = GetSpellTargetObject();
	int nPP = GetLocalInt(oManifestor, "PSI_PP");
    int nContinue = TRUE;
	
	//********************************************************************
	//Arcane Spell Failure
	//********************************************************************
/*	int spellFailure = GetArcaneSpellFailure(oManifestor);
	int iArmorRank = GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oManifestor));
	object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oManifestor);
	string sShield = GetTag(oShield);
	if (iArmorRank > 1 || (GetBaseItemType(oShield) == BASE_ITEM_SMALLSHIELD && sShield != "mwa_shlt_zal_3") ||
						  GetBaseItemType(oShield) == BASE_ITEM_LARGESHIELD ||
						  GetBaseItemType(oShield) == BASE_ITEM_TOWERSHIELD )
	{ return (d100() > spellFailure); }

    if (nPsyicClasses(oManifestor)>1 )
	{spellFailure = 0; }  - removed on 4/26/2021*/ 
	


	
	//********************************************************************
	//Catapsi Interference ((Handled better in psi_inc_manifest))
	//********************************************************************
    	
	//********************************************************************
	//Ectoplasmic Cocoon
	//********************************************************************
	if (GetLocalInt(oManifestor, "PRC_Power_EctoForm") && GetHasSpellEffect(14139, oManifestor))
    {
        int nPower = GetSpellLevel(GetSpellId());
        nContinue = GetIsSkillSuccessful(oManifestor, SKILL_CONCENTRATION, (20 + nPower));
    }
	//********************************************************************
	//Ectoplasmic Shambler Effect
	//********************************************************************
	if (GetLocalInt(oManifestor, "PRC_IsInEctoplasmicShambler") && GetHasSpellEffect(14192, oManifestor))
    {
        int nPower = GetSpellLevel(GetSpellId());
        nContinue = GetIsSkillSuccessful(oManifestor, SKILL_CONCENTRATION, (15 + nPower));
    }
	//********************************************************************
	//Mind Trap effect
	//********************************************************************
	if (GetLocalInt(oManifestor, "PRC_Power_MindTrap_Active") && GetHasSpellEffect(14123, oManifestor))
    {
        int num = d6();
		SetLocalInt(oManifestor, "PSI_PP", GetLocalInt(oManifestor, "PSI_PP")-num);
    }
	//********************************************************************
	//Null Psionics effect
	//********************************************************************
	if (GetLocalInt(oManifestor, "NullPsionicsField") && GetHasSpellEffect(14215, oManifestor))
    {
        nContinue = FALSE;
    }
	if (GetLocalInt(oTarget, "NullPsionicsField") && GetHasSpellEffect(14215, oTarget))
    {
        nContinue = FALSE;
    }
	//********************************************************************
	// Mage slayer
	if (GetHasFeat(2950, oManifestor)) nContinue = FALSE;
	

	/*object oManifestor = oManifestor;
    object oTarget = GetSpellTargetObject();
    int nContinue;

    DeleteLocalInt(oManifestor, "SpellConc");
    nContinue = !ExecuteScriptAndReturnInt("prespellcode",oManifestor);

    //---------------------------------------------------------------------------
    // This stuff is only interesting for player characters we assume that use
    // magic device always works and NPCs don't use the crafting feats or
    // sequencers anyway. Thus, any NON PC spellcaster always exits this script
    // with TRUE (unless they are DM possessed or in the Wild Magic Area in
    // Chapter 2 of Hordes of the Underdark.
    //---------------------------------------------------------------------------
    if(!GetIsPC(oManifestor))
    //&& !GetPRCSwitch(PRC_NPC_HAS_PC_SPELLCASTING))
    {
        if(!GetIsDMPossessed(oManifestor) && !GetLocalInt(GetArea(oManifestor), "X2_L_WILD_MAGIC"))
        {
            return TRUE;
        }
    }

    // Ectoplasmic Form conc check
    if (GetLocalInt(oTarget, "PRC_Power_EctoForm"))
    {
        int nPower = GetPowerLevel(oManifestor);
        nContinue = GetIsSkillSuccessful(oManifestor, SKILL_CONCENTRATION, (20 + nPower));
    }

    //---------------------------------------------------------------------------
    // Run Disrupting Strike Check
    //---------------------------------------------------------------------------
    if (nContinue && GetLocalInt(oManifestor, "DisruptingStrike_PsionicsFail"))
    {
        nContinue = FALSE;
    }

    //---------------------------------------------------------------------------
    // Run Ectoplasmic Shambler Concentration Check
    //---------------------------------------------------------------------------
    if (nContinue)
        nContinue = EShamConc();

    //---------------------------------------------------------------------------
    // Run NullPsionicsField Check
    //---------------------------------------------------------------------------
    if (nContinue)
        nContinue = NullPsionicsField();

    if (nContinue)
    {
        //---------------------------------------------------------------------------
        // Run use magic device skill check
        //---------------------------------------------------------------------------
        nContinue = X2UseMagicDeviceCheck();
    }

    if (nContinue)
    {
        //-----------------------------------------------------------------------
        // run any user defined spellscript here
        //-----------------------------------------------------------------------
        nContinue = X2RunUserDefinedSpellScript();
    }

    //---------------------------------------------------------------------------
    // Check for the new restricted itemproperties
    //---------------------------------------------------------------------------
    if(nContinue
    && GetIsObjectValid(GetSpellCastItem()))
    //&& !CheckPRCLimitations(GetSpellCastItem(), oManifestor))
    {
        SendMessageToPC(oManifestor, "You cannot use "+GetName(GetSpellCastItem()));
        nContinue = FALSE;
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
            nContinue = !ExecuteScriptAndReturnInt("x2_pc_craft", oManifestor);
        }

        //-----------------------------------------------------------------------
        // * Execute item OnSpellCast At routing script if activated
        //-----------------------------------------------------------------------
        if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
        {
            SetUserDefinedItemEventNumber(X2_ITEM_EVENT_SPELLCAST_AT);
            int nRet = ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oTarget), oManifestor);
            if (nRet == X2_EXECUTE_SCRIPT_END)
            {
                return FALSE;
            }
        }

        //-----------------------------------------------------------------------
        // Prevent any spell that has no special coding to handle targetting of items
        // from being cast on items. We do this because we can not predict how
        // all the hundreds spells in NWN will react when cast on items
        //-----------------------------------------------------------------------
        if (nContinue) {
            nContinue = X2CastOnItemWasAllowed(oTarget);
        }
    }

    //Cleaning spell variables used for holding the charge
    if(!GetLocalInt(oManifestor, "PRC_SPELL_EVENT"))
    {
        DeleteLocalInt(oManifestor, "PRC_SPELL_CHARGE_COUNT");
        DeleteLocalInt(oManifestor, "PRC_SPELL_CHARGE_SPELLID");
        DeleteLocalObject(oManifestor, "PRC_SPELL_CONC_TARGET");
        DeleteLocalInt(oManifestor, "PRC_SPELL_METAMAGIC");
        DeleteLocalManifestation(oManifestor, "PRC_POWER_HOLD_MANIFESTATION");
    }
    else if(GetLocalInt(oManifestor, "PRC_SPELL_CHARGE_SPELLID") != GetSpellId())
    {   //Sanity check, in case something goes wrong with the action queue
        DeleteLocalInt(oManifestor, "PRC_SPELL_EVENT");
    }*/
	
	if (GetSpellFailedBecauseMissChance(oManifestor)) nContinue = FALSE;
	if (nContinue) FF_SaySpellChat(oManifestor);
	
    return nContinue;
	
}