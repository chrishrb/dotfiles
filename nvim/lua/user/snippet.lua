local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

-- for custom snippets
function _G.snippets_clear()
	for m, _ in pairs(luasnip.snippets) do
		package.loaded["snippets."..m] = nil
	end
	luasnip.snippets = setmetatable({}, {
		__index = function(t, k)
			local ok, m = pcall(require, "snippets." .. k)
			t[k] = ok and m or {}
			return t[k]
		end
	})
end


_G.snippets_clear()

-- friendly snippets
require("luasnip/loaders/from_vscode").lazy_load()
