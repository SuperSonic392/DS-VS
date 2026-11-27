-- Source - https://stackoverflow.com/a/68323185
-- Posted by Francisco
-- Retrieved 2026-10-25, License - CC BY-SA 4.0

function hslToRgb(h, s, l)
    h = h / 360
    s = s / 100
    l = l / 100

    local r, g, b;

    if s == 0 then
        r, g, b = l, l, l; -- achromatic
    else
        local function hue2rgb(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1 / 6 then return p + (q - p) * 6 * t end
            if t < 1 / 2 then return q end
            if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
            return p;
        end

        local q = l < 0.5 and l * (1 + s) or l + s - l * s;
        local p = 2 * l - q;
        r = hue2rgb(p, q, h + 1 / 3);
        g = hue2rgb(p, q, h);
        b = hue2rgb(p, q, h - 1 / 3);
    end

    if not a then a = 1 end
    return {r = r * 255, g = g * 255, b = b * 255} -- turned this into a key/value table and removed the alpha. 
end


-- ~~stolen from Google's AI overview. Todo: Un-sloppify this code aka just redo it. ~~
-- successfully un-sloppified. Thank you Stack Overflow. 
function hueToRgb(hue)
    hue = hue % 360
    return hslToRgb(hue, 100, 50)
end


-- stolen and modified from Display Coordinates DX 
-- https://mods.sm64coopdx.com/mods/display-coordinates-dx.1167/
-- ... and then not used, lol. Still gonna keep it though, might come in handy. 
function DrawText(text, width, x, y)
    djui_hud_set_resolution(RESOLUTION_N64);
    djui_hud_set_font(FONT_HUD);

    local pos = FormatScreenPosition(width, x, y)

    djui_hud_set_color(255, 255, 255, 255);
    djui_hud_print_text(text, pos.x, pos.y, 1);
end

function FormatScreenPosition(width, x, y)
    -- get width of screen and text
    local screenWidth = djui_hud_get_screen_width()

    -- get height of screen and text
    local screenHeight = djui_hud_get_screen_height()
    local height = 64

    -- negative means from the right/bottom
    if x < 0 then
        x = screenWidth - width + x
    end
    
    if y < 0 then
        y = screenHeight - height + y
    end

    return {x = x, y = y}
end

function set_netplayer_palette(np, palette)
    if(np == nil) then
        return -- ABORT, ABORT! (I can almost guarentee that this code is unreachable but it's better to be safe than sorry)
    end
    if(palette == nil) then -- fallback to prevent script errors
        palette = PALETTE_LIST[1]
    end
    network_player_set_override_palette_color(np, PANTS, {r = palette[PANTS].r, g = palette[PANTS].g, b = palette[PANTS].b})
    network_player_set_override_palette_color(np, SHIRT, {r = palette[SHIRT].r, g = palette[SHIRT].g, b = palette[SHIRT].b})
    network_player_set_override_palette_color(np, GLOVES, {r = palette[GLOVES].r, g = palette[GLOVES].g, b = palette[GLOVES].b})
    network_player_set_override_palette_color(np, SHOES, {r = palette[SHOES].r, g = palette[SHOES].g, b = palette[SHOES].b})
    network_player_set_override_palette_color(np, HAIR, {r = palette[HAIR].r, g = palette[HAIR].g, b = palette[HAIR].b})
    network_player_set_override_palette_color(np, SKIN, {r = palette[SKIN].r, g = palette[SKIN].g, b = palette[SKIN].b})
    network_player_set_override_palette_color(np, CAP, {r = palette[CAP].r, g = palette[CAP].g, b = palette[CAP].b})
    network_player_set_override_palette_color(np, EMBLEM, {r = palette[EMBLEM].r, g = palette[EMBLEM].g, b = palette[EMBLEM].b})
end