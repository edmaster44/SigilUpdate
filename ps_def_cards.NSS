/******************************************************************
* Definition/Const file for Triple Triad like card game for SCoD  *
* by Agony_Aunt/Loki_999                                          *
******************************************************************/

// reminder - make a consolidated list here of all vars being used on objects for easy cross reference and to avoid duplication.
// so players, board, deck and cards... will also help when it comes to the game over clean up routine as everything has to be cleared where possible.

// game name
const string CARD_GAME_NAME = "Bet Your Life!";

const string CARD_GAME_FEEDBACK_COLOUR = "<C=GOLD>";

// constants for identifying players and observers and card positions
const string CARD_PLAYER = "PLAYER"; // followed by 1 or 2 - defines player vars
const string CARD_PLAYER1 = "PLAYER1"; // followed by 1 or 2 - defines player vars
const string CARD_PLAYER2 = "PLAYER2"; // followed by 1 or 2 - defines player vars
const string CARD_OBSERVER = "OBSERVER"; // followed by 1 to 10, allowing up to 10 observers
const int CARD_MAX_OBSERVERS = 10;
const int CARD_PLAYER_TYPE_PLAYER = 1;
const int CARD_PLAYER_TYPE_OBSERVER = 2;

const int CARD_PLAYER_1 = 1; // blue, on rule selection screen left, on game screen left
const int CARD_PLAYER_2 = 2; // red, on rule selection screen right, on game screen right

// used to keep track of player scores on the board.
const string SCORE_PLAYER1 = "P1_SCORE";
const string SCORE_PLAYER2 = "P2_SCORE";

const string CARD_PLAYER_NAME = "CARDPLAYERNAME"; // if a player quits/crashes we still have their name.
const string CARD_OBSERVER_NAME = "CARDOBSERVERNAME"; // if an observer quits/crashes we still have their name.
const string CARD_PLAYER_DECK = "CARDPLAYERDECK";
const string CARD_TABLE_OBJECT = "CARDTABLE"; // this is the string for the object stored on the PC for when they join a game.
const string CARD_TABLE_POSITION = "CARDTABLEPOSITION"; // used to store position, so no need to cycle, just remove var from table.

const string LAST_PLAYER_CARDS_SELECTED = "LASTPLAYERCARDSSELECTED"; // used to determine who was last finishing selecting their cards.

// other consts

// distances from board before game kicks observer/player
const float MAX_PLAYER_DISTANCE_FROM_BOARD = RADIUS_SIZE_MEDIUM;
const float MAX_OBSERVER_DISTANCE_FROM_BOARD = RADIUS_SIZE_LARGE; // oberservers can be a little further away

// 2da def
const string CARD_2DA = "cards"; // don't add .2da
const string CARD_2DA_COL_NAME = "NAME";
const string CARD_2DA_COL_IMAGE = "IMAGE";
const string CARD_2DA_COL_UP = "UP";
const string CARD_2DA_COL_DOWN = "DOWN";
const string CARD_2DA_COL_LEFT = "LEFT";
const string CARD_2DA_COL_RIGHT = "RIGHT";


const int CARD_ITEM_TYPE_BASE = 0; // value of base cards do not exceed 15 points, low level monsters
const int CARD_ITEM_TYPE_LOW = 1; // value of base cards do not exceed 20 points, medium level monsters, places, "lesser" (eg: elemental) planes
const int CARD_ITEM_TYPE_MED = 2; // value of base cards do not exceed 25 points, plane cards are mid, faction cards
const int CARD_ITEM_TYPE_HIGH = 3; // value of base cards do not exceed 30 points, powerful planar beings, famous personages
const int CARD_ITEM_TYPE_ULTRA = 4; // value of base cards do not exceed 35 points, except for the LoP who is 36. Gods, faction heads are also ultra (1% chance of an ultra when a card drops)

const int CARD_ITEM_TYPE_2DA_OFFSET = 100; // multiplier for how separate each rank of card should be in the 2da.  Basically Base cards are 1-100, Low are 2-200, etc.

// Base <-16 point value; Low <=20, Med <=25, High <=30, Ultra = LoP and any others like it > 30.
const int CARD_TYPE_BASE_MAX = 22; // controls max value to check in 2da for rank. So if 10, then base cards are rows 1-10.
const int CARD_TYPE_LOW_MAX = 39;
const int CARD_TYPE_MED_MAX = 40;
const int CARD_TYPE_HIGH_MAX = 20;
const int CARD_TYPE_ULTRA_MAX = 1;

