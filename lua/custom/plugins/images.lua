local puppeteer_config = vim.fn.stdpath 'config' .. '/mermaid-puppeteer.json'

return {
  {
    '3rd/image.nvim',
    ft = { 'markdown', 'norg', 'typst', 'asciidoc', 'adoc' },
    build = false,
    opts = {
      backend = 'kitty',
      processor = 'magick_cli',
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          floating_windows = false,
          filetypes = { 'markdown' },
        },
        asciidoc = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          floating_windows = false,
          filetypes = { 'asciidoc', 'adoc' },
        },
        neorg = {
          enabled = true,
          filetypes = { 'norg' },
        },
        typst = {
          enabled = true,
          filetypes = { 'typst' },
        },
      },
      max_width_window_percentage = 85,
      max_height_window_percentage = 60,
      window_overlap_clear_enabled = true,
      editor_only_render_when_focused = true,
      hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
    },
  },
  {
    '3rd/diagram.nvim',
    ft = { 'markdown', 'norg' },
    dependencies = { '3rd/image.nvim' },
    opts = {
      events = {
        render_buffer = { 'BufWinEnter', 'InsertLeave', 'TextChanged' },
        clear_buffer = { 'BufLeave', 'InsertEnter' },
      },
      renderer_options = {
        mermaid = {
          background = 'transparent',
          theme = 'dark',
          scale = 2,
          cli_args = { '-p', puppeteer_config },
        },
      },
    },
    keys = {
      {
        '<leader>mv',
        function() require('diagram').show_diagram_hover() end,
        ft = { 'markdown', 'norg' },
        desc = 'View diagram',
      },
      {
        '<leader>mr',
        function() require('diagram').render() end,
        ft = { 'markdown', 'norg' },
        desc = 'Render diagrams',
      },
      {
        '<leader>mc',
        function() require('diagram').clear() end,
        ft = { 'markdown', 'norg' },
        desc = 'Clear diagrams',
      },
      {
        '<leader>mI',
        '<cmd>ImageReport<cr>',
        ft = { 'markdown', 'norg' },
        desc = 'Image report',
      },
    },
  },
}
