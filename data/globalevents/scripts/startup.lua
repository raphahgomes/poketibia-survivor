function onStartup()
	math.randomseed(os.mtime())

	db.query("TRUNCATE TABLE `players_online`")
	db.asyncQuery("DELETE FROM `guild_wars` WHERE `status` = 0")
	db.asyncQuery("DELETE FROM `players` WHERE `deletion` != 0 AND `deletion` < " .. os.time())
	db.asyncQuery("DELETE FROM `ip_bans` WHERE `expires_at` != 0 AND `expires_at` <= " .. os.time())
	db.asyncQuery("DELETE FROM `market_history` WHERE `inserted` <= " .. (os.time() - configManager.getNumber(configKeys.MARKET_OFFER_DURATION)))

	-- Move expired bans to ban history
	local resultId = db.storeQuery("SELECT * FROM `account_bans` WHERE `expires_at` != 0 AND `expires_at` <= " .. os.time())
	if resultId ~= false then
		repeat
			local accountId = result.getDataInt(resultId, "account_id")
			db.asyncQuery("INSERT INTO `account_ban_history` (`account_id`, `reason`, `banned_at`, `expired_at`, `banned_by`) VALUES (" .. accountId .. ", " .. db.escapeString(result.getDataString(resultId, "reason")) .. ", " .. result.getDataLong(resultId, "banned_at") .. ", " .. result.getDataLong(resultId, "expires_at") .. ", " .. result.getDataInt(resultId, "banned_by") .. ")")
			db.asyncQuery("DELETE FROM `account_bans` WHERE `account_id` = " .. accountId)
		until not result.next(resultId)
		result.free(resultId)
	end

	-- Check house auctions
	local resultId = db.storeQuery("SELECT `id`, `highest_bidder`, `last_bid`, (SELECT `balance` FROM `players` WHERE `players`.`id` = `highest_bidder`) AS `balance` FROM `houses` WHERE `owner` = 0 AND `bid_end` != 0 AND `bid_end` < " .. os.time())
	if resultId ~= false then
		repeat
			local house = House(result.getDataInt(resultId, "id"))
			if house ~= nil then
				local highestBidder = result.getDataInt(resultId, "highest_bidder")
				local balance = result.getDataLong(resultId, "balance")
				local lastBid = result.getDataInt(resultId, "last_bid")
				if balance >= lastBid then
					db.query("UPDATE `players` SET `balance` = " .. (balance - lastBid) .. " WHERE `id` = " .. highestBidder)
					house:setOwnerGuid(highestBidder)
				end
				db.asyncQuery("UPDATE `houses` SET `last_bid` = 0, `bid_end` = 0, `highest_bidder` = 0, `bid` = 0 WHERE `id` = " .. house:getId())
			end
		until not result.next(resultId)
		result.free(resultId)
	end

	-- Provisionamento automático das contas de teste:
	-- 1. Conta GM/GOD: login "su" | senha "123456" | char "SU" (group_id = 3, invulnerável)
	-- 2. Conta Normal: login "survivor" | senha "123456" | char "Survivor" (group_id = 1, jogador comum)
	local sha1Pass = "7c4a8d09ca3762af61e59520943dc26494f8941b" -- sha1("123456")
	db.query("INSERT IGNORE INTO `accounts` (`name`, `password`, `type`, `premdays`, `lastday`, `email`, `creation`) VALUES ('su', '" .. sha1Pass .. "', 5, 365, " .. os.time() .. ", 'su@poketibia.local', " .. os.time() .. ")")
	db.query("UPDATE `accounts` SET `password` = '" .. sha1Pass .. "', `type` = 5, `premdays` = 365 WHERE `name` = 'su'")

	db.query("INSERT IGNORE INTO `accounts` (`name`, `password`, `type`, `premdays`, `lastday`, `email`, `creation`) VALUES ('survivor', '" .. sha1Pass .. "', 1, 365, " .. os.time() .. ", 'survivor@poketibia.local', " .. os.time() .. ")")
	db.query("UPDATE `accounts` SET `password` = '" .. sha1Pass .. "', `type` = 1, `premdays` = 365 WHERE `name` = 'survivor'")

	local suAcc = db.storeQuery("SELECT `id` FROM `accounts` WHERE `name` = 'su'")
	if suAcc ~= false then
		local suAccId = result.getDataInt(suAcc, "id")
		result.free(suAcc)
		local checkSuChar = db.storeQuery("SELECT `id` FROM `players` WHERE `name` = 'SU'")
		if checkSuChar == false then
			db.query(string.format([[
				INSERT INTO `players` (`name`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `maglevel`, `mana`, `manamax`, `soul`, `town_id`, `posx`, `posy`, `posz`, `conditions`, `cap`, `sex`)
				VALUES ('SU', 3, %d, 250, 1, 5000, 5000, 20000000, 114, 114, 114, 114, 1974, 0, 100, 100, 0, 1, 1054, 1050, 7, '', 4000, 1)
			]], suAccId))
		else
			result.free(checkSuChar)
			db.query("UPDATE `players` SET `group_id` = 3, `account_id` = " .. suAccId .. " WHERE `name` = 'SU'")
		end
	end

	local survAcc = db.storeQuery("SELECT `id` FROM `accounts` WHERE `name` = 'survivor'")
	if survAcc ~= false then
		local survAccId = result.getDataInt(survAcc, "id")
		result.free(survAcc)
		local checkSurvChar = db.storeQuery("SELECT `id` FROM `players` WHERE `name` = 'Survivor'")
		if checkSurvChar == false then
			db.query(string.format([[
				INSERT INTO `players` (`name`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `maglevel`, `mana`, `manamax`, `soul`, `town_id`, `posx`, `posy`, `posz`, `conditions`, `cap`, `sex`)
				VALUES ('Survivor', 1, %d, 150, 1, 1500, 1500, 5000000, 114, 114, 114, 114, 1974, 0, 100, 100, 0, 1, 1054, 1050, 7, '', 4000, 1)
			]], survAccId))
		else
			result.free(checkSurvChar)
			db.query("UPDATE `players` SET `group_id` = 1, `account_id` = " .. survAccId .. " WHERE `name` = 'Survivor'")
		end
	end

	PokeDungeon.buildMap()
end
