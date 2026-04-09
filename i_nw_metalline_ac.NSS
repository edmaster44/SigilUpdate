

//i_nw_metalline_ac (tag-based OnActivated script)
//
//Changes the base material of the weapon when activated
//'Underdark' campaign accessory, page 69

#include "x2_inc_itemprop"
void main()
{
object oItem = GetItemActivated();
object oUser = GetItemActivator();
int iOldMat = GetLocalInt(oItem, "Mat");
//adamantine 1, coldiron 2, iron 4, silver 6
int iNewMat;
string sSuffix;

switch (iOldMat)
{
case 0:
{
iNewMat = 1;
sSuffix = "adamantine";
break;
}
case 1:
{
iNewMat = 2;
sSuffix = "cold iron";
break;
}
case 2:
{
iNewMat = 4;
sSuffix = "steel";
break;
}
case 4:
{
iNewMat = 6;
sSuffix = "alchemical silver";
break;
}
case 6:
{
iNewMat = 1;
sSuffix = "adamantine";
break;
}
}//end switch
string sDesc = "The wielder can alter the composition of a metalline weapon from one kind of metal to another once per round. The weapon transmutes in turn into adamantine, cold iron, steel and alchemical silver, cycling back to adamantine again. It is currently comprised of "+sSuffix+".";

ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("sp_transmutation_conjure.sef"), oUser);
SendMessageToPC(oUser, "<i>Transmuting into "+sSuffix);
SetDescription(oItem, sDesc);
SetLocalInt(oItem, "Mat", iNewMat);
SetItemBaseMaterialType(oItem, iNewMat);
}