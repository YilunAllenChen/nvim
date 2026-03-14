return {
  {
    '3rd/image.nvim',
    ft = { 'markdown' },
    build = false,
    opts = {
      backend = 'kitty',
      processor = 'magick_cli',
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { 'markdown' },
        },
      },
      max_height_window_percentage = 50,
      window_overlap_clear_ft_ignore = {
        'cmp_menu',
        'cmp_docs',
        'snacks_notif',
        'scrollview',
        'scrollview_sign',
      },
      editor_only_render_when_focused = true,
      tmux_show_only_in_active_window = true,
      hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
    },
  },
  {
    '3rd/diagram.nvim',
    ft = { 'markdown' },
    dependencies = { '3rd/image.nvim' },
    opts = function()
      return {
        integrations = {
          require 'diagram.integrations.markdown',
        },
        renderer_options = {
          mermaid = {
            theme = 'neutral',
            background = 'transparent',
            scale = 2,
          },
        },
      }
    end,
    keys = {
      {
        '<leader>md',
        function() require('diagram').show_diagram_hover() end,
        ft = { 'markdown' },
        desc = 'Show Mermaid Diagram',
      },
    },
  },
}
