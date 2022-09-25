//:://////////////////////////////////////////////
//:: Sigil Equip system
//:://////////////////////////////////////////////
//:: Runs the Custom OnEquip and OnUnequip Scripts.
//:://////////////////////////////////////////////
//:: Created By: Clangeddin
//:: Created On: December 29, 2017

#include "aaa_constants"
#include "ginc_2da"
#include "nw_i0_spells"
#include "x2_inc_itemprop"
#include "class_monk_shatteringblows"
#include "ps_inc_equipmentprops"


const int SIGIL_EQUIP_FX = -9444;
const int SIGIL_ARMOR_OPTIMIZATION_FX = -9544;


//This gets the weapons that qualify for Meditative Strikes
int GetMonkWeapon(object oItem)
{ 
       int iBaseItem = GetBaseItemType(oItem);
    return iBaseItem ==  BASE_ITEM_SHURIKEN || iBaseItem == BASE_ITEM_GLOVES ||    iBaseItem == BASE_ITEM_KAMA || iBaseItem == BASE_ITEM_QUARTERSTAFF;
}


int GetCreatureWeapons(object oItem)
{
int iBaseItem = GetBaseItemType(oItem);
return iBaseItem == 164  || iBaseItem == 165  || iBaseItem == 166 || iBaseItem == 167 || iBaseItem == 168 || iBaseItem == 169 || iBaseItem == 170
|| iBaseItem == 171 || iBaseItem == 172 || iBaseItem == 173 || iBaseItem == 174 || iBaseItem == 175 || iBaseItem == 176 || iBaseItem == 177 || iBaseItem == 178
|| iBaseItem == 179 || iBaseItem == 180;
}


int NoHeavyArmorOrShield(object oPC)
{
	int chest = GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST,oPC));
	if(chest == 3 || chest == 2) return FALSE;

//	SendMessageToPC(oPC,"DEBUG: Armor check is good!");	
	
	object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
	if (oShield == OBJECT_INVALID) return TRUE;

//	SendMessageToPC(oPC,"DEBUG: Shield check is good!");	
		
	int shield = GetBaseItemType(oShield);
	if(shield == 56 || shield == 14 || shield == 57) return FALSE;	

//	SendMessageToPC(oPC,"DEBUG: Shield type check is good!");	
		
	return TRUE;
}




int GetDervishWeapon(object oItem)
{  
if(!GetIsObjectValid(oItem)) return FALSE;
        
int iType = GetBaseItemType(oItem);
    if(Get2DAString("baseitems","WeaponType",iType) == "3" && Get2DAString("baseitems","WeaponSize",iType) == "3"
    || Get2DAString("baseitems","WeaponType",iType) == "3" && Get2DAString("baseitems","WeaponSize",iType) == "4") return TRUE;
    else            
    return FALSE;
}
int nDervishValid (object oPC)
{

int chest = GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST,oPC));
	if(chest == 3 || chest == 2) return FALSE;

//	SendMessageToPC(oPC,"DEBUG: Armor check is good!");	
	
	object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
	if (oShield == OBJECT_INVALID) return TRUE;

//	SendMessageToPC(oPC,"DEBUG: Shield check is good!");	
		
	int shield = GetBaseItemType(oShield);
	if(shield == 56 || shield == 14 || shield == 57) return FALSE;	

//	SendMessageToPC(oPC,"DEBUG: Shield type check is good!");	
		
	return TRUE;
}


//Gets the Property from wisdom, converts into Magical Damage, and applies it on correct weapons
void ApplyMeditativeStrikes(object oPC,object oItem)
{    
    int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
    
    if(nWis <= 0){
    
    //    SendMessageToPC(oPC, "Wisdom modifier is lower or equal to 0");
        return;
    }
    else if(!GetMonkWeapon(oItem)){
    
      //  SendMessageToPC(oPC, "Weapon is not a monk weapon");
        return;
    }
    itemproperty ipAdd = GetItemPropertyReference(oItem, "MeditativeStrikes");
        if (GetIsItemPropertyValid(ipAdd) != FALSE) {
        SendMessageToPC(oPC, "Meditative strikes already active.");
        return;
}


    
    int nDamageConstant = IPGetDamageBonusConstantFromNumber(nWis);    
    int nDamageType = IP_CONST_DAMAGETYPE_DIVINE;
    float fDUR = 9999.9f;    
    ipAdd  = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, nDamageConstant);
    
    if(GetHasFeat(2840,oPC, TRUE))
    {
        if(!GetIsItemPropertyValid(ipAdd)){
        
            SendMessageToPC(oPC, "Itemproperty was not valid");
            return;
        }
    
        SendMessageToPC(oPC, "Applying damage constant: "+IntToString(nDamageConstant));    
        IPSafeAddItemProperty(oItem, ipAdd, fDUR, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        SaveItemPropertyReference(oItem, "MeditativeStrikes", ipAdd);

        SendMessageToPC(oPC, "Wisdom Damage bonus of " + IntToString(nWis) + " applied to your Monk Weapon");
    }

}

