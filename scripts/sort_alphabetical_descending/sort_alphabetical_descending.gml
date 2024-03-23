function sort_alphabetical_descending(_a, _b)
{
	if (_a < _b)
	{
		return -1;
	}

	if (_a > _b)
	{
		return 1;
	}

	return 0;
}