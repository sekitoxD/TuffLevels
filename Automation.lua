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
            -- there's a single reward, or none.
            local numChoices = Compat:Guard(GetNumQuestChoices) or 0
            if numChoices <= 1 then
                Compat:Guard(GetQuestReward, 1)
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
