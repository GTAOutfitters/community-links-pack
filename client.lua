-- Community Links Pack by GTAOutfitters
-- Standalone chat commands: /discord, /store, /website, /rules, /help

local lastUsed = 0

local function rgb()
    return { Config.AccentColor:match('(%d+),%s*(%d+),%s*(%d+)') }
end

local function say(title, text)
    local r, g, b = rgb()
    TriggerEvent('chat:addMessage', {
        color = { tonumber(r) or 255, tonumber(g) or 255, tonumber(b) or 255 },
        multiline = true,
        args = { title, text }
    })
end

local function cooledDown()
    local now = GetGameTimer()
    if now - lastUsed < (Config.Cooldown * 1000) then
        say('Slow down', 'Please wait a few seconds between link commands.')
        return false
    end
    lastUsed = now
    return true
end

local function linkCommand(name, url, label)
    if url == nil or url == '' then return end
    RegisterCommand(name, function()
        if not cooledDown() then return end
        say(label, url)
    end, false)
    TriggerEvent('chat:addSuggestion', '/' .. name, 'Show the server ' .. label:lower() .. ' link')
end

linkCommand('discord', Config.Discord, 'Discord')
linkCommand('store', Config.Store, 'Store')
linkCommand('website', Config.Website, 'Website')

RegisterCommand('rules', function()
    if not cooledDown() then return end
    say(Config.ServerName .. ' — Rules', table.concat(Config.Rules, '\n'))
end, false)
TriggerEvent('chat:addSuggestion', '/rules', 'Show the server rules')

RegisterCommand('help', function()
    if not cooledDown() then return end
    local lines = { 'Available commands:' }
    if Config.Discord ~= '' then lines[#lines + 1] = '/discord — join our Discord' end
    if Config.Store ~= '' then lines[#lines + 1] = '/store — visit the server store' end
    if Config.Website ~= '' then lines[#lines + 1] = '/website — visit our website' end
    lines[#lines + 1] = '/rules — read the server rules'
    say(Config.ServerName, table.concat(lines, '\n'))
end, false)
TriggerEvent('chat:addSuggestion', '/help', 'Show the community commands')
