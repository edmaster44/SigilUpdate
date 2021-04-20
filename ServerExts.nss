//
// New NWNX API.  Sends a fake position update to player ReceivingPCObject,
// for object TargetObject, setting the object to a position of FakePosition.
// The server-side position is *UNCHANGED*, i.e. GetPosition returns the real
// value.  Only ReceivingPCObject sees the update, and new players joining the
// area do not receive the update automatically without script code making the
// appropriate call to do so.
//
// Unlike with a "normal" position update, the "fake" position update can set
// a custom (arbitrary) Z-height value, even for creature objects.  The new
// position value is purely a client-only display artifact, and is not
// reflected by GetPosition, or any server-side mechanics.
//
// Attempting to place a creature in a position that is not walkable is not
// recommended.  No checks about the legitimacy of the position value are done
// so a safe course of action is to get an object's position and only adjust
// the vector.z coordinate component value.
//
// NOTE:  If TargetObject is ReceivingPCObject's controlled object, i.e. their
//        PC when they are possessing a PC, then the camera height will be
//        adjusted at the same time to keep the PC in camera range.  This is
//        because the client camera is based on the controlled object position.
//
// WARNING:  A PC in transition may crash if they have not received information
//           about TargetObject yet.  To avoid this, check that
//           ReceivingPCObject is not script hidden.
//

void ServerExts_SendObjectDisplayPositionUpdate(object ReceivingPCObject, object TargetObject, vector FakePosition);

//
// Send a SEF update to a given player on a given creature object.
//
// WARNING:  SEFIds must not be reused.  The server starts assigning SEFIds at
//           0x80000000 incrementing and values starting from 0 incrementing
//           are used by the client internally.  Values from 0xFFFFFFFF
//           decrementing are recommended to avoid collisions.
//
// WARNING:  Clients lose all knowledge of SEFs on transition.  Applying a SEF
//           with the same SEFId twice may cause the client to crash.  Deleting
//           a SEF by SEFId that is not known to the client is benign.
//
// WARNING:  A PC in transition may crash if they have not received information
//           about TargetObject yet.  To avoid this, check that
//           ReceivingPCObject is not script hidden.

void ServerExts_SendObjectSEFUpdate(object ReceivingPCObject, object TargetObject, vector SEFTargetPosition, object SEFTargetObject, int SEFId, int Add, string SEFName);

//
// Send a SEF update to a given player on a given object.  The object must not
// be a static object or a placed effect.
//
// WARNING:  SEFIds must not be reused.  The server starts assigning SEFIds at
//           0x80000000 incrementing and values starting from 0 incrementing
//           are used by the client internally.  Values from 0xFFFFFFFF
//           decrementing are recommended to avoid collisions.
//
// WARNING:  Clients lose all knowledge of SEFs on transition.  Applying a SEF
//           with the same SEFId twice may cause the client to crash.  Deleting
//           a SEF by SEFId that is not known to the client is benign.
//
// WARNING:  A PC in transition may crash if they have not received information
//           about TargetObject yet.  To avoid this, check that
//           ReceivingPCObject is not script hidden.

void ServerExts_SendObjectSEFUpdateEx(object ReceivingPCObject, object TargetObject, vector SEFTargetPosition, object SEFTargetObject, int SEFId, int Add, string SEFName);

//
// Test whether a client knows about a given object.  If so, it is safe to
// perform operations that will pass ahead of a GameObjUpdate cycle.
//
// This function returns TRUE if a client has been sent information about a
// given object by the server.
//
// Now ServerExts performs this check internally and uses error code -4 to
// that indicate that an object not known to a client would be acted upon.
// This function can be used to test for that property directly via script
// logic.
//
// Static objects cannot be dynamically updated and are not tracked by this
// mechanism and should not be passed to this function.
//

int ServerExts_ObjectKnownToClient(object ReceivingPCObject, object Object);

//
// Cause the server to queue an appearance refresh for a given creature object
// for a given player connection at the next GameObjUpdate cycle.
//

void ServerExts_RefreshCreatureAppearance(object ReceivingPCObject, object TargetObject);

const int MAX_PLAYERS = 96;
const int PLAYERID_SYNTHETIC_FIRST = MAX_PLAYERS;
const int PLAYERID_SYNTHETIC_LAST = 0xFF;
const int LISTTYPE_MASK = 0x80000000;
const int PLAYERID_INVALIDID = 0xFFFFFFFE;

