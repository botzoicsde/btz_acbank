serverside = {}

local Proxy = module("vrp", "lib/Proxy")
local Tunnel =  module("vrp", "lib/Tunnel")

vRP = Proxy.getInterface("vRP")
Tunnel.bindInterface("btz_acbanca",serverside)

-----------------------------------------------------------------
-- Configuratie
local valoareamodificatacash = 1000000 	-- Daca valoarea de bani cash pe care o are playerul este mai mare decat asta, ii va da Kick/Ban
local valoareamodificatabanca = 1000000 	-- Daca valoarea de bani din banca pe care o are playerul este mai mare decat asta, ii va da Kick/Ban
local VerificaBanca = true			-- Variabila ce va verifica banca
local KickSauBan = "ban" 		-- Alege ce pedeapsa va primi playerul ce abuzeaza. Ban sau Kick?
local folosesteDiscord = false 		-- Foloseste Discord Webhook pentru a tine evidenta. Modifica in linia 40 si linia 47 Linkul
-----------------------------------------------------------------

local valoarevechecash = {}
local valoarevechebanca = {}
local cash = {}
local banca = {}
local AccesGiveMoney = false

function VerificaBaniiJucatorului(user_id)
	local user_id = vRP.getUserId({source})
	cash[user_id] = vRP.getMoney1337({user_id})
	banca[user_id] = vRP.getBankMoney1337({user_id})
	if valoarevechecash[user_id] == nil then
		valoarevechecash[user_id] = cash[user_id]
	elseif valoarevechecash[user_id] ~= nil then
		if cash[user_id] ~= nil and AccesGiveMoney == false then
			local diferenta = cash[user_id] - valoarevechecash[user_id]
			if valoarevechecash[user_id] ~= banca[user_id] then
				if cash[user_id] > (valoarevechecash[user_id] + valoareamodificatacash) then
					print("ID: " ..user_id.. " a primit mai mult decat "..valoareamodificatacash.." in mai putin de 5 secunde. Valoarea veche: " ..valoarevechecash[user_id].. " Valoarea noua: " ..cash[user_id].. " Diferenta: $" ..diferenta)
					if folosesteDiscord == true then
						if KickSauBan == "ban" then
							vRP.getUserIdentity({user_id, function(identity)
								local mesaj = "ID: " ..user_id.. " a primit mai mult decat "..valoareamodificatacash.." cash in mai putin de 5 secunde. Valoarea veche: $" ..valoarevechecash[user_id].. " Valoarea noua: $" ..cash[user_id].. " Diferenta: $" ..diferenta.. " si a primit automat ban. @everyone"
								local embed = {
									{
									  ["color"] = 1234521,
									  ["title"] = "__".. "Marcel Bancaru'".."__",
									  ["description"] = "Player-ul "..GetPlayerName(player).."("..user_id..") A LUAT BAN PENTRU MONEY-CHEAT",
									  ["thumbnail"] = {
										["url"] = "https://i.imgur.com/Bi2iC6K.png",
									  },
									  ["footer"] = {
									  ["text"] = "",
									  },
									}
								  }
								  PerformHttpRequest('https://discord.com/api/webhooks/783082107303100508/jeeexN8dITBdK0wXB4IpRjoplX4fn-58J_XuZEfRIJP3wuzLjJuaLXMo6ppbMYx9bcYC', function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' }) 
								vRP.ban({source,"ID: " ..user_id.. " a primit ban pentru cheating. *bani*. Diferenta: $" ..diferenta})
							end})
						end
						if KickSauBan == "kick" then
							vRP.getUserIdentity({user_id, function(identity)
								local mesaj = "ID: " ..user_id.. " A primit mai mult decat "..valoareamodificatacash.." cash in mai putin de 5 secunde. Valoarea veche: $" ..valoarevechecash[user_id].. " Valoarea noua: $" ..cash[user_id].. " Diferenta: $" ..diferenta.. " si a primit automat kick. @everyone"
								local embed = {
									{
									  ["color"] = 1234521,
									  ["title"] = "__".. "Marcel Bancaru'".."__",
									  ["description"] = "Player-ul "..GetPlayerName(player).."("..user_id..") A LUAT BAN PENTRU MONEY-CHEAT",
									  ["thumbnail"] = {
										["url"] = "https://i.imgur.com/Bi2iC6K.png",
									  },
									  ["footer"] = {
									  ["text"] = "",
									  },
									}
								  }
								  PerformHttpRequest('https://discord.com/api/webhooks/783082107303100508/jeeexN8dITBdK0wXB4IpRjoplX4fn-58J_XuZEfRIJP3wuzLjJuaLXMo6ppbMYx9bcYC', function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' }) 
								vRP.kick({source,"ID: " ..user_id.. " a primit kick pentru cheating. *bani*. Diferenta: $" ..diferenta})
							end})
						end
					elseif folosesteDiscord == false then
						if KickSauBan == "ban" then
							vRP.ban({source,"ID: " ..user_id.. " a primit ban pentru cheating. *bani*. Diferenta: $" ..diferenta})
						elseif KickSauBan == "kick" then
							vRP.kick({source,"ID: " ..user_id.. " a primit kick pentru cheating. *bani*. Diferenta: $" ..diferenta})
						end
					end
				end
			end	
			valoarevechecash[user_id] = cash[user_id]
		end
	end
	if VerificaBanca == true then
		if valoarevechebanca[user_id] == nil then
			valoarevechebanca[user_id] = banca[user_id]
		elseif valoarevechebanca[user_id] ~= nil then
			if banca[user_id] ~= nil and AccesGiveMoney == false then
				local diferenta = banca[user_id] - valoarevechebanca[user_id]
				if valoarevechebanca[user_id] ~= cash[user_id] then
					if banca[user_id] > (valoarevechebanca[user_id] + valoareamodificatabanca) then
						print("ID: " ..user_id.. " A primit mai mult decat "..valoareamodificatabanca.." in mai putin de 5 secunde. Old Bank: " ..valoarevechebanca.. " New Bank: " ..banca.. " Diferenta: $" ..diferenta)
						if folosesteDiscord == true then
							if KickSauBan == "ban" then
								vRP.getUserIdentity({user_id, function(identity)
									local mesaj = "ID: " ..user_id.. " A primit mai mult decat "..valoareamodificatabanca.." in Bank Money in mai putin de 5 secunde. Valoarea veche: $" ..valoarevechebanca[user_id].. " New Bank: $" ..banca[user_id].. " Diferenta: $" ..diferenta.. " and was automatically banned. @everyone"
									local embed = {
										{
										  ["color"] = 1234521,
										  ["title"] = "__".. "Marcel Bancaru'".."__",
										  ["description"] = "Player-ul "..GetPlayerName(player).."("..user_id..") A LUAT BAN PENTRU MONEY-CHEAT",
										  ["thumbnail"] = {
											["url"] = "https://i.imgur.com/Bi2iC6K.png",
										  },
										  ["footer"] = {
										  ["text"] = "",
										  },
										}
									  }
									  PerformHttpRequest('https://discord.com/api/webhooks/783082107303100508/jeeexN8dITBdK0wXB4IpRjoplX4fn-58J_XuZEfRIJP3wuzLjJuaLXMo6ppbMYx9bcYC', function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' }) 
									vRP.ban({source,"ID: " ..user_id.. " a primit ban pentru cheating. *bani*. Diferenta: $" ..diferenta})
								end})
							end
							if KickSauBan == "kick" then
								vRP.getUserIdentity({user_id, function(identity)
									local mesaj = "ID: " ..user_id.. " A primit mai mult decat "..valoareamodificatabanca.." in Bank Money in mai putin de 5 secunde. Valoarea veche: $" ..valoarevechebanca[user_id].. " New Bank: $" ..banca[user_id].. " Diferenta: $" ..diferenta.. " and was automatically kicked. @everyone"
									local embed = {
										{
										  ["color"] = 1234521,
										  ["title"] = "__".. "Marcel Bancaru'".."__",
										  ["description"] = "Player-ul "..GetPlayerName(player).."("..user_id..") A LUAT BAN PENTRU MONEY-CHEAT",
										  ["thumbnail"] = {
											["url"] = "https://i.imgur.com/Bi2iC6K.png",
										  },
										  ["footer"] = {
										  ["text"] = "",
										  },
										}
									  }
									  PerformHttpRequest('https://discord.com/api/webhooks/783082107303100508/jeeexN8dITBdK0wXB4IpRjoplX4fn-58J_XuZEfRIJP3wuzLjJuaLXMo6ppbMYx9bcYC', function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' }) 
									vRP.kick({source,"UserID: " ..user_id.. " a primit kick pentru cheating. *bani*. Diferenta: $" ..diferenta})
								end})
							end
						elseif folosesteDiscord == false then
							if KickSauBan == "ban" then
								vRP.ban({source,"ID: " ..user_id.. " a primit ban pentru cheating. *bani*. Diferenta: $" ..diferenta})
							elseif KickSauBan == "kick" then
								vRP.kick({source,"ID: " ..user_id.. " a primit kick pentru cheating. *bani*. Diferenta: $" ..diferenta})
							end
						end
					end
				end	
				valoarevechebanca[user_id] = banca[user_id]
			end
		end
	end
end

RegisterNetEvent("verificadacaelegit")
AddEventHandler("verificadacaelegit", function()
	local source = source
	if source then
		local user_id = vRP.getUserId({source})
		AccesGiveMoney = vRP.hasPermission({user_id,"player.givemoney"})
		VerificaBaniiJucatorului(user_id)
	end
end)
