function OnPostSpawn() {
	local date = {}
	LocalTime(date)

	if (date.month != 4 || date.day < 20 || date.day > 27) {
		self.Destroy()
	}
}