//
// Create a synthetic player.  Player join messages are sent to all existing
// players, and newly connecting players will observe the synthetic player in
// the client-side player list.
//
// Synthetic player IDs must begin at PLAYERID_SYNTHETIC_FIRST (an unsigned
// value).  Presently, only 256 total synthetic and real players may exist at
// any given time.
//
// The gender, first name, and last name are taken from PCCreatureObject, which
// must be a "placeholder" creature that has been created and should remain for
// the lifetime of the synthetic player.  For example, such a "placeholder"
// creature might be placed in limbo and have its first name, last name, and
// gender configured by the appropriate nwscript.nss APIs.
//
// No synthetic player may have a player ID or account name that duplicates
// that of any existing player.
//
// While a synthetic player exists for a given account name, any attempt for a
// player to enter the game world with that account name will result in the
// attempt being refused and that player being disconnected with a message
// indicating that their player name was in use.
//
// Returns TRUE on success else FALSE if a failure occurred.
//

int ServerExts_CreateSyntheticPlayer(int PlayerId, object PCCreatureObject, int IsDM, string AccountName, string PortraitResRef);

//
// Delete a synthetic player.  Player part messages are sent to all existing
// players, and newly connecting players will not see the synthetic player in
// the client-side player list.
//
// This function does not delete the associated placeholder creature that was
// passed to ServerExts_CreateSyntheticPlayer.  Script code should delete the
// placeholder creature AFTER calling ServerExts_DeleteSyntheticPlayer.
//

void ServerExts_DeleteSyntheticPlayer(int PlayerId);

//
// Send a tell message to a game client from a synthetic player.  Note that
// the OnChat script is not invoked.
//

void ServerExts_SendTellFromSyntheticPlayer(object ToPCObjectId, int FromPlayerId, string Message);

//
// Get the player ID (0 through MAX_PLAYERS) for a creature object.
//
// Note that placeholder creatures used with ServerExts_CreateSyntheticPlayer
// do not have a controlling player ID.  Only actualized creatures have a
// controlling player ID.
//
// PLAYERID_INVALIDID is returned if the creature does not have a controlling
// player ID.
//
// Player IDs are "slot numbers" for players in the server and are reused when
// a player disconnects and a new player connects.  Thus, a player ID is only
// valid while a given player is still connected.
//

int ServerExts_GetCreatureControllingPlayerId(object CreatureObject);

//
// Set the name of a script that is invoked when a game client sends a tell to
// a synthetic player.  The script must be a GUI script name (i.e., gui_*).
//
// The script name should not have the .nss extension (i.e., it is a RESREF).
//
// Setting an empty string as the extended tell script will disable the ability
// for players to send tells to synthetic players.
//
// The extended tell script should typically additionally send a to-self tell
// with SendChatMessage so that the game client sees an outbound tell message.
//

void ServerExts_SetExtendedTellScriptName(string ScriptName);

//
// Set information used for a best-effort, emergency portal that is performed
// after writing a crash dump if the server crashes.
//
// The portal waypoint may not have any | characters in it.
//
// Only effective if crash dumps are enabled.
//
// The crash portal may only be set once per server startup.
//
// Arguments are otherwise like those to ActivatePortal.
//
// NOTE:  The emergency portal does NOT save characters, to avoid the risk of
//        corruption as the state of the server at crash time is not known.
//
//        The emergency portal may fail because of the limited capabilities
//        that are available when the server crashes, and it is possible that
//        not all players may be successfully portaled, e.g. if they were
//        behind on network traffic, the portal message may not be sendable.
//

void ServerExts_SetCrashPortal(string Hostname, string Password, string WaypointTag, int Seamless);

//
// Immediately exit the server.  Avoids a server crash at shutdown.  No
// character files are saved.
//
// ExitCode - Supplies the process exit code to terminate the process with.
//            Zero is a typical default.
//

void ServerExts_ExitProcess(int ExitCode);

//
// Generate a crash.  Primarily useful to test ServerExts_SetCrashPortal.  Also
// useful if it is valuable to generate a deliberate crash dump for other
// reasons (crash dumps must still be enabled for a crash dump to be written).
//

void ServerExts_CrashServer();

