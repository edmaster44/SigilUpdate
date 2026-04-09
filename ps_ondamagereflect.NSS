


#include "hench_i0_ai"
#include "ginc_behavior"

void main()
{
object oDamager = GetLastAttacker();
 
   if (GetIsObjectValid(oDamager))
   {
 string damagerName = GetName(oDamager);

 object oLastWeapon = GetLastWeaponUsed(oDamager);
 if (!GetWeaponRanged(oLastWeapon))
 {
  int weaponType = GetBaseItemType(oLastWeapon);
 
  switch (weaponType)
  {
  case BASE_ITEM_GREATAXE:
  case BASE_ITEM_GREATSWORD:
  case BASE_ITEM_WARMACE:
  case BASE_ITEM_HALBERD:
  case BASE_ITEM_FALCHION:
  case BASE_ITEM_SCYTHE:
  case BASE_ITEM_SPEAR:
  case BASE_ITEM_QUARTERSTAFF:
   break;
  default:
   // Read damage hit dice (number of d8) from local variable
   int damageD8 = GetLocalInt(OBJECT_SELF, "REFLECT_D8");

   // Read damage hit dice (number of d6) from local variable
   int damageD6 = GetLocalInt(OBJECT_SELF, "REFLECT_D6");

   // Read constant part of damage from local variable
   int damageConst = GetLocalInt(OBJECT_SELF, "REFLECT_CONST");
   
   // Compute total damage
   int totalDamage = d8() * damageD8 + d6() * damageD6 + damageConst;
   
   if (totalDamage > 0)
   {
    // Read damage type from local variable, this is e.g. DAMAGE_TYPE_PIERCING (=2) etc.
    int damageType = GetLocalInt(OBJECT_SELF, "REFLECT_TYPE");
    // Damage type defaults to Piercing, if the variable is not set
    if (damageType == 0)
     damageType = DAMAGE_TYPE_PIERCING;
   
    // Read damage power (enchantment equivalent) from local variable, 0 is for normal damage
    int damagePower = GetLocalInt(OBJECT_SELF, "REFLECT_POWER");

    // apply damage
    ApplyEffectToObject (DURATION_TYPE_INSTANT,
     EffectDamage (totalDamage, damageType, damagePower),
     oDamager);
   }
  }
 }
 else
 {
 }
}

// Call the default OnAttacked script
ExecuteScript("nw_c2_default5", OBJECT_SELF);
}