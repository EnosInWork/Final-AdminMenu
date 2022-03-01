ESX = nil
local allReport = {}
local items = {}

TriggerEvent(Config.ESXTrigger, function(obj) ESX = obj end)

ESX.RegisterServerCallback('BahFaut:getUsergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()
	print(GetPlayerName(source).." - "..group)
	cb(group)
end)


MySQL.ready(function()
  MySQL.Async.fetchAll("SELECT * FROM items", {}, function(result)
      for k, v in pairs(result) do
          items[k] = { label = v.label, name = v.name }
      end
  end)
end)


ESX.RegisterServerCallback('finalmenuadmin:getAllItems', function(source, cb)
  cb(items)
end)


ESX.RegisterServerCallback("finalmenuadmin:getAllJobs", function(source, cb)
  local allJobs = {}

  MySQL.Async.fetchAll("SELECT * FROM jobs", {}, function(data)
      for _, v in pairs(data) do
      table.insert(allJobs, {
        NameSociety = v.name,
        LabelSociety = v.label
      })
      end
      cb(allJobs)
  end)
end)

ESX.RegisterServerCallback("finalmenuadmin:getAllGrade", function(source, cb, jobName)
  local gradeJobs = {}

  MySQL.Async.fetchAll("SELECT * FROM job_grades WHERE job_name = @job_name", {['job_name'] = jobName}, function(data)
      for _,v in pairs(data) do
      table.insert(gradeJobs, {
        gradeJob = v.grade,
        gradeLabel = v.label
      })
      end
      cb(gradeJobs)
  end)
end)

