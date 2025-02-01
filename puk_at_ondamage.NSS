/*
    INFORMATION:
    Amount of XP to Give to set the Initial Level
    L1 = 1
    L2 = 1000
    L3 = 3000
    L4 = 6000
    L5 = 10000
    L6 = 15000
    L7 = 21000
    L8 = 28000
    L9 = 36000
    L10 = 45000
    L11 = 55000
    L12 = 66000
    L13 = 78000
    L14 = 91000
    L15 = 105000
    L16 = 120000
    L17 = 136000
    L18 = 153000
    L19 = 171000
    L20 = 190000
    L21 = 210000
    L22 = 231000
    L23 = 253000
    L24 = 276000
    L25 = 300000
    L26 = 325000
    L27 = 351000
    L28 = 378000
    L29 = 406000
    L30 = 435000
    */
////////////////////////////////////////////////////////////////////////////////
//
//  Training Dummy and Training Target
//  puk_at_ondamage
//  By:Don Anderson
//  dandersonru@msn.com
//  Adapted and implemented for NWN 2 by puket
//
//  This is placed in the OnDamaged Event of an Archery Target
//
////////////////////////////////////////////////////////////////////////////////

#include "x2_inc_itemprop"
#include "ps_inc_functions"

// Color Variables
const string RED       = "<color=#FF0000>";
const string BLUE      = "<color=#0000FF>";
const string GRAY      = "<color=#808080>";
const string GREEN     = "<color=#8000>";
const string LIGREEN   = "<color=LightGreen>";
const string WHITE     = "<color=#FFFFFF>";
const string CYAN      = "<color=#00FFFF>";
const string YELLOW    = "<color=#FFFF00>";
const string ORANGE    = "<color=#FFA500>";
const string ORCHID    = "<color=#DA70D6>";
const string MINTCREAM = "<color=#F5FFFA>";
const string INDIGO    = "<color=#4B0082>";
const string GOLD      = "<color=#FFD700>";

int GetIsEnhanced(object oItem)
{
    if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS)) return TRUE;
    else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP)) return TRUE;
    else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP)) return TRUE;
    else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT)) return TRUE;
    else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS)) return TRUE;
    else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP)) return TRUE;
    else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP)) return TRUE;
    else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT)) return TRUE;
    else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS)) return TRUE;
    else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP)) return TRUE;
    else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP)) return TRUE;
    else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT)) return TRUE;
    else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ON_HIT_PROPERTIES)) return TRUE;
    else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL)) return TRUE;
    else return FALSE;
}

