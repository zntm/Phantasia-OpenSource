#macro DISCORD_APP_ID "877407647815594024"

ready = false;

if (!np_initdiscord(DISCORD_APP_ID, true, np_steam_app_id_empty))
{
	throw "NekoPresence init fail.";
}