local transform_mod = require('telescope.actions.mt').transform_mod

-- local actions = require('telescope.actions')
-- local action_state = require('telescope.actions.state')

return transform_mod {
    delete_selected_or_at_cursor = function(prompt_bufnr)
        print(prompt_bufnr)
        print(#action_state.get_current_picker(prompt_bufnr))
        -- if #action_state.get_current_picker(prompt_bufnr):get_multi_selection() > 0 then
        --     delete_selected(prompt_bufnr)
        -- else
        --     delete_at_cursor(prompt_bufnr)
        -- end
    end,

    -- delete_all = function(prompt_bufnr)
    --     vim.cmd('BookmarkClearAll')
    -- end
}


