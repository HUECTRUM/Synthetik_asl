state("Synthetik")
{
	string22 room: 0x22A4088, 0x280;
	double finalBossHp: 0x24D6EAC, 0x14, 0xD4, 0x12C, 0x80, 0x48, 0x8, 0x2C, 0x10, 0x390, 0x0;
}

startup {
	settings.Add("bossOnlySplits", false, "Split on boss rooms only");
	settings.Add("mainMenuReset", false, "Auto reset on entering main menu");
}

init {
	int moduleSize = modules.First().ModuleMemorySize;
	print("Main module size: " + moduleSize.ToString());
	
	if (moduleSize == 39813120) { //TODO: need more data to make sure this is the only valid size
		version = "v25.30";
	} else {
		print("Unknown version. Main module size: " + moduleSize.ToString());
		version = "unknown";
	}
	
	vars.finalBossSpawned = false;
}

start {
	if (old.room.StartsWith("main_menu") && !current.room.StartsWith("main_menu")) {
		vars.finalBossSpawned = false;
		return true;
	}
}

isLoading {
	return false;
}

split {
	if (current.room.StartsWith("R_Boss_Heart") || current.room.StartsWith("_Boss_Heart") || current.room.StartsWith("Boss_Heart")) {
		if (!vars.finalBossSpawned && current.finalBossHp > 50000) { //this gets around tracking tanks' hitpoints which are stored in the same address
			print("final boss spawned");
			vars.finalBossSpawned = true;
		} else {
			if (vars.finalBossSpawned && current.finalBossHp < 1e-6) { //final boss killed
				return true;
			}
		}
	}
	
	bool roomChanged = !old.room.StartsWith("main_menu") && !current.room.StartsWith("main_menu") && old.room != current.room
			&& !old.room.StartsWith("_Boss_Heart") && !old.room.StartsWith("Boss_Heart") && !current.room.StartsWith("_Boss_Heart") && !current.room.StartsWith("_Boss_Heart");
			
	return settings["bossOnlySplits"]
		? roomChanged && old.room.StartsWith("R_Boss")
		: roomChanged;
}

reset {
	return !old.room.StartsWith("main_menu") && current.room.StartsWith("main_menu") && settings["mainMenuReset"];
}