//Removes Meditative Strikes off propertry
void RemoveMeditativeStrikes(object oPC,object oItem)
{
  if(GetHasFeat(2840,oPC, TRUE)){
itemproperty ipAdd = GetItemPropertyReference(oItem, "MeditativeStrikes");
if (GetIsItemPropertyValid(ipAdd) == FALSE) {
    SendMessageToPC(oPC, "Item Property no longer exists on the Item itself");
    return;
}

DeleteItemPropertyReference(oItem, "MeditativeStrikes");

}

}

//Adds Austere One levels as flat Slashing Damage to gloves
void ApplyAustereStrikes(object oPC,object oItem)
{    
    int nRak = GetLevelByClass(CLASS_TYPE_AUSTERE_ONE, oPC);
    
    if(nRak <= 0){
    
    //    SendMessageToPC(oPC, "Austere One PRC levels = 0");
        return;
    }
    else if(!GetBaseItemType(oItem) == BASE_ITEM_GLOVES){                 
    
      //  SendMessageToPC(oPC, "PC is using a weapon, not unarmed");
        return;
    }
    itemproperty ipAdd = GetItemPropertyReference(oItem, "AustereStrikes");
        if (GetIsItemPropertyValid(ipAdd) != FALSE) {
        SendMessageToPC(oPC, "Austere Strikes already active.");
        return;
}


    
    int nDamageConstant = GetLevelByClass(CLASS_TYPE_AUSTERE_ONE, oPC);    
    int nDamageType = IP_CONST_DAMAGETYPE_SLASHING;
    float fDUR = 9999.9f;    
    ipAdd  = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING, nDamageConstant);
    
    if(GetLevelByClass(CLASS_TYPE_AUSTERE_ONE, oPC)> 0)
    {
        if(!GetIsItemPropertyValid(ipAdd)){
        
            SendMessageToPC(oPC, "Item property was not valid");
            return;
        }
    
        SendMessageToPC(oPC, "Applying damage constant: "+IntToString(nDamageConstant));    
        IPSafeAddItemProperty(oItem, ipAdd, fDUR, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        SaveItemPropertyReference(oItem, "AustereStrikes", ipAdd);

        SendMessageToPC(oPC, "Slashing Damage bonus of " + IntToString(nDamageConstant) + " applied to your Gloves");
    }

}

//Removes Austere Strikes off propertry
void RemoveAustereStrikes(object oPC,object oItem)
{
  if(GetLevelByClass(CLASS_TYPE_AUSTERE_ONE, oPC)> 0){
itemproperty ipAdd = GetItemPropertyReference(oItem, "AustereStrikes");
if (GetIsItemPropertyValid(ipAdd) == FALSE) {
    SendMessageToPC(oPC, "Item Property no longer exists on the Item itself");
    return;
}

DeleteItemPropertyReference(oItem, "AustereStrikes");

}

}


