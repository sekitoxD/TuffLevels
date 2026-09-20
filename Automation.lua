-- TuFFlevels / Automation.lua
--
-- Opt-in, step-aware auto accept/turn-in. Off by default. Only ever acts
-- on the quest that matches the CURRENT step - never a blanket "accept
-- everything", and never guesses between multiple reward choices (that
-- turn-in is just left for you to click). Holding Shift while a quest
-- dialog opens bypasses automation for that one interaction.
--
-- Confirmed live (2026-09-19) that AcceptQuest/GetQuestReward work from a
-- plain event handler with no hardware event on the Forever beta - see
-- plans/02-restedxp-improvements.md Phase C0.

local ADDON, ns = ...
local Compat = ns.Compat
local Core = ns.Core

local Automation = {}
ns.Automation = Automation

Automation.enabled = false

function Automation:Load()
    local db = Compat:InitSavedVar("TuFFlevelsDB")
    self.enabled = db.autoAcceptTurnin or false
end

function Automation:Toggle()
    self.enabled = not self.enabled
    Compat:InitSavedVar("TuFFlevelsDB").autoAcceptTurnin = self.enabled
    ns.Print("Auto accept/turn-in " .. (self.enabled and "on" or "off"))
    if ns.UI and ns.UI.Refresh then ns.UI:Refresh() end
end

--------------------------------------------------------------------------
-- Matching
--------------------------------------------------------------------------

-- Resolves name-based steps the same way Core does, so automation works
-- on spreadsheet-imported routes too, not just numeric-ID ones.
local function CurrentStepFor(stepType, questID)
    local step = Core:CurrentStep()
    if not (step and step.type == stepType) then return nil end
    if not step.quest and step.questName then Core.ResolveQuest(step) end
    if step.quest and step.quest == questID then return step end
    return nil
end

-- Never guesses which reward to take (that stays a manual click) - but
-- names which choice looks like the better vendor sell value, so the
-- player isn't clicking blind. This deliberately stops short of
-- highlighting the actual reward button: that frame's name and layout
-- differ between Classic Era and Forever/Retail (the same "port from
-- Retail, not Classic" trap CLAUDE.md calls out for API calls applies to
-- UI frame internals too), and there's no headless client to verify a
-- guess against - a chat call-out is the version of this feature that can
-- actually be checked by reading the code.
local function AnnounceBestChoice(numChoices)
    local bestIndex, bestPrice
    for i = 1, numChoices do
        local link = Compat:Guard(GetQuestItemLink, "choice", i)
        local price = link and Compat:GetItemSellPrice(link)
        if price and (not bestPrice or price > bestPrice) then
            bestIndex, bestPrice = i, price
        end
    end
    if bestIndex then
        local link = Compat:Guard(GetQuestItemLink, "choice", bestIndex)
        ns.Print(("Reward choice %d looks like the best vendor value: %s"):format(
            bestIndex, link or ("#" .. bestIndex)))
    end
end

local function FindGossipMatch(list, step)
    for _, entry in ipairs(list) do
        if (entry.questID and step.quest and entry.questID == step.quest)
            or (step.name and entry.title == step.name) then
            return entry
        end
    end
    return nil
end

--------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------

local f = CreateFrame("Frame")
Compat:RegisterEvents(f, { "QUEST_DETAIL", "QUEST_COMPLETE", "QUEST_GREETING" })

f:SetScript("OnEvent", Compat:Wrap("Automation", function(self, event)
    if not Automation.enabled then return end
    if Compat:Guard(IsShiftKeyDown) then return end

    if event == "QUEST_DETAIL" then
        local questID = Compat:Guard(GetQuestID)
        if questID and CurrentStepFor("accept", questID) then
            Compat:Guard(AcceptQuest)
        end

    elseif event == "QUEST_COMPLETE" then
        local questID = Compat:Guard(GetQuestID)
        if questID and CurrentStepFor("turnin", questID) then
            -- Never guess between reward choices - only auto-turn-in when
            -- there's a single reward, or none. With more than one, call
            -- out the best vendor-value choice instead of picking for you.
            local numChoices = Compat:Guard(GetNumQuestChoices) or 0
            if numChoices <= 1 then
                Compat:Guard(GetQuestReward, 1)
            else
                AnnounceBestChoice(numChoices)
            end
        end

    elseif event == "QUEST_GREETING" then
        local step = Core:CurrentStep()
        if not step then return end

        if step.type == "turnin" then
            local match = FindGossipMatch(Compat:GossipActiveQuests(), step)
            if match then Compat:SelectGossipActiveQuest(match) end
        elseif step.type == "accept" then
            local match = FindGossipMatch(Compat:GossipAvailableQuests(), step)
            if match then Compat:SelectGossipAvailableQuest(match) end
        end
    end
end))