// object consts
const string CARD_TABLE_TAG = "card_board_tt"; // the placeable that will act as the board that people will interact with
const string CARD_CARD_TAG = "card_card_tt"; // individual cards. will use tag based scripting on tag
const string CARD_CARD_RESREF = "card_card_tt";
const string CARD_DECK_TAG = "card_deck_tt"; // the deck object in inventory
const string CARD_PLACEABLE_BACK = "p_card_back"; // back side of the card as shown on the table
const string CARD_PLACEABLE_BLUE = "p_card_blue"; // blue is used for player 1
const string CARD_PLACEABLE_RED = "p_card_red"; // red is used for player 2
const string CARD_CHAIR_BLUE = "kemo_chair_p_blue";
const string CARD_CHAIR_RED = "kemo_chair_p_red";

// Chair position offset consts.  No need for Z offset, because same Z as table (well, unless placed on uneven surface... that could look like a chair is buried or floating).
// THINK! Facing of these means X and Y do not necessarily conform to X and Y unless table is set facing exactly North.  Therefore all offsets have to be recalcuated taking into
// account rotation.  So, either have to force facing on placement of table, or do lots of maths...
// rethink - don't need for all individual coords.  Think rows and columns.

const float CARDS_BLUE_CHAIR_ORIENT = 0.0;
const float CARDS_RED_CHAIR_ORIENT = 180.0;

const float CARDS_BLUE_CHAIR_X = -1.2;
const float CARDS_BLUE_ROW_X = -0.4;
const float CARDS_ROW1_X = -0.2;
const float CARDS_ROW2_X = 0.0;
const float CARDS_ROW3_X = 0.2;
const float CARDS_RED_ROW_X = 0.4;
const float CARDS_RED_CHAIR_X = 1.2;

const float CARDS_PLAYER_HAND_1_Y = -0.24;
const float CARDS_PLAYER_HAND_2_Y = -0.12;
const float CARDS_PLAYER_HAND_3_Y = 0.0;
const float CARDS_PLAYER_HAND_4_Y = 0.12;
const float CARDS_PLAYER_HAND_5_Y = 0.24;
const float CARDS_COL1_Y = -0.12;
const float CARDS_COL2_Y = 0.0;
const float CARDS_COL3_Y = 0.12;

const float CARDS_HEIGHT_Z = 0.87;
const float CARDS_ROTATION = 90.0;

const float CARD_BG_FLIP_TIME = 0.5; // seconds.
const int CARD_BG_FLIP_NUMBER = 5; // must be odd so always ends up on opposing colour
const float CARD_BG_FLIP_TOTAL_TIME = 2.5; // we do each change several times, eg: from blue to red, and back and back etc. Must equal the above two multiplied.
const float CARD_RULE_DISPLAY_TIME = 2.0; // how long it displays the text indicating a rule is in effect while flipping cards such as Plus, Same, or Combo.


const string CARD_DECK_SIZE = "CARD_DECK_SIZE";

// Rules. Can use same values for GUI elements and variables.
const string RULE_BUTTON = "RULE_BUTTON_P";

const string RULE_OPEN = "OPEN";
const string RULE_RANDOM = "RANDOM";
const string RULE_SAME = "SAME";
const string RULE_PLUS = "PLUS";
const string RULE_WALL = "WALL"; // wall can work with same or plus.  Can have Same/Plus/Wall
const string RULE_COMBO = "COMBO"; // not a rule by itself but defined for the text that appears when a combo occurs
const string RULE_READY = "READY"; // not a rule, just used for var name to indicate player ready.

const string CARDS_TEXT_SAME = "cardstextsame.tga";
const string CARDS_TEXT_PLUS = "cardstextplus.tga";
const string CARDS_TEXT_COMBO = "cardstextcombo.tga";
const string CARDS_TEXT_WALL = "cardstextwall.tga";
const string CARDS_TEXT_BLANK = "cardstextblank.tga"; // to blank the text just a transparent tga

// texture names for card parts not defined in 2da
const string CARD_BG_PLAYER0 = "card_bg_yellow.tga";
const string CARD_BG_PLAYER1 = "card_bg_blue.tga";
const string CARD_BG_PLAYER2 = "card_bg_red.tga";
const string CARD_BORDER_SELECTED = "card_border_selected.tga";
const string CARD_BORDER_UNSELECTED = "card_border_unselected.tga";
const string CARD_BLANK = "card_blank.tga"; // just a transparent TGA that takes up the whole card space. Can be used on border and image parts.
const string CARD_HIDDEN = "card_backside.tga"; // for cards that are not visible.


