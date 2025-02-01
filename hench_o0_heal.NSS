#include "ff_safevar"

/*

    Companion and Monster AI

    Heals ally from command, currently only from shout (could reenable auto heal later)  

*/


#include "hench_i0_itemsp"
#include "hench_i0_assoc"


void main()
{
//    Jug_Debug(GetName(OBJECT_SELF) + " healing code start");

    int nHealingType = PS_GetLocalInt(OBJECT_SELF, henchHealTypeStr);

    if (nHealingType == HENCH_CNTX_MENU_OFF)
    {    
        PS_DeleteLocalInt(OBJECT_SELF, henchHealCountStr);
        PS_DeleteLocalInt(OBJECT_SELF, henchHealTypeStr);
        PS_DeleteLocalInt(OBJECT_SELF, henchHealStateStr);
        PS_DeleteLocalObject(OBJECT_SELF, henchHealSpellTarget);
        return;
    }

    SetCommandable(TRUE);
//	SpawnScriptDebugger();
	object oMaster = GetCurrentMaster(); 

	gfBuffSelfWeight = 1.0;
	gfBuffOthersWeight = 1.0;

	IntitializeHealingInfo(TRUE);

    InitializeBasicTargetInfo();
    // clear enemy target lists
    PS_DeleteLocalObject(OBJECT_SELF, sEnemySeen);
    PS_DeleteLocalObject(OBJECT_SELF, sEnemyLineOfSight);
	
	gsAttackTargetInfo.spellID = -1;	// SPELL_ACID_FOG is zero
	gsBuffTargetInfo.spellID = -1;	// SPELL_ACID_FOG is zero
		
	int iNegEffectsOnSelf = GetCreatureNegEffects(OBJECT_SELF);		
	int iPosEffectsOnSelf = GetCreaturePosEffects(OBJECT_SELF);
    int nClass = HenchDetermineClassToUse();    
    
    object oHealTarget = PS_GetLocalObject(OBJECT_SELF, henchHealSpellTarget);
    int curHealCount = PS_GetLocalInt(OBJECT_SELF, henchHealCountStr);

    if (!GetIsObjectValid(oHealTarget))
    {
        InitializeAllyList(FALSE);
        if (curHealCount == 1)
        {
            ReportUnseenAllies();
        }
    }
    else
    {
        int bTargetSeen = InitializeSingleAlly(oHealTarget);
        if (!bTargetSeen)
        {
			//	"I can't see "
            SpeakString(GetStringByStrRef(230439) + GetName(oHealTarget));
        }
    }
        
    if (nHealingType == HENCH_CNTX_MENU_HEAL)
    {    
	    gbDisableNonHealorCure = TRUE;        
        gbSpellInfoCastMask = HENCH_SPELL_INFO_HEAL_OR_CURE;
        PS_DeleteLocalInt(OBJECT_SELF, henchHealStateStr);
    }
    else
    {
        gbDoingBuff = TRUE;
        // initialize all buffing flags
        object oFriend = OBJECT_SELF;
        while (GetIsObjectValid(oFriend))
        {
    	    PS_SetLocalFloat(oFriend, friendMeleeTargetStr, 1.0);
            object oLast = oFriend;
	    	oFriend = PS_GetLocalObject(oFriend, sAllyLineOfSight);
            PS_SetLocalObject(oLast, friendMeleeTargetStr, oFriend);
        }
                
        gHenchUseSpellProtectionsChecked = HENCH_GLOBAL_FLAG_TRUE;
		goBestSpellCaster = OBJECT_SELF;	// give good default for buff
        gbMeleeTargetInit = TRUE;
        gbIAmMeleeTarget = TRUE;
        
        int currentBuffState = PS_GetLocalInt(OBJECT_SELF, henchHealStateStr);        
        if (currentBuffState == HENCH_CNTX_MENU_BUFF_LONG)
        {    
            gbSpellInfoCastMask = HENCH_SPELL_INFO_LONG_DUR_BUFF;
        }
        else if (currentBuffState == HENCH_CNTX_MENU_BUFF_MEDIUM)
        {    
            gbSpellInfoCastMask = HENCH_SPELL_INFO_MEDIUM_DUR_BUFF;
        }
        else if (currentBuffState == HENCH_CNTX_MENU_BUFF_SHORT)
        {    
            gbSpellInfoCastMask = HENCH_SPELL_INFO_SHORT_DUR_BUFF;
        }
        else
        {
            PS_DeleteLocalInt(OBJECT_SELF, henchHealCountStr);
            PS_DeleteLocalInt(OBJECT_SELF, henchHealTypeStr);
            PS_DeleteLocalInt(OBJECT_SELF, henchHealStateStr);
            PS_DeleteLocalObject(OBJECT_SELF, henchHealSpellTarget);
            return;
        }
    }
//    Jug_Debug(GetName(OBJECT_SELF) + " cont heal target " + GetName(oHealTarget) + " mask " + IntToHexString(gbSpellInfoCastMask));
    
    InitializeItemSpells(nClass, iNegEffectsOnSelf, iPosEffectsOnSelf);
      
    if ((nHealingType == HENCH_CNTX_MENU_BUFF_MEDIUM) || (nHealingType == HENCH_CNTX_MENU_BUFF_SHORT))
    {
        int currentBuffState = PS_GetLocalInt(OBJECT_SELF, henchHealStateStr);
        if (!HenchCheckSpellToCast(0, TRUE))
        {
            // try the next shorter duration        
//            Jug_Debug(GetName(OBJECT_SELF) + " skipping buff " + IntToString(currentBuffState));
            if (currentBuffState == HENCH_CNTX_MENU_BUFF_LONG)
            {
//                Jug_Debug(GetName(OBJECT_SELF) + " try medium");
                PS_SetLocalInt(OBJECT_SELF, henchHealCountStr, curHealCount + 1);
                PS_SetLocalInt(OBJECT_SELF, henchHealStateStr, HENCH_CNTX_MENU_BUFF_MEDIUM);
                DelayCommand(0.01, ExecuteScript("hench_o0_heal", OBJECT_SELF));
                return;
            }
            if ((currentBuffState == HENCH_CNTX_MENU_BUFF_MEDIUM) && (nHealingType == HENCH_CNTX_MENU_BUFF_SHORT))
            {
//                Jug_Debug(GetName(OBJECT_SELF) + " try short");
                PS_SetLocalInt(OBJECT_SELF, henchHealCountStr, curHealCount + 1);
                PS_SetLocalInt(OBJECT_SELF, henchHealStateStr, HENCH_CNTX_MENU_BUFF_SHORT);
                DelayCommand(0.01, ExecuteScript("hench_o0_heal", OBJECT_SELF));
                return;
            }
//            Jug_Debug(GetName(OBJECT_SELF) + " continue on");
        }
        else
        {
            // check to see if we should wait        
//            Jug_Debug(GetName(OBJECT_SELF) + " checking next buff " + IntToString(currentBuffState));
            object oPartyMember = GetFirstFactionMember(OBJECT_SELF, FALSE);
            while (GetIsObjectValid(oPartyMember))
            {
         		if (!(GetIsPC(oPartyMember) && GetHenchPartyState(HENCH_PARTY_DISABLE_SELF_HEAL_OR_BUFF))
					&& (oPartyMember != OBJECT_SELF))
        		{
                    int partyMemberHealState = PS_GetLocalInt(oPartyMember, henchHealStateStr);
                    if (partyMemberHealState && (partyMemberHealState < currentBuffState))
                    {
                        // need to wait
//                        Jug_Debug(GetName(OBJECT_SELF) + " waiting for next buff " + IntToString(currentBuffState));
                        return;
                    }
        		}
                oPartyMember = GetNextFactionMember(OBJECT_SELF, FALSE);
            }
        }
    }
    
    if (HenchCheckSpellToCast(0))
    {
        if (bgAnyValidTarget && (curHealCount < 10))
        {
            DelayCommand(2.0, VoiceCanDo());
        }
        PS_SetLocalInt(OBJECT_SELF, henchHealCountStr, curHealCount + 10);
		
		if (GetIsPC(OBJECT_SELF))
		{		
			ActionWait(4.0);
			ActionDoCommand(DelayCommand(0.01, ExecuteScript("hench_o0_heal", OBJECT_SELF)));		
		}		
		
        return;
    }
    
    if (curHealCount < 10)
    {
            // didn't find any heal or buff spells
        DelayCommand(2.5, VoiceCannotDo());
    }
    else
    {
        VoiceTaskComplete(TRUE);
    }
    
    PS_DeleteLocalInt(OBJECT_SELF, henchHealCountStr);
    PS_DeleteLocalInt(OBJECT_SELF, henchHealTypeStr);
    PS_DeleteLocalInt(OBJECT_SELF, henchHealStateStr);
    PS_DeleteLocalObject(OBJECT_SELF, henchHealSpellTarget);
}