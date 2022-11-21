function Discord.API:CreateWebhook(link)
    local self = {}

    self.sendMessage = function(name, message, color)
        format = os.date('%H:%M:%S', os.time()) 
        local date_local = format

        local embeds = {
            {
                ["title"] =name,
                ["description"] = message,
                ["type"] = "rich",
                ["color"] = color,
                ["thumbnail"] = {
                    ["url"] = "https://cdn.discordapp.com/attachments/965985032726532126/967759390901927956/kzbylecoqblanc.png",
                },
                ["footer"] = {
                    ["text"] = "www.kernioz.com",
                    ["icon_url"] = "https://cdn.discordapp.com/attachments/965985032726532126/967759390901927956/kzbylecoqblanc.png"
                },
            }
        }

        if message == nil or message == '' then return FALSE end

        PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
    end

    return self
end