// GUI card elements - these add to position names in the XML. eg: top left on board pane would be ROW1COL1_PANE and the text box with the name of the card will be ROW1COL1_NAME;
// should be the same extensions to board variables as well.
const string CARD = "CARD";
const string DECK = "DECK";
const string CARD_PANE = "PANE";
const string CARD_BORDER = "BORDER";
const string CARD_PICTURE = "IMAGE";
const string CARD_BACKGROUND = "BACKGROUND";
const string CARD_NAME = "NAME";
const string CARD_VALUE_UP = "UP";
const string CARD_VALUE_DOWN = "DOWN";
const string CARD_VALUE_LEFT = "LEFT";
const string CARD_VALUE_RIGHT = "RIGHT";
const string CARD_ID = "ID"; // to be used for comparing if exists rather than strings, INT type variable, row from 2da.

// card positions.  Remember, GUI positions will be strings anyway, so waste of effort trying to keep things as ints, and more flexible.
// remember cards will be made up of several components: 1) The frame, 2) the central image, 3) the name and numbers (actually 5 elements), and the background (card colour).

const string CARD_P = "P";
const string _HAND_ = "_";
const string CARD_P1_HAND_1 = "P1_1";
const string CARD_P1_HAND_2 = "P1_2";
const string CARD_P1_HAND_3 = "P1_3";
const string CARD_P1_HAND_4 = "P1_4";
const string CARD_P1_HAND_5 = "P1_5";

const string CARD_P2_HAND_1 = "P2_1";
const string CARD_P2_HAND_2 = "P2_2";
const string CARD_P2_HAND_3 = "P2_3";
const string CARD_P2_HAND_4 = "P2_4";
const string CARD_P2_HAND_5 = "P2_5";

const string BOARD_ROW = "R";
const string BOARD_COL = "C";

const string BOARD_R1_C1 = "R1C1";
const string BOARD_R1_C2 = "R1C2";
const string BOARD_R1_C3 = "R1C3";
const string BOARD_R2_C1 = "R2C1";
const string BOARD_R2_C2 = "R2C2";
const string BOARD_R2_C3 = "R2C3";
const string BOARD_R3_C1 = "R3C1";
const string BOARD_R3_C2 = "R3C2";
const string BOARD_R3_C3 = "R3C3";

const string PLACEABLE = "PLACEABLE";

// format for storing cards values and variables
const string CARD_OWNER = "OWNER"; // stored when a card is played to keep track of whose card it is
// use variable then like R1C1 + CARD_OWNER - this will change as cards are flipped
// can also be used for calculating score on both sides perhaps
// other vars are stored like R1C1 + CARD_PANE

const string SELECTED_CARD = "SELECTED_CARD"; // just the string position of the selected card based on the XML.

const int LEAVE_REASON_UNKNOWN = 1; // used for unknown errors and situations.
const int LEAVE_REASON_TOO_FAR_PLAYER1 = 2; // if player or observer moves too far from the board
const int LEAVE_REASON_TOO_FAR_PLAYER2 = 3;
const int LEAVE_REASON_NOT_FOUND_PLAYER1 = 4; // player 1 does not exist
const int LEAVE_REASON_NOT_FOUND_PLAYER2 = 5; // player 2 does not exist
const int LEAVE_REASON_PLAYER1_QUIT = 6; // probably only called from player 1 closing GUI or convo
const int LEAVE_REASON_PLAYER2_QUIT = 7; // probably only called from player 2 closing GUI or convo
const int LEAVE_REASON_GAME_BOARD_DESTROYED = 8; // if someone destroys the board, all vars will be lost.
const int LEAVE_REASON_GAME_FINISHED = 9; // game over

const string LEAVE_STRING_P1_TOO_FAR = "Player 1 has left the table.";
const string LEAVE_STRING_P2_TOO_FAR = "Player 2 has left the table.";
const string LEAVE_STRING_P1_QUIT_CLIENT = "Player 1 appears to have quit the client.";
const string LEAVE_STRING_P2_QUIT_CLIENT = "Player 2 appears to have quit the client";
const string LEAVE_STRING_P1_QUIT_GAME = "Player 1 has quit playing.";
const string LEAVE_STRING_P2_QUIT_GAME = "Player 2 has quit playing.";
const string LEAVE_STRING_GAME_FINISHED = "The game is over. Select the board to join a new round.";
const string LEAVE_STRING_BOARD_DESTROYED = "The board has been packed away, game discontinued.";

