// test de marche 6mn
int calculScoreMarche6Min({
  required String sexe,
  required int age,
  required int distance,
}) {
  final s = sexe.toLowerCase();
  if (sexe == 'homme' && age >= 20 && age <= 29) {
    if (distance < 725) return 1;
    if (distance < 763) return 2;
    if (distance < 801) return 3;
    if (distance < 839) return 4;
    return 5;
  }
  if (sexe == 'femme' && age >= 20 && age <= 29) {
    if (distance < 672) return 1;
    if (distance < 707) return 2;
    if (distance < 742) return 3;
    if (distance < 777) return 4;
    return 5;
  }
  if (sexe == 'homme' && age >= 30 && age <= 39) {
    if (distance < 675) return 1;
    if (distance < 713) return 2;
    if (distance < 751) return 3;
    if (distance < 789) return 4;
    return 5;
  }
  if (sexe == 'femme' && age >= 30 && age <= 39) {
    if (distance < 614) return 1;
    if (distance < 649) return 2;
    if (distance < 684) return 3;
    if (distance < 719) return 4;
    return 5;
  }
  if (sexe == 'homme' && age >= 40 && age <= 49) {
    if (distance < 585) return 1;
    if (distance < 624) return 2;
    if (distance < 662) return 3;
    if (distance < 700) return 4;
    return 5;
  }
  if (sexe == 'femme' && age >= 40 && age <= 49) {
    if (distance < 556) return 1;
    if (distance < 591) return 2;
    if (distance < 626) return 3;
    if (distance < 661) return 4;
    return 5;
  }
  if (sexe == 'homme' && age >= 50 && age <= 59) {
    if (distance < 575) return 1;
    if (distance < 613) return 2;
    if (distance < 651) return 3;
    if (distance < 689) return 4;
    return 5;
  }
  if (sexe == 'femme' && age >= 50 && age <= 59) {
    if (distance < 498) return 1;
    if (distance < 533) return 2;
    if (distance < 568) return 3;
    if (distance < 603) return 4;
    return 5;
  }
  if (sexe == 'homme' && age >= 60) {
    if (distance < 524) return 1;
    if (distance < 562) return 2;
    if (distance < 600) return 3;
    if (distance < 638) return 4;
    return 5;
  }
  if (sexe == 'femme' && age >= 60) {
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
  final s = sexe.toLowerCase();
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
      "femme": [
        [1, 22],
        [23, 31],
        [32, 39],
        [40, 47],
        [48, 50]
      ],
      "homme": [
        [1, 20],
        [21, 30],
        [31, 39],
        [40, 48],
        [49, 50]
      ],
    },
    "20-29": {
      "femme": [
        [1, 21],
        [22, 30],
        [31, 38],
        [39, 46],
        [47, 50]
      ],
      "homme": [
        [1, 20],
        [21, 28],
        [29, 37],
        [38, 47],
        [48, 50]
      ],
    },
    "30-39": {
      "femme": [
        [1, 21],
        [22, 30],
        [31, 38],
        [39, 46],
        [47, 50]
      ],
      "homme": [
        [1, 18],
        [19, 27],
        [28, 36],
        [37, 45],
        [46, 50]
      ],
    },
    "40-49": {
      "femme": [
        [1, 19],
        [20, 28],
        [29, 37],
        [38, 46],
        [47, 50]
      ],
      "homme": [
        [1, 16],
        [17, 25],
        [26, 34],
        [35, 44],
        [45, 50]
      ],
    },
    "50-59": {
      "femme": [
        [1, 20],
        [21, 28],
        [29, 36],
        [37, 45],
        [46, 50]
      ],
      "homme": [
        [1, 13],
        [14, 23],
        [24, 32],
        [33, 41],
        [42, 50]
      ],
    },
    "60+": {
      "femme": [
        [1, 18],
        [19, 26],
        [27, 35],
        [36, 43],
        [44, 50]
      ],
      "homme": [
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
  final s = sexe.toLowerCase();

  if (repetitions <= 0 || repetitions > 40) return 0;
  if (sexe == 'homme' && age >= 20 && age <= 29) {
    if (repetitions <= 19) return 1;
    if (repetitions <= 25) return 2;
    if (repetitions <= 30) return 3;
    if (repetitions <= 33) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'femme' && age >= 20 && age <= 29) {
    if (repetitions <= 20) return 1;
    if (repetitions <= 27) return 2;
    if (repetitions <= 31) return 3;
    if (repetitions <= 34) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'homme' && age >= 30 && age <= 39) {
    if (repetitions <= 21) return 1;
    if (repetitions <= 31) return 2;
    if (repetitions <= 33) return 3;
    if (repetitions <= 34) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'femme' && age >= 30 && age <= 39) {
    if (repetitions <= 18) return 1;
    if (repetitions <= 20) return 2;
    if (repetitions <= 22) return 3;
    if (repetitions <= 28) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'homme' && age >= 40 && age <= 49) {
    if (repetitions <= 18) return 1;
    if (repetitions <= 19) return 2;
    if (repetitions <= 20) return 3;
    if (repetitions <= 24) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'femme' && age >= 40 && age <= 49) {
    if (repetitions <= 15) return 1;
    if (repetitions <= 18) return 2;
    if (repetitions <= 22) return 3;
    if (repetitions <= 26) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'homme' && age >= 50 && age <= 59) {
    if (repetitions <= 13) return 1;
    if (repetitions <= 15) return 2;
    if (repetitions <= 18) return 3;
    if (repetitions <= 20) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'femme' && age >= 50 && age <= 59) {
    if (repetitions <= 11) return 1;
    if (repetitions <= 13) return 2;
    if (repetitions <= 17) return 3;
    if (repetitions <= 18) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'homme' && age >= 60) {
    if (repetitions <= 12) return 1;
    if (repetitions <= 14) return 2;
    if (repetitions <= 16) return 3;
    if (repetitions <= 18) return 4;
    if (repetitions <= 40) return 5;
  }
  if (sexe == 'femme' && age >= 60) {
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

int calculScoreMonteeMarche({
  required String sexe,
  required int age,
  required int bpm,
}) {
  final s = sexe.toLowerCase();
  if (sexe == 'homme' && age <= 25) {
    if (bpm >= 108) return 1;
    if (bpm >= 101) return 2;
    if (bpm >= 94) return 3;
    if (bpm >= 85) return 4;
    return 5;
  }

  if (sexe == 'femme' && age <= 25) {
    if (bpm > 120) return 1;
    if (bpm > 110) return 2;
    if (bpm > 102) return 3;
    if (bpm > 93) return 4;
    return 5;
  }

  if (sexe == 'homme' && age <= 35) {
    if (bpm > 110) return 1;
    if (bpm > 102) return 2;
    if (bpm > 94) return 3;
    if (bpm > 85) return 4;
    return 5;
  }

  if (sexe == 'femme' && age <= 35) {
    if (bpm > 120) return 1;
    if (bpm > 110) return 2;
    if (bpm > 101) return 3;
    if (bpm > 92) return 4;
    return 5;
  }

  if (sexe == 'homme' && age <= 45) {
    if (bpm > 113) return 1;
    if (bpm > 104) return 2;
    if (bpm > 98) return 3;
    if (bpm > 88) return 4;
    return 5;
  }

  if (sexe == 'femme' && age <= 45) {
    if (bpm > 120) return 1;
    if (bpm > 112) return 2;
    if (bpm > 104) return 3;
    if (bpm > 96) return 4; //
    return 5;
  }

  if (sexe == 'homme' && age <= 55) {
    if (bpm > 119) return 1;
    if (bpm > 111) return 2;
    if (bpm > 101) return 3;
    if (bpm > 93) return 4; //
    return 5;
  }

  if (sexe == 'femme' && age <= 55) {
    if (bpm > 124) return 1;
    if (bpm > 118) return 2;
    if (bpm > 110) return 3;
    if (bpm > 101) return 4;
    return 5;
  }

  if (sexe == 'homme' && age <= 65) {
    if (bpm > 117) return 1;
    if (bpm > 109) return 2;
    if (bpm > 100) return 3;
    if (bpm > 94) return 4;
    return 5;
  }

  if (sexe == 'femme' && age <= 65) {
    if (bpm > 127) return 1;
    if (bpm > 118) return 2;
    if (bpm > 111) return 3;
    if (bpm > 103) return 4;
    return 5;
  }

  return 0; // Valeurs incorrectes ou incomplètes
}

String scoreMainPied(int niveau) {
  const positions = {
    1: 'Les mains sur les cuisses',
    2: 'Les mains sur les genoux',
    3: 'Les mains sur les tibias',
    4: 'Les mains sur les chevilles',
    5: 'La paume de la main touche le sol',
  };

  return positions[niveau] ?? 'Niveau invalide';
}

String scoreEpaule(int niveau) {
  const positions = {
    1: "Je ne parviens pas à mettre deux mains dans le dos",
    2: "Mes deux mains dans le dos ne se touchent pas",
    3: "Les bouts des doigts se touchent",
    4: "Les doigts s'agrippent",
    5: "Les mains parviennent à se superposer",
  };

  return positions[niveau] ?? "Niveauinvalide";
}

int calculerScoreTestFlamand({
  required int age,
  required String sexe,
  required int secondes,
}) {
  final s = sexe.toLowerCase();
  if (age <= 30) {
    if (sexe == 'homme') {
      if (secondes < 17) return 1;
      if (secondes < 21) return 2;
      if (secondes < 25) return 3;
      if (secondes < 29) return 4;
      return 5;
    } else if (sexe == 'femme') {
      if (secondes < 14) return 1;
      if (secondes < 18) return 2;
      if (secondes < 22) return 3;
      if (secondes < 26) return 4;
      return 5;
    }
  } else if (age >= 31 && age <= 39) {
    if (sexe == 'homme') {
      if (secondes < 14) return 1;
      if (secondes < 17) return 2;
      if (secondes < 22) return 3;
      if (secondes < 26) return 4;
      return 5;
    } else if (sexe == 'femme') {
      if (secondes < 10) return 1;
      if (secondes < 14) return 2;
      if (secondes < 18) return 3;
      if (secondes < 23) return 4;
      return 5;
    }
  } else if (age >= 40 && age <= 49) {
    if (sexe == 'homme') {
      if (secondes < 10) return 1;
      if (secondes < 14) return 2;
      if (secondes < 18) return 3;
      if (secondes < 23) return 4;
      return 5;
    } else if (sexe == 'femme') {
      if (secondes < 9) return 1;
      if (secondes < 13) return 2;
      if (secondes < 16) return 3;
      if (secondes < 20) return 4;
      return 5;
    }
  } else if (age >= 50 && age <= 59) {
    if (sexe == 'homme') {
      if (secondes < 9) return 1;
      if (secondes < 13) return 2;
      if (secondes < 16) return 3;
      if (secondes < 20) return 4;
      return 5;
    } else if (sexe == 'femme') {
      if (secondes < 6) return 1;
      if (secondes < 10) return 2;
      if (secondes < 14) return 3;
      if (secondes < 18) return 4;
      return 5;
    }
  } else if (age >= 60) {
    if (sexe == 'homme') {
      if (secondes < 6) return 1;
      if (secondes < 10) return 2;
      if (secondes < 14) return 3;
      if (secondes < 17) return 4;
      return 5;
    } else if (sexe == 'femme') {
      if (secondes < 6) return 1;
      if (secondes < 9) return 2;
      if (secondes < 12) return 3;
      if (secondes < 14) return 4;
      return 5;
    }
  }

  // Par défaut si hors barème connu
  return 0;
}

int imcScore(double imc) {
  if (imc < 18.5) return 1;
  if (imc < 25) return 5; // Normal
  if (imc < 30) return 4; // Surpoids léger
  if (imc < 35) return 3; // Obésité modérée
  if (imc < 40) return 2; // Obésité sévère
  return 1; // Obésité morbide
}

// Score test handgrip
int calculerScoreTestHandgrip({
  required int age,
  required String sexe,
  required int forcemax,
}) {
  final s = sexe.toLowerCase();
  if (forcemax < 45 || forcemax > 125) return 0;

  if (s == 'homme') {
    if (age >= 15 && age <= 19) {
      if (forcemax <= 83) return 1;
      if (forcemax <= 94) return 2;
      if (forcemax <= 103) return 3;
      if (forcemax <= 112) return 4;
      return 5;
    }
    if (age >= 20 && age <= 29) {
      if (forcemax <= 96) return 1;
      if (forcemax <= 105) return 2;
      if (forcemax <= 112) return 3;
      if (forcemax <= 123) return 4;
      return 5;
    }
    if (age >= 30 && age <= 39) {
      if (forcemax <= 96) return 1;
      if (forcemax <= 104) return 2;
      if (forcemax <= 112) return 3;
      if (forcemax <= 122) return 4;
      return 5;
    }
    if (age >= 40 && age <= 49) {
      if (forcemax <= 93) return 1;
      if (forcemax <= 101) return 2;
      if (forcemax <= 109) return 3;
      if (forcemax <= 118) return 4;
      return 5;
    }
    if (age >= 50 && age <= 59) {
      if (forcemax <= 86) return 1;
      if (forcemax <= 95) return 2;
      if (forcemax <= 101) return 3;
      if (forcemax <= 109) return 4;
      return 5;
    }
    if (age >= 60) {
      if (forcemax <= 78) return 1;
      if (forcemax <= 85) return 2;
      if (forcemax <= 92) return 3;
      if (forcemax <= 101) return 4;
      return 5;
    }
  }

  if (s == 'femme') {
    if (age >= 15 && age <= 19) {
      if (forcemax <= 53) return 1;
      if (forcemax <= 58) return 2;
      if (forcemax <= 63) return 3;
      if (forcemax <= 70) return 4;
      return 5;
    }
    if (age >= 20 && age <= 29) {
      if (forcemax <= 54) return 1;
      if (forcemax <= 60) return 2;
      if (forcemax <= 64) return 3;
      if (forcemax <= 70) return 4;
      return 5;
    }
    if (age >= 30 && age <= 39) {
      if (forcemax <= 56) return 1;
      if (forcemax <= 60) return 2;
      if (forcemax <= 65) return 3;
      if (forcemax <= 72) return 4;
      return 5;
    }
    if (age >= 40 && age <= 49) {
      if (forcemax <= 54) return 1;
      if (forcemax <= 58) return 2;
      if (forcemax <= 64) return 3;
      if (forcemax <= 77) return 4;
      return 5;
    }
    if (age >= 50 && age <= 59) {
      if (forcemax <= 50) return 1;
      if (forcemax <= 54) return 2;
      if (forcemax <= 58) return 3;
      if (forcemax <= 64) return 4;
      return 5;
    }
    if (age >= 60) {
      if (forcemax <= 47) return 1;
      if (forcemax <= 50) return 2;
      if (forcemax <= 53) return 3;
      if (forcemax <= 59) return 4;
      return 5;
    }
  }

  return 0;
}
