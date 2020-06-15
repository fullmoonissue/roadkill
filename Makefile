install: install-luacheck install-luaunit

install-luacheck:
	luarocks install luacheck

install-luaunit:
	luarocks install luaunit

cs-check:
	luacheck --std=lua51+roadkill entrypoint.lua scripts src tests

test: unit-test real-case-test

unit-test:
	@echo "\n(ง ͠° ͟ل͜ ͡°)ง Unit Tests\n"
	lua tests/context.lua -v
	lua tests/playlist.lua -v
	lua tests/utils.lua -v
	lua tests/vlc.lua -v

real-case-test:
	@echo "\n(ง ͠° ͟ل͜ ͡°)ง Real Case Tests\n"
	lua tests/audit.lua -v