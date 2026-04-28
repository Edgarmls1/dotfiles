# by discomanfulanito,
# for everyone — as code should be

# Sprites are drawn from here
POKEMON_LIST=(  
  "beedrill -m"              #015
  arbok                      #024
  ninetales                  #038
  "ninetales -s"           
  venonat                    #048
  venomoth                   #049
  persian                    #053
  psyduck                    #054
  golduck                    #055
  arcanine                   #059
  alakazam                   #065
  haunter                    #093 *
  gengar                     #094
  marowak                    #105
  "marowak -a"           
  snorlax                    #143
  ampharos                   #181
  espeon                     #196 *
  umbreon                    #197 *
  lugia                      #249
  ho-oh                      #250
  mudkip                     #258 *
  swampert                   #260 *
  poochyena                  #261 *
  ludicolo                   #272
  gardevoir                  #282
  ninjask                    #291
  shedinja                   #292
  sableye                    #302 *
  "camerupt -m"              #323
  flygon                     #330 *
  zangoose                   #335
  seviper                    #336
  lunatone                   #337
  solrock                    #338
  "banette -m"               #354 *
  absol                      #359 *
  regirock                   #377
  regice                     #378
  registeel                  #379
  kyogre                     #382
  groudon                    #383
  rayquaza                   #384 *
  deoxys                     #386
  bidoof                     #399
  luxray                     #405 *
  mismagius                  #429 *
  glasmeow                   #431
  spiritomb                  #442 *
  lucario                    #448 *
  gallade                    #475
  dusknoir                   #477
  uxie						 #480
  mesprit                    #481
  azelf                      #482
  dialga                     #483 *
  palkia                     #484 *
  regigigas                  #486
  giratina                   #487 *
  "giratina -f origin"            # *
  cresselia                  #488
  darkrai                    #491 *
  victini                    #494 *
  purrloin                   #509
  liepard                    #510
  sandile                    #551
  krokorok                   #552 *
  krookodile                 #553 *
  cofagrigus                 #563 *
  zoroark                    #571 *
  joltik                     #595
  galvantula                 #596 *
  chandelure                 #609
  haxorus                    #612
  "haxorus -s"     
  heatmor                    #631
  durant                     #632
  hydreigon                  #635
  volcarona                  #637
  cobalion                   #638
  terrakion                  #639
  virizion                   #640
  reshiram                   #643 *
  zekrom                     #644 *
  kyurem                     #646
  "kyurem -f black"               # *
  "kyurem -f white"               # *
  fennekin                   #653
  froakie                    #656
  pancham                    #674
  pangoro                    #675
  meowstic                   #678
  "meowstic --female"     
  phantump                   #708
  noivern                    #715 *
  xerneas                    #716
  "xerneas -s"     
  yveltal                    #717 *
  "yveltal -s"     
  zygarde                    #718
  "zygarde -s"     
  hoopa                      #720 *
  "hoopa -f unbound"              # *
  volcanion                  #721
  rowlet                     #722 *
  decidueye                  #724 *
  litten                     #725
  vikavolt                   #738
  lycanroc                   #745
  "lycanroc -f midnight"     
  "lycanroc -f dusk"         
  "wishiwashi -f school"     #746
  golsopod                   #768 *
  type-null                  #772 *
  silvally                   #773 *
  mimikyu                    #778 *
  "mimikyu -s"                    # *
  solgaleo                   #791
  lunala                     #792 *
  marshadow                  #802 *
  zeraora                    #807 *
  corviknight                #823 *
  "corviknight --gmax"
  nickit                     #827
  thievul                    #828
  toxtricity                 #849 *
  "toxtricity -f low-key"         # *
  dragapult                  #887
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