RegisterServerEvent("finalmenuadmin:GiveCash")
AddEventHandler("finalmenuadmin:GiveCash", function(money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = money
    
    xPlayer.addMoney((total))

    local item = '~g~$ en liquide.'
    local message = '~g~Give de : '
    TriggerClientEvent('esx:showNotification', _source, message .. total .. item)
end)

RegisterServerEvent("finalmenuadmin:GiveBanque")
AddEventHandler("finalmenuadmin:GiveBanque", function(money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = money
    
    xPlayer.addAccountMoney('bank', total)

    local item = '~b~$ en banque.'
    local message = '~b~Give de : '
    TriggerClientEvent('esx:showNotification', _source, message .. total .. item)
end)

RegisterNetEvent("finalmenuadmin:giveItem")
AddEventHandler("finalmenuadmin:giveItem", function(target, itemName, qty)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer then
        xPlayer.addInventoryItem(itemName, tonumber(qty))
        TriggerClientEvent("esx:showNotification", source, ("~g~Give de %sx %s au joueur %s effectué"):format(qty, ESX.GetItemLabel(itemName), GetPlayerName(target)))
    else
        TriggerClientEvent("esx:showNotification", source, "~r~Ce joueur n'est plus connecté")
    end
end)

RegisterServerEvent("finalmenuadmin:GiveND")
AddEventHandler("finalmenuadmin:GiveND", function(money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = money
    
    xPlayer.addAccountMoney('black_money', total)

    local item = '~r~$ d\'argent sale.'
    local message = '~r~Give de : '
    TriggerClientEvent('esx:showNotification', _source, message..total..item)
end)

RegisterNetEvent("msg:Message")
AddEventHandler("msg:Message", function(id, type)
	TriggerClientEvent("msg:envoyer", id, type)
end)

RegisterServerEvent('finalmenuadmin:kickjoueur')
AddEventHandler('finalmenuadmin:kickjoueur', function(player, raison)
    local steam
    local playerId = source
    local PcName = GetPlayerName(playerId)
    local joueur = GetPlayerName(player)
    for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
        if string.match(v, 'steam:') then
            steam = string.sub(v, 7)
            break
        end
    end
    TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..PcName..".\nSteam : steam:"..steam.."\nA kick "..joueur.." pour "..raison)

    DropPlayer(player, raison)
end)

RegisterServerEvent('whipezebi')
AddEventHandler('whipezebi', function(player)
    local steam
    local playerId = source
    local PcName = GetPlayerName(playerId)
    local joueur = GetPlayerName(player)
    local ahzebisteam = ESX.GetPlayerFromId(player)
    MySQL.Async.execute(
			  'DELETE FROM users WHERE identifier = @identifier',
			  { ['@identifier'] = ahzebisteam.identifier }
			)
    MySQL.Async.execute(
			  'DELETE FROM user_accounts WHERE identifier = @identifier',
			  { ['@identifier'] = ahzebisteam.identifier }
			)
    MySQL.Async.execute(
			  'DELETE FROM user_inventory WHERE identifier = @identifier',
			  { ['@identifier'] = ahzebisteam.identifier }
			)
            MySQL.Async.execute(
                'DELETE FROM user_sim WHERE identifier = @identifier',
                { ['@identifier'] = ahzebisteam.identifier }
              )
              MySQL.Async.execute(
                'DELETE FROM owned_vehicles WHERE owner = @identifier',
                { ['@identifier'] = ahzebisteam.identifier }
              )
              MySQL.Async.execute(
                'DELETE FROM owned_properties WHERE owner = @identifier',
                { ['@identifier'] = ahzebisteam.identifier }
              )
              MySQL.Async.execute(
                'DELETE FROM prw_items WHERE identifier = @identifier',
                { ['@identifier'] = ahzebisteam.identifier }
              )
              MySQL.Async.execute(
                'DELETE FROM billing WHERE identifier = @identifier',
                { ['@identifier'] = ahzebisteam.identifier }
              )
              MySQL.Async.execute(
                'DELETE FROM open_car WHERE identifier = @identifier',
                { ['@identifier'] = ahzebisteam.identifier }
              )
    TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..PcName..".\nA whipe (mort rp) "..joueur.." ")

    DropPlayer(player, "Tu as été whipe!")
end)



RegisterNetEvent("finalmenuadmin:addreport")
AddEventHandler("finalmenuadmin:addreport", function(raison)
  local _src = source
  local xPlayer = ESX.GetPlayerFromId(_src)
    table.insert(allReport, {
      srcDuMec = _src,
      nomDuMec = xPlayer.getName(),
      raisonDuReport = raison
    })
    TriggerClientEvent("finalmenuadmin:sendNotifForReport", -1, 1)
end)


ESX.RegisterServerCallback('finalmenuadmin:getAllReport', function(source, cb)
  cb(allReport)
end)

RegisterServerEvent("finalmenuadmin:closeReport")
AddEventHandler("finalmenuadmin:closeReport", function(nomMec, raisonMec)
    TriggerClientEvent("finalmenuadmin:sendNotifForReport", -1, 2, nomMec, raisonMec)
    table.remove(allReport, srcDuMec, nomDuMec, raisonDuReport)
end)

ESX.RegisterServerCallback('adminmenu:getOtherPlayerData', function(source, cb, target, notify)
  local xPlayer = ESX.GetPlayerFromId(target)

  if xPlayer then
      local data = {
          name = xPlayer.getName(),
          job = xPlayer.job.label,
          grade = xPlayer.job.grade_label,
          inventory = xPlayer.getInventory(),
          accounts = xPlayer.getAccounts(),
          weapons = xPlayer.getLoadout(),
          money = xPlayer.getMoney()
      }

      cb(data)
  end
end)

RegisterNetEvent("warn:Get")
AddEventHandler("warn:Get", function()
    local _src = source
    local table = {}
    MySQL.Async.fetchAll('SELECT * FROM warn', {}, function(result)
        for k,v in pairs(result) do
            table[v.id] = v
        end
        TriggerClientEvent("warn:Get", _src, table)
    end)
end)

RegisterNetEvent("warn:Delete")
AddEventHandler("warn:Delete", function(id)
    local _src = source

    MySQL.Async.execute('DELETE FROM warn WHERE id = @id',
    { ['id'] = id },
    function(affectedRows)
        TriggerClientEvent("warn:Delete", _src)
    end
    )
end)

RegisterNetEvent("warn:Add")
AddEventHandler("warn:Add", function(builder)
    local _src = source
	  local xPlayer = ESX.GetPlayerFromId(_src)
	  local name = xPlayer.getName(_src)
    local date = os.date("*t", os.time()).day.."/"..os.date("*t", os.time()).month.."/"..os.date("*t", os.time()).year.." à "..os.date("*t", os.time()).hour.."h"..os.date("*t", os.time()).min
    MySQL.Async.execute('INSERT INTO warn (author,date,firstname,lastname,steam,reason,warnnumero) VALUES (@a,@b,@c,@d,@e,@f,@g)',

    { 
        ['a'] = name,
        ['b'] = date,
        ['c'] = builder.firstname,
        ['d'] = builder.lastname,
        ['e'] = builder.steam,
        ['f'] = builder.reason,
        ['g'] = builder.warnnumero,
    },

    function(affectedRows)
        TriggerClientEvent("warn:Add", _src)
    end
    )
end)

----------------------------------------------------------------------------------------
WebHook2 = Config.DiscordWebHook
Name = Config.DiscordName
Logo = Config.DiscordLogo
----------------------------------------------------------------------------------------
LogsBlue = 3447003
LogsRed = 15158332
LogsYellow = 15844367
LogsOrange = 15105570
LogsGrey = 9807270
LogsPurple = 10181046
LogsGreen = 3066993
LogsLightBlue = 1752220
----------------------------------------------------------------------------------------
RegisterNetEvent('Ise_Logs2')
AddEventHandler('Ise_Logs2', function(Color, Title, Description)
	Ise_Logs2(Color, Title, Description)
end)

RegisterNetEvent('Ise_Logs3')
AddEventHandler('Ise_Logs3', function(Webhook, Color, Title, Description)
	Ise_Logs3(Webhook, Color, Title, Description)
end)

function Ise_Logs2(Color, Title, Description)
	local Content = {
	        {
	            ["color"] = Color,
	            ["title"] = Title,
	            ["description"] = Description,
		        ["footer"] = {
	                ["text"] = Name,
	                ["icon_url"] = Logo,
	            },
	        }
	    }
	PerformHttpRequest(WebHook2, function(err, text, headers) end, 'POST', json.encode({username = Name, embeds = Content}), { ['Content-Type'] = 'application/json' })
end

function Ise_Logs3(webhook3, Color, Title, Description)
	local Content = {
	        {
	            ["color"] = Color,
	            ["title"] = Title,
	            ["description"] = Description,
		        ["footer"] = {
	                ["text"] = Name,
	                ["icon_url"] = Logo,
	            },
	        }
	    }
	PerformHttpRequest(webhook3, function(err, text, headers) end, 'POST', json.encode({username = Name, embeds = Content}), { ['Content-Type'] = 'application/json' })
end