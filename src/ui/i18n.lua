local locale = 'en'
local locales = {
    en = '🇺🇸',
    fr = '🇫🇷',
}

local allTranslations = {
    en = {
        playlistTexts = {
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
        window = {
            title = {
                all = '[Roadkill] %s',
                formComposition = 'Items composition of %s',
                formFileName = 'Dashboard',
                formItemType = '[%s]',
            },
        },
        name = {
            form = {
                button = {
                    create = 'Create',
                    delete = 'Delete',
                    launch = 'Launch',
                    update = 'Update',
                },
                error = {
                    alreadyExists = 'This name already exists',
                    nameRequired = 'Name required',
                },
                label = {
                    existingCompositions = 'Existing compositions',
                    language = 'Language',
                    newComposition = 'New composition',
                },
            },
        },
        items = {
            form = {
                button = {
                    apply = 'Apply',
                    backToDashboard = 'Back to dashboard',
                    configureType = 'Configure',
                    save = 'Save',
                },
                dropdown = {
                    delete = 'Delete',
                    duplicate = 'Duplicate',
                    moveDown = 'Move Down',
                    moveUp = 'Move Up',
                    onSelectedItem = 'On selected item',
                    position = 'Position',
                    shift = 'Shift',
                    to = 'To',
                    update = 'Update',
                },
                error = {
                    noItemsNoSave = 'No items to save',
                },
                success = {
                    fileSaved = 'File saved',
                },
                label = {
                    actions = 'Actions',
                    addItem = 'Add an item',
                    listItems = 'List items',
                },
            },
        },
        url = {
            form = {
                button = {
                    add = 'Add',
                    goBack = 'Go back',
                    update = 'Update',
                },
                error = {
                    pathRequired = 'Required',
                },
                label = {
                    path = 'Url ?',
                },
            },
        },
        folder = {
            form = {
                button = {
                    add = 'Add',
                    goBack = 'Go back',
                    update = 'Update',
                },
                checkbox = {
                    yes = 'Yes'
                },
                error = {
                    pathRequired = 'Required',
                },
                label = {
                    path = 'Location of the folder ?',
                    random = 'Randomize file selection ?',
                    loop = 'Number of loop by element ?',
                    nbElements = 'Number of elements ?',
                    startAt = 'Start at ?',
                    stopAt = 'Stop at ?',
                },
            },
        },
        file = {
            form = {
                button = {
                    add = 'Add',
                    goBack = 'Go back',
                    update = 'Update',
                },
                error = {
                    pathRequired = 'Required',
                },
                label = {
                    path = 'Location of the file ?',
                    startAt = 'Start at ?',
                    stopAt = 'Stop at ?',
                },
            },
        },
    },
    fr = {
        playlistTexts = {
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
            ['work-before-all'] = 'Avant tout éléments',
            ['work-start'] = 'Avant l\'élément',
            ['work-items'] = 'Éléments',
            ['work-end'] = 'Après l\'élément',
            ['work-after-all'] = 'Après tout éléments',
        },
        window = {
            title = {
                all = '[Roadkill] %s',
                formComposition = 'Composition des éléments de %s',
                formFileName = 'Tableau de bord',
                formItemType = '[%s]',
            },
        },
        name = {
            form = {
                button = {
                    create = 'Créer',
                    delete = 'Supprimer',
                    launch = 'Lancer',
                    update = 'Mettre à jour',
                },
                error = {
                    alreadyExists = 'Ce nom existe déjà',
                    nameRequired = 'Nom requis',
                },
                label = {
                    existingCompositions = 'Compositions existantes',
                    language = 'Langue',
                    newComposition = 'Nouvelle composition',
                },
            },
        },
        items = {
            form = {
                button = {
                    apply = 'Appliquer',
                    backToDashboard = 'Retour au tableau de bord',
                    configureType = 'Configurer',
                    save = 'Sauvegarder',
                },
                dropdown = {
                    delete = 'Supprimer',
                    duplicate = 'Dupliquer',
                    moveDown = 'Descendre',
                    moveUp = 'Monter',
                    onSelectedItem = 'Sur l\'élément sélectionné',
                    position = 'Position',
                    shift = 'Déplacer',
                    to = 'Vers',
                    update = 'Mettre à jour',
                },
                error = {
                    noItemsNoSave = 'Aucun élément à sauvegarder',
                },
                success = {
                    fileSaved = 'Fichier sauvegardé',
                },
                label = {
                    actions = 'Actions',
                    addItem = 'Ajouter un élément',
                    listItems = 'Lister les éléments',
                },
            },
        },
        url = {
            form = {
                button = {
                    add = 'Ajouter',
                    goBack = 'Revenir en arrière',
                    update = 'Mettre à jour',
                },
                error = {
                    pathRequired = 'Requis',
                },
                label = {
                    path = 'Url ?',
                },
            },
        },
        folder = {
            form = {
                button = {
                    add = 'Ajouter',
                    goBack = 'Revenir en arrière',
                    update = 'Mettre à jour',
                },
                checkbox = {
                    yes = 'Oui'
                },
                error = {
                    pathRequired = 'Requis',
                },
                label = {
                    path = 'Chemin du dossier ?',
                    random = 'Randomiser la sélection des fichiers ?',
                    loop = 'Nombre de répétitions par éléments ?',
                    nbElements = 'Nombre d\'éléments ?',
                    startAt = 'Départ ?',
                    stopAt = 'Fin ?',
                },
            },
        },
        file = {
            form = {
                button = {
                    add = 'Ajouter',
                    goBack = 'Revenir en arrière',
                    update = 'Mettre à jour',
                },
                error = {
                    pathRequired = 'Requis',
                },
                label = {
                    path = 'Chemin du fichier ?',
                    startAt = 'Départ ?',
                    stopAt = 'Fin ?',
                },
            },
        },
    },
}
local translations = allTranslations[locale]

return {
    locales = locales,
    getTranslations = function()
        return translations
    end,
    setLocale = function(newLocale)
        locale = newLocale
        translations = allTranslations[locale]
    end,
}