//Elemental Weapon - Applies Elemental Damage based on feat.
void ApplyElementalWeapon(object oPC, object oItem)
{   

if (GetWeaponRanged(oItem)==TRUE) 
{SendMessageToPC(oPC,"Elemental Weapon only works with Melee Weapons");//
return; }


    int nLevel=GetLevelByClass(CLASS_TYPE_ELEMENTAL_WARRIOR, oPC);
    itemproperty ipAdd = GetItemPropertyReference(oItem, "ElementalWeapon");
    int nDamage = IP_CONST_DAMAGEBONUS_1d6;
        if (nLevel >= 5 ) 
        {   nDamage = IP_CONST_DAMAGEBONUS_3d6; }
   // int nItemVisual;
    int DamageType;     
    //itemproperty iGlow = ItemPropertyVisualEffect(nItemVisual);
    if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_AIR,oPC,TRUE))
    {   
        DamageType = IP_CONST_DAMAGETYPE_ELECTRICAL;
       // nItemVisual = ITEM_VISUAL_ELECTRICAL;
    }
        else
    if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_EARTH,oPC,TRUE))
    {   
        DamageType = IP_CONST_DAMAGETYPE_ACID;
       // nItemVisual = ITEM_VISUAL_ACID;             
    }
        else
    if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_FIRE,oPC,TRUE))
    {
        DamageType = IP_CONST_DAMAGETYPE_FIRE;
      //  nItemVisual = ITEM_VISUAL_FIRE;         
    }
        else
    if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_WATER,oPC,TRUE))
    {
        DamageType = IP_CONST_DAMAGETYPE_COLD;
      //  nItemVisual = ITEM_VISUAL_COLD; 
    }
    ipAdd =ItemPropertyDamageBonus(DamageType,nDamage);
    float fDUR = 9999.9f;   
    if(GetHasFeat(FEAT_ELEMWAR_WEAPON,oPC, TRUE))
    {   if(!GetIsItemPropertyValid(ipAdd)){
        
           // SendMessageToPC(oPC, "Itemproperty was not valid");
            return;
        }
   // SendMessageToPC(oPC, "Applying damage constant: "+IntToString(nDamage));    
    IPSafeAddItemProperty(oItem,ipAdd,fDUR,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    //IPSafeAddItemProperty(oItem, iGlow, fDUR, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    SaveItemPropertyReference(oItem, "ElementalWeapon", ipAdd);
  //  SendMessageToPC(oPC, "Elemental Damage has been added to your weapon");
}
}
//Removes Elemental Weapon Property off Weapon
void RemoveElementalWeapon(object oPC,object oItem)
{
  if(GetLevelByClass(CLASS_TYPE_ELEMENTAL_WARRIOR,oPC)>=0 ){
itemproperty ipAdd = GetItemPropertyReference(oItem, "ElementalWeapon");
if (GetIsItemPropertyValid(ipAdd) == FALSE) {
    //SendMessageToPC(oPC, "Item Property no longer exists on the Item itself");
    return;
}
    DeleteItemPropertyReference(oItem, "ElementalWeapon");
    
    

}
}




//Wrapper to check if nTYPE is a creature weapon. Item Type from 160 to 180
int GetIsCreatureWeapon(int nTYPE)
{
   if (nTYPE < 160) return FALSE;
   if (nTYPE > 180) return FALSE;
    return TRUE;
   
}


int GetIsShields (object oItem)
{
  int iBaseItem = GetBaseItemType(oItem);
   return iBaseItem = BASE_ITEM_LARGESHIELD || BASE_ITEM_SMALLSHIELD || BASE_ITEM_TOWERSHIELD;

}


//A Wrapper for to Ignore Exsisting Finesse
int GetExistingFinesse(object oItem)
{
    if ((GetBaseItemType(oItem) == BASE_ITEM_DAGGER) || (GetBaseItemType(oItem) ==BASE_ITEM_GLOVES )
     ||(GetBaseItemType(oItem) == BASE_ITEM_KAMA ) ||(GetBaseItemType(oItem) == BASE_ITEM_SHORTSWORD)||(GetBaseItemType(oItem) ==BASE_ITEM_SICKLE)
    ||(GetBaseItemType(oItem) ==BASE_ITEM_HANDAXE)||(GetBaseItemType(oItem) ==BASE_ITEM_LIGHTHAMMER)||
    (GetBaseItemType(oItem) ==BASE_ITEM_MACE)||(GetBaseItemType(oItem) ==BASE_ITEM_RAPIER)) return TRUE;
else
return FALSE;


}

//Wrapper to equip effects from equipment in the proper manner.
void ApplyEquipmentEffect(object oPC, effect eFX, int nDUR = DURATION_TYPE_PERMANENT)
{
    eFX = SupernaturalEffect(eFX);
    eFX = SetEffectSpellId(eFX, SIGIL_EQUIP_FX);
    ApplyEffectToObject(nDUR, eFX, oPC);
}

//Removes Shield if you don't have the feat required for it. To prevent exploit.
int FixSHIELD(object oPC, object oSHIELD, int nSHIELD)
{
    int nFEAT;
    switch (nSHIELD)
    {
        case BASE_ITEM_SMALLSHIELD: nFEAT = FEAT_SHIELD_PROFICIENCY; break;
        case BASE_ITEM_LARGESHIELD: nFEAT = FEAT_SHIELD_PROFICIENCY; break;
        case BASE_ITEM_TOWERSHIELD: nFEAT = FEAT_TOWER_SHIELD_PROFICIENCY; break;
        default: return FALSE;
    }
    if (GetHasFeat(nFEAT, oPC, TRUE) == TRUE) return FALSE;
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionUnequipItem(oSHIELD));
    return TRUE;
}

