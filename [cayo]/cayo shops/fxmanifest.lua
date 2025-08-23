fx_version 'cerulean'
game 'gta5'

author 'ZenESX Framework'
description 'Cayo Perico Shops - Geschäfte und Banken auf Cayo Perico'
version '1.0.0'

this_is_a_map 'yes'

data_file 'DLC_ITYP_REQUEST' 'stream/ytyp/chodnik_01.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/ytyp/v_int_10.ytyp'

replace_level_meta 'h4_islandairstrip_12'
replace_level_meta 'h4_islandairstrip_hangar_props'
replace_level_meta 'h4_islandairstrip'
replace_level_meta 'h4_nw_ipl_01'

files {
    'stream/_manifest.ymf',
    'stream/ytyp/chodnik_01.ytyp',
    'stream/ytyp/v_int_10.ytyp',
    '-replace-/h4_islandairstrip_12.ybn',
    '-replace-/h4_islandairstrip_hangar_props.ymap',
    '-replace-/h4_islandairstrip.ymap',
    '-replace-/h4_nw_ipl_01.ymap'
}

lua54 'yes'