//
// Send a chat message to a specific player, even if the chat message is of a
// normally broadcast (i.e., talk/say) type.  This allows different players to
// be sent different views of the same broadcast chat type, if desired.
//
// Note that the module OnChat script is never invoked for this function and
// no checks are made that the sender and receiver would normally be able to
// talk in the given channel if CheckRange is set to FALSE.  That is, it is up
// to the caller to check that the sender and receiver are in range in such
// case.
//
// Arguments are otherwise like those to SendChatMessage.
//

const float CHAT_DISTANCE_SAY      = 20.0;
const float CHAT_DISTANCE_WHISPER  = 3.0;
const float CHAT_DISTANCE_CONVERSE = 10.0; // Dialog
const float CHAT_DISTANCE_BARTER   = 10.0; // Barter

const int CHAT_MODE_DM_MASK        = 0x10; // OR in to chat channel to indicate sender is a DM.

void ServerExts_SendChatMessage(object Sender, object ReceivingPlayer, int Channel, string Message, int CheckRange = TRUE);

//
// Constants for ServerExts_SetExtendedFog.
//

//
// Set a custom far clip parameter.
//

const int SERVEREXTS_FARCLIP_MODE_CUSTOM = 0;

//
// Use the default from the day night stage when handling the update on the
// client side (FarClip argument is ignored).
// 

const int SERVEREXTS_FARCLIP_MODE_DNS_DEFAULT = 1;

//
// Set extended fog parameters for a single player.  FogType, Color FogStart,
// and FogEnd parameters are just as with SetNWN2Fog.
//
// For a client without Client Extension 1.0.0.29, this function behaves just
// as for SetNWN2Fog except that it is sent to a single PC only.
//
// For a client with Client Extension 1.0.0.29 or above, this function sets
// custom far clip parameters.
//
// FarClipMode should be one of SERVEREXTS_FARCLIP_MODE_*.
//
// FarClip is only used if SERVEREXTS_FARCLIP_MODE_CUSTOM is supplied for the
// FarClipMode parameter.  This overrides the far clip plane on the client.
// Clients without Client Extension 1.0.0.29 are hardcoded to set a far clip
// plane of 200.0f for any SetNWN2Fog/ResetNWN2Fog request.
//
// Ensure that ReceivingPCObject is in an area before calling this function!
//

void ServerExts_SetExtendedFog(object ReceivingPCObject, int FogType, int Color, float FogStart, float FogEnd, int FarClipMode, float FarClip);

//
// As ServerExts_SetExtendedFog, except that the color is provided as 3 RGB
// floats, each in the range [0.0f, 1.0f].
//

void ServerExts_SetExtendedFog2(object ReceivingPCObject, int FogType, float R, float G, float B, float FogStart, float FogEnd, int FarClipMode, float FarClip);

//
// Enable an event handler for players.
//
// The module must be sure that the default event handler for players, which is
// skipped until this call is made, will work properly for a PC.
//
// These events can be enabled:
//
// CREATURE_SCRIPT_ON_MELEE_ATTACKED - Note that enabling this disables the
//                                     default auto attack the attacker that
//                                     the server performs in response to an
//                                     attack on a PC, so one must replicate
//                                     this in a script to maintain player
//                                     expectations!
//
//                                     N.B.  This event is not presently fully
//                                           functional because SetEventHandler
//                                           does not save the on melee
//                                           attacked handler for PCs.  It is
//                                           possible that a direct .bic edit
//                                           may save the event handler, but
//                                           this is not tested.  In most cases
//                                           it is recommended to use the on
//                                           damaged script for PCs, instead.
//
// CREATURE_SCRIPT_ON_DAMAGED - No caveats.
//
// Once enabled, events are permanently enabled until the server restarts.
//

void ServerExts_EnablePlayerEvent(int EventId);

//
// Get the count of internal objects (CNWSObject) that are currently
// instantiated in the server.
//

int ServerExts_GetObjectCount();


//
// Implementation follows ...
//


void ServerExts_SendObjectDisplayPositionUpdate(object ReceivingPCObject, object TargetObject, vector FakePosition)
{
    int Code;
    string PackedParams;
    
    PackedParams = ObjectToString(TargetObject) + " " +
                   FloatToString(FakePosition.x) + " " +
                   FloatToString(FakePosition.y) + " " +
                   FloatToString(FakePosition.z);
    Code = NWNXGetInt("SERVEREXTS",
                      "SET CREATURE DISPLAY POSITION",
                      PackedParams,
                      ObjectToInt(ReceivingPCObject));

    if (Code != 0)
    {
        WriteTimestampedLogEntry("ServerExts_SendFakePositionUpdate: Failed to send update to PC " + GetName(ReceivingPCObject) + ": " + PackedParams + " -> returned " + IntToString(Code));
    }
}