// Game board/table variables
// Game board/table variables
// Regarding game states - when game over - are we leaving the screens open? Then what? They can rejoin, but we need to close any existing GUIs that may have been left open - mainly game board.
// especially since a person could be playing one round and ovserving the next, or vice versa.
const string GAME_STATE = "GAME_STATE"; // used to determine game state, state variables follow
const string LAST_GAME_STATE = "OLD_GAME_STATE"; // used only when game in play and rules being processed to determine who went last
const int GAME_STATE_NO_PLAYERS = 0; // nobody in game. Waiting screens for everyone
const int GAME_STATE_1_PLAYER = 1; // one player joined. Everyone still gets waiting screen.
const int GAME_STATE_RULES_SELECTION = 2; // players selecting rules - observers get waiting screeen with text update
const int GAME_STATE_CARD_SELECTION_1 = 3; // players selecting cards (if game type not random otherwise this game state is set during the random selection). Observers get waiting screen with text update.
const int GAME_STATE_CARD_SELECTION_2 = 4; // one player selected, waiting for other.
const int GAME_STATE_GAME_STARTING = 5; // Everyone now sees the game board and play.
const int GAME_STATE_GAME_IN_PROGRESS_TURN_P1 = 6; // In progress, turn player 1 - toggle between this and the other until game over
const int GAME_STATE_GAME_IN_PROGRESS_TURN_P2 = 7; // In progress, turn player 2
const int GAME_STATE_GAME_IN_PROGRESS_PROCESSING_RULES = 8; // When cards are being flipped
const int GAME_STATE_GAME_OVER = 9; // When this state is hit, we will show game results and all can close their game windows. (Need to check for people starting new game with old windows open).

const string GAME_STATE_NO_PLAYERS_TEXT = "Waiting for players. There are no players currently at the table.";
const string GAME_STATE_1_PLAYER_TEXT = "Waiting for players. Currently 1 player is at the table.";
// const string GAME_STATE_2_PLAYERS_TEXT = "Waiting. 2 Players are now at the table."; // should never be needed.
const string GAME_STATE_RULES_SELECTION_TEXT = "Waiting for players to decide on rules for the game";
const string GAME_STATE_CARD_SELECTION_TEXT = "Waiting for players to select their cards.";

const string GAME_BOARD_STATUS_GAME_OVER = "GAME OVER! ";
const string GAME_BOARD_STATUS_PLAYER_WINS = " wins!"; // suffix to follow actual player's name.
const string GAME_BOARD_STATUS_DRAW = "Game is a draw.";
const string GAME_BOARD_STATUS_PLAYERS_TURN = "'s turn."; // suffix to follow actual player's name.
const string GAME_BOARD_STATUS_PLAYER_QUIT = "GAME OVER! PLAYER QUIT! NO RESULT";
const string GAME_BOARD_STATUS_PROCESSING_RULES = "Applying rules";

const string GAME_OWNER_NAME = "GAME_OWNER_NAME"; // local string containing the name of the owner.
const string GAME_OWNER_OBJECT = "GAME_OWNER_OBJECT"; // secondary check object for convo script.

// card XMLs and screen name constants (and probably also need to scan through for functions not using these
const string CARD_SCREEN_WAITING_XML = "cardswaiting.xml";
const string CARD_SCREEN_WAITING_SCENE = "CARDS_WAITING";
const string CARD_SCREEN_RULES_XML = "cardsrules.xml";
const string CARD_SCREEN_RULES_SCENE = "CARDS_RULES";
const string CARD_SCREEN_SELECTION_XML = "cardsselection.xml";
const string CARD_SCREEN_SELECTION_SCENE = "CARDS_SELECTION";
const string CARD_SCREEN_GAME_XML = "cardsgame.xml";
const string CARD_SCREEN_GAME_SCENE = "CARDS_GAME";
const string CARD_SCREEN_DECK_XML = "cardsviewdeck.xml";
const string CARD_SCREEN_DECK_SCENE = "TT_GUI_VIEW_DECK";
const string CARD_SCREEN_SINGLE_XML = "cardssingle.xml";
const string CARD_SCREEN_SINGLE_SCENE = "TT_GUI_SINGLE_CARD";

// Deck function commands
const int DECK_VIEW = 0;
const int DECK_SORT_ALPHA = 1;
const int DECK_SORT_POWER_INCREASE = 2;
const int DECK_SORT_POWER_DECREASE = 3;