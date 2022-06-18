local Translations = {
    error = {
        ['owner_not_found'] = 'A tulajdonos nem található',
        ['not_nearby_house'] = 'Nem vagy ház közelében',
        ['no_perms'] = 'Nincs engedélye erre',
        ['not_keyholder'] = 'Nincs kulcsa ehhez a házhoz',
        ['target_not_found'] = 'A cél nem található',
        ['cant_give_keys_to_self'] = 'Nem adhatsz kulcsot magadnak',
        ['cant_remove_keys_from_self'] = 'Nem távolíthatja el magát',
        ['not_in_car'] = 'Nem autóban van',
        ['dont_park_here'] = 'Ez a jármű nem ide tartozik',
        ['no_vehicles'] = 'Itt nincsenek járművek',
        ['not_owner_car'] = 'Ez a jármű nem tulajdonosa senkinek',
    },
    success = {
        ['create_house'] = 'A %{house} sikeresen létrehozva %{owner} számára',
        ['create_stash'] = 'A rejtés sikeresen létrehozva a %{house}-ban',
        ['create_outfit'] = 'Sikeresen létrehoztuk a ruhatárat a %{house}-on belül',
        ['create_logout'] = 'Az ágy sikeresen létrehozva a következő helyen: %{house}',
        ['create_garage'] = 'A garázs sikeresen létrehozva a következő helyen: %{house}',
        ['create_door'] = 'Sikeresen létrehoztunk egy ajtót %{house} belsejében',
        ['give_keys'] = 'Kulcsokat adott a következőnek: %{target}',
        ['remove_keys'] = 'A kulcsok eltávolítva innen: %{target}',
        ['deleted_house'] = 'A %{house} sikeresen törölve',
    },
    info = {
        ['deleted_houses'] = '%{amount} ház(ak) törölve',
    },
    text = {
        ['open_stash'] = 'A Stash megnyitása',
        ['change_outfit'] = 'Ruházat váltás',
        ['change_char'] = 'Karakter módosítása',
        ['open_door'] = 'Nyitott ajtó',
        ['close_door'] = 'Ajtó bezárása',
        ['store_car'] = 'Áruház',
        ['retrieve_car'] = 'Autó visszakeresése',
        ['vehicle_info'] = 'Tábla: %{plate} | Motor: %{engine} | Üzemanyag: %{fuel}',
        ['all_houses'] = 'Minden ház',
        ['house_info'] = 'Tulajdonos: %{owner} | Helyszín: %{center}',
    },
    command = {
        ['create_house'] = 'Nyitott belső ház létrehozása. Az Ön jelenlegi tartózkodási helye a ház közepe legyen.',
        ['name_of_house'] = 'A ház neve (Egyedi) (Kis- és nagybetűk megkülönböztetése)',
        ['owner_cid'] = 'A tulajdonos állampolgársága (kis- és nagybetűk megkülönböztetése) vagy a szerver azonosítója',
        ['delete_all'] = 'Az összes létező ház törlése',
        ['create_stash'] = 'Hozzon létre rejtést a jelenlegi tartózkodási helyén a házában',
        ['create_outfit'] = 'Hozzon létre egy ruhatárat a jelenlegi helyén, a házában',
        ['create_logout'] = 'Hozzon létre egy ágyat a jelenlegi helyén a házában',
        ['create_garage'] = 'Hozzon létre garázst a jelenlegi helyén a házában',
        ['create_door'] = 'Hozzon létre ajtót a jelenlegi helyén a házában',
        ['door_name'] = 'Az ajtó neve az ajtózár erőforráson belül (FONTOS)',
        ['give_keys'] = 'Adjon kulcsokat valaki másnak abban a házban, ahol éppen tartózkodik',
        ['target_keys'] = 'A cél állampolgára (kis- és nagybetűk megkülönböztetése) vagy a szerver azonosítója',
        ['remove_keys'] = 'Kulcsok eltávolítása valaki mástól abban a házban, ahol éppen tartózkodik',
        ['delete_house'] = 'Egy adott ház törlése',
        ['viewallhouses'] = 'Az összes ház megtekintése ezen a szerveren',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
