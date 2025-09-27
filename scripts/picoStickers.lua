function onCreate()
    if stringStartsWith(boyfriendName, "pico") then
        setPropertyFromClass("substates.StickerSubState", "STICKER_SET", "stickers-set-pico")
    end
end