void ServerExts_SendObjectSEFUpdate(object ReceivingPCObject, object TargetObject, vector SEFTargetPosition, object SEFTargetObject, int SEFId, int Add, string SEFName)
{
    int Code;
    string PackedParams;
    
    PackedParams = ObjectToString(TargetObject) + " " +
                   FloatToString(SEFTargetPosition.x) + " " +
                   FloatToString(SEFTargetPosition.y) + " " +
                   FloatToString(SEFTargetPosition.z) + " " +
                        ObjectToString(SEFTargetObject) + " " +
                        GetStringRight(IntToHexString(SEFId), 8) + " " +
                        ((Add != FALSE) ? "1 " : "0 ") +
                        SEFName;

    Code = NWNXGetInt("SERVEREXTS",
                      "SEND SEF UPDATE",
                      PackedParams,
                      ObjectToInt(ReceivingPCObject));

    if (Code != 0)
    {
        WriteTimestampedLogEntry("ServerExts_SendObjectSEFUpdate: Failed to send update to PC " + GetName(ReceivingPCObject) + ": " + PackedParams + " -> returned " + IntToString(Code));
    }
}

void ServerExts_SendObjectSEFUpdateEx(object ReceivingPCObject, object TargetObject, vector SEFTargetPosition, object SEFTargetObject, int SEFId, int Add, string SEFName)
{
    int Code;
    string PackedParams;
    
    PackedParams = ObjectToString(TargetObject) + " " +
                   FloatToString(SEFTargetPosition.x) + " " +
                   FloatToString(SEFTargetPosition.y) + " " +
                   FloatToString(SEFTargetPosition.z) + " " +
                        ObjectToString(SEFTargetObject) + " " +
                        GetStringRight(IntToHexString(SEFId), 8) + " " +
                        ((Add != FALSE) ? "1 " : "0 ") +
                        IntToString(GetObjectType(TargetObject)) + " " +
                        SEFName;

    Code = NWNXGetInt("SERVEREXTS",
                      "SEND SEF UPDATE EX",
                      PackedParams,
                      ObjectToInt(ReceivingPCObject));

    if (Code != 0)
    {
        WriteTimestampedLogEntry("ServerExts_SendObjectSEFUpdateEx: Failed to send update to PC " + GetName(ReceivingPCObject) + ": " + PackedParams + " -> returned " + IntToString(Code));
    }
}

int ServerExts_ObjectKnownToClient(object ReceivingPCObject, object Object)
{
    int Code;
    string PackedParams;
    
    PackedParams = ObjectToString(Object);

    Code = NWNXGetInt("SERVEREXTS",
                      "GET PLAYER LUO FOR OBJECT",
                      PackedParams,
                      ObjectToInt(ReceivingPCObject));

    if ((Code != 0) && (Code != 1))
    {
        WriteTimestampedLogEntry("ServerExts_ObjectKnownToClient: Failed to query LUO existance for PC " + GetName(ReceivingPCObject) + ": " + PackedParams + " -> returned " + IntToString(Code));
    }

    return (Code == 1);
}

void ServerExts_RefreshCreatureAppearance(object ReceivingPCObject, object TargetObject)
{
    int Code;
    string PackedParams;
    
    PackedParams = ObjectToString(TargetObject);

    Code = NWNXGetInt("SERVEREXTS",
                      "REFRESH CREATURE APPEARANCE",
                      PackedParams,
                      ObjectToInt(ReceivingPCObject));

    if (Code != 0)
    {
        WriteTimestampedLogEntry("ServerExts_RefreshCreatureAppearance: Failed to adjust LUO appearance for PC " + GetName(ReceivingPCObject) + ": " + PackedParams + " -> returned " + IntToString(Code));
    }

    return;
}

