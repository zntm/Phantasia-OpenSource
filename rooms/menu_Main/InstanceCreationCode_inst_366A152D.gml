halign = fa_right;
valign = fa_middle;

if (VERSION_NUMBER.TYPE == VERSION_TYPE.RELEASE)
{
	text = "Release";
}
else if (VERSION_NUMBER.TYPE == VERSION_TYPE.ALPHA)
{
	text = "Alpha";
}
else if (VERSION_NUMBER.TYPE == VERSION_TYPE.BETA)
{
	text = "Beta";
}

text += $" {VERSION_NUMBER.MAJOR}.{VERSION_NUMBER.MINOR}";

if (VERSION_NUMBER.PATCH > 0)
{
	text += $".{VERSION_NUMBER.PATCH}";
}

if (DEV_MODE)
{
	text += "-Dev";
}