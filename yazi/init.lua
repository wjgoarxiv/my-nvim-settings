local ok_git, git = pcall(require, "git")

if ok_git then
  pcall(function()
    th.git = th.git or {}
    th.git.modified_sign = "M "
    th.git.deleted_sign = "D "
    th.git.untracked_sign = "? "
    th.git.added_sign = "A "

    git:setup({
      order = 1500,
    })
  end)
end
