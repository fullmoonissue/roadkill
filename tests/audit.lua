local i18nModule = require('src/ui/i18n')
local i18nAudit = require('scripts/audit-i18n')
local lu = require('luaunit')

function testAuditI18N()
    lu.assertTrue(i18nAudit.areKeysEquivalent(i18nModule.allTranslations))
    lu.assertTrue(i18nAudit.areReferencesEquivalent())
end

os.exit(lu.LuaUnit.run())