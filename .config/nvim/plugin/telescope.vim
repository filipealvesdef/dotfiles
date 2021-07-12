lua << EOF
local actions = require('telescope.actions')
require('telescope').setup{
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
        },
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "    ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                mirror = false,
            },
            vertical = {
                mirror = false,
            },
        },
        file_sorter =    require'telescope.sorters'.get_fzy_sorter,
        file_ignore_patterns = {},
        winblend = 0,
        border = {},
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons = true,
        use_less = true,
        path_display = {},
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,

        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            }
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        },
    },
}
require('telescope').load_extension('fzy_native')
EOF

nnoremap <Leader>f<Leader> :lua require('telescope.builtin').find_files()<CR>
nnoremap <Leader>pp :lua require('telescope.builtin').live_grep()<CR>
nnoremap <Leader>oo :lua require('telescope.builtin').buffers()<CR>
nnoremap <Leader>ff :lua require('telescope.builtin').git_files()<CR>
nnoremap <Leader>fe :lua require('telescope.builtin').file_browser()<CR>
nnoremap <Leader>ps :lua require('telescope.builtin').grep_string()<CR>
