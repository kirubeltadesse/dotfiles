return {
  {
    "nvim-neotest/neotest",
    dependencies = { "nvim-neotest/neotest-jest", "marilari88/neotest-vitest" },
    opts = function(_, opts)
     -- TODO: add pytest, java-test, and c++-test
      --table.insert(opts.adapters, require("neotest-jest"))
      --table.insert(opts.adapters, require("neotest-vitest"))
    end,
  },
}
