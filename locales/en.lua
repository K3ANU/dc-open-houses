local Translations = {
    error = {
        ['owner_not_found'] = 'Owner not found',
        ['not_nearby_house'] = 'You are not near a house',
        ['no_perms'] = 'You have no permission to do this'
    },
    success = {
        ['create_house'] = 'Succesfully created %{house} for %{owner}'
    },
    info = {
        ['deleted_houses'] = 'Deleted %{amount} house(s)'
    },
    text = {
        ['open_stash'] = 'Open Stash',
        ['change_outfit'] = 'Change Outfit',
        ['change_char'] = 'Change Character'
    },
    command = {
        ['create_house'] = 'Create an open interior house. Your current location should be the center of the house',
        ['name_of_house'] = 'The name of the house (Unique)',
        ['owner_cid'] = 'The citizenid of the owner (Case sensitive) or server id',
        ['create_stash'] = 'Create a stash at your current location in your house',
        ['delete_all'] = 'Delete all the houses there are'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
