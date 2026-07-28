return {
  {
    "keaising/im-select.nvim",
    event = "VeryLazy",
    opts = {
      default_im_select = "com.apple.keylayout.US",
      default_command = "/etc/profiles/per-user/kirubeltadesse/bin/macism",
      set_default_events = { "InsertLeave" },
      set_previous_events = { "InsertEnter" },
      keep_quiet_on_no_binary = false,
      async_switch_im = false,
    },
  },
}
