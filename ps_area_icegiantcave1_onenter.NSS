
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = GetGlobalInt("icegiantcave1EnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("icegiantcave1EnterLock", 1); // Only allows one clean up at a time.

//  DelayCommand(300.0, ExecuteScript("ps_chest_treasure",oPC));
   
  SetGlobalInt("icegiantcave1EnterLock", 0);
 }
}