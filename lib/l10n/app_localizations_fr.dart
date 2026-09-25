// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get languageName => 'Français';

  @override
  String get appTitle => 'NHimmo';

  @override
  String lineRent(String month) {
    return 'Loyer $month';
  }

  @override
  String lineProrata(String days, String total) {
    return '$days/$total jours';
  }

  @override
  String lineIndex(String from, String to) {
    return 'Index $from à $to';
  }

  @override
  String lineConsumption(String qty, String unit, String price) {
    return '$qty $unit × $price';
  }

  @override
  String lineMaintenance(String amount) {
    return 'Entretien compteur $amount';
  }

  @override
  String lineVat(String rate, String mode) {
    return 'TVA $rate % ($mode)';
  }

  @override
  String get vatIncludedShort => 'incluse';

  @override
  String get vatAddedShort => 'en sus';

  @override
  String lineServiceIncluded(
    String qty,
    String unit,
    String included,
    String billed,
  ) {
    return '$qty $unit(s), $included inclus, $billed facturé(s)';
  }

  @override
  String lineServiceQty(String qty, String unit) {
    return '$qty $unit(s)';
  }

  @override
  String get lineDamages => 'Dégâts constatés (état des lieux de sortie)';

  @override
  String lineCredit(String days) {
    return 'Déduction loyer et services – $days jour(s) non occupé(s)';
  }

  @override
  String lineBenefit(String name) {
    return 'Avantage $name';
  }

  @override
  String get benefitFull => 'Exonération totale';

  @override
  String benefitPercent(String value) {
    return 'Réduction de $value %';
  }

  @override
  String benefitUnits(String value, String unit) {
    return '$value $unit gratuits par mois';
  }

  @override
  String benefitAmount(String amount) {
    return '$amount déduits par mois';
  }

  @override
  String get benefitModePercent => 'Réduction en %';

  @override
  String get benefitModeUnits => 'Unités gratuites / mois';

  @override
  String get benefitModeAmount => 'Montant fixe déduit / mois';

  @override
  String get vatNone => 'Pas de TVA';

  @override
  String get vatIncluded => 'TVA incluse dans le prix';

  @override
  String get vatAdded => 'TVA en sus';

  @override
  String get roomLiving => 'Salon';

  @override
  String get roomDining => 'Salle à manger';

  @override
  String get roomKitchen => 'Cuisine';

  @override
  String get roomBedroom => 'Chambre';

  @override
  String roomBedroomN(String n) {
    return 'Chambre $n';
  }

  @override
  String get roomBathroom => 'Salle de bain';

  @override
  String get roomToilet => 'WC';

  @override
  String get roomHallway => 'Couloir';

  @override
  String get roomBalcony => 'Balcon';

  @override
  String get roomTerrace => 'Terrasse';

  @override
  String get roomGarage => 'Garage';

  @override
  String get roomOutside => 'Extérieur';

  @override
  String get condNew => 'Neuf';

  @override
  String get condGood => 'Bon';

  @override
  String get condWorn => 'Usé';

  @override
  String get condDamaged => 'Dégradé';

  @override
  String get condBroken => 'Hors service';

  @override
  String get methodCash => 'Espèces';

  @override
  String get methodMobile => 'Mobile Money';

  @override
  String get methodTransfer => 'Virement';

  @override
  String get methodCheque => 'Chèque';

  @override
  String get methodOther => 'Autre';

  @override
  String get methodDeposit => 'Caution';

  @override
  String get payStatusPaid => 'Payée';

  @override
  String get payStatusPartial => 'Partielle';

  @override
  String get payStatusUnpaid => 'Impayée';

  @override
  String warnMissingReading(String place, String meter) {
    return '$place : relevé $meter manquant';
  }

  @override
  String warnIndexLower(String place, String meter) {
    return '$place : index $meter inférieur au précédent';
  }

  @override
  String warnExitIndexMissing(String meter) {
    return 'Index de sortie $meter non saisi';
  }

  @override
  String warnExitIndexLower(String meter) {
    return 'Index $meter inférieur au dernier index facturé';
  }

  @override
  String get docInvoice => 'Facture';

  @override
  String get docReceipt => 'Quittance';

  @override
  String get docExit => 'Décompte de sortie';

  @override
  String errorWith(String error) {
    return 'Erreur : $error';
  }

  @override
  String get requiredField => 'Champ obligatoire';

  @override
  String get amountRequired => 'Montant obligatoire';

  @override
  String get amountInvalid => 'Montant invalide';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get add => 'Ajouter';

  @override
  String get close => 'Fermer';

  @override
  String get validate => 'Valider';

  @override
  String get newItem => 'Nouveau';

  @override
  String get notes => 'Notes';

  @override
  String get note => 'Note';

  @override
  String get phone => 'Téléphone';

  @override
  String get email => 'E-mail';

  @override
  String get address => 'Adresse';

  @override
  String get navHome => 'Accueil';

  @override
  String get navProperties => 'Biens';

  @override
  String get navRentals => 'Locations';

  @override
  String get navReadings => 'Relevés';

  @override
  String get navFinance => 'Finances';

  @override
  String get language => 'Langue';

  @override
  String get appLanguage => 'Langue de l\'application';

  @override
  String get systemLanguage => 'Langue du téléphone';

  @override
  String get documentLanguage => 'Langue des documents';

  @override
  String get documentLanguageHelp =>
      'Factures, quittances et décompte de ce locataire seront produits dans cette langue.';

  @override
  String sameAsApp(String lang) {
    return 'Comme l\'application ($lang)';
  }

  @override
  String get hello => 'Bonjour 👋';

  @override
  String get scanDocument => 'Scanner un document';

  @override
  String get settings => 'Paramètres';

  @override
  String get collectedThisMonth => 'Encaissé ce mois';

  @override
  String forBilledIn(String amount, String month) {
    return 'pour $amount facturés en $month';
  }

  @override
  String get actionRead => 'Relever';

  @override
  String get actionCollect => 'Encaisser';

  @override
  String get actionScan => 'Scanner';

  @override
  String get actionExport => 'Exporter';

  @override
  String get occupancy => 'Occupation';

  @override
  String apartmentsCount(String occupied, String total) {
    return '$occupied / $total appartements';
  }

  @override
  String get unpaid => 'Impayés';

  @override
  String lateInvoices(String count) {
    return '$count facture(s) en retard';
  }

  @override
  String get noDelay => 'Aucun retard';

  @override
  String get readingsOfMonth => 'Relevés du mois';

  @override
  String get done => 'Terminé';

  @override
  String get toComplete => 'À compléter';

  @override
  String get lastBilling => 'Dernière facturation';

  @override
  String get billedVsCollected => 'Facturé vs encaissé';

  @override
  String get billed => 'Facturé';

  @override
  String get collected => 'Encaissé';

  @override
  String consumptionOf(String month) {
    return 'Consommations · $month';
  }

  @override
  String get balancesToRecover => 'Soldes à recouvrer';

  @override
  String get endContractFirst => 'Terminez d\'abord le contrat en cours.';

  @override
  String get reactivateQ => 'Réactiver ?';

  @override
  String get archiveQ => 'Archiver ?';

  @override
  String get aptWillReappear =>
      'L\'appartement réapparaîtra dans les listes et relevés.';

  @override
  String get aptWillDisappear =>
      'L\'appartement n\'apparaîtra plus dans les listes et relevés.';

  @override
  String get reactivate => 'Réactiver';

  @override
  String get archive => 'Archiver';

  @override
  String get rent => 'Loyer';

  @override
  String get deposit => 'Caution';

  @override
  String sinceDate(String date) {
    return 'Depuis le $date';
  }

  @override
  String get aptFree => 'Appartement libre';

  @override
  String get rentOut => 'Louer';

  @override
  String get meters => 'Compteurs';

  @override
  String get noMeters =>
      'Aucun compteur. Ajoutez-en pour facturer les consommations.';

  @override
  String get serialUnknown => 'N° non renseigné';

  @override
  String serialNo(String serial) {
    return 'N° $serial';
  }

  @override
  String get initialIndex => 'Index initial';

  @override
  String readOn(String date) {
    return 'relevé $date';
  }

  @override
  String get consumption => 'Consommation';

  @override
  String get leaseHistory => 'Historique des locations';

  @override
  String get ongoing => 'en cours';

  @override
  String get buildings => 'Immeubles';

  @override
  String get monthlyRents => 'Loyers mensuels';

  @override
  String billedYear(String year) {
    return 'Facturé $year';
  }

  @override
  String collectedYear(String year) {
    return 'Encaissé $year';
  }

  @override
  String unpaidAmount(String amount) {
    return 'Impayés : $amount';
  }

  @override
  String get apartments => 'Appartements';

  @override
  String get owners => 'Propriétaires';

  @override
  String get noApartment => 'Aucun appartement';

  @override
  String get noApartmentHelp =>
      'Commencez par créer un propriétaire, puis un immeuble, puis ses appartements.';

  @override
  String get pillApartments => 'appartements';

  @override
  String get pillOccupied => 'occupés';

  @override
  String get pillFree => 'libres';

  @override
  String floorN(String floor) {
    return 'Étage $floor';
  }

  @override
  String get free => 'Libre';

  @override
  String get perMonth => '/ mois';

  @override
  String get noBuilding => 'Aucun immeuble';

  @override
  String get noBuildingHelp =>
      'Un immeuble regroupe les appartements d\'un propriétaire.';

  @override
  String get addressUnknown => 'Adresse non renseignée';

  @override
  String ownerIs(String name) {
    return 'Propriétaire : $name';
  }

  @override
  String occupiedRatio(String occupied, String total) {
    return '$occupied/$total occupés';
  }

  @override
  String get noOwner => 'Aucun propriétaire';

  @override
  String get noOwnerHelp => 'Ajoutez le ou les propriétaires des biens gérés.';

  @override
  String aptCount(String count) {
    return '$count appt(s)';
  }

  @override
  String get newOwner => 'Nouveau propriétaire';

  @override
  String get editOwner => 'Modifier le propriétaire';

  @override
  String get ownerHasBuildings => 'Ce propriétaire possède des immeubles.';

  @override
  String get deleteQ => 'Supprimer ?';

  @override
  String get fullName => 'Nom complet';

  @override
  String get newBuilding => 'Nouvel immeuble';

  @override
  String get editBuilding => 'Modifier l\'immeuble';

  @override
  String get createOwnerFirst =>
      'Créez d\'abord le propriétaire de l\'immeuble.';

  @override
  String get createOwner => 'Créer un propriétaire';

  @override
  String get buildingHasApts => 'Cet immeuble contient des appartements.';

  @override
  String get ownerRequired => 'Propriétaire *';

  @override
  String get chooseOwner => 'Choisissez un propriétaire';

  @override
  String get buildingName => 'Nom de l\'immeuble';

  @override
  String get buildingNameHint => 'ex. Résidence Les Palmiers';

  @override
  String get newApartment => 'Nouvel appartement';

  @override
  String get editApartment => 'Modifier l\'appartement';

  @override
  String get aptNeedsBuilding =>
      'Un appartement appartient à un immeuble. Créez-en un d\'abord.';

  @override
  String get createBuilding => 'Créer un immeuble';

  @override
  String get buildingRequired => 'Immeuble *';

  @override
  String get chooseBuilding => 'Choisissez un immeuble';

  @override
  String get aptName => 'Nom / numéro';

  @override
  String get aptNameHint => 'ex. A3, Studio 12';

  @override
  String get floor => 'Étage';

  @override
  String get description => 'Description';

  @override
  String get aptDescHint => 'ex. 2 chambres, salon, cuisine';

  @override
  String get defaultRent => 'Loyer mensuel par défaut';

  @override
  String get defaultDeposit => 'Caution par défaut';

  @override
  String get metersToCreate => 'Compteurs à créer';

  @override
  String get newMeter => 'Nouveau compteur';

  @override
  String get editMeter => 'Modifier le compteur';

  @override
  String get typeRequired => 'Type *';

  @override
  String get chooseType => 'Choisissez un type';

  @override
  String get serialNumber => 'N° de série';

  @override
  String get indexInvalid => 'Index invalide';

  @override
  String get deactivate => 'Désactiver';

  @override
  String get tabOngoing => 'En cours';

  @override
  String get tabEnded => 'Terminées';

  @override
  String get tenants => 'Locataires';

  @override
  String get noActiveLease => 'Aucune location en cours';

  @override
  String get noEndedLease => 'Aucune location terminée';

  @override
  String get noActiveLeaseHelp =>
      'Créez un contrat pour attribuer un appartement libre à un locataire.';

  @override
  String leftOn(String date) {
    return 'Sorti le $date';
  }

  @override
  String dueAmount(String amount) {
    return 'Dû $amount';
  }

  @override
  String advanceAmount(String amount) {
    return 'Avance $amount';
  }

  @override
  String get toRefund => 'À rembourser';

  @override
  String get upToDate => 'À jour';

  @override
  String get noTenant => 'Aucun locataire';

  @override
  String get newTenant => 'Nouveau locataire';

  @override
  String get tenantHasLeases =>
      'Ce locataire a des contrats : suppression impossible.';

  @override
  String get idNumber => 'N° pièce d\'identité';

  @override
  String get emergencyContact => 'Personne à prévenir';

  @override
  String get leases => 'Contrats';

  @override
  String get noLease => 'Aucun contrat.';

  @override
  String get newLease => 'Nouvelle location';

  @override
  String get noFreeApartment => 'Aucun appartement libre';

  @override
  String get noFreeApartmentHelp =>
      'Tous les appartements sont occupés ou aucun n\'a été créé.';

  @override
  String get editLease => 'Modifier le contrat';

  @override
  String get createLease => 'Créer le contrat';

  @override
  String get aptAndTenant => 'Appartement et locataire';

  @override
  String get apartmentRequired => 'Appartement *';

  @override
  String get chooseApartment => 'Choisissez un appartement';

  @override
  String get tenantRequired => 'Locataire *';

  @override
  String get chooseTenant => 'Choisissez un locataire';

  @override
  String get conditions => 'Conditions';

  @override
  String get entryDate => 'Date d\'entrée';

  @override
  String get initialTermEndOptional =>
      'Fin de la période initiale (facultatif)';

  @override
  String get tacitRenewal => 'Reconduction tacite';

  @override
  String get tacitOnHelp =>
      'À l\'échéance, le bail est prolongé d\'une période de même durée.';

  @override
  String get tacitOffHelp =>
      'Le bail sera signalé comme échu, mais reste actif jusqu\'à sa clôture.';

  @override
  String get monthlyRent => 'Loyer mensuel';

  @override
  String get depositRequired => 'Caution exigée';

  @override
  String get depositPaid => 'Caution effectivement versée';

  @override
  String get firstMonthProrata => 'Premier mois au prorata';

  @override
  String get firstMonthProrataOn =>
      'Le loyer du mois d\'entrée est calculé au nombre de jours.';

  @override
  String get firstMonthProrataOff =>
      'Le locataire paie le mois d\'entrée en entier.';

  @override
  String get services => 'Services';

  @override
  String get noServices => 'Aucun service (parking, gardiennage…).';

  @override
  String get service => 'Service';

  @override
  String serviceQtySummary(String qty, String included, String billed) {
    return '$qty au total, $included inclus → $billed facturé(s)';
  }

  @override
  String amountPerMonth(String amount) {
    return '$amount/mois';
  }

  @override
  String get entryReadings => 'Index d\'entrée';

  @override
  String get entryReadingHint =>
      'Laisser vide pour utiliser le dernier index connu';

  @override
  String get serviceRequired => 'Service *';

  @override
  String get chooseService => 'Choisissez un service';

  @override
  String get totalQuantity => 'Quantité totale';

  @override
  String get includedQuantity => 'Dont inclus';

  @override
  String get number => 'Nombre';

  @override
  String get extraUnitPrice => 'Prix par unité supplémentaire / mois';

  @override
  String get extraUnitHelp => 'ex. 3 véhicules dont 1 autorisé → 2 facturés';

  @override
  String get tenantSheet => 'Fiche locataire';

  @override
  String get apartmentSheet => 'Fiche appartement';

  @override
  String get entryInspection => 'État des lieux d\'entrée';

  @override
  String get exitInspection => 'État des lieux de sortie';

  @override
  String get statusOngoingCaps => 'EN COURS';

  @override
  String get statusEndedCaps => 'TERMINÉ';

  @override
  String get remainingToPay => 'Reste à payer';

  @override
  String get tenantAdvance => 'Avance du locataire';

  @override
  String get refundToTenant => 'À rembourser au locataire';

  @override
  String get accountUpToDate => 'Compte à jour';

  @override
  String get refund => 'Rembourser';

  @override
  String get endLease => 'Mettre fin au contrat';

  @override
  String get endLeaseHelp =>
      'Index de sortie, état des lieux, caution et solde';

  @override
  String get exitDocument => 'Document de fin de contrat';

  @override
  String get exitDocumentHelp => 'Détail complet et solde final';

  @override
  String get lease => 'Contrat';

  @override
  String get moveIn => 'Entrée';

  @override
  String get moveOut => 'Sortie';

  @override
  String get depositPaidShort => 'Caution versée';

  @override
  String get firstMonth => 'Premier mois';

  @override
  String get lastMonth => 'Dernier mois';

  @override
  String get prorated => 'Au prorata';

  @override
  String get fullMonth => 'Mois complet';

  @override
  String get damagesRetained => 'Dégâts retenus';

  @override
  String serviceLine(String qty, String included, String price) {
    return '$qty ($included inclus) · $price';
  }

  @override
  String get totalBilled => 'Total facturé';

  @override
  String get totalPaid => 'Total payé';

  @override
  String invoicesCount(String count) {
    return 'Factures ($count)';
  }

  @override
  String get noInvoiceYet =>
      'Aucune facture. Elles sont générées depuis l\'onglet Relevés.';

  @override
  String paymentsCount(String count) {
    return 'Paiements ($count)';
  }

  @override
  String get noPayment => 'Aucun paiement enregistré.';

  @override
  String get initialTermEnd => 'Fin de la période initiale';

  @override
  String get renewal => 'Reconduction';

  @override
  String get renewalTacit => 'Tacite';

  @override
  String renewedTimes(String count) {
    return 'Tacite · reconduit $count fois';
  }

  @override
  String get no => 'Non';

  @override
  String get nextDeadline => 'Prochaine échéance';

  @override
  String get leaseExpired =>
      'Bail échu : le locataire est toujours en place, à renouveler ou clôturer';

  @override
  String get closeLeaseQ => 'Clôturer le contrat ?';

  @override
  String get closeLeaseHelp =>
      'La facture de sortie sera créée, la caution imputée et l\'appartement libéré. Cette action est définitive.';

  @override
  String get closeAction => 'Clôturer';

  @override
  String get endOfLease => 'Fin de contrat';

  @override
  String placeSince(String place, String date) {
    return '$place · depuis le $date';
  }

  @override
  String get exit => 'Sortie';

  @override
  String get exitDate => 'Date de sortie';

  @override
  String get lastMonthProrata => 'Dernier mois au prorata';

  @override
  String lastMonthProrataOn(String days) {
    return 'Le locataire paie uniquement les jours occupés ($days j).';
  }

  @override
  String get lastMonthProrataOff => 'Le locataire paie le mois complet.';

  @override
  String get exitReadings => 'Index de sortie';

  @override
  String lastBilledHint(String value) {
    return 'Dernier facturé : $value';
  }

  @override
  String get indexRequired => 'Index obligatoire';

  @override
  String lowerThanLast(String value) {
    return 'Inférieur au dernier index ($value)';
  }

  @override
  String get inspectionAndDamages => 'État des lieux et dégâts';

  @override
  String get roomByRoomOptional => 'Détail pièce par pièce (facultatif)';

  @override
  String get totalDamages => 'Montant total des dégâts';

  @override
  String deductedFromDeposit(String amount) {
    return 'Déduit de la caution de $amount';
  }

  @override
  String get observations => 'Observations';

  @override
  String get statement => 'Décompte';

  @override
  String get exitInvoiceTotal => 'Total facture de sortie';

  @override
  String get previousBalance => 'Solde antérieur';

  @override
  String get tenantStillOwes => 'Le locataire doit encore';

  @override
  String get accountSettled => 'Compte soldé';

  @override
  String get depositInsufficient =>
      'La caution est insuffisante : le reste sera à régler par le locataire.';

  @override
  String get computeStatement => 'Calculer le décompte';

  @override
  String get closeLease => 'Clôturer le contrat';

  @override
  String get noItem => 'Aucun élément';

  @override
  String get exitInspectionHelp =>
      'Ajoutez les dégâts constatés pièce par pièce, avec leur coût.';

  @override
  String get entryInspectionHelp =>
      'Facultatif : décrivez l\'état de chaque pièce à l\'entrée.';

  @override
  String get damagesTotal => 'Total des dégâts';

  @override
  String get item => 'Élément';

  @override
  String get newItemInspection => 'Nouvel élément';

  @override
  String get whichRoom => '1. Dans quelle pièce ?';

  @override
  String get chooseRoom => 'Choisissez la pièce';

  @override
  String get otherRoom => 'Autre pièce';

  @override
  String get whichItem => '2. Quel élément ?';

  @override
  String entryWas(String item, String condition) {
    return '$item (entrée : $condition)';
  }

  @override
  String get itemName => 'Nom de l\'élément constaté';

  @override
  String get itemNameHint => 'ex. Climatiseur Samsung, porte d\'entrée, lustre';

  @override
  String get conditionNoted => '3. État constaté';

  @override
  String get comment => 'Commentaire';

  @override
  String get repairCost => 'Coût de réparation';

  @override
  String get photo => 'Photo';

  @override
  String get retake => 'Reprendre';

  @override
  String get newRoom => 'Nouvelle pièce';

  @override
  String get newRoomHint => 'ex. Chambre parentale, buanderie';

  @override
  String get benefitApplied => 'Appliqué';

  @override
  String get benefitUpcoming => 'À venir';

  @override
  String get benefitSuspended => 'Suspendu';

  @override
  String get leaseStart => 'Début du bail';

  @override
  String get noLimit => 'sans limite';

  @override
  String get benefits => 'Avantages';

  @override
  String get noBenefit =>
      'Aucun avantage. Exemple : employé ENEO exonéré d\'électricité.';

  @override
  String get suspendFrom => 'Suspendre à partir de…';

  @override
  String get resumeFrom => 'Reprendre à partir de…';

  @override
  String benefitSuspendedFrom(String month) {
    return 'Avantage suspendu à partir de $month';
  }

  @override
  String benefitResumedFrom(String month) {
    return 'Avantage repris à partir de $month';
  }

  @override
  String get deleteBenefitQ => 'Supprimer l\'avantage ?';

  @override
  String get deleteBenefitHelp =>
      'Les factures verrouillées ne changent pas. Les factures modifiables seront à recalculer.';

  @override
  String get reasonEneo => 'Employé ENEO';

  @override
  String get reasonCamwater => 'Employé CAMWATER';

  @override
  String get reasonOwner => 'Accord du propriétaire';

  @override
  String get reasonGoodwill => 'Geste commercial';

  @override
  String get reasonCaretaker => 'Gardien de l\'immeuble';

  @override
  String get newBenefit => 'Nouvel avantage';

  @override
  String get editBenefit => 'Modifier l\'avantage';

  @override
  String get chargeRequired => 'Charge concernée *';

  @override
  String get chooseCharge => 'Choisissez la charge';

  @override
  String get units => 'Unités';

  @override
  String get amount => 'Montant';

  @override
  String get percentHelp =>
      'Pourcentage de la charge offert (100 % = exonération totale).';

  @override
  String get unitsHelp =>
      'Nombre d\'unités offertes chaque mois ; le surplus est facturé.';

  @override
  String get fixedHelp => 'Montant déduit chaque mois de cette charge.';

  @override
  String get amountPerMonthOff => 'Montant déduit par mois';

  @override
  String get percentage => 'Pourcentage';

  @override
  String get freeUnitsPerMonth => 'Unités gratuites par mois';

  @override
  String get valueInvalid => 'Valeur invalide';

  @override
  String get max100 => '100 % maximum';

  @override
  String get reason => 'Motif';

  @override
  String get reasonHint => 'ex. Employé ENEO';

  @override
  String fromLabel(String value) {
    return 'Depuis : $value';
  }

  @override
  String toLabel(String value) {
    return 'Jusqu\'à : $value';
  }

  @override
  String get leaseStartLower => 'début du bail';

  @override
  String get noEndDate => 'Sans date de fin';

  @override
  String get endAfterStart => 'La fin doit être après le début.';

  @override
  String get benefitSaved =>
      'Avantage enregistré. Recalculez les factures non verrouillées si besoin.';

  @override
  String get invoices => 'Factures';

  @override
  String get payments => 'Paiements';

  @override
  String get noInvoiceThisMonth => 'Aucune facture ce mois-ci';

  @override
  String get noInvoiceThisMonthHelp =>
      'Saisissez les relevés du mois puis générez les factures depuis l\'onglet Relevés.';

  @override
  String get remaining => 'Reste';

  @override
  String get filterAll => 'Toutes';

  @override
  String get filterUnpaid => 'Impayées';

  @override
  String get filterPaid => 'Payées';

  @override
  String get downloadAllInvoices => 'Télécharger toutes les factures (PDF)';

  @override
  String invoicesOfMonth(String month) {
    return 'Factures $month';
  }

  @override
  String get noPaymentThisMonth => 'Aucun paiement ce mois-ci';

  @override
  String get totalCollected => 'Total encaissé';

  @override
  String get overdue => 'En retard';

  @override
  String remainingAmount(String amount) {
    return 'reste $amount';
  }

  @override
  String get depositApplied => 'Caution imputée';

  @override
  String get refundKind => 'Remboursement';

  @override
  String get refundReceipt => 'Reçu de remboursement';

  @override
  String get invoiceNotFound => 'Facture introuvable';

  @override
  String get recalculate => 'Recalculer';

  @override
  String get invoiceRecalculated => 'Facture recalculée';

  @override
  String recalculatedWarnings(String count) {
    return 'Recalculée · $count avertissement(s)';
  }

  @override
  String get deleteInvoiceQ => 'Supprimer la facture ?';

  @override
  String get locked => 'Verrouillée';

  @override
  String get editable => 'Modifiable';

  @override
  String remainingToPayAmount(String amount) {
    return 'Reste à payer : $amount';
  }

  @override
  String get period => 'Période';

  @override
  String get type => 'Type';

  @override
  String get exitInvoice => 'Facture de sortie';

  @override
  String get monthly => 'Mensuelle';

  @override
  String get issuedOn => 'Émise le';

  @override
  String get dueDate => 'Échéance';

  @override
  String get detail => 'Détail';

  @override
  String get ofWhichVat => 'dont TVA';

  @override
  String get total => 'Total';

  @override
  String get exitInvoiceFinal => 'Facture de sortie : définitive.';

  @override
  String get laterMonthBilled =>
      'Un mois ultérieur a été facturé : cette facture est définitive.';

  @override
  String get pdf => 'PDF';

  @override
  String get collectPayment => 'Encaisser un paiement';

  @override
  String get saveRefund => 'Enregistrer le remboursement';

  @override
  String get savePayment => 'Enregistrer le paiement';

  @override
  String get refundSaved => 'Remboursement enregistré';

  @override
  String get paymentSaved => 'Paiement enregistré';

  @override
  String receiptNo(String number) {
    return 'Reçu n° $number';
  }

  @override
  String get viewRefundReceipt => 'Voir le reçu';

  @override
  String get viewReceipt => 'Voir la quittance';

  @override
  String get balanceDue => 'Solde dû';

  @override
  String get inTenantFavor => 'En faveur du locataire';

  @override
  String get amountReceived => 'Montant reçu';

  @override
  String get paymentDate => 'Date du paiement';

  @override
  String get referenceHint => 'Référence (transaction, chèque…)';

  @override
  String invoicesFor(String month) {
    return 'Factures de $month';
  }

  @override
  String generationSummary(String created, String updated) {
    return '$created créée(s), $updated mise(s) à jour.';
  }

  @override
  String generationSummaryLocked(
    String created,
    String updated,
    String locked,
  ) {
    return '$created créée(s), $updated mise(s) à jour, $locked verrouillée(s) non modifiée(s).';
  }

  @override
  String get warnings => 'Avertissements :';

  @override
  String get viewInvoices => 'Voir les factures';

  @override
  String get exportMonthReadings => 'Exporter les relevés du mois';

  @override
  String get noMeter => 'Aucun compteur';

  @override
  String get noMeterHelp =>
      'Ajoutez des compteurs aux appartements (onglet Biens) pour saisir les relevés.';

  @override
  String get metersRead => 'compteurs relevés';

  @override
  String photosCount(String count) {
    return '$count photo(s)';
  }

  @override
  String get generateInvoices => 'Générer les factures';

  @override
  String previousValue(String value) {
    return 'Précédent : $value';
  }

  @override
  String get noPhoto => 'Sans photo';

  @override
  String get previous => 'Précédent';

  @override
  String get readingLocked =>
      'Un relevé plus récent existe : ce relevé est verrouillé.';

  @override
  String get newReading => 'Nouvel index';

  @override
  String get readingLowerThanPrevious => 'Index inférieur au précédent';

  @override
  String anomalyHelp(String average) {
    return '⚠ Consommation plus de 2× supérieure à la moyenne ($average)';
  }

  @override
  String get photographMeter => 'Photographier le compteur';

  @override
  String get retakePhoto => 'Reprendre la photo';

  @override
  String get readingDate => 'Date du relevé';

  @override
  String get noPhotoTitle => 'Aucune photo';

  @override
  String get saveWithoutPhoto =>
      'Enregistrer ce relevé sans photo du compteur ?';

  @override
  String get restoreQ => 'Restaurer cette sauvegarde ?';

  @override
  String get restoreHelp =>
      'Toutes les données actuelles seront remplacées. Une sauvegarde de sécurité de l\'état actuel est créée automatiquement avant.';

  @override
  String get restore => 'Restaurer';

  @override
  String get backup => 'Sauvegarde';

  @override
  String get backupHelp =>
      'Toutes les données restent sur ce téléphone. Créez régulièrement une sauvegarde et envoyez-la ailleurs (Drive, e-mail, WhatsApp, clé USB) : en cas de perte du téléphone, c\'est votre seule copie.';

  @override
  String get backupShareText => 'Sauvegarde NHimmo';

  @override
  String get createShareBackup => 'Créer et partager une sauvegarde';

  @override
  String get chooseBackupFile => 'Choisir une sauvegarde NHimmo (.zip)';

  @override
  String get restoreFromFile => 'Restaurer depuis un fichier';

  @override
  String get localBackups => 'Sauvegardes sur ce téléphone';

  @override
  String get noLocalBackup => 'Aucune sauvegarde locale.';

  @override
  String sizeKb(String size) {
    return '$size Ko';
  }

  @override
  String get share => 'Partager';

  @override
  String get meterTypes => 'Types de compteurs';

  @override
  String get meterTypesHelp =>
      'Un seul calcul pour tous : consommation × prix unitaire + entretien, TVA selon le mode choisi. Pour fournir du gaz, ajoutez simplement un type « Gaz ».';

  @override
  String get inactive => 'Inactif';

  @override
  String pricePerUnit(String price, String unit) {
    return '$price / $unit';
  }

  @override
  String maintenanceShort(String amount) {
    return 'entretien $amount';
  }

  @override
  String withRate(String mode, String rate) {
    return '$mode ($rate %)';
  }

  @override
  String get newType => 'Nouveau type';

  @override
  String get newMeterType => 'Nouveau type de compteur';

  @override
  String get name => 'Nom';

  @override
  String get gasHint => 'ex. Gaz';

  @override
  String get unitOfMeasure => 'Unité de mesure';

  @override
  String get unitHint => 'ex. m³, kWh';

  @override
  String get tariff => 'Tarif';

  @override
  String get unitPrice => 'Prix par unité';

  @override
  String get meterFee => 'Entretien / location compteur (par mois)';

  @override
  String get vat => 'TVA';

  @override
  String get vatNoneShort => 'Aucune';

  @override
  String get vatIncludedCap => 'Incluse';

  @override
  String get vatAddedCap => 'En sus';

  @override
  String get vatRate => 'Taux de TVA';

  @override
  String get rateRequired => 'Taux obligatoire';

  @override
  String get vatOnFee => 'TVA aussi sur l\'entretien';

  @override
  String get simulation => 'Simulation';

  @override
  String get excludingTax => 'Hors taxe';

  @override
  String get totalCharged => 'Total facturé';

  @override
  String get active => 'Actif';

  @override
  String get inactiveTypeHelp => 'Un type inactif n\'est plus proposé.';

  @override
  String get translations => 'Traductions';

  @override
  String get translationsHelp =>
      'Nom affiché sur les documents des locataires de chaque langue (vide = nom principal).';

  @override
  String nameIn(String lang) {
    return 'Nom ($lang)';
  }

  @override
  String unitIn(String lang) {
    return 'Unité ($lang)';
  }

  @override
  String get noService => 'Aucun service';

  @override
  String servicePriceLine(String price, String unit) {
    return '$price par $unit et par mois';
  }

  @override
  String get newService => 'Nouveau service';

  @override
  String get defaultUnit => 'unité';

  @override
  String get parkingHint => 'ex. Parking';

  @override
  String get unit => 'Unité';

  @override
  String get serviceUnitHint => 'ex. véhicule, place';

  @override
  String get monthlyPricePerUnit => 'Prix mensuel par unité';

  @override
  String get scopeReadings => 'Relevés';

  @override
  String get scopeReadingsHelp =>
      'Index, consommations, photos (oui/non), par mois ou période';

  @override
  String get scopeBilling => 'Facturation';

  @override
  String get scopeBillingHelp =>
      'Factures, lignes détaillées, paiements, soldes';

  @override
  String get scopeAll => 'Toutes les données';

  @override
  String get scopeAllHelp => 'Toutes les tables de l\'application';

  @override
  String get exports => 'Exports';

  @override
  String get whatToExport => 'Que voulez-vous exporter ?';

  @override
  String get thisMonth => 'Ce mois';

  @override
  String get last3Months => '3 derniers mois';

  @override
  String get thisYear => 'Cette année';

  @override
  String get format => 'Format';

  @override
  String get fullBackupZip => 'Sauvegarde complète (ZIP)';

  @override
  String get fullBackupHelp =>
      'Base + photos, réimportable dans l\'application';

  @override
  String get exportAndShare => 'Exporter et partager';

  @override
  String fromMonth(String month) {
    return 'Du $month';
  }

  @override
  String toMonth(String month) {
    return 'Au $month';
  }

  @override
  String get general => 'Général';

  @override
  String get generalHelp => 'Nom, coordonnées, langue, devise, échéance';

  @override
  String get meterTypesTileHelp =>
      'Eau, électricité, gaz… prix, entretien, TVA';

  @override
  String get servicesTileHelp => 'Parking, gardiennage…';

  @override
  String get exportsTileHelp => 'Relevés, facturation, toutes les données';

  @override
  String get backupRestore => 'Sauvegarde et restauration';

  @override
  String get backupRestoreHelp => 'Fichier ZIP complet (données + photos)';

  @override
  String get demoLoaded => 'Données de démonstration chargées';

  @override
  String get loadDemo => 'Charger des données de démonstration';

  @override
  String get loadDemoHelp =>
      'Pour découvrir l\'application (visible seulement si elle est vide)';

  @override
  String signatureKey(String key) {
    return 'Clé de signature des documents : $key';
  }

  @override
  String get managerHeader => 'Gestionnaire (en-tête des documents)';

  @override
  String get businessName => 'Nom / raison sociale';

  @override
  String get invoiceFooter => 'Mention en bas des factures';

  @override
  String get currency => 'Devise';

  @override
  String get customSymbol => 'Symbole affiché (devise personnalisée)';

  @override
  String get symbolBefore => 'Symbole avant le montant';

  @override
  String preview(String value) {
    return 'Aperçu : $value';
  }

  @override
  String get billing => 'Facturation';

  @override
  String get invoiceDueDay => 'Jour d\'échéance des factures';

  @override
  String get scanTitle => 'Scanner un document';

  @override
  String get scanHelp =>
      'Visez le QR code d\'une facture, d\'une quittance ou d\'un décompte de sortie imprimé.';

  @override
  String docWithNumber(String doc, String number) {
    return '$doc $number';
  }

  @override
  String balanceAtPrint(String amount) {
    return 'Solde au moment de l\'impression : $amount';
  }

  @override
  String get result => 'Résultat';

  @override
  String get qrUnknown => 'QR code non reconnu';

  @override
  String get qrUnknownHelp =>
      'Ce QR code ne provient pas d\'un document NHimmo.';

  @override
  String get verification => 'Vérification';

  @override
  String get signatureInvalid => 'Signature invalide';

  @override
  String get signatureValid => 'Signature valide';

  @override
  String get documentAuthentic => 'Document authentique';

  @override
  String get documentChanged => 'Document modifié depuis l\'impression';

  @override
  String get signatureInvalidHelp =>
      'Ce document a été falsifié ou n\'a pas été émis par cette application.';

  @override
  String get signatureValidHelp =>
      'Le document a bien été émis avec votre clé, mais il n\'existe plus dans les données.';

  @override
  String get documentAuthenticHelp =>
      'Les informations imprimées correspondent aux données enregistrées.';

  @override
  String get documentChangedHelp =>
      'Le document a été régénéré depuis : ouvrez-le pour voir la version actuelle.';

  @override
  String get numberLabel => 'Numéro';

  @override
  String get openDocument => 'Ouvrir le document';

  @override
  String get scanAnother => 'Scanner un autre document';

  @override
  String pdfNumber(String number) {
    return 'N° $number';
  }

  @override
  String get pdfDigitalSignature => 'Signature numérique';

  @override
  String get pdfDesignation => 'Désignation';

  @override
  String get pdfExclTax => 'HT';

  @override
  String get pdfAmount => 'Montant';

  @override
  String get pdfFooter =>
      'Document signé numériquement, vérifiable par QR code dans NHimmo';

  @override
  String pdfPage(String page, String total) {
    return 'Page $page/$total';
  }

  @override
  String get pdfDefaultThanks => 'Merci pour votre règlement.';

  @override
  String pdfPeriod(String period) {
    return 'Période : $period';
  }

  @override
  String pdfIssuedDue(String issued, String due) {
    return 'Émise le $issued  ·  Échéance $due';
  }

  @override
  String get pdfLandlord => 'Bailleur / gestionnaire';

  @override
  String get pdfTenant => 'Locataire';

  @override
  String get pdfTotalExclTax => 'Total HT';

  @override
  String get pdfTotalDue => 'Total à payer';

  @override
  String get pdfStatus => 'Statut';

  @override
  String get pdfPaidStamp => 'PAYÉE';

  @override
  String pdfNotes(String notes) {
    return 'Notes : $notes';
  }

  @override
  String pdfDate(String date) {
    return 'Date : $date';
  }

  @override
  String pdfRefundText(String manager, String tenant) {
    return 'Le gestionnaire $manager a remboursé à $tenant la somme de :';
  }

  @override
  String pdfReceivedText(String tenant, String place) {
    return 'Reçu de $tenant, locataire de $place, la somme de :';
  }

  @override
  String pdfPaymentMethod(String method) {
    return 'Mode de règlement : $method';
  }

  @override
  String pdfReference(String ref) {
    return 'réf. $ref';
  }

  @override
  String pdfNote(String note) {
    return 'Note : $note';
  }

  @override
  String pdfBalanceAfter(String amount) {
    return 'Solde du compte locataire après ce règlement : $amount';
  }

  @override
  String pdfDoneOn(String date) {
    return 'Fait le $date';
  }

  @override
  String get pdfExitTitle => 'Décompte de fin de contrat';

  @override
  String pdfMoveInOut(String moveIn, String moveOut) {
    return 'Entrée : $moveIn  ·  Sortie : $moveOut';
  }

  @override
  String get pdfLastMonthProrata => 'Dernier mois : au prorata des jours';

  @override
  String get pdfLastMonthFull => 'Dernier mois : mois complet';

  @override
  String get pdfOutgoingTenant => 'Locataire sortant';

  @override
  String get pdfSectionExitInvoice => '1. Facture de sortie';

  @override
  String get pdfNoLine => 'Aucune ligne.';

  @override
  String get pdfSectionDamages => '2. Détail des dégâts constatés';

  @override
  String get pdfRoom => 'Pièce';

  @override
  String get pdfItem => 'Élément';

  @override
  String get pdfCondition => 'État';

  @override
  String get pdfComment => 'Commentaire';

  @override
  String get pdfCost => 'Coût';

  @override
  String pdfSectionSummary(String n) {
    return '$n. Récapitulatif du compte';
  }

  @override
  String get pdfTotalLease => 'Total facturé sur toute la durée du contrat';

  @override
  String get pdfTotalTenantPaid => 'Total réglé par le locataire';

  @override
  String get pdfDepositApplied => 'Caution versée à l\'entrée (imputée)';

  @override
  String get pdfDamagesFromDeposit => 'dont dégâts retenus sur la caution';

  @override
  String get pdfRefundsDone => 'Remboursements déjà effectués';

  @override
  String get pdfTenantOwes => 'Reste à payer par le locataire';

  @override
  String get pdfToRefund => 'À rembourser au locataire';

  @override
  String get pdfSettled => 'Compte soldé';

  @override
  String get pdfDepositNotEnough =>
      'La caution ne couvre pas la totalité des sommes dues : le locataire doit compléter le montant ci-dessus.';

  @override
  String pdfObservations(String notes) {
    return 'Observations : $notes';
  }

  @override
  String get pdfManagerSign => 'Le gestionnaire';

  @override
  String get pdfTenantSign => 'Le locataire (lu et approuvé)';

  @override
  String get xBuilding => 'Immeuble';

  @override
  String get xApartment => 'Appartement';

  @override
  String get xMeter => 'Compteur';

  @override
  String get xReading => 'Index';

  @override
  String get xPreviousReading => 'Index précédent';

  @override
  String get xYes => 'oui';

  @override
  String get xNo => 'non';

  @override
  String get xKindMonthly => 'Mensuel';

  @override
  String get xInvoiceNo => 'N° facture';

  @override
  String xTotalWith(String symbol) {
    return 'Total ($symbol)';
  }

  @override
  String get xLabel => 'Libellé';

  @override
  String get xDetails => 'Détails';

  @override
  String get xQuantity => 'Quantité';

  @override
  String get xUnitPrice => 'Prix unitaire';

  @override
  String get xInclTax => 'TTC';

  @override
  String get xStartReading => 'Index début';

  @override
  String get xEndReading => 'Index fin';

  @override
  String get xReceiptNo => 'N° reçu';

  @override
  String get xMethod => 'Mode';

  @override
  String get xReference => 'Référence';

  @override
  String get xPayment => 'Paiement';

  @override
  String get xBalanceSigned => 'Solde (+ dû / − à rembourser)';

  @override
  String get xSheetLines => 'Lignes';

  @override
  String get xSheetBalances => 'Soldes';

  @override
  String get backupNotMyImmo => 'Ce fichier n\'est pas une sauvegarde NHimmo.';

  @override
  String get backupUnknownFormat => 'Format de sauvegarde inconnu.';

  @override
  String get backupTooRecent =>
      'Sauvegarde créée par une version plus récente de l\'application.';

  @override
  String get editPayment => 'Modifier le versement';

  @override
  String get completeDeposit => 'Compléter la caution';

  @override
  String get paymentUpdated => 'Versement modifié';

  @override
  String get depositMissing => 'Reste à verser';

  @override
  String get depositAmountReceived => 'Montant de caution reçu';

  @override
  String get depositReceived => 'Caution reçue';

  @override
  String get deletePaymentQ => 'Supprimer ce versement ?';

  @override
  String deletePaymentHelp(String number) {
    return 'Le versement $number sera supprimé et le solde du locataire recalculé.';
  }

  @override
  String get paymentDeleted => 'Versement supprimé';

  @override
  String get paymentLockedHelp =>
      'Un versement plus récent existe : seul le dernier versement peut être modifié ou supprimé.';

  @override
  String get paymentAutoLocked =>
      'Caution imputée automatiquement à la clôture du contrat : non modifiable.';

  @override
  String get depositIncomplete => 'Caution incomplète';

  @override
  String get depositIncompleteShort => 'Caution incomplète';

  @override
  String depositIncompleteDetail(String paid, String required) {
    return 'Caution versée : $paid sur $required';
  }

  @override
  String depositMissingAmount(String amount) {
    return 'Reste à verser : $amount';
  }

  @override
  String get complete => 'Compléter';

  @override
  String get incompleteDeposits => 'Cautions incomplètes';

  @override
  String get creditSettlement => 'Règlement par avance';

  @override
  String get creditAvailable => 'Avance / paiements disponibles';

  @override
  String get creditApplied => 'Déduit de l\'avance';

  @override
  String get creditRemaining => 'Avance restante après cette facture';

  @override
  String get depositReceipt => 'Reçu de caution';

  @override
  String pdfDepositReceivedText(String tenant, String place) {
    return 'Reçu de $tenant, locataire de $place, au titre de la caution, la somme de :';
  }
}