int ServerExts_CreateSyntheticPlayer(int PlayerId, object PCCreatureObject, int IsDM, string AccountName, string PortraitResRef)
{
    int Code;
    string Delimiter = "|";
    string FirstName;
    string LastName;
    string PackedParams;
    string AccountNameLower;
    object PC;
    int PCObjectId;

    if (PlayerId > PLAYERID_SYNTHETIC_LAST)
    {
        WriteTimestampedLogEntry("ServerExts_CreateSyntheticPlayer: Invalid player ID: " + IntToString(PlayerId));
        return FALSE;
    }

    //
    // The first character of the packed parameters string is the delimiter
    // character.  This must not exist in any of the name strings.
    //

    FirstName = GetFirstName(PCCreatureObject);
    LastName = GetLastName(PCCreatureObject);

    //
    // Make sure that the delimiter is safe.
    //

    if (FindSubString(FirstName, Delimiter) != -1)
    {
        WriteTimestampedLogEntry("ServerExts_CreateSyntheticPlayer: Invalid first name: " + FirstName);
        return FALSE;
    }

    if (FindSubString(LastName, Delimiter) != -1)
    {
        WriteTimestampedLogEntry("ServerExts_CreateSyntheticPlayer: Invalid last name: " + FirstName);
        return FALSE;
    }

    if (FindSubString(AccountName, Delimiter) != -1)
    {
        WriteTimestampedLogEntry("ServerExts_CreateSyntheticPlayer: Invalid first name: " + LastName);
        return FALSE;
    }

    PCObjectId = ObjectToInt(PCCreatureObject) | LISTTYPE_MASK;

    //
    // Build the parameter string.
    //
    // |PlayerId|PCObjectId|IsDM|AccountName|PCObjectExists|ControlObjectId|PCObjectFirstName|PCObjectLastName|GenderFlag|Portrait|ControlObjectFirstName|ControlObjectLastName
    //

    PackedParams = Delimiter;

    PackedParams += IntToString(PlayerId);
    PackedParams += Delimiter;

    PackedParams += IntToString(PCObjectId);
    PackedParams += Delimiter;

    PackedParams += ((IsDM != FALSE) ? "1" : "0");
    PackedParams += Delimiter;

    PackedParams += AccountName;
    PackedParams += Delimiter;

    //
    // Always indicate a PC object exists.
    //

    PackedParams += "1";
    PackedParams += Delimiter;

    //
    // Always indicate that the control object ID is the PC object ID.
    //

    PackedParams += IntToString(PCObjectId);
    PackedParams += Delimiter;

    PackedParams += FirstName;
    PackedParams += Delimiter;

    PackedParams += LastName;
    PackedParams += Delimiter;

    //
    // Only indicate male/female genders for now.
    //

    PackedParams += IntToString(((GetGender(PCCreatureObject) == GENDER_FEMALE) ? 0xFFFE : 0xFFFF));
    PackedParams += Delimiter;

    PackedParams += PortraitResRef;
    PackedParams += Delimiter;

    //
    // As the control object ID is always represented as the PC creature object
    // ID, use the same first and last name.
    //

    PackedParams += FirstName;
    PackedParams += Delimiter;

    PackedParams += LastName;
    PackedParams += Delimiter;

    Code = NWNXGetInt("SERVEREXTS",
                      "CREATE SYNTHETIC PLAYER",
                      PackedParams,
                      0);

    if (Code != 0)
    {
        WriteTimestampedLogEntry("ServerExts_CreateSyntheticPlayer: Failed to create synthetic player for object " + GetName(PCCreatureObject) + ": " + PackedParams + " -> returned " + IntToString(Code));
        return FALSE;
    }

    return TRUE;
}

void ServerExts_DeleteSyntheticPlayer(int PlayerId)
{
    int Code;

    Code = NWNXGetInt("SERVEREXTS",
                      "DELETE SYNTHETIC PLAYER",
                      "",
                      PlayerId);

    if (Code != 0)
    {
        WriteTimestampedLogEntry("ServerExts_DeleteSyntheticPlayer: Failed to delete synthetic player " + IntToString(PlayerId) + " -> returned " + IntToString(Code));
    }
}

void ServerExts_SendTellFromSyntheticPlayer(object ToPCObjectId, int FromPlayerId, string Message)
{
    int Code;
    string PackedParams;

    PackedParams = ObjectToString(ToPCObjectId) + "|" +
                   Message;

    Code = NWNXGetInt("SERVEREXTS",
                      "SEND TELL FROM SYNTHETIC PLAYER",
                      PackedParams,
                      FromPlayerId);

    if (Code != 0)
    {
        WriteTimestampedLogEntry("SendTellFromSyntheticPlayer: Failed to send tell from synthetic player " + IntToString(FromPlayerId) + " to " + GetName(ToPCObjectId) + " -> returned " + IntToString(Code));
    }
}

