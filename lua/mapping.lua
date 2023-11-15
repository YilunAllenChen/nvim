local M = {}

function M.which_key_register()
  if M.which_key_queue then
    local wk_avail, wk = pcall(require, "which-key")
    if wk_avail then
      for mode, registration in pairs(M.which_key_queue) do
        wk.register(registration, { mode = mode })
      end
      M.which_key_queue = nil
    end
  end
end

function M.set_mappings(map_table, base)
  -- iterate over the first keys for each mode
  base = base or {}
  for mode, maps in pairs(map_table) do
    -- iterate over each keybinding set in the current mode
    for keymap, options in pairs(maps) do
      -- build the options for the command accordingly
      if options then
        local cmd = options
        local keymap_opts = base
        if type(options) == "table" then
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend("force", keymap_opts, options)
          keymap_opts[1] = nil
        end
        if not cmd or keymap_opts.name then -- if which-key mapping, queue it
          if not M.which_key_queue then M.which_key_queue = {} end
          if not M.which_key_queue[mode] then M.which_key_queue[mode] = {} end
          M.which_key_queue[mode][keymap] = keymap_opts
        else -- if not which-key mapping, set it
          vim.keymap.set(mode, keymap, cmd, keymap_opts)
        end
      end
    end
  end
  if package.loaded["which-key"] then M.which_key_register() end -- if which-key is loaded already, register
end

