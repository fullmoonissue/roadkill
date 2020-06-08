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
            ['work-before-all'] = 'Before all exercices',
            ['work-start'] = 'Before any exercice',
            ['work-items'] = 'Exercices',
            ['work-end'] = 'After any exercice',
            ['work-after-all'] = 'After all exercices',
        },
        window = {
            title = {
                all = '[Roadkill] %s',
                formConfiguration = 'Items configuration of %s',
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
                    nameRequired = 'Name required',
                },
                label = {
                    existingConfigurations = 'Existing configurations',
                    language = 'Language',
                    newConfiguration = 'New configuration',
                },
            },
        },
        items = {
            form = {
                button = {
                    backToDashboard = 'Back to dashboard',
                    configureType = 'Configure...',
                    save = 'Save',
                },
                success = {
                    fileSaved = 'File saved',
                },
                label = {
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
                    duration = 'Duration ?',
                    start = 'Start ?',
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
                    duration = 'Duration ?',
                    start = 'Start ?',
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
            ['work-before-all'] = 'Avant tout exercices',
            ['work-start'] = 'Avant l\'exercice',
            ['work-items'] = 'Exercices',
            ['work-end'] = 'Après l\'exercice',
            ['work-after-all'] = 'Après tout exercices',
        },
        window = {
            title = {
                all = '[Roadkill] %s',
                formConfiguration = 'Configuration des éléments de %s',
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
                    nameRequired = 'Nom requis',
                },
                label = {
                    existingConfigurations = 'Configurations existantes',
                    language = 'Langue',
                    newConfiguration = 'Nouvelle configuration',
                },
            },
        },
        items = {
            form = {
                button = {
                    backToDashboard = 'Retour au tableau de bord',
                    configureType = 'Configurer...',
                    save = 'Sauvegarder',
                },
                success = {
                    fileSaved = 'Fichier sauvegardé',
                },
                label = {
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
                    duration = 'Durée ?',
                    start = 'Départ ?',
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
                    duration = 'Durée ?',
                    start = 'Départ ?',
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