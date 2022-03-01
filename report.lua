if Config.Report == true then 
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
end)


RegisterNetEvent("finalmenuadmin:sendNotifForReport")
AddEventHandler("finalmenuadmin:sendNotifForReport", function(type, nomdumec, raisondumec)
    if type == 1 then
        ESX.TriggerServerCallback('BahFaut:getUsergroup', function(group)
            playergroup = group
            for k,v in pairs(Config.AdminRanks) do
                if playergroup == v then
                ESX.ShowNotification('~r~[REPORT]\n~o~Un nouveau report à été effectué !')
                end
            end
        end)
    elseif type == 2 then
        ESX.TriggerServerCallback('BahFaut:getUsergroup', function(group)
            playergroup = group
            for k,v in pairs(Config.AdminRanks) do
                if playergroup == v then
                ESX.ShowNotification('Le report de ~b~'..nomdumec..'~s~ à été fermé !')
                end
            end
        end)
    end
end)

function ReportKeyBoardText(TextEntry, ExampleText, MaxStringLength)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
    blockinput = true
    
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
        end
    end


function OuvrirReport()
	local reportmenu = RageUI.CreateMenu("Report", "Intéractions")
    reportmenu:SetRectangleBanner(255, 11, 11, 170)
	RageUI.Visible(reportmenu, not RageUI.Visible(reportmenu))
	while reportmenu do
		Citizen.Wait(0)
			RageUI.IsVisible(reportmenu, true, true, true, function()
            RageUI.Separator("~r~Report ")
            RageUI.ButtonWithStyle("Faire un report", nil, {RightLabel = "📋"}, true, function(Hovered, Active, Selected)
				if (Selected) then
                    local raisonDuReport = KeyBoardText("Raison du report", "", 30)
                    TriggerServerEvent("finalmenuadmin:addreport", raisonDuReport)
                    RageUI.CloseAll()
                    ESX.ShowNotification("~g~Votre report à bien été envoyer.")
                end
            end)
            end, function()
            end)
        if not RageUI.Visible(reportmenu) then
            reportmenu = RMenu:DeleteType("Report", true)
        end end end
RegisterCommand("report", function() 
  OuvrirReport()
end)
else return end