M.set_mappings {
  n = {

    -- Blazingly Fast Shortcuts
    ["'"] = {
      function()
        if vim.bo.buftype == 'terminal' then
          vim.cmd('bd!')
        else
          vim.cmd('confirm q')
        end
      end
      , desc = "Quit"
    },
    [","] = { function() require("telescope.builtin").live_grep() end, desc = "Find words" },
    ["="] = {
      function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end,
      desc = "Find all files",
    },
    ["C-g"] = { function()
      local filePath = vim.fn.expand('%:p')
      if filePath == '' then
        print('No file loaded')
      else
        print(filePath)
      end
    end, desc = "Show Full Path" },

    -- Jumping Around
    [";"] = { "<cmd>:HopWord<cr>", desc = "Hop" },
    ['<leader><leader>'] = { function() require('telescope.builtin').current_buffer_fuzzy_find() end, desc =
    "Fuzzy Search In Buffer" },
    ['gd'] = { function() require('telescope.builtin').lsp_definitions() end, desc = "definition" },
    ["gD"] = {
      function() require('telescope.builtin').lsp_declarations() end,
      desc = "Declaration of current symbol",
    },
    ['gr'] = { function() require('telescope.builtin').lsp_references() end, desc = "references" },
    ['gt'] = { function() require('telescope.builtin').lsp_type_definitions() end, desc = "type definition" },
    ['gI'] = { function() require('telescope.builtin').lsp_incoming_calls() end, desc = "incoming calls" },

    ["<leader>;"] = { "<cmd>:HopAnywhere<cr>", desc = "Hop!!" },
    ["<leader>P"] = { "<cmd>:Telescope projects<cr>", desc = "Telescope projects" },
    ["<leader>b"] = { function() require("telescope.builtin").buffers() end, desc = "Find buffers" },

    -- Editing
    ["<leader>e"] = { "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
    ["<leader>w"] = { "<cmd>w<cr>", desc = "Save" },
    ["<leader>q"] = { "<cmd>confirm q<cr>", desc = "Quit" },
    ["<leader>n"] = { "<cmd>enew<cr>", desc = "New File" },
    ["<leader>'"] = { "<cmd>:edit!<cr>", desc = "Reload buffer" },
    ["<leader>/"] = {
      function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Toggle comment line",
    },
    ["<leader>fR"] = { function() require("spectre").open() end, desc = "Spectre search & replace" },

    -- Packages & Plugins
    ["<leader>p"] = { function() require("lazy").home() end, desc = "Plugins" },
    ["<leader>m"] = { "<cmd>Mason<cr>", desc = "Mason Installer" },

    -- Git
    ["<leader>g"] = { desc = "Git" },
    ["]g"] = { function() require("gitsigns").next_hunk() end, desc = "Next Git hunk" },
    ["[g"] = { function() require("gitsigns").prev_hunk() end, desc = "Previous Git hunk" },
    ["<leader>gl"] = { function() require("gitsigns").blame_line() end, desc = "View Git blame" },
    ["<leader>gL"] = { function() require("gitsigns").blame_line { full = true } end, desc = "View full Git blame" },
    ["<leader>gg"] = {
      function()
        local lazygit = require("toggleterm.terminal").Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
        lazygit:toggle()
      end,
      desc = "ToggleTerm lazygit"
    },


    -- LSP
    ["K"] = {
      function() vim.lsp.buf.hover() end,
      desc = "Hover symbol details",
    },
    ["<leader>l"] = { desc = "LSP" },
    ["<leader>lf"] = {
      function() vim.lsp.buf.format() end,
      desc = "Format buffer",
    },
    ["<leader>lr"] = {
      function() vim.lsp.buf.rename() end,
      desc = "Rename current symbol",
    },
    ["<leader>lx"] = { "<cmd>:LspRestart<cr>", desc = "LSP Restart" },
    ["<leader>lS"] = { function() require("aerial").toggle() end, desc = "Symbols outline" },
    ["<leader>ls"] = {
      function()
        local aerial_avail, _ = pcall(require, "aerial")
        if aerial_avail then
          require("telescope").extensions.aerial.aerial()
        else
          require("telescope.builtin").lsp_document_symbols()
        end
      end,
      desc = "Search symbols",
    },
    ["<leader>la"] = { function() require("actions-preview").code_actions() end, desc = "Code action" },
    ["<leader>li"] = { "<cmd>LspInfo<cr>", desc = "LSP information" },

    -- Diagnostics
    ["<leader>ld"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
    ["[d"] = { function() vim.diagnostic.goto_prev() end, desc = "Previous diagnostic" },
    ["]d"] = { function() vim.diagnostic.goto_next() end, desc = "Next diagnostic" },

    -- Buffers
    ["H"] = { "<cmd>:bprevious<cr>", desc = "Prev Buffer" },
    ["L"] = { "<cmd>:bnext<cr>", desc = "Next Buffer" },
    ["<leader>C"] = { "<cmd>:%bd|e#<cr>", desc = "Close all buffers except current" },

    -- Findings stuff
    ["<leader>f"] = { desc = "Find" },
    ["<leader>fd"] = { "<cmd>TodoTelescope<cr>", desc = "TODO" },
    ["<leader>f<CR>"] = { function() require("telescope.builtin").resume() end, desc = "Resume previous search" },
    ["<leader>fc"] = { function() require("telescope.builtin").grep_string() end, desc = "Find for word under cursor" },
    ["<leader>fC"] = { function() require("telescope.builtin").commands() end, desc = "Find commands" },
    ["<leader>fh"] = { function() require("telescope.builtin").help_tags() end, desc = "Find help" },
    ["<leader>fk"] = { function() require("telescope.builtin").keymaps() end, desc = "Find keymaps" },
    ["<leader>ft"] = { function() require("telescope.builtin").colorscheme { enable_preview = true } end, desc =
    "Find themes" },

    -- Opening terminals
    ["<C-t>"] = { "<cmd>:terminal<cr>" },
    ["t"] = { "<C-w>s<cmd>:terminal<cr>a" },
    ["T"] = { "<C-w>v<cmd>:terminal<cr>a" },

    -- window management & navigation
    ["\\"] = { "<C-w>v", desc = "Vertical Split" },
    ["-"] = { "<C-w>s", desc = "Horizontal Split" },
    ["<C-h>"] = { "<cmd>wincmd h<cr>", desc = "Terminal left window navigation" },
    ["<C-j>"] = { "<cmd>wincmd j<cr>", desc = "Terminal down window navigation" },
    ["<C-k>"] = { "<cmd>wincmd k<cr>", desc = "Terminal up window navigation" },
    ["<C-l>"] = { "<cmd>wincmd l<cr>", desc = "Terminal right window navigation" },
    ["<C-Up>"] = { "<cmd>resize -2<CR>", desc = "Resize split up" },
    ["<C-Down>"] = { "<cmd>resize +2<CR>", desc = "Resize split down" },
    ["<C-Left>"] = { "<cmd>vertical resize +2<CR>", desc = "Resize split left" },
    ["<C-Right>"] = { "<cmd>vertical resize -2<CR>", desc = "Resize split right" },

    -- fun stuff
    ["<leader>fml"] = { "<cmd>CellularAutomaton make_it_rain<cr>", desc = "Make It Rain!!!" },
    ["<leader>gol"] = { "<cmd>CellularAutomaton game_of_life<cr>", desc = "Game Of Life!!!" },
    ["<leader>sld"] = { "<cmd>CellularAutomaton scramble<cr>", desc = "SCRABLE!!!" },

  },
  t = {
    ["<esc>"] = { "<C-\\><C-n>" },
    ["<C-h>"] = { "<cmd>wincmd h<cr>", desc = "Terminal left window navigation" },
    ["<C-j>"] = { "<cmd>wincmd j<cr>", desc = "Terminal down window navigation" },
    ["<C-k>"] = { "<cmd>wincmd k<cr>", desc = "Terminal up window navigation" },
    ["<C-l>"] = { "<cmd>wincmd l<cr>", desc = "Terminal right window navigation" },
  },
  i = {
    ["<C-d><C-b>"] = { "import ipdb; ipdb.set_trace(context=5)", desc = "debug" },
  },
  v = {
    ["<leader>/"] = {
      "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
      desc = "Toggle comment for selection",
    },
    ["<S-Tab>"] = { "<gv", desc = "Unindent line" },
    ["<Tab>"] = { ">gv", desc = "Indent line" },

    ["<leader>le"] = { "<cmd>Refactor extract<CR>", desc = "Refactor: extract function" },
    ["<leader>rr"] = { "<cmd>SnipRun<CR>", desc = "Run snippet" },
  }

}
