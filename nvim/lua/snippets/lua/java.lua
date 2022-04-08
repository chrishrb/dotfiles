local snip_status_ok, ls = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

-- some shorthands...
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local l = require("luasnip.extras").lambda

-- function for getting the package
local function get_package()
  local filepath = vim.fn.expand"%:p"
  local _i, _j = filepath:find("src/main/[^/]*/*")
  if not _j then
    return ""
  end
  filepath = filepath:sub(_j+1)
  filepath = filepath:sub(0, filepath:find("/[^/]*$")-1):gsub("/", ".")
  return filepath
end

local snippets = {
  s("source", {
    t("package "),
    t(get_package()),
    t({";", ""}),
    t({"", "", ""}),
    t("public class "),
    l(l.TM_FILENAME_BASE),
    t({" {", "\t"}),
    i(0),
    t({"", "}"})
  }),
  s("test", {
    t("package "),
    t(get_package()),
    t({";", "", ""}),
    t({"import org.junit.jupiter.api.Test;", ""}),
    t({"import static org.junit.jupiter.api.Assertions.*;", ""}),
    t({"", "", ""}),
    t("public class "),
    l(l.TM_FILENAME_BASE),
    t({" {", "\t"}),
    i(0),
    t({"", "}"})
  }),
  s("test_method", {
    t({"@Test", ""}),
    t({"public void "}),
    i(1, "name"),
    t({"() {", "\t"}),
    i(0),
    t({"", "}"}),
  })
}

ls.add_snippets("java", snippets)
