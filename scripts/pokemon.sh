# by discomanfulanito,
# for everyone — as code should be

# Sprites are drawn from here
POKEMON_LIST=(
	unown
	"unown -f g"
	"unown -f y"
	"015 -m"          #   mega beedrill
	024               #   arbok
	038               #   ninetales
	"038 -s"          #   ninetales shiny
	048               #   venonat
	049               #   venomoth
	053               #   persian
	054               #   psyduck
	055               #   golduck
	059               #   arcanine
	065               #   alakazam
	093               # * haunter
	094               #   gengar
	105               #   marowak
	"105 -a"          #   alolan marowak
	143               #   snorlax
	181               #   ampharos
	196               # * espeon
	197               # * umbreon
	249               #   lugia
	250               #   ho-oh
	258               # * mudkip
	260               # * swampert
	261               # * poochyena
	272               #   ludicolo
	282               #   gardevoir
	291               #   ninjask
	292               #   shedinja
	302               # * sableye
	"323 -m"          #   mega camerupt
	330               # * flygon
	335               #   zangoose
	336               #   seviper
	337               #   lunatone
	338               #   solrock
	"354 -m"          # * mega benette
	359               # * absol
	377               #   regirock
	378               #   regice
	379               #   registeel
	382               #   kyogre
	383               #   groudon
	384               # * rayquaza
	386               #   deoxys
	399               #   bidoof
	405               # * luxray
	429               # * mismagius
	431               #   glasmeow
	442               # * spiritomb
	448               # * lucario
	475               #   gallade
	477               #   dusknoir
	479               #   rotom
	"479 -s"          #   rotom shiny
	480               #   uxie
	481               #   mesprit
	482               #   azelf
	483               # * dialga
	484               # * palkia
	486               #   regigigas
	487               # * giratina
	"487 -f origin"   # * origin giratina
	488               #   cresselia
	491               # * darkrai
	494               # * victini
	509               #   purrloin
	510               #   liepard
	551               #   sandile
	552               # * krokorok
	553               # * krookodile
	563               # * cofagrigus
	571               # * zoroark
	595               #   joltik
	596               # * galvantula
	609               #   chandelure
	612               #   haxorus
	"612 -s"          #   haxorus shiny
	631               #   heatmor
	632               #   durant
	635               #   hydreigon
	637               #   volcarona
	638               #   cobalion
	639               #   terrakion
	640               #   virizion
	643               # * reshiram
	644               # * zekrom
	646               #   kyurem
	"646 -f black"    # * black kyurem
	"646 -f white"    # * white kyurem
	653               #   fennekin
	656               #   froakie
	674               #   pancham
	675               #   pangoro
	678               #   meowstic
	"678 --female"    #   meowstic femele
	708               #   phantump
	715               # * noivern
	716               #   xerneas
	"716 -s"          #   xerneas shiny
	717               # * yveltal
	"717 -s"          # * yveltal shiny
	718               #   zygarde
	"718 -s"          #   zygarde shiny
	720               # * hoopa
	"720 -f unbound"  # * hoopa unbound
	721               #   volcanion
	722               # * rowlet
	724               # * decidueye
	725               #   litten
	738               #   vikavolt
	745               #   lycanroc
	"745 -f midnight" #   midnight lycanroc
	"745 -f dusk"     #   dusk lycanroc
	"746 -f school"   #   wishiwashi
	768               # * golsopod
	772               # * type-null
	773               # * silvally
	778               # * mimikyu
	"778 -s"          # * mimikyu shiny
	791               #   solgaleo
	792               # * lunala
	802               # * marshadow
	807               # * zeraora
	823               # * corviknight
	827               #   nickit
	828               #   thievul
	849               # * toxtricity
	"849 -f low-key"  # * toxtricity
	887
)

# Change with your fetcher
FETCHER="fastfetch --logo none"

FETCHER_HEIGHT=$($FETCHER | wc -l)

# Extra settings
EXTRA_PADDING_H=2
EXTRA_PADDING_W=0

# Room for the sprite
WIDTH=38

# Gets a sprite via pokeget
sprite=$(pokeget ${POKEMON_LIST[RANDOM % ${#POKEMON_LIST[@]}]} --hide-name)

# Gets sprite's height
height=$(echo "$sprite" | wc -l)

# Pad for vertical centering
pad_top=$((($FETCHER_HEIGHT - $height) / 2))
pad_top=$((pad_top + EXTRA_PADDING_H))

# Just for safety
(( pad_top < 0 )) && pad_top=0

# Gets sprite's sprite_width
# strip ANSI color codes with sed to get the true printed width
sprite_width=$(
  printf '%s\n' "$sprite" \
  | sed 's/\x1b\[[0-9;]*m//g' \
  | awk '{ if (length > max) max = length } END { print max }'
)

# Calculate the lateral padding
pad_Left=$((($WIDTH - sprite_width) / 2))
# +1 to avoid odd-width rounding issues so logo area remains visually centered
pad_Right=$((($WIDTH - sprite_width + 2) / 2))

pad_Left=$((pad_Left + EXTRA_PADDING_W))
pad_Right=$((pad_Right + EXTRA_PADDING_W))

# Just for safety
(( pad_Left < 0 )) && pad_Left=0
(( pad_Right < 0 )) && pad_Right=0

# this may not work for your fetcher, check them all
echo "$sprite" | $FETCHER --file-raw - --logo-padding-top $pad_top --logo-padding-left $pad_Left --logo-padding-right $pad_Right
