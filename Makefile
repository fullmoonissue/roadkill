install: install-luacheck install-luaunit

install-luacheck:
	luarocks install luacheck

install-luaunit:
	luarocks install luaunit

cs-check:
	luacheck --std=min+roadkill entrypoint.lua src tests

test:
	lua tests/configuration.lua -v
	lua tests/playlist.lua -v
	lua tests/utils.lua -v
	lua tests/vlc/options.lua -v