void main()
{
    object oSelf    = OBJECT_SELF;
    string sName    = GetName(oSelf);
    object oPC      = GetLastDamager();
	
	if(!GetIsPC(oPC)) return;

    object oWeapon  = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    string sWeapon  = GetResRef(oWeapon);
    int nWeapon     = GetWeaponRanged(oWeapon);

    //:****************************************************************************/
	//: LOOK HERE PLEASE !!!
    //: SET ONLY HERE WHAT YOU WANT TO GIVE OR ALLOW AT ALL !!!
    int nTrainerLEV = 0;//Set to 1 this if you don't want to give XP and/or Level-up
	int nTrainerENR = 1;//Set to 1 this if you want to allow Enhanced Weapons
    int nTrainerXPS = 250;//Set this to the XP Per Each Session
    int nTrainerDPS = 100;//Set this to Amount of Damage Required Per Session
    int nTrainerXPL = 28000;//Set this to the Max XP for Combat Trainers (Level 10 Default)

   //:****************************************************************************/

    //The Player is restricted by the Max XP Level Setting
    if(nTrainerXPL == 0) nTrainerXPL = 10000;//Level 5 Default
    int nPCXP = GetXP(oPC);
    if(nPCXP > nTrainerXPL)
    {
      AssignCommand(oPC,ClearAllActions(TRUE));
      SendMessageToPC(oPC, WHITE + "You can no longer learn anything from this "+sName+ ".");
      return;
    }

    //If the Weapon is not a ranged weapon cancel
    if(nWeapon == FALSE)
    {
      AssignCommand(oPC,ClearAllActions(TRUE));
      SendMessageToPC(oPC, RED + "You can only use Ranged Weapons on this Target.");
      return;
    }

    //NO Enhanced Weapons Can Be Used
    if(GetIsEnhanced(oWeapon) == TRUE && nTrainerENR == 0)
    {
      AssignCommand(oPC,ClearAllActions(TRUE));
      SendMessageToPC(oPC, RED + "You can only use NON ENHANCED Ranged Weapons on this Target.");
      return;
    }
	
    int nXP     = nTrainerXPS;
    int nReq    = nTrainerDPS;
    int nGive   = 0;
    int nDamage = GetTotalDamageDealt();
    int nTally  = PS_GetLocalInt(oPC, "ATTALLY");
    int nMessage = 0;

    //These are the Messages given during the Session
    string sMessage1 = WHITE + "That one might have missed the Barn =) !";
    string sMessage2 = WHITE + "Barely hit the target!";
    string sMessage3 = WHITE + "Blue....could be better!";
    string sMessage4 = WHITE + "White.....not bad at all!";
    string sMessage5 = WHITE + "Red.....nice shot!";
    string sMessage6 = WHITE + "Very Nice shot....dead center of the Red!";

    //NO CHEATING =) ...the Weapon you start the session with is what you must finish with
    if(nTally == 0)
    {
      PS_SetLocalString(oPC,"SESSIONRANGED",sWeapon);
    }
    if(nTally >= 1)
    {
      string sOWeapon = PS_GetLocalString(oPC,"SESSIONRANGED");
      object oNWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
      string sNWeapon = GetResRef(oWeapon);

      if(sOWeapon != sNWeapon)
      {
        AssignCommand(oPC,ClearAllActions(TRUE));
        SendMessageToPC(oPC, RED + "You must finish this Session with the SAME weapon you started it with!");
        return;
      }
    }

    //This is where we keep a running total
    nTally = nTally + nDamage;
    nMessage = nDamage;

    if(nTally >= nReq)
    {
      nGive = 1;
      PS_SetLocalInt(oPC,"ATTALLY",0);
    }
    else if(nTally < nReq)
    {
      nGive = 0;
      PS_SetLocalInt(oPC,"ATTALLY",nTally);
    }

    //Give the Player information about the progress
    string sTally = IntToString(nTally);
    string sReq = IntToString(nReq);
    SendMessageToPC(oPC, WHITE + "Tallied damage is: " + LIGREEN +sTally+ WHITE + " of the required: " + LIGREEN +sReq );

    if (!GetIsPC(oPC)) return;

    // Give Experience for this session
    if(nGive == 1 && nTrainerLEV == 0)
    {
      AssignCommand(oPC,ClearAllActions(TRUE));
      PS_GiveXPReward(oPC,nXP);
      SendMessageToPC(oPC, WHITE + "Nice work!! You have gained " + YELLOW +IntToString(nXP)+ WHITE + " Experience in this session.");
      DelayCommand(1.0, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED,1.0,3.0)));
      DelayCommand(4.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1,1.0)));
    }
	else if(nGive == 1 && nTrainerLEV == 1)
	{
      AssignCommand(oPC,ClearAllActions(TRUE));
      SendMessageToPC(oPC, WHITE + "Nice work!! You have finished this session.");
      DelayCommand(1.0, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED,1.0,3.0)));
      DelayCommand(4.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1,1.0)));
    }
    //Give a Message to Player
    else 
    {
      if(d2() == 1)
      {
        //Decide which message to give to the Player
        if(nMessage == 0) SendMessageToPC(oPC, sMessage1);
        if(nMessage >= 1 && nMessage < 3) SendMessageToPC(oPC, sMessage2);
        if(nMessage >= 3 && nMessage < 6) SendMessageToPC(oPC, sMessage3);
        if(nMessage >= 6 && nMessage < 10) SendMessageToPC(oPC, sMessage4);
        if(nMessage >= 10 && nMessage < 15) SendMessageToPC(oPC, sMessage5);
        if(nMessage >= 15) SendMessageToPC(oPC, sMessage6);
      }
    }
}