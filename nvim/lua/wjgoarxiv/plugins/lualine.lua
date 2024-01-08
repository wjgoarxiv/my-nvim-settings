local status, lualine = pcall(require, "lualine")
if not status then
    return
end

lualine.setup {
    options = {
        theme = 'auto', -- Use 'auto' for default theme or set to 'gruvbox' if already installed
    }
    -- other default configurations
}