int ServerExts_GetCreatureControllingPlayerId(object CreatureObject)
{
    int Code;

    Code = NWNXGetInt("SERVEREXTS",
                      "GET CREATURE CONTROLLING PLAYER ID",
                      "",
                      ObjectToInt(CreatureObject));

    return Code;
}

void ServerExts_SetExtendedTellScriptName(string ScriptName)
{
    int Code;
    string PackedParams;
    
    PackedParams = ScriptName;

    Code = NWNXGetInt("SERVEREXTS",
                      "SET EXTENDED TELL SCRIPT NAME",
                      PackedParams,
                      0);

    if (Code != 0)
    {
        WriteTimestampedLogEntry("ServerExts_SetExtendedTellScriptName: Failed to set extended tell script name: " + PackedParams + " -> returned " + IntToString(Code));
    }

    return;
}

void ServerExts_SetExtendedFog(object ReceivingPCObject, int FogType, int Color, float FogStart, float FogEnd, int FarClipMode, float FarClip)
{
    int Code;
    string PackedParams;

    PackedParams = IntToString(FogType) + " " +
                   FloatToString(IntToFloat((Color >> 16) & 0xFF) / 255.0f) + " " +
                   FloatToString(IntToFloat((Color >> 8) & 0xFF) / 255.0f) + " " +
                   FloatToString(IntToFloat((Color >> 0) & 0xFF) / 255.0f) + " " +
                   FloatToString(FogStart) + " " +
                   FloatToString(FogEnd) + " " +
                   IntToString(FarClipMode) + " " +
                   FloatToString(FarClip);
    Code = NWNXGetInt("SERVEREXTS",
                      "SET EXTENDED FOG",
                      PackedParams,
                      ObjectToInt(ReceivingPCObject));

    if (Code != 0)
    {
        WriteTimestampedLogEntry("ServerExts_SetExtendedFog: Failed to send update to PC " + GetName(ReceivingPCObject) + ": " + PackedParams + " -> returned " + IntToString(Code));
    }
}

void ServerExts_SetExtendedFog2(object ReceivingPCObject, int FogType, float R, float G, float B, float FogStart, float FogEnd, int FarClipMode, float FarClip)
{
    int Code;
    string PackedParams;

    PackedParams = IntToString(FogType) + " " +
                   FloatToString(R) + " " +
                   FloatToString(G) + " " +
                   FloatToString(B) + " " +
                   FloatToString(FogStart) + " " +
                   FloatToString(FogEnd) + " " +
                   IntToString(FarClipMode) + " " +
                   FloatToString(FarClip);
    Code = NWNXGetInt("SERVEREXTS",
                      "SET EXTENDED FOG",
                      PackedParams,
                      ObjectToInt(ReceivingPCObject));

    if (Code != 0)
    {
        WriteTimestampedLogEntry("ServerExts_SetExtendedFog2: Failed to send update to PC " + GetName(ReceivingPCObject) + ": " + PackedParams + " -> returned " + IntToString(Code));
    }
}

void ServerExts_SetCrashPortal(string Hostname, string Password, string WaypointTag, int Seamless)
{
    int Code;
    string PackedParams;

    PackedParams = "|" +
                   Hostname + "|" +
                   WaypointTag + "|" +
                   IntToString(Seamless) + "|" +
                   Password + "|";
    Code = NWNXGetInt("SERVEREXTS",
                      "SET CRASH PORTAL",
                      PackedParams,
                      0);

    if (Code != 0)
    {
        WriteTimestampedLogEntry("ServerExts_SetCrashPortal: Failed to set crash portal: " + PackedParams + " -> returned " + IntToString(Code));
    }
}

void ServerExts_ExitProcess(int ExitCode)
{
    int Code;
    string PackedParams;
    
    PackedParams = "";

    Code = NWNXGetInt("SERVEREXTS",
                      "EXIT PROCESS",
                      PackedParams,
                      ExitCode);

    if (Code != 0)
    {
        WriteTimestampedLogEntry("ServerExts_ExitProcess: Failed to exit process: " + PackedParams + " -> returned " + IntToString(Code));
    }

    return;
}

