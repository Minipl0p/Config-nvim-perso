-- ============================================================
-- AstroCommunity — packs de langages et plugins communautaires
-- ============================================================
return {
	"AstroNvim/astrocommunity",
	{ import = "astrocommunity.pack.lua" },
	{ import = "astrocommunity.pack.cpp" },
	{ import = "astrocommunity.pack.cs" },
	{ import = "astrocommunity.pack.go" },
	{ import = "astrocommunity.pack.typescript" },
	{ import = "astrocommunity.pack.html-css" },
	{ import = "astrocommunity.pack.rust" },
	{ import = "astrocommunity.pack.ocaml" },
	{ import = "astrocommunity.pack.java" },
	{ import = "astrocommunity.pack.python" },
	{ import = "astrocommunity.pack.php" },
	{ import = "astrocommunity.pack.kotlin" },
	{ import = "astrocommunity.pack.swift" },
	{ import = "astrocommunity.pack.zig" },
	{ import = "astrocommunity.pack.bash" },
	{ import = "astrocommunity.pack.sql" },
	{ import = "astrocommunity.pack.yaml" },
	{ import = "astrocommunity.pack.json" },
	{ import = "astrocommunity.pack.markdown" },
	{ import = "astrocommunity.pack.cmake" },
	{ import = "astrocommunity.pack.tailwindcss" },
	-- IA
	{ import = "astrocommunity.ai.copilot-lua" },
	-- Git
	{ import = "astrocommunity.git.diffview-nvim" },
	{ import = "astrocommunity.git.git-conflict-nvim" },
	-- Explorateur de fichiers
	{ import = "astrocommunity.file-explorer.yazi-nvim" },
	-- Édition
	{ import = "astrocommunity.motion.flash-nvim" },

	-- Fix: docker pack — override le LSP avec le bon nom mason-lspconfig
	{
		"AstroNvim/astrolsp",
		optional = true,
		opts = function(_, opts)
			opts.servers = opts.servers or {}
			-- Retire les noms invalides ajoutés par les packs community
			-- "docker-language-server" → le bon nom est "dockerls"
			-- "volar" → supprimé (pack vue retiré, conflit avec ts_ls)
			local invalid = { "docker-language-server", "volar" }
			if opts.servers then
				for _, bad in ipairs(invalid) do
					opts.servers[bad] = nil
				end
			end
			-- Ajoute le bon nom pour Docker LSP
			opts.servers.dockerls = opts.servers.dockerls or {}
			return opts
		end,
	},
}
