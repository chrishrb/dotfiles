local status_ok, lspsaga = pcall(require, "lspsaga")
if not status_ok then
  return
end

lspsaga.init_lsp_saga {
  border_style = "single",

  code_action_icon = " ",
  diagnostic_header = { "", "", "", "" },
  code_action_lightbulb = {
    enable = true,
    sign = true,
    sign_priority = 40,
    virtual_text = true,
  },

  finder_icons = {
    def = "",
    ref = "",
    link = ""
  },
  max_preview_lines = 10,
  definition_preview_icon = "",
  server_filetype_map = {},
}

lspsaga.init_lsp_saga({
    symbol_in_winbar = {
        in_custom = true
    }
})
