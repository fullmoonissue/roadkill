install:
	luarocks install luacheck
	luarocks install luaunit

cs-check:
	luacheck --std=min+roadkill roadkill.lua

test:
	lua roadkill.lua -v