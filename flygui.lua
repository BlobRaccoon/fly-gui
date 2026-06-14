    -- UIS service for mobile or keyboard detection
    local UIS = game:GetService("UserInputService")
    -- TCH service for credits in chat
    local TCH = game:GetService("TextChatService")
    -- Turn the long command 'TCH.TextChannels.RBXGeneral' shorter
    local channel = TCH.TextChannels.RBXGeneral
    -- Emote Hub By 7yd7 (I did NOT make this script)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))()
    -- Wait to prevent lag
    task.wait(1)
    -- Dropkick by platinww (I did NOT make this script)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/platinww/CrustyMain/refs/heads/main/universal/DropKick.lua"))()
    -- Dropkick is laggy roblox needs to wait to load the next one after it
    task.wait(4)
    -- Agar ware by agarv (I did NOT make this script)
    loadstring(game:HttpGet("\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\97\103\97\114\118\115\111\99\111\111\111\108\115\109\105\116\104\47\83\99\114\105\112\116\115\47\114\101\102\115\47\104\101\97\100\115\47\109\97\105\110\47\65\71\65\82\87\65\82\69\46\108\117\97"))()
    -- Mobile or Keyboard detection
    -- Fly with animation by 396abc (I did NOT make this script)
    if UIS.TouchEnabled and not UIS.KeyboardEnabled then
	    -- Mobile
        loadstring(game:HttpGet("https://raw.githubusercontent.com/396abc/Script/refs/heads/main/MobileFly.lua"))()
    else
	    -- Keyboard
        loadstring(game:HttpGet("https://raw.githubusercontent.com/396abc/Script/refs/heads/main/FlyR15.lua"))()
    end
    -- wait 3
    task.wait(3)
    -- Credits/Info messages
    channel:DisplaySystemMessage("[The Chosen One Greif/Troll combo]")
    channel:DisplaySystemMessage("Loaded successfully.")
    channel:DisplaySystemMessage(" ")
    channel:DisplaySystemMessage("Included scripts:")
    channel:DisplaySystemMessage("→ Emote Wheel (7yd7)")
    channel:DisplaySystemMessage("→ Dropkick (platinww)")
    channel:DisplaySystemMessage("→ Agar Ware (argarv)")
    channel:DisplaySystemMessage("→ Fly Animation (396abc)")
