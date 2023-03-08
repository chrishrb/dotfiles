local status_ok, devicons = pcall(require, "nvim-web-devicons")
if not status_ok then
  return
end

devicons.set_icon {
  ["tf"] = {
    icon = " ",
    color = "#5C52E0",
    cterm_color = "63",
    name = "tf"
  },
  ["hcl"] = {
    icon = " ",
    color = "#5C52E0",
    cterm_color = "63",
    name = "hcl"
  },
  ["terraformrc"] = {
    icon = " ",
    color = "#5C52E0",
    cterm_color = "63",
    name = "terraformrc"
  },
  ["tfvars"] = {
    icon = " ",
    color = "#5C52E0",
    cterm_color = "63",
    name = "tfvars"
  },
  ["tfstate"] = {
    icon = " ",
    color = "#5C52E0",
    cterm_color = "63",
    name = "tfstate"
  },
}

