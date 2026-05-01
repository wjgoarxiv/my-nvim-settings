--- @since 25.5.31
--- @sync entry

local function setup(self, opts)
  self.open_multi = opts.open_multi
end

local function entry(self)
  local hovered = cx.active.current.hovered
  local command = hovered and hovered.cha.is_dir and "enter" or "open"

  ya.emit(command, { hovered = not self.open_multi })
end

return { entry = entry, setup = setup }
