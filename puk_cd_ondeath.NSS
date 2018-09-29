////////////////////////////////////////////////////////////////////////////////
//
//  Training Dummy and Training Target
//  puk_cd_ondeath
//  By:Don Anderson
//  dandersonru@msn.com
//  Adapted and implemented for NWN 2 by puket
//
//  This is placed in the OnDeath Event of a Combat Dummy and/or Archery Target
//
////////////////////////////////////////////////////////////////////////////////

void main()
{
    object oSelf    = OBJECT_SELF;
    int nSelf       = GetObjectType(oSelf);
    string sSelf    = GetResRef(oSelf);
    location lSelf  = GetLocation(oSelf);

    CreateObject(nSelf, sSelf, lSelf, FALSE);
}