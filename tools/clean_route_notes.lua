-- Strips raw RXPGuides dot-directives (".mob X", ".isOnQuest 7", ".zoneskip Y",
-- ".money >0.5", ...) that RXPImport used to leak into a step's `note` / `name`
-- text. Run with a stock Lua 5.1:
--   lua tools/clean_route_notes.lua Routes/Alliance/Human.lua [more files...]
--   lua tools/clean_route_notes.lua --check <files>     (report only, no write)
--
-- Per " - "-separated segment: a segment that is a dot-directive is dropped, or
-- reduced to its human annotation when it has one (".xp 4-610 >> Grind until..."
-- keeps "Grind until..."). Repeated annotation text lifted from directives is collapsed.
-- Only the text inside note = "..." / name = "..." literals is touched.

local check = false
local files = {}
for _, a in ipairs(arg) do
    if a == "--check" then check = true else files[#files + 1] = a end
end

local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

local function CleanText(text)
    local out, seen = {}, {}
    local padded = text .. " - "
    for seg in padded:gmatch("(.-) %- ") do
        local keep = seg
        local fromDirective = false
        if seg:match("^%.%a") then
            local ann = seg:match(">>(.*)$")
            keep = ann and trim(ann) or ""
            fromDirective = true
        end
        -- Plain text is never deduped (a puzzle answer like "Owl - Bear - Owl"
        -- repeats on purpose); only text lifted out of a directive is.
        if keep ~= "" and not (fromDirective and seen[keep]) then
            if fromDirective then seen[keep] = true end
            out[#out + 1] = keep
        end
    end
    return table.concat(out, " - ")
end

local total, changed = 0, 0
for _, path in ipairs(files) do
    local h = assert(io.open(path, "rb"))
    local src = h:read("*a")
    h:close()
    local pieces, pos, n = {}, 1, 0
    while true do
        local s, e, field = src:find("([nN][aoA][mmtT][eE]) = \"", pos)
        if not s then break end
        -- only the lowercase field names `name` / `note`
        local fieldOk = (field == "name" or field == "note") and src:sub(s - 1, s - 1):match("[%s,{]")
        -- read the literal to its closing unescaped quote
        local i = e + 1
        while true do
            local c = src:sub(i, i)
            if c == "\\" then i = i + 2
            elseif c == '"' or c == "" then break
            else i = i + 1 end
        end
        pieces[#pieces + 1] = src:sub(pos, e)
        local body = src:sub(e + 1, i - 1)
        if fieldOk and body:find("%.%a") then
            local cleaned = CleanText(body)
            if cleaned ~= body then n = n + 1 end
            body = cleaned
        end
        pieces[#pieces + 1] = body
        pos = i
    end
    pieces[#pieces + 1] = src:sub(pos)
    total = total + 1
    changed = changed + n
    print(("%s: %d strings cleaned"):format(path, n))
    if not check and n > 0 then
        local w = assert(io.open(path, "wb"))
        w:write(table.concat(pieces))
        w:close()
    end
end
print(("%d files, %d strings %s"):format(total, changed, check and "would change" or "changed"))
