local Translations = {
    error = {

    },
    success = {

    },
    info = {
        ['create_house'] = 'Create an open interior house. Your current location should be the center of the house',
        ['name_of_house'] = 'The name of the house (Unique)',
        ['owner_cid'] = 'The citizenid of the owner (Case sensitive)',
    },
    menu = {

    },
    log = {

    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
