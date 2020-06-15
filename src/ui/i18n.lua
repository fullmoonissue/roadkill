local locale = 'en'
local locales = {
    en = '🇺🇸',
    fr = '🇫🇷',
}

local allTranslations = {
    en = {
        _references = {
            add = 'Add',
            delete = 'Delete',
            goBack = 'Go back',
            required = 'Required',
            startAt = 'Start at',
            stopAt = 'Stop at',
            update = 'Update',
        },
        -- Text to describe a technical key
        textInPlaylist = {
            ['work-before-all'] = 'Before Starting !',
            ['work-start'] = 'Let\'s Go !',
            ['work-items'] = 'Work !',
            ['work-end'] = 'Take a break !',
            ['work-after-all'] = 'Finish !',
        },
        textItemTypes = {
            ['Folder'] = 'Folder',
            ['File'] = 'File',
            ['Url'] = 'Url',
        },
        textRootKeys = {
            ['work-before-all'] = 'Before all items',
            ['work-start'] = 'Before any item',
            ['work-items'] = 'Items',
            ['work-end'] = 'After any item',
            ['work-after-all'] = 'After all items',
        },
        -- Title of a window
        window = {
            formComposition = '[%s] Items composition',
            formDashboard = 'Dashboard',
            formItemType = 'Type : %s',
            prefix = '[Roadkill] %s',
        },
        -- Forms
        formDashboard = {
            button = {
                create = 'Create',
                delete = '_(delete)',
                launch = 'Launch',
                update = '_(update)',
            },
            error = {
                alreadyExists = 'This name already exists',
                compositionNotValid = 'Composition not valid',
                nameRequired = 'Name required',
            },
            label = {
                existingCompositions = 'Existing compositions',
                language = 'Language',
                newComposition = 'New composition',
            },
        },
        formComposition = {
            button = {
                apply = 'Apply',
                backToDashboard = 'Back to dashboard',
                configureType = 'Configure',
            },
            dropdown = {
                delete = '_(delete)',
                duplicate = 'Duplicate',
                moveDown = 'Move Down',
                moveUp = 'Move Up',
                onSelectedItem = 'On selected item',
                position = 'Position',
                shift = 'Shift',
                to = 'To',
                update = '_(update)',
            },
            label = {
                actions = 'Actions',
                addItem = 'Add an item',
                listItems = 'List items',
            },
        },
        formItemTypeUrl = {
            button = {
                add = '_(add)',
                goBack = '_(goBack)',
                update = '_(update)',
            },
            error = {
                pathRequired = '_(required)',
            },
            label = {
                path = 'Url ?',
            },
        },
        formItemTypeFolder = {
            button = {
                add = '_(add)',
                goBack = '_(goBack)',
                update = '_(update)',
            },
            checkbox = {
                yes = 'Yes'
            },
            error = {
                pathRequired = '_(required)',
            },
            label = {
                path = 'Location of the folder ?',
                random = 'Randomize file selection ?',
                loop = 'Number of loop by element ?',
                nbElements = 'Number of elements ?',
                startAt = '_(startAt) ?',
                stopAt = '_(stopAt) ?',
            },
        },
        formItemTypeFile = {
            button = {
                add = '_(add)',
                goBack = '_(goBack)',
                update = '_(update)',
            },
            error = {
                pathRequired = '_(required)',
            },
            label = {
                path = 'Location of the file ?',
                startAt = '_(startAt) ?',
                stopAt = '_(stopAt) ?',
            },
        },
    },
    fr = {
        _references = {
            add = 'Add',
            delete = 'Supprimer',
            goBack = 'Revenir en arrière',
            required = 'Requis',
            startAt = 'Départ',
            stopAt = 'Fin',
            update = 'Mettre à jour',
        },
        -- Text to describe a technical key
        textInPlaylist = {
            ['work-before-all'] = 'Avant de commencer !',
            ['work-start'] = 'Allons-y !',
            ['work-items'] = 'Bosse !',
            ['work-end'] = 'Pause !',
            ['work-after-all'] = 'Fin !',
        },
        textItemTypes = {
            ['Folder'] = 'Dossier',
            ['File'] = 'Fichier',
            ['Url'] = 'Url',
        },
        textRootKeys = {
            ['work-before-all'] = 'Avant tout élément',
            ['work-start'] = 'Avant l\'élément',
            ['work-items'] = 'Éléments',
            ['work-end'] = 'Après l\'élément',
            ['work-after-all'] = 'Après tout élément',
        },
        -- Title of a window
        window = {
            formComposition = '[%s] Composition des éléments',
            formDashboard = 'Tableau de bord',
            formItemType = 'Type : %s',
            prefix = '[Roadkill] %s',
        },
        -- Forms
        formDashboard = {
            button = {
                create = 'Créer',
                delete = '_(delete)',
                launch = 'Lancer',
                update = '_(update)',
            },
            error = {
                alreadyExists = 'Ce nom existe déjà',
                compositionNotValid = 'Composition non valide',
                nameRequired = 'Nom requis',
            },
            label = {
                existingCompositions = 'Compositions existantes',
                language = 'Langue',
                newComposition = 'Nouvelle composition',
            },
        },
        formComposition = {
            button = {
                apply = 'Appliquer',
                backToDashboard = 'Retour au tableau de bord',
                configureType = 'Configurer',
            },
            dropdown = {
                delete = '_(delete)',
                duplicate = 'Dupliquer',
                moveDown = 'Descendre',
                moveUp = 'Monter',
                onSelectedItem = 'Sur l\'élément sélectionné',
                position = 'Position',
                shift = 'Déplacer',
                to = 'Vers',
                update = '_(update)',
            },
            label = {
                actions = 'Actions',
                addItem = 'Ajouter un élément',
                listItems = 'Lister les éléments',
            },
        },
        formItemTypeUrl = {
            button = {
                add = '_(add)',
                goBack = '_(goBack)',
                update = '_(update)',
            },
            error = {
                pathRequired = '_(required)',
            },
            label = {
                path = 'Url ?',
            },
        },
        formItemTypeFolder = {
            button = {
                add = '_(add)',
                goBack = '_(goBack)',
                update = '_(update)',
            },
            checkbox = {
                yes = 'Oui'
            },
            error = {
                pathRequired = '_(required)',
            },
            label = {
                path = 'Chemin du dossier ?',
                random = 'Randomiser la sélection des fichiers ?',
                loop = 'Nombre de répétitions par éléments ?',
                nbElements = 'Nombre d\'éléments ?',
                startAt = '_(startAt) ?',
                stopAt = '_(stopAt) ?',
            },
        },
        formItemTypeFile = {
            button = {
                add = '_(add)',
                goBack = '_(goBack)',
                update = '_(update)',
            },
            error = {
                pathRequired = '_(required)',
            },
            label = {
                path = 'Chemin du fichier ?',
                startAt = '_(startAt) ?',
                stopAt = '_(stopAt) ?',
            },
        },
    },
}

local subsituteReference, found
subsituteReference = function(tables, references, notFounds)
    if notFounds == nil then
        notFounds = {}
    end
    for key, properties in pairs(tables) do
        if 'string' == type(properties) then
            _, _, found = string.find(properties, '_%((%a+)%)')
            if found ~= nil then
                if references[found] == nil then
                    table.insert(notFounds, found)
                    references[found] = ''
                end
                tables[key], _ = string.gsub(properties, '_%(' .. found .. '%)', references[found])
            end
        else
            subsituteReference(properties, references, notFounds)
        end
    end
end

for _, properties in pairs(allTranslations) do
    subsituteReference(properties, properties['_references'])
end

local translations = allTranslations[locale]

return {
    allTranslations = allTranslations,
    locales = locales,
    getTranslations = function()
        return translations
    end,
    setLocale = function(newLocale)
        locale = newLocale
        translations = allTranslations[locale]
    end,
    subsituteReference = subsituteReference,
}