void ServerExts_EnablePlayerEvent(int EventId)
{
	int Code;
	string PackedParams;
    string FunctionCode;

    switch (EventId)
    {

    case CREATURE_SCRIPT_ON_MELEE_ATTACKED:
        FunctionCode = "ENABLE PLAYER ON MELEE ATTACKED";
        break;

    case CREATURE_SCRIPT_ON_DAMAGED:
        FunctionCode = "ENABLE PLAYER ON DAMAGED";
        break;

    default:
        WriteTimestampedLogEntry("ServerExts_EnablePlayerEvent: Unsupported event " + IntToString(EventId));
        return;

    }

	Code = NWNXGetInt("SERVEREXTS",
	                  FunctionCode,
	                  PackedParams,
	                  0);

	if (Code != 0)
	{
		WriteTimestampedLogEntry("ServerExts_EnablePlayerEvent: Failed to enable event: " + FunctionCode + " " + PackedParams + " -> returned " + IntToString(Code));
	}

    return;
}

void ServerExts_CrashServer()
{
    int Code;
    string PackedParams;
    
    PackedParams = "";

    Code = NWNXGetInt("SERVEREXTS",
                      "CRASH SERVER",
                      PackedParams,
                      0);

    if (Code != 0)
    {
        WriteTimestampedLogEntry("ServerExts_CrashServer: Failed to crash server: " + PackedParams + " -> returned " + IntToString(Code));
    }

    return;
}

void ServerExts_SendChatMessage(object Sender, object ReceivingPlayer, int Channel, string Message, int CheckRange = TRUE)
{
    int Code;
    string PackedParams;
    int SenderObjectId;
    int ReceiverObjectId;
    vector Position;

    if (ReceivingPlayer == OBJECT_INVALID)
        return;

    Channel &= ~CHAT_MODE_DM_MASK;

    if (Channel == CHAT_MODE_SERVER)
        Sender = OBJECT_INVALID;

    SenderObjectId = ObjectToInt(Sender);
    ReceiverObjectId = ObjectToInt(ReceivingPlayer) | LISTTYPE_MASK;

    //
    // If requested, check range.
    //

    if (CheckRange != FALSE)
    {
        float Range;

        switch (Channel)
        {

        case CHAT_MODE_TALK:
        case CHAT_MODE_WHISPER:
            if (GetArea(Sender) != GetArea(ReceivingPlayer))
                return;

            if (Channel == CHAT_MODE_TALK)
                Range = CHAT_DISTANCE_SAY;
            else
                Range = CHAT_DISTANCE_WHISPER;

            if (GetDistanceBetween(Sender, ReceivingPlayer) > Range)
                return;

            break;

        }
    }

    if (Sender != OBJECT_INVALID)
    {
        if (GetIsDM(Sender) != FALSE)
            Channel |= CHAT_MODE_DM_MASK;

        Position = GetPosition(Sender);
        SenderObjectId |= LISTTYPE_MASK;

        Code = NWNXGetInt("SERVEREXTS",
                          "SET CHAT FIRST NAME",
                          GetFirstName(Sender),
                          0);

        if (Code != 0)
        {
            WriteTimestampedLogEntry("ServerExts_SendChatMessage: Failed to set chat first name for message to PC " + GetName(ReceivingPlayer) + ": -> returned " + IntToString(Code));
            return;
        }

        Code = NWNXGetInt("SERVEREXTS",
                          "SET CHAT LAST NAME",
                          GetLastName(Sender),
                          0);

        if (Code != 0)
        {
            WriteTimestampedLogEntry("ServerExts_SendChatMessage: Failed to set chat first name for message to PC " + GetName(ReceivingPlayer) + ": -> returned " + IntToString(Code));
            return;
        }
    }
    else if (Channel != CHAT_MODE_SERVER)
    {
        return;
    }

    PackedParams = IntToString(SenderObjectId) + " " +
                   IntToString(ReceiverObjectId) + " " +
                   FloatToString(Position.x) + " " +
                   FloatToString(Position.y) + " " +
                   FloatToString(Position.z) + " " +
                   IntToString(Channel) + "|";
    Code = NWNXGetInt("SERVEREXTS",
                      "SEND CHAT MESSAGE",
                      PackedParams + Message,
                      0);

    if (Code != 0)
    {
        WriteTimestampedLogEntry("ServerExts_SendChatMessage: Failed to send chat message to PC " + GetName(ReceivingPlayer) + ": " + PackedParams + " -> returned " + IntToString(Code));
    }
}

int ServerExts_GetObjectCount()
{
    int Code;
    string PackedParams;
    
    PackedParams = "";

    Code = NWNXGetInt("SERVEREXTS",
                      "GET OBJECT COUNT",
                      PackedParams,
                      0);

    return Code;
}