//Removes Armor if you don't have the feat required for it. To prevent exploit.
int FixARMOR(object oPC, object oARMOR)
{
    int nARMOR = GetArmorRank(oARMOR);
    int nFEAT;
    switch (nARMOR)
    {
        case ARMOR_RANK_LIGHT: nFEAT = FEAT_ARMOR_PROFICIENCY_LIGHT; break;
        case ARMOR_RANK_MEDIUM: nFEAT = FEAT_ARMOR_PROFICIENCY_MEDIUM; break;
        case ARMOR_RANK_HEAVY: nFEAT = FEAT_ARMOR_PROFICIENCY_HEAVY; break;
        default: return FALSE;
    }
    if (GetHasFeat(nFEAT, oPC, TRUE) == TRUE) return FALSE;
    AssignCommand(oPC, ClearAllActions(TRUE));
    AssignCommand(oPC, ActionUnequipItem(oARMOR));
    return TRUE;
}

// Check for giant weapons and monkey grip abuse
int MonkeyGripAbuse(object oPC, object oITEM, int nITEM)
{
    if (nITEM != 150 && nITEM != 151 && nITEM != 152) return FALSE;
    if (GetCreatureSize(oPC) >= CREATURE_SIZE_LARGE) return FALSE;
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionUnequipItem(oITEM));
    SendMessageToPC(oPC, "<c=red>Your character is too small to wield giant weapons, yes, even with monkey grip, the size/weight mechanics are simply too much for you.");
    return TRUE;
}

// once per day any temp properties stuck on the item will be cleared. Basically first time it is equipped between resets.
// might fire again if player has relogged as object ID can change, but at least won't fire every time.
void CheckForTempProperties(object oItem, object oPC)
{
    string sID = ObjectToString(oItem);
    if (GetLocalInt(oPC, sID) == TRUE) return;
    itemproperty ipProp = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ipProp))
    {
        if (GetItemPropertyDurationType(ipProp) == DURATION_TYPE_TEMPORARY) RemoveItemProperty(oItem, ipProp);
        ipProp = GetNextItemProperty(oItem);
    }
    SetLocalInt(oPC, sID, TRUE);
}

// Check No Manual Dexterity. With it you can only equip creature weapons.
int CheckManualDexterity(object oPC, object oITEM, int nITEM)
{
    if (GetIsCreatureWeapon(nITEM) == TRUE) return FALSE;
    
    switch (nITEM)
    {
        case BASE_ITEM_AMULET:
        case BASE_ITEM_ARROW:
        case BASE_ITEM_BELT:
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BOOTS:
        case BASE_ITEM_BRACER:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_CLOAK:
        case BASE_ITEM_GLOVES:
        case BASE_ITEM_HELMET:
        case BASE_ITEM_RING:
        case BASE_ITEM_ARMOR:
            return FALSE;
    }
    
    if (GetHasFeat(2340, oPC, TRUE) == FALSE) return FALSE;
    
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionUnequipItem(oITEM));
    SendMessageToPC(oPC, "<c=red>Your character cannot wield weapons, shields, or any other object in their hands due to the No Manual Dexterity feat");
    return TRUE;    
}

// No Weapons and Shields for Dragons in Natural Form and no Armor in both forms (exept clothes)
// Creature weapons are 160-180. Others are not allowed unless "in humanoid form (=1)".
int CheckDragonForms(object oPC, object oITEM, int nITEM)
{
    switch (nITEM)
    {
        case BASE_ITEM_AMULET:
        case BASE_ITEM_ARROW:
        case BASE_ITEM_BELT:
        case BASE_ITEM_BOLT:
		case BASE_ITEM_ARMOR:
        case BASE_ITEM_BOOTS:
        case BASE_ITEM_BRACER:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_CLOAK:
        case BASE_ITEM_GLOVES:
        case BASE_ITEM_HELMET:
        case BASE_ITEM_RING:
            return FALSE;
    }
    
    if (GetHasFeat(3623, oPC, TRUE) == FALSE) return FALSE;
    
    object oESSENCE = GetItemPossessedBy(oPC, "ps_essence");
    if (GetLocalInt(oESSENCE, "TempChange") == 1)
    {
        if (GetIsCreatureWeapon(nITEM) == TRUE)
        {
            SendMessageToPC(oPC, "<c=red>Your character does not have claws or a bite in humanoid form.");
            AssignCommand(oPC, ClearAllActions());
            AssignCommand(oPC, ActionUnequipItem(oITEM));
            return TRUE;
        }
    }
    else if (GetIsCreatureWeapon(nITEM) == FALSE)
    {
        SendMessageToPC(oPC, "<c=red>Your character cannot wield weapons or shields in natural form.");
        AssignCommand(oPC, ClearAllActions());
        AssignCommand(oPC, ActionUnequipItem(oITEM));
        return TRUE;
    }
    
    return FALSE;
}

