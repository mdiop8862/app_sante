// test de marche 6mn
int calculScoreMarche6Min({
  required String sexe,
  required int age,
  required int distance,
}) {
  if (sexe == 'Homme' && age >= 20 && age <= 29) {
    if (distance < 725) return 1;
    if (distance < 763) return 2;
    if (distance < 801) return 3;
    if (distance < 839) return 4;
    return 5;
  }
  if (sexe == 'Femme' && age >= 20 && age <= 29) {
    if (distance < 672) return 1;
    if (distance < 707) return 2;
    if (distance < 742) return 3;
    if (distance < 777) return 4;
    return 5;
  }
  if (sexe == 'Homme' && age >= 30 && age <= 39) {
    if (distance < 675) return 1;
    if (distance < 713) return 2;
    if (distance < 751) return 3;
    if (distance < 789) return 4;
    return 5;
  }
  if (sexe == 'Femme' && age >= 30 && age <= 39) {
    if (distance < 614) return 1;
    if (distance < 649) return 2;
    if (distance < 684) return 3;
    if (distance < 719) return 4;
    return 5;
  }
  if (sexe == 'Homme' && age >= 40 && age <= 49) {
    if (distance < 585) return 1;
    if (distance < 624) return 2;
    if (distance < 662) return 3;
    if (distance < 700) return 4;
    return 5;
  }
  if (sexe == 'Femme' && age >= 40 && age <= 49) {
    if (distance < 556) return 1;
    if (distance < 591) return 2;
    if (distance < 626) return 3;
    if (distance < 661) return 4;
    return 5;
  }
  if (sexe == 'Homme' && age >= 50 && age <= 59) {
    if (distance < 575) return 1;
    if (distance < 613) return 2;
    if (distance < 651) return 3;
    if (distance < 689) return 4;
    return 5;
  }
  if (sexe == 'Femme' && age >= 50 && age <= 59) {
    if (distance < 498) return 1;
    if (distance < 533) return 2;
    if (distance < 568) return 3;
    if (distance < 603) return 4;
    return 5;
  }
  if (sexe == 'Homme' && age >= 60 ) {
    if (distance < 524) return 1;
    if (distance < 562) return 2;
    if (distance < 600) return 3;
    if (distance < 638) return 4;
    return 5;
  }
  if (sexe == 'Femme' && age >= 60 ) {
    if (distance < 441) return 1;
    if (distance < 476) return 2;
    if (distance < 511) return 3;
    if (distance < 546) return 4;
    return 5;
  }

  return 0; // Cas non couvert
}

