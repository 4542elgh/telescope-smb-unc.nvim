local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local entry_display = require('telescope.pickers.entry_display')
local conf = require('telescope.config').values

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

local function ends_with(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

local function get_drives()
    local drives= {}
    local output = vim.fn.system("cmd /C net use")
    local tempDriveLetter = ""
    local count = 0

    for line in output:gmatch("%S+") do
        if ends_with(line, ":") then
            tempDriveLetter = line
            count = count + 1
        end

        if starts_with(line, "\\") then
            table.insert(drives, {
                filename = "Drive " .. tempDriveLetter,
                lnum = tonumber(count),
                col=1,
                text = line,
                sign_idx = count,
            })
        end
    end

    return drives
end

local function make_entry()
    local displayer = entry_display.create {
        items = {
            { width = 5 },
            { width = 10 },
            { remaining = true }
        }
    }

    local make_display = function(entry)
        return displayer {
            {entry.lnum, "TelescopeResultsLineNr"},
            entry.filename,
            entry.text,
        }
    end

    return function(entry)
        return {
            valid = true,
            value = entry,
            ordinal = entry.text.."this is ordinal key",
            display = make_display,
            filename = entry.filename,
            lnum = entry.lnum,
            col = 1,
            text = entry.text,
        }
    end
end

local function make_picker()
    local make_finder = function()
        return finders.new_table {
            results = get_drives(),
            entry_maker = make_entry(),
        }
    end

    pickers.new({}, {
        prompt_title = "SMB Get UNC Path",
        finder = make_finder(),
        -- previewer = conf.qflist_previewer({}),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                -- vim.inspect(selection)
                vim.fn.setreg("\"", selection.text)
            end)
            return true
        end,
    }):find()
end

return require('telescope').register_extension {
    exports = {
        -- Default when to argument is given, i.e. :Telescope vim_bookmarks
        smb_unc = make_picker,
        all = make_picker,
    }
}