// Marquis Cambion Silent Metal
void SilentMetal(object oPC, object oARMOR, object oSHIELD, int nSHIELD, string s2DA = "armorrulestats", string sCOLUMN = "ACCHECK")
{
    if (GetHasFeat(FEAT_MARQCAMB_SILENT_METAL, oPC, TRUE) == FALSE) return;
    int nCACHE = GetNum2DARows(s2DA); //Faster if cached.
    int nRULES;
    int nACCHECK;
    int nPENALTY;
    
    if (GetArmorRank(oARMOR) != ARMOR_RANK_NONE)
    {
        nRULES = GetArmorRulesType(oARMOR);
        nACCHECK = Get2DAInt(s2DA, sCOLUMN, nRULES);
        if (nACCHECK != 0) nPENALTY = abs(nACCHECK);
    }
    
    if (nSHIELD == BASE_ITEM_SMALLSHIELD || nSHIELD == BASE_ITEM_LARGESHIELD || nSHIELD == BASE_ITEM_TOWERSHIELD)
    {
        nRULES = GetArmorRulesType(oSHIELD);
        nACCHECK = Get2DAInt(s2DA, sCOLUMN, nRULES);
        if (nACCHECK != 0) nPENALTY = nPENALTY + abs(nACCHECK);
    }
    
    if (nPENALTY < 1) return;
    effect eFX = EffectSkillIncrease(SKILL_HIDE, nPENALTY);
    eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_MOVE_SILENTLY, nPENALTY));
    ApplyEquipmentEffect(oPC, eFX);
}


// Heavy Armor Optimization Feats
void HeavyArmorOptimizations(object oPC, object oARMOR) {

	//Remove previous optimization effect
	if ( GetHasSpellEffect(SIGIL_ARMOR_OPTIMIZATION_FX, oPC) ) {
		effect eEffect = GetFirstEffect( oPC );
		while ( GetIsEffectValid(eEffect) ) {
		
			if ( GetEffectSpellId(eEffect) == SIGIL_ARMOR_OPTIMIZATION_FX){
				RemoveEffect( oPC, eEffect );
			}
				
			eEffect = GetNextEffect( oPC );
		}
	}
	
	if (GetBaseItemType(oARMOR) != BASE_ITEM_ARMOR) return;
    if (GetArmorRank(oARMOR) != ARMOR_RANK_HEAVY) return;
	
	//On to calculations
    int nAC;
	int nDUR = DURATION_TYPE_PERMANENT;
    int nSKILL;
    if (GetHasFeat(2838, oPC, TRUE) == TRUE)
    {
        nAC = 4;
        nSKILL = 5;
    }
    else if (GetHasFeat(2837, oPC, TRUE) == TRUE)
    {
        nAC = 2;
        nSKILL = 3;
    }
    else if (GetHasFeat(2836, oPC, TRUE) == TRUE)
    {
        nAC = 1;
        nSKILL = 1;
    }
    else return;
    
    effect eFX = EffectACIncrease(nAC);
    eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_PARRY, nSKILL));
    eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_SET_TRAP, nSKILL));
    eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_TUMBLE, nSKILL));
    if (GetHasFeat(FEAT_MARQCAMB_SILENT_METAL, oPC, TRUE) == FALSE)
    {
        eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_HIDE, nSKILL));
        eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_MOVE_SILENTLY, nSKILL));
    }
	
	
    eFX = SupernaturalEffect(eFX);
    eFX = SetEffectSpellId(eFX, SIGIL_ARMOR_OPTIMIZATION_FX);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC);
}

// Check if the weapon is finessable. Custom finessables from 160 to 174 and 202.
int GetIsSpecialFinessable(int nTYPE)
{
    if (GetIsCreatureWeapon(nTYPE) == TRUE) return TRUE;
    switch (nTYPE)
    {
        case 202:
        case BASE_ITEM_WHIP:
        case BASE_ITEM_CSLASHWEAPON:
        case BASE_ITEM_CPIERCWEAPON:
        case BASE_ITEM_CBLUDGWEAPON:
        case BASE_ITEM_CSLSHPRCWEAP:
            return TRUE;
    }
    return FALSE;
}


// Unearthly grace feat for Nymphs. CHA bonus to Saves and Dodge AC.
void UnearthlyGrace(object oPC, object oCHEST)
{
    if (GetHasFeat(2367, oPC, TRUE) == FALSE) return;
    if (GetArmorRank(oCHEST) > ARMOR_RANK_LIGHT) return;
    int nCHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    if (nCHA < 1) return;
    effect eFX = EffectSavingThrowIncrease(SAVING_THROW_ALL, nCHA);
    eFX = EffectLinkEffects(eFX, EffectACIncrease(nCHA, AC_DEFLECTION_BONUS));
    ApplyEquipmentEffect(oPC, eFX);
}


