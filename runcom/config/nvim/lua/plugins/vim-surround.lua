return {
	"tpope/vim-surround",
	event = "VeryLazy",
	dependancies = {
		"tpope/vim-repeat",
	},

	--   Surround.vim is all about "surroundings": parentheses, brackets, quotes, XML tags, and more. The plugin provides mappings to easily delete, change and add such surroundings in pairs.
	--
	--    It's easiest to explain with examples. Press cs"' inside
	-- "Hello world!"
	--
	--    to change it to
	-- 'Hello world!'
	--
	--    Now press cs'<q> to change it to
	-- <q>Hello world!</q>
	--
	--    To go full circle, press cst" to get
	-- "Hello world!"
	--
	--    To remove the delimiters entirely, press ds".
	-- Hello world!
	--
	--    Now with the cursor on "Hello", press ysiw] (iw is a text object).
	-- [Hello] world!
	--
	--    Let's make that braces and add some space (use } instead of { for no space): cs]{
	-- { Hello } world!
	--
	--    Now wrap the entire line in parentheses with yssb or yss).
	-- ({ Hello } world!)
	--
	--    Revert to the original text: ds{ds)
	-- Hello world!
	--
	--    Emphasize hello: ysiw<em>
	-- <em>Hello</em> world!
	--
	--    Finally, let's try out visual mode. Press a capital V (for linewise visual mode) followed by S<p class="important">.
	-- <p class="important">
	--   <em>Hello</em> world!
	-- </p>
	--
}
