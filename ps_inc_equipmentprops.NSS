#include "x2_inc_itemprop"
const string IPR_TYPE = "IPR_TYPE";
const string IPR_COST = "IPR_COST";
const string IPR_COSTVALUE = "IPR_COSTVALUE";
const string IPR_PARAM1 = "IPR_PARAM1";
const string IPR_PARAM1VALUE = "IPR_PARAM1VALUE";
const string IPR_SUBTYPE = "IPR_SUBTYPE";
const string IPR_EXISTS = "IPR_EXISTS";


//Gets Item Properties by Hash
int GetItemPropertyHash(itemproperty ip){

    int type = GetItemPropertyType(ip);
    int hash = 0xAAAAAA;
    
    hash ^= GetItemPropertyCostTable(ip);
    hash ^= GetItemPropertyCostTableValue(ip);
    hash ^= GetItemPropertyParam1(ip);
    hash ^= GetItemPropertyParam1Value(ip);
    hash ^= GetItemPropertySubType(ip);
    
    hash &= 0x00FFFFFF;
    hash |= (type << 24);
    
    return hash;
}

itemproperty GetItemPropertyByHash(object oItem, int nHash, int nNtn=0){

    int n=0;
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip)){
    
        if(GetItemPropertyHash(ip) == nHash && n++ == nNtn){
        
            return ip;
        }
    
        ip = GetNextItemProperty(oItem);
    }
    
    return ip;
}


//Saves the Item Property Reference using a set of Local Integers
void SaveItemPropertyReference(object Obj,string Name,itemproperty Prop)
{
    SetLocalInt (Obj, IPR_EXISTS + Name, TRUE);
    SetLocalInt (Obj, IPR_TYPE + Name, GetItemPropertyType (Prop));
    SetLocalInt (Obj, IPR_COST + Name, GetItemPropertyCostTable (Prop));
    SetLocalInt (Obj, IPR_COSTVALUE + Name, GetItemPropertyCostTableValue (Prop));
    SetLocalInt (Obj, IPR_PARAM1 + Name, GetItemPropertyParam1 (Prop));
    SetLocalInt (Obj, IPR_PARAM1VALUE + Name, GetItemPropertyParam1Value (Prop));
    SetLocalInt (Obj, IPR_SUBTYPE + Name, GetItemPropertySubType (Prop));
}
//Gets the Item Property by Reference, and usage as well as the Object itself

itemproperty GetItemPropertyReference(object Obj, string Name)
{
    int i;
    itemproperty Prop;

    if (GetLocalInt (Obj, IPR_EXISTS + Name) == FALSE)
    {
       // WriteTimestampedLogEntry ("GetItemPropertyReference: Attempted to remove nonexistant itemprop " + Name + " from object " + GetName (Obj) + ".");
        return Prop;
    }

    i = 0;
    Prop = GetFirstItemProperty (Obj);
    while (GetIsItemPropertyValid (Prop) != FALSE)
    {
        if ((GetLocalInt (Obj, IPR_TYPE + Name) == GetItemPropertyType (Prop)) &&
            (GetLocalInt (Obj, IPR_COST + Name) == GetItemPropertyCostTable (Prop)) &&
            (GetLocalInt (Obj, IPR_COSTVALUE + Name) == GetItemPropertyCostTableValue (Prop)) &&
            (GetLocalInt (Obj, IPR_PARAM1 + Name) == GetItemPropertyParam1 (Prop)) &&
            (GetLocalInt (Obj, IPR_PARAM1VALUE + Name) == GetItemPropertyParam1Value (Prop)) &&
            (GetLocalInt (Obj, IPR_SUBTYPE + Name) == GetItemPropertySubType (Prop)))
        {
            return Prop;
        }

        Prop = GetNextItemProperty (Obj);
    }

    return Prop;
}

//Removes the Item Property by name and reference 
void DeleteItemPropertyReference(object Obj,string Name)
{
    itemproperty Prop;

    Prop = GetItemPropertyReference (Obj, Name);

    if (GetIsItemPropertyValid (Prop) == FALSE)
        return;

    RemoveItemProperty (Obj, Prop);

    DeleteLocalInt (Obj, IPR_TYPE + Name);
    DeleteLocalInt (Obj, IPR_COST + Name);
    DeleteLocalInt (Obj, IPR_COSTVALUE + Name);
    DeleteLocalInt (Obj, IPR_PARAM1 + Name);
    DeleteLocalInt (Obj, IPR_PARAM1VALUE + Name);
    DeleteLocalInt (Obj, IPR_SUBTYPE + Name);
    DeleteLocalInt (Obj, IPR_EXISTS + Name);
}