// Keep monk AC from affecting druids
void MonkDruidPenalty(object oPC)
{

    if (!GetHasFeat(4727, oPC, TRUE)) return;
	
	int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
    effect eFX = EffectACDecrease(nWis, AC_SHIELD_ENCHANTMENT_BONUS);
    ApplyEquipmentEffect(oPC, eFX);
	SendMessageToPC(oPC, "Both Druid and Monk levels detected. Applying AC penalty based on WIS mod");
}





//Fixes the Spell Resistance bug from items.
void SpellResistFix(object oPC, string s2DA = "iprp_srcost", string sCOLUMN = "Value")
{
    object oITEM;
    int nEQUIP;
    int nSR;
    int nMAX;
    int nTYPE;
    int nTABLE;
    int nCACHE = GetNum2DARows(s2DA);
    itemproperty iPROP;
    while (nEQUIP < 18)
    {
        oITEM = GetItemInSlot(nEQUIP, oPC);
        if (GetItemHasItemProperty(oITEM, ITEM_PROPERTY_SPELL_RESISTANCE) == TRUE)
        {
            iPROP = GetFirstItemProperty(oITEM);
            while (GetIsItemPropertyValid(iPROP))
            {
                nTYPE = GetItemPropertyType(iPROP);
                if (nTYPE == ITEM_PROPERTY_SPELL_RESISTANCE)
                {
                    nTABLE = GetItemPropertyCostTableValue(iPROP);
                    nSR = Get2DAInt(s2DA, sCOLUMN, nTABLE);
                    if (nSR > nMAX) nMAX = nSR;
                }
                iPROP = GetNextItemProperty(oITEM);
            }
        }
        nEQUIP = nEQUIP + 1;
    }
    if (nMAX > 0)
	{
    effect eFX = EffectSpellResistanceIncrease(nMAX);
    ApplyEquipmentEffect(oPC, eFX);
	}	
}

//Shields provide concealment against ranged attacks.
void ShieldRangedConceal(object oPC, int nSHIELD)
{
    int nCONCEAL;
    switch (nSHIELD)
    {
        case BASE_ITEM_SMALLSHIELD: nCONCEAL = 10; break;
        case BASE_ITEM_LARGESHIELD: nCONCEAL = 30; break;
        case BASE_ITEM_TOWERSHIELD: nCONCEAL = 60; break;
        default: return;
    }
    effect eFX = EffectConcealment(nCONCEAL, MISS_CHANCE_TYPE_VS_RANGED);
    ApplyEquipmentEffect(oPC, eFX);
}

void FIX_BLINDFIGHT(object oPC)
{
	if (GetHasFeat(FEAT_BLIND_FIGHT,oPC, TRUE) == FALSE) return;
	effect eEBLIND = EffectImmunity(IMMUNITY_TYPE_BLINDNESS);
	eEBLIND = SupernaturalEffect(eEBLIND);
	eEBLIND = SetEffectSpellId(eEBLIND, 9005);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEBLIND, oPC);
}

//Samurais get AB and damage bonus when they dual wield katana/longsword in main hand and shortsword in off hand.
void TwoSwordsAsOne(object oPC, int nRIGHT, int nLEFT)
{
    int nSAMURAI = GetLevelByClass(65, oPC);
    if (nSAMURAI < 2) return;
    if ((nRIGHT != BASE_ITEM_KATANA) && (nRIGHT != BASE_ITEM_LONGSWORD)) return;
    if (nLEFT != BASE_ITEM_SHORTSWORD) return;
    int nBONUS = 1;
    int nDMG_TYPE = DAMAGE_TYPE_BLUDGEONING;
    if (nSAMURAI >= 30) nDMG_TYPE = DAMAGE_TYPE_DIVINE;
    if (nSAMURAI >= 26) nBONUS = 5;
    else if (nSAMURAI >= 21) nBONUS = 4;
    else if (nSAMURAI >= 16) nBONUS = 3;
    else if (nSAMURAI >= 11) nBONUS = 2;
    effect eFX = EffectAttackIncrease(nBONUS);
    eFX = EffectLinkEffects(eFX, EffectDamageIncrease(nBONUS, nDMG_TYPE));
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC);
   // ApplyEquipmentEffect(oPC, eFX);
}



