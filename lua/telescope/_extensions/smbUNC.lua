local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local entry_display = require('telescope.pickers.entry_display')
local conf = require('telescope.config').values
local bookmark_actions = require('telescope._extensions.vim_bookmarks.actions')

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

local function ends_with(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

local function get_bookmarks()
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
                filename = tempDriveLetter,
                lnum = tonumber(count),
                col=1,
                text = line,
                sign_idx = count,
            })
        end
    end

    return drives
end

local function make_entry_from_bookmarks()
    local displayer = entry_display.create {
        items = {
            { width = 5 },
            { width = 10 },
            { remaining = true }
        }
    }

    local make_display = function(entry)
        local line_info = {entry.lnum, "TelescopeResultsLineNr"}

        return displayer {
            line_info,
            "Drive " .. entry.filename,
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

local function make_bookmark_picker()
    local make_finder = function()
        local bookmarks = get_bookmarks()
        if vim.tbl_isempty(bookmarks) then
            print("No bookmarks! this should not happen with testing")
            return
        end
        return finders.new_table {
            results = bookmarks,
            entry_maker = make_entry_from_bookmarks(),
        }
    end

    local initial_finder = make_finder()
    pickers.new({}, {
        prompt_title = "SMB Get UNC Path",
        finder = initial_finder,
        -- previewer = conf.qflist_previewer(opts),
        sorter = conf.generic_sorter(opts),
    }):find()
end

local all = function()
    make_bookmark_picker()
end

return require('telescope').register_extension {
    exports = {
        -- Default when to argument is given, i.e. :Telescope vim_bookmarks
        vim_bookmarks = all,
        all = all,
        actions = bookmark_actions
    }
}
