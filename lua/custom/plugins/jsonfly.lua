return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "https://git.myzel394.app/Myzel394/jsonfly.nvim",
    },
    keys = {
        {
            "<leader>j",
            "<cmd>Telescope jsonfly<cr>",
            desc = "Open json(fly)",
            ft = { "json", "xml", "yaml" },
            mode = "n"
        }
    }
}