//When a Samurai draws their weapon (a katana or longsword) foes can be frightened by it.
void FrightfulPresence(object oPC)
{
    if (GetHasFeat(2419, oPC, TRUE) == FALSE) return;
    location lPC = GetLocation(oPC);
    int nCHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    float fDUR = RoundsToSeconds(nCHA);
    int nDC = 20 + nCHA;
    int nHD;
    effect eFX_1 = EffectLinkEffects(EffectStunned(), EffectVisualEffect(VFX_DUR_STUN));
    effect eFX_2 = EffectLinkEffects(EffectFrightened(), EffectVisualEffect(VFX_DUR_SPELL_FEAR));
    effect eFX_3 = EffectLinkEffects(EffectLinkEffects(EffectACDecrease(2), EffectAttackDecrease(2)), EffectVisualEffect(VFX_DUR_SPELL_DOOM));
    object oTARGET = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lPC, TRUE, OBJECT_TYPE_CREATURE);
    while (oTARGET != OBJECT_INVALID)
    {
        if (GetIsEnemy(oTARGET, oPC) == TRUE)
        {
            if (WillSave(oTARGET, nDC, SAVING_THROW_TYPE_FEAR, oPC) == SAVING_THROW_CHECK_FAILED)
            {
                nHD = GetHitDice(oTARGET);
                if (nHD >= 20) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX_3, oTARGET, fDUR);
                else if (nHD >= 5) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX_2, oTARGET, fDUR);
                else ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX_1, oTARGET, fDUR);    
            }
        }
        oTARGET = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lPC, TRUE, OBJECT_TYPE_CREATURE);
    }
}

//At level 5, when the Samurai draws a longsword or katana (in right hand) they gain an attack bonus 
//equal to their charisma bonus for 1 round. They also gain 1 extra attack for that round as well. 
void IajaitsuMaster(object oPC, object oITEM, int nITEM)
{
    if ((nITEM != BASE_ITEM_KATANA) && (nITEM != BASE_ITEM_LONGSWORD)) return;
    if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC) != oITEM) return;
    if (GetHasFeat(2414, oPC, TRUE))
    {
        int nCHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);
        float fDUR = RoundsToSeconds(1);
        effect eFX = EffectModifyAttacks(1);
        if (nCHA > 0) eFX = EffectLinkEffects(eFX, EffectAttackIncrease(nCHA));
        eFX = ExtraordinaryEffect(eFX);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX, oPC, fDUR);
    }
    DelayCommand(0.0f, FrightfulPresence(oPC));
}

// Do bonus damage when unarmed or wielding a creature weapon (new creature weapons)
// need to check on-equip script and cancel these effects if a weapon is equipped.
// Not implemented yet (TatooedMonk)
void TatooedMonk(object oPC, int nRIGHT, int nLEFT)
{
    if (GetLevelByClass(998, oPC) < 1) return;
    
}


//Drunk Masters get bonuses with improvised weapons.
//Not implemented yet
void DrunkMasterImprovised(object oPC, int nRIGHT)
{
    int nDRUNK = GetLevelByClass(999, oPC);
    if (nDRUNK < 1) return;
    if (nRIGHT != BASE_ITEM_INVALID && nRIGHT != BASE_ITEM_CLUB && nRIGHT != 152) return;
    int nLEVEL = nDRUNK + GetLevelByClass(CLASS_TYPE_MONK, oPC);
    int nATTACKS = 2;
    if (nLEVEL < 11) nATTACKS = 1;
    
    int nDMG = DAMAGE_BONUS_1d8;
    int nAB = 1;
    int nAC = 1;
    
    if (GetHasFeat(12468, oPC, TRUE)) 
    {
        nDMG = DAMAGE_BONUS_2d12;
        nAB = 4;
        nAC = 7;
    }   
    else if (GetHasFeat(12467, oPC, TRUE))
    {
        nDMG = DAMAGE_BONUS_2d8;
        nAB = 3;
        nAC = 5;
    }
    else if (GetHasFeat(12466, oPC, TRUE))
    {
        nDMG = DAMAGE_BONUS_1d12;
        nAB = 2;
        nAC = 3;
    }
    
    effect eFX = EffectModifyAttacks(nATTACKS);
    eFX = EffectLinkEffects(eFX, EffectAttackIncrease(nAB));
    eFX = EffectLinkEffects(eFX, EffectDamageIncrease(nDMG));
    eFX = EffectLinkEffects(eFX, EffectACIncrease(nAC, AC_DEFLECTION_BONUS));
    ApplyEquipmentEffect(oPC, eFX);
}


