#include "x2_inc_itemprop"
#include "ps_inc_equipmentprops"



//This gets the weapons that qualify for Meditative Strikes
int GetMonkWeapon(object oItem)
{ 
       int iBaseItem = GetBaseItemType(oItem);
    return iBaseItem ==  BASE_ITEM_SHURIKEN || iBaseItem == BASE_ITEM_GLOVES ||    iBaseItem == BASE_ITEM_KAMA || iBaseItem == BASE_ITEM_QUARTERSTAFF;
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
	itemproperty Prop = GetItemPropertyReference(oItem, "MeditativeStrikes");
		if (GetIsItemPropertyValid(Prop) != FALSE) {
    	SendMessageToPC(oPC, "Meditative strikes already active.");
    	return;
}


    
    int nDamageConstant = IPGetDamageBonusConstantFromNumber(nWis);    
    int nDamageType = IP_CONST_DAMAGETYPE_MAGICAL;
    float fDUR = 9999.9f;    
    Prop  = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, nDamageConstant);
    
    if(GetHasFeat(2840,oPC, TRUE))
    {
        if(!GetIsItemPropertyValid(Prop)){
        
            SendMessageToPC(oPC, "Itemproperty was not valid");
            return;
        }
    
        SendMessageToPC(oPC, "Applying damage constant: "+IntToString(nDamageConstant));    
        IPSafeAddItemProperty(oItem, Prop, fDUR, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
		SaveItemPropertyReference(oItem, "MeditativeStrikes", Prop);

        SendMessageToPC(oPC, "Wisdom Damage bonus of " + IntToString(nWis) + " applied to your Monk Weapon");
    }

}
