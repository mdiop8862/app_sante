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
  if (sexe == 'Homme' && age >= 60) {
    if (distance < 524) return 1;
    if (distance < 562) return 2;
    if (distance < 600) return 3;
    if (distance < 638) return 4;
    return 5;
  }
  if (sexe == 'Femme' && age >= 60) {
    if (distance < 441) return 1;
    if (distance < 476) return 2;
    if (distance < 511) return 3;
    if (distance < 546) return 4;
    return 5;
  }

  return 0; // Cas non couvert
}

// Score Flexométre

int calculScore(String sexe, int age, int valeur) {
  sexe = sexe.toUpperCase();

  String tranche;
  if (age < 20) {
    tranche = "-19";
  } else if (age < 30) {
    tranche = "20-29";
  } else if (age < 40) {
    tranche = "30-39";
  } else if (age < 50) {
    tranche = "40-49";
  } else if (age < 60) {
    tranche = "50-59";
  } else {
    tranche = "60+";
  }

  Map<String, Map<String, List<List<int>>>> colorThresholds = {
    "-19": {
      "Femme": [
        [1, 22],
        [23, 31],
        [32, 39],
        [40, 47],
        [48, 50]
      ],
      "Homme": [
        [1, 20],
        [21, 30],
        [31, 39],
        [40, 48],
        [49, 50]
      ],
    },
    "20-29": {
      "Femme": [
        [1, 21],
        [22, 30],
        [31, 38],
        [39, 46],
        [47, 50]
      ],
      "Homme": [
        [1, 20],
        [21, 28],
        [29, 37],
        [38, 47],
        [48, 50]
      ],
    },
    "30-39": {
      "Femme": [
        [1, 21],
        [22, 30],
        [31, 38],
        [39, 46],
        [47, 50]
      ],
      "Homme": [
        [1, 18],
        [19, 27],
        [28, 36],
        [37, 45],
        [46, 50]
      ],
    },
    "40-49": {
      "Femme": [
        [1, 19],
        [20, 28],
        [29, 37],
        [38, 46],
        [47, 50]
      ],
      "Homme": [
        [1, 16],
        [17, 25],
        [26, 34],
        [35, 44],
        [45, 50]
      ],
    },
    "50-59": {
      "Femme": [
        [1, 20],
        [21, 28],
        [29, 36],
        [37, 45],
        [46, 50]
      ],
      "Homme": [
        [1, 13],
        [14, 23],
        [24, 32],
        [33, 41],
        [42, 50]
      ],
    },
    "60+": {
      "Femme": [
        [1, 18],
        [19, 26],
        [27, 35],
        [36, 43],
        [44, 50]
      ],
      "Homme": [
        [1, 11],
        [12, 21],
        [22, 30],
        [31, 40],
        [41, 50]
      ],
    },
  };

  var plages = colorThresholds[tranche]?[sexe];
  if (plages == null) {
    print("Tranche d'âge ou sexe non reconnu");
    return 0;
  }

  for (int i = 0; i < plages.length; i++) {
    if (valeur >= plages[i][0] && valeur <= plages[i][1]) {
      return i + 1;
    }
  }

  return 0;
}

// Score test assis-debout

int calculerScoreTestAssisDebout({
  required int age,
  required String sexe,
  required int repetitions,
}) {
  if (repetitions <= 0) return 0;
  repetitions = repetitions.clamp(0, 40);
  sexe = sexe.toUpperCase();

  if (sexe == 'Homme' && age >= 20 && age <= 29) {
    if (repetitions <= 19) return 1;
    if (repetitions <= 25) return 2;
    if (repetitions <= 30) return 3;
    if (repetitions <= 33) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'Femme' && age >= 20 && age <= 29) {
    if (repetitions <= 20) return 1;
    if (repetitions <= 27) return 2;
    if (repetitions <= 31) return 3;
    if (repetitions <= 34) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'Homme' && age >= 30 && age <= 39) {
    if (repetitions <= 21) return 1;
    if (repetitions <= 31) return 2;
    if (repetitions <= 33) return 3;
    if (repetitions <= 34) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'Femme' && age >= 30 && age <= 39) {
    if (repetitions <= 18) return 1;
    if (repetitions <= 20) return 2;
    if (repetitions <= 22) return 3;
    if (repetitions <= 28) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'Homme' && age >= 40 && age <= 49) {
    if (repetitions <= 18) return 1;
    if (repetitions <= 19) return 2;
    if (repetitions <= 20) return 3;
    if (repetitions <= 24) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'Femme' && age >= 40 && age <= 49) {
    if (repetitions <= 15) return 1;
    if (repetitions <= 18) return 2;
    if (repetitions <= 22) return 3;
    if (repetitions <= 26) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'Homme' && age >= 50 && age <= 59) {
    if (repetitions <= 13) return 1;
    if (repetitions <= 15) return 2;
    if (repetitions <= 18) return 3;
    if (repetitions <= 20) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'Femme' && age >= 50 && age <= 59) {
    if (repetitions <= 11) return 1;
    if (repetitions <= 13) return 2;
    if (repetitions <= 17) return 3;
    if (repetitions <= 18) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'Homme' && age >= 60) {
    if (repetitions <= 12) return 1;
    if (repetitions <= 14) return 2;
    if (repetitions <= 16) return 3;
    if (repetitions <= 18) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'Femme' && age >= 60) {
    if (repetitions <= 10) return 1;
    if (repetitions <= 12) return 2;
    if (repetitions <= 14) return 3;
    if (repetitions <= 16) return 4;
    if (repetitions <= 40) return 5;
  }

  return 0;
}

// score test de la chaise
int calculerScoreTestChaise(int dureeEnSecondes) {
  if (dureeEnSecondes < 0) return 0;
  if (dureeEnSecondes < 30) return 1;
  if (dureeEnSecondes < 45) return 2;
  if (dureeEnSecondes < 90) return 3;
  if (dureeEnSecondes < 180) return 4;
  if (dureeEnSecondes <= 270) return 5;
  return 0;
}