//Gets the AC provided by the equipped shield
//oShield should be the item equipped in the left hand
int GetACProvidedByShield(object oShield) {
    if (!GetIsObjectValid(oShield))
        return 0;
        
    int nIndex = GetArmorRulesType(oShield);
    int nAC = StringToInt(Get2DAString("armorrulestats", "ACBONUS", nIndex));
    
    //we have the base AC, now to check enchantment bonus
    itemproperty ip = GetFirstItemProperty(oShield);
    while (GetIsItemPropertyValid(ip)) {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_AC_BONUS) {
            nAC += GetItemPropertyCostTableValue(ip);
            break;
        }
        ip = GetNextItemProperty(oShield);
    }
    
    return nAC;
}

//Con Drain Protection in OOC rooms.
void ConDrainProtection(object oItem, object oPC)
{   
    string sArea = GetTag(GetArea(oPC));
    if (sArea == "ooc_appearance_changer_room" || sArea == "ps_area_s_cw_festhall-changing")
    {   
        if (IPGetItemHasItemAbilityBonusPropertySubType(oItem, ABILITY_CONSTITUTION)) ForceRest(oPC);
    }   
}

//When all is said and done, the various custom effects dependant on equipment are applied.
void EquipmentEffects(object oPC)
{
    object oCHEST = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    if (FixARMOR(oPC, oCHEST) == TRUE) return;
    
    object oLHAND = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    int nLEFT = GetBaseItemType(oLHAND);
    if (FixSHIELD(oPC, oLHAND, nLEFT) == TRUE) return;
    
    object oRHAND = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int nRIGHT = GetBaseItemType(oRHAND);   
    SpellResistFix(oPC);
    ShieldRangedConceal(oPC, nLEFT);
	FIX_BLINDFIGHT(oPC);
    SilentMetal(oPC, oCHEST, oLHAND, nLEFT);
    HeavyArmorOptimizations(oPC, oCHEST);
    UnearthlyGrace(oPC, oCHEST);
	MonkDruidPenalty(oPC);
    TwoSwordsAsOne(oPC, nRIGHT, nLEFT);
    //TatooedMonk(oPC, nRIGHT, nLEFT);
    //DrunkMasterImprovised(oPC, nRIGHT, nLEFT);
}


		




//This starts all the various checks and effects to be applied based on equipment, as per Sigil's custom rules.
//nEQUIP: TRUE when called from OnEqup and FALSE when called from OnUnequip.
//Found in "ps_inc_equipment.nss".
void SigilEquipment(object oPC, object oITEM, int nEQUIP)
{
    RemoveEffectsFromSpell(oPC, SIGIL_EQUIP_FX);
    int nITEM = GetBaseItemType(oITEM);
    if (nEQUIP == TRUE)
    {
        CheckForTempProperties(oITEM, oPC);
        
      DelayCommand(0.1f,ApplyMeditativeStrikes(oPC,oITEM));
	  
	  DelayCommand(0.1f,ApplyAustereStrikes(oPC,oITEM));
    
      DelayCommand(0.1f,ApplyElementalWeapon(oPC,oITEM));
        
        /*	 if (GetIsFinessable(oITEM))
			 DelayCommand(0.05f,PS_ApplySpecialWeaponFinesse(oPC, oITEM));*/

            if (!GetExistingFinesse(oITEM)&&  GetSubRace(oPC) == 243) 
            DelayCommand(0.05f,PS_ApplySpecialWeaponFinesse(oPC, oITEM));
				
			if (GetDervishWeapon(oITEM) && (GetLevelByClass(CLASS_DERVISH,oPC)>4))
				 DelayCommand(0.05f,PS_ApplySpecialWeaponFinesse(oPC, oITEM));

        
        if (nITEM == BASE_ITEM_GLOVES) SetGlovesOnHitProperty(oPC);
        
    
        {
            if (MonkeyGripAbuse(oPC, oITEM, nITEM) == TRUE) return;
            if (CheckManualDexterity(oPC, oITEM, nITEM) == TRUE) return;
            if (CheckDragonForms(oPC, oITEM, nITEM) == TRUE) return;
            IajaitsuMaster(oPC, oITEM, nITEM);
        }
    }
    else
    {
        ConDrainProtection(oITEM, oPC);
        if (nITEM == BASE_ITEM_GLOVES) RemoveTempOnHitProperty(oITEM);
            PS_RemoveSpecialWeaponFinesse(oPC, oITEM);
            RemoveElementalWeapon(oPC,oITEM);
            RemoveMeditativeStrikes(oPC,oITEM);
			RemoveAustereStrikes(oPC,oITEM);
        
    }

    DelayCommand(0.0f, EquipmentEffects(oPC));
}