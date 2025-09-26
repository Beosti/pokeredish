; home/ability_helpers.asm

SECTION "Ability Helpers", ROM0
; A = species id -> A = ability id
GetSpeciesAbility::
  ; If you didn’t pad index 0 in the table:
  dec a                      ; 1..151 → 0..150
  ; (remove this if you padded index 0)

  ld e, a
  ld d, 0
  ld hl, MonAbilities
  add hl, de

  ; save current bank
  ldh a, [hLoadedROMBank]
  ld c, a

  ; switch to table’s bank and read
  ld b, BANK(MonAbilities)
  call Bankswitch
  ld a, [hl]
  ; restore bank
  ld b, c
  call Bankswitch
  ret

GetActiveMonAbility::
  ldh a, [hWhoseTurn]
  and a
  jr z, .player
  ld a, [wEnemyMonSpecies]
  jr .got
.player
  ld a, [wBattleMonSpecies]
.got
  jp GetSpeciesAbility



HasAbility_LEVITATE::
  cp ABILITY_LEVITATE ; compare a with constant; sets z if equal
  ret                 ; return with z = 1 if a == ability_levitate, else z = 0

