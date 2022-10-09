-- setup with all defaults
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
require'nvim-tree'.setup { -- BEGIN_DEFAULT_OPTS
  auto_reload_on_write = true,
  disable_netrw = false,
  --hide_root_folder = false,
  hijack_cursor = false,
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = false,
  ignore_buffer_on_setup = false,
  open_on_setup = false,
  open_on_setup_file = false,
  open_on_tab = false,
  sort_by = "name",
  update_cwd = false,
  view = {
    width = 40,
    height = 30,
    side = "left",
    preserve_window_proportions = false,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
    mappings = {
      custom_only = false,
      list = {
        { key = {"l", "o", "<2-LeftMouse>"}, action = "edit" },
        { key = "v",    action = "vsplit" },
        { key = "s",    action = "split" },
        { key = "t",    action = "tabnew" },
        { key = "h",    action = "close_node" },
        { key = "<BS>", action = "dir_up" },
        { key = "dd",   action = "cut" },
        { key = "yy",   action = "copy" },
        { key = "X",    action = "system_open" },

        { key = "<C-e>",                        action = "" },
        { key = {"O"},                          action = "edit_no_picker" },
        { key = {"<2-RightMouse>", "<C-]>"},    action = "cd" },

        { key = "<",                            action = "prev_sibling" },
        { key = ">",                            action = "next_sibling" },
        { key = "P",                            action = "parent_node" },
        --{ key = "",                            action = "first_sibling" },
        --{ key = "",                            action = "last_sibling" },

        { key = "<Tab>",                        action = "preview" },

        { key = "I",     action = "toggle_git_ignored" },
        { key = "H",     action = "toggle_dotfiles" },
        { key = "g?",    action = "toggle_help" },
        { key = "K", action = "toggle_file_info" },

        { key = "R",     action = "refresh" },
        { key = "a",     action = "create" },
        --{ key = "d",     action = "remove" },
        { key = "D",     action = "trash" },
        { key = "r",     action = "rename" },
        { key = "<C-r>", action = "full_rename" },
        { key = "p",     action = "paste" },
        { key = "y",     action = "copy_name" },
        { key = "Y",     action = "copy_path" },
        { key = "gy",    action = "copy_absolute_path" },
        { key = "[c",    action = "prev_git_item" },
        { key = "]c",    action = "next_git_item" },
        { key = "q",     action = "close" },
        { key = "W",     action = "collapse_all" },
        { key = "S",     action = "search_node" },
        { key = ".",     action = "run_file_command" }
      },
    },
  },
  renderer = {
    indent_markers = {
      enable = false,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
  },
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = false,
    update_cwd = false,
    ignore_list = {},
  },
  ignore_ft_on_setup = {},
  system_open = {
    cmd = nil,
    args = {},
  },
  diagnostics = {
    enable = false,
    show_on_dirs = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  filters = {
    dotfiles = false,
    custom = {},
    exclude = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 400,
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
    },
    open_file = {
      quit_on_open = false,
      resize_window = false,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  log = {
    enable = false,
    truncate = false,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      git = false,
      profile = false,
    },
  },
} -- END_DEFAULT_OPTS
