return {
  {
    "keaising/im-select.nvim",
    event = "VeryLazy",
    opts = {
      default_im_select = "com.apple.keylayout.US",
      default_command = "im-select",
      set_default_events = { "InsertLeave", "CmdlineLeave" },
      set_previous_events = { "InsertEnter", "CmdlineEnter" },
      keep_quiet_on_no_binary = false,
      async_switch_im = true,
    },
  },
}
