import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @languageName.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get languageName;

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'NHimmo'**
  String get appTitle;

  /// No description provided for @lineRent.
  ///
  /// In fr, this message translates to:
  /// **'Loyer {month}'**
  String lineRent(String month);

  /// No description provided for @lineProrata.
  ///
  /// In fr, this message translates to:
  /// **'{days}/{total} jours'**
  String lineProrata(String days, String total);

  /// No description provided for @lineIndex.
  ///
  /// In fr, this message translates to:
  /// **'Index {from} à {to}'**
  String lineIndex(String from, String to);

  /// No description provided for @lineConsumption.
  ///
  /// In fr, this message translates to:
  /// **'{qty} {unit} × {price}'**
  String lineConsumption(String qty, String unit, String price);

  /// No description provided for @lineMaintenance.
  ///
  /// In fr, this message translates to:
  /// **'Entretien compteur {amount}'**
  String lineMaintenance(String amount);

  /// No description provided for @lineVat.
  ///
  /// In fr, this message translates to:
  /// **'TVA {rate} % ({mode})'**
  String lineVat(String rate, String mode);

  /// No description provided for @vatIncludedShort.
  ///
  /// In fr, this message translates to:
  /// **'incluse'**
  String get vatIncludedShort;

  /// No description provided for @vatAddedShort.
  ///
  /// In fr, this message translates to:
  /// **'en sus'**
  String get vatAddedShort;

  /// No description provided for @lineServiceIncluded.
  ///
  /// In fr, this message translates to:
  /// **'{qty} {unit}(s), {included} inclus, {billed} facturé(s)'**
  String lineServiceIncluded(
    String qty,
    String unit,
    String included,
    String billed,
  );

  /// No description provided for @lineServiceQty.
  ///
  /// In fr, this message translates to:
  /// **'{qty} {unit}(s)'**
  String lineServiceQty(String qty, String unit);

  /// No description provided for @lineDamages.
  ///
  /// In fr, this message translates to:
  /// **'Dégâts constatés (état des lieux de sortie)'**
  String get lineDamages;

  /// No description provided for @lineCredit.
  ///
  /// In fr, this message translates to:
  /// **'Déduction loyer et services – {days} jour(s) non occupé(s)'**
  String lineCredit(String days);

  /// No description provided for @lineBenefit.
  ///
  /// In fr, this message translates to:
  /// **'Avantage {name}'**
  String lineBenefit(String name);

  /// No description provided for @benefitFull.
  ///
  /// In fr, this message translates to:
  /// **'Exonération totale'**
  String get benefitFull;

  /// No description provided for @benefitPercent.
  ///
  /// In fr, this message translates to:
  /// **'Réduction de {value} %'**
  String benefitPercent(String value);

  /// No description provided for @benefitUnits.
  ///
  /// In fr, this message translates to:
  /// **'{value} {unit} gratuits par mois'**
  String benefitUnits(String value, String unit);

  /// No description provided for @benefitAmount.
  ///
  /// In fr, this message translates to:
  /// **'{amount} déduits par mois'**
  String benefitAmount(String amount);

  /// No description provided for @benefitModePercent.
  ///
  /// In fr, this message translates to:
  /// **'Réduction en %'**
  String get benefitModePercent;

  /// No description provided for @benefitModeUnits.
  ///
  /// In fr, this message translates to:
  /// **'Unités gratuites / mois'**
  String get benefitModeUnits;

  /// No description provided for @benefitModeAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant fixe déduit / mois'**
  String get benefitModeAmount;

  /// No description provided for @vatNone.
  ///
  /// In fr, this message translates to:
  /// **'Pas de TVA'**
  String get vatNone;

  /// No description provided for @vatIncluded.
  ///
  /// In fr, this message translates to:
  /// **'TVA incluse dans le prix'**
  String get vatIncluded;

  /// No description provided for @vatAdded.
  ///
  /// In fr, this message translates to:
  /// **'TVA en sus'**
  String get vatAdded;

  /// No description provided for @roomLiving.
  ///
  /// In fr, this message translates to:
  /// **'Salon'**
  String get roomLiving;

  /// No description provided for @roomDining.
  ///
  /// In fr, this message translates to:
  /// **'Salle à manger'**
  String get roomDining;

  /// No description provided for @roomKitchen.
  ///
  /// In fr, this message translates to:
  /// **'Cuisine'**
  String get roomKitchen;

  /// No description provided for @roomBedroom.
  ///
  /// In fr, this message translates to:
  /// **'Chambre'**
  String get roomBedroom;

  /// No description provided for @roomBedroomN.
  ///
  /// In fr, this message translates to:
  /// **'Chambre {n}'**
  String roomBedroomN(String n);

  /// No description provided for @roomBathroom.
  ///
  /// In fr, this message translates to:
  /// **'Salle de bain'**
  String get roomBathroom;

  /// No description provided for @roomToilet.
  ///
  /// In fr, this message translates to:
  /// **'WC'**
  String get roomToilet;

  /// No description provided for @roomHallway.
  ///
  /// In fr, this message translates to:
  /// **'Couloir'**
  String get roomHallway;

  /// No description provided for @roomBalcony.
  ///
  /// In fr, this message translates to:
  /// **'Balcon'**
  String get roomBalcony;

  /// No description provided for @roomTerrace.
  ///
  /// In fr, this message translates to:
  /// **'Terrasse'**
  String get roomTerrace;

  /// No description provided for @roomGarage.
  ///
  /// In fr, this message translates to:
  /// **'Garage'**
  String get roomGarage;

  /// No description provided for @roomOutside.
  ///
  /// In fr, this message translates to:
  /// **'Extérieur'**
  String get roomOutside;

  /// No description provided for @condNew.
  ///
  /// In fr, this message translates to:
  /// **'Neuf'**
  String get condNew;

  /// No description provided for @condGood.
  ///
  /// In fr, this message translates to:
  /// **'Bon'**
  String get condGood;

  /// No description provided for @condWorn.
  ///
  /// In fr, this message translates to:
  /// **'Usé'**
  String get condWorn;

  /// No description provided for @condDamaged.
  ///
  /// In fr, this message translates to:
  /// **'Dégradé'**
  String get condDamaged;

  /// No description provided for @condBroken.
  ///
  /// In fr, this message translates to:
  /// **'Hors service'**
  String get condBroken;

  /// No description provided for @methodCash.
  ///
  /// In fr, this message translates to:
  /// **'Espèces'**
  String get methodCash;

  /// No description provided for @methodMobile.
  ///
  /// In fr, this message translates to:
  /// **'Mobile Money'**
  String get methodMobile;

  /// No description provided for @methodTransfer.
  ///
  /// In fr, this message translates to:
  /// **'Virement'**
  String get methodTransfer;

  /// No description provided for @methodCheque.
  ///
  /// In fr, this message translates to:
  /// **'Chèque'**
  String get methodCheque;

  /// No description provided for @methodOther.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get methodOther;

  /// No description provided for @methodDeposit.
  ///
  /// In fr, this message translates to:
  /// **'Caution'**
  String get methodDeposit;

  /// No description provided for @payStatusPaid.
  ///
  /// In fr, this message translates to:
  /// **'Payée'**
  String get payStatusPaid;

  /// No description provided for @payStatusPartial.
  ///
  /// In fr, this message translates to:
  /// **'Partielle'**
  String get payStatusPartial;

  /// No description provided for @payStatusUnpaid.
  ///
  /// In fr, this message translates to:
  /// **'Impayée'**
  String get payStatusUnpaid;

  /// No description provided for @warnMissingReading.
  ///
  /// In fr, this message translates to:
  /// **'{place} : relevé {meter} manquant'**
  String warnMissingReading(String place, String meter);

  /// No description provided for @warnIndexLower.
  ///
  /// In fr, this message translates to:
  /// **'{place} : index {meter} inférieur au précédent'**
  String warnIndexLower(String place, String meter);

  /// No description provided for @warnExitIndexMissing.
  ///
  /// In fr, this message translates to:
  /// **'Index de sortie {meter} non saisi'**
  String warnExitIndexMissing(String meter);

  /// No description provided for @warnExitIndexLower.
  ///
  /// In fr, this message translates to:
  /// **'Index {meter} inférieur au dernier index facturé'**
  String warnExitIndexLower(String meter);

  /// No description provided for @docInvoice.
  ///
  /// In fr, this message translates to:
  /// **'Facture'**
  String get docInvoice;

  /// No description provided for @docReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Quittance'**
  String get docReceipt;

  /// No description provided for @docExit.
  ///
  /// In fr, this message translates to:
  /// **'Décompte de sortie'**
  String get docExit;

  /// No description provided for @errorWith.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : {error}'**
  String errorWith(String error);

  /// No description provided for @requiredField.
  ///
  /// In fr, this message translates to:
  /// **'Champ obligatoire'**
  String get requiredField;

  /// No description provided for @amountRequired.
  ///
  /// In fr, this message translates to:
  /// **'Montant obligatoire'**
  String get amountRequired;

  /// No description provided for @amountInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Montant invalide'**
  String get amountInvalid;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get add;

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @validate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get validate;

  /// No description provided for @newItem.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau'**
  String get newItem;

  /// No description provided for @notes.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @note.
  ///
  /// In fr, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @phone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get phone;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @address.
  ///
  /// In fr, this message translates to:
  /// **'Adresse'**
  String get address;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @navProperties.
  ///
  /// In fr, this message translates to:
  /// **'Biens'**
  String get navProperties;

  /// No description provided for @navRentals.
  ///
  /// In fr, this message translates to:
  /// **'Locations'**
  String get navRentals;

  /// No description provided for @navReadings.
  ///
  /// In fr, this message translates to:
  /// **'Relevés'**
  String get navReadings;

  /// No description provided for @navFinance.
  ///
  /// In fr, this message translates to:
  /// **'Finances'**
  String get navFinance;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @appLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue de l\'application'**
  String get appLanguage;

  /// No description provided for @systemLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue du téléphone'**
  String get systemLanguage;

  /// No description provided for @documentLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue des documents'**
  String get documentLanguage;

  /// No description provided for @documentLanguageHelp.
  ///
  /// In fr, this message translates to:
  /// **'Factures, quittances et décompte de ce locataire seront produits dans cette langue.'**
  String get documentLanguageHelp;

  /// No description provided for @sameAsApp.
  ///
  /// In fr, this message translates to:
  /// **'Comme l\'application ({lang})'**
  String sameAsApp(String lang);

  /// No description provided for @hello.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour 👋'**
  String get hello;

  /// No description provided for @scanDocument.
  ///
  /// In fr, this message translates to:
  /// **'Scanner un document'**
  String get scanDocument;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @collectedThisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Encaissé ce mois'**
  String get collectedThisMonth;

  /// No description provided for @forBilledIn.
  ///
  /// In fr, this message translates to:
  /// **'pour {amount} facturés en {month}'**
  String forBilledIn(String amount, String month);

  /// No description provided for @actionRead.
  ///
  /// In fr, this message translates to:
  /// **'Relever'**
  String get actionRead;

  /// No description provided for @actionCollect.
  ///
  /// In fr, this message translates to:
  /// **'Encaisser'**
  String get actionCollect;

  /// No description provided for @actionScan.
  ///
  /// In fr, this message translates to:
  /// **'Scanner'**
  String get actionScan;

  /// No description provided for @actionExport.
  ///
  /// In fr, this message translates to:
  /// **'Exporter'**
  String get actionExport;

  /// No description provided for @occupancy.
  ///
  /// In fr, this message translates to:
  /// **'Occupation'**
  String get occupancy;

  /// No description provided for @apartmentsCount.
  ///
  /// In fr, this message translates to:
  /// **'{occupied} / {total} appartements'**
  String apartmentsCount(String occupied, String total);

  /// No description provided for @unpaid.
  ///
  /// In fr, this message translates to:
  /// **'Impayés'**
  String get unpaid;

  /// No description provided for @lateInvoices.
  ///
  /// In fr, this message translates to:
  /// **'{count} facture(s) en retard'**
  String lateInvoices(String count);

  /// No description provided for @noDelay.
  ///
  /// In fr, this message translates to:
  /// **'Aucun retard'**
  String get noDelay;

  /// No description provided for @readingsOfMonth.
  ///
  /// In fr, this message translates to:
  /// **'Relevés du mois'**
  String get readingsOfMonth;

  /// No description provided for @done.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get done;

  /// No description provided for @toComplete.
  ///
  /// In fr, this message translates to:
  /// **'À compléter'**
  String get toComplete;

  /// No description provided for @lastBilling.
  ///
  /// In fr, this message translates to:
  /// **'Dernière facturation'**
  String get lastBilling;

  /// No description provided for @billedVsCollected.
  ///
  /// In fr, this message translates to:
  /// **'Facturé vs encaissé'**
  String get billedVsCollected;

  /// No description provided for @billed.
  ///
  /// In fr, this message translates to:
  /// **'Facturé'**
  String get billed;

  /// No description provided for @collected.
  ///
  /// In fr, this message translates to:
  /// **'Encaissé'**
  String get collected;

  /// No description provided for @consumptionOf.
  ///
  /// In fr, this message translates to:
  /// **'Consommations · {month}'**
  String consumptionOf(String month);

  /// No description provided for @balancesToRecover.
  ///
  /// In fr, this message translates to:
  /// **'Soldes à recouvrer'**
  String get balancesToRecover;

  /// No description provided for @endContractFirst.
  ///
  /// In fr, this message translates to:
  /// **'Terminez d\'abord le contrat en cours.'**
  String get endContractFirst;

  /// No description provided for @reactivateQ.
  ///
  /// In fr, this message translates to:
  /// **'Réactiver ?'**
  String get reactivateQ;

  /// No description provided for @archiveQ.
  ///
  /// In fr, this message translates to:
  /// **'Archiver ?'**
  String get archiveQ;

  /// No description provided for @aptWillReappear.
  ///
  /// In fr, this message translates to:
  /// **'L\'appartement réapparaîtra dans les listes et relevés.'**
  String get aptWillReappear;

  /// No description provided for @aptWillDisappear.
  ///
  /// In fr, this message translates to:
  /// **'L\'appartement n\'apparaîtra plus dans les listes et relevés.'**
  String get aptWillDisappear;

  /// No description provided for @reactivate.
  ///
  /// In fr, this message translates to:
  /// **'Réactiver'**
  String get reactivate;

  /// No description provided for @archive.
  ///
  /// In fr, this message translates to:
  /// **'Archiver'**
  String get archive;

  /// No description provided for @rent.
  ///
  /// In fr, this message translates to:
  /// **'Loyer'**
  String get rent;

  /// No description provided for @deposit.
  ///
  /// In fr, this message translates to:
  /// **'Caution'**
  String get deposit;

  /// No description provided for @sinceDate.
  ///
  /// In fr, this message translates to:
  /// **'Depuis le {date}'**
  String sinceDate(String date);

  /// No description provided for @aptFree.
  ///
  /// In fr, this message translates to:
  /// **'Appartement libre'**
  String get aptFree;

  /// No description provided for @rentOut.
  ///
  /// In fr, this message translates to:
  /// **'Louer'**
  String get rentOut;

  /// No description provided for @meters.
  ///
  /// In fr, this message translates to:
  /// **'Compteurs'**
  String get meters;

  /// No description provided for @noMeters.
  ///
  /// In fr, this message translates to:
  /// **'Aucun compteur. Ajoutez-en pour facturer les consommations.'**
  String get noMeters;

  /// No description provided for @serialUnknown.
  ///
  /// In fr, this message translates to:
  /// **'N° non renseigné'**
  String get serialUnknown;

  /// No description provided for @serialNo.
  ///
  /// In fr, this message translates to:
  /// **'N° {serial}'**
  String serialNo(String serial);

  /// No description provided for @initialIndex.
  ///
  /// In fr, this message translates to:
  /// **'Index initial'**
  String get initialIndex;

  /// No description provided for @readOn.
  ///
  /// In fr, this message translates to:
  /// **'relevé {date}'**
  String readOn(String date);

  /// No description provided for @consumption.
  ///
  /// In fr, this message translates to:
  /// **'Consommation'**
  String get consumption;

  /// No description provided for @leaseHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des locations'**
  String get leaseHistory;

  /// No description provided for @ongoing.
  ///
  /// In fr, this message translates to:
  /// **'en cours'**
  String get ongoing;

  /// No description provided for @buildings.
  ///
  /// In fr, this message translates to:
  /// **'Immeubles'**
  String get buildings;

  /// No description provided for @monthlyRents.
  ///
  /// In fr, this message translates to:
  /// **'Loyers mensuels'**
  String get monthlyRents;

  /// No description provided for @billedYear.
  ///
  /// In fr, this message translates to:
  /// **'Facturé {year}'**
  String billedYear(String year);

  /// No description provided for @collectedYear.
  ///
  /// In fr, this message translates to:
  /// **'Encaissé {year}'**
  String collectedYear(String year);

  /// No description provided for @unpaidAmount.
  ///
  /// In fr, this message translates to:
  /// **'Impayés : {amount}'**
  String unpaidAmount(String amount);

  /// No description provided for @apartments.
  ///
  /// In fr, this message translates to:
  /// **'Appartements'**
  String get apartments;

  /// No description provided for @owners.
  ///
  /// In fr, this message translates to:
  /// **'Propriétaires'**
  String get owners;

  /// No description provided for @noApartment.
  ///
  /// In fr, this message translates to:
  /// **'Aucun appartement'**
  String get noApartment;

  /// No description provided for @noApartmentHelp.
  ///
  /// In fr, this message translates to:
  /// **'Commencez par créer un propriétaire, puis un immeuble, puis ses appartements.'**
  String get noApartmentHelp;

  /// No description provided for @pillApartments.
  ///
  /// In fr, this message translates to:
  /// **'appartements'**
  String get pillApartments;

  /// No description provided for @pillOccupied.
  ///
  /// In fr, this message translates to:
  /// **'occupés'**
  String get pillOccupied;

  /// No description provided for @pillFree.
  ///
  /// In fr, this message translates to:
  /// **'libres'**
  String get pillFree;

  /// No description provided for @floorN.
  ///
  /// In fr, this message translates to:
  /// **'Étage {floor}'**
  String floorN(String floor);

  /// No description provided for @free.
  ///
  /// In fr, this message translates to:
  /// **'Libre'**
  String get free;

  /// No description provided for @perMonth.
  ///
  /// In fr, this message translates to:
  /// **'/ mois'**
  String get perMonth;

  /// No description provided for @noBuilding.
  ///
  /// In fr, this message translates to:
  /// **'Aucun immeuble'**
  String get noBuilding;

  /// No description provided for @noBuildingHelp.
  ///
  /// In fr, this message translates to:
  /// **'Un immeuble regroupe les appartements d\'un propriétaire.'**
  String get noBuildingHelp;

  /// No description provided for @addressUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Adresse non renseignée'**
  String get addressUnknown;

  /// No description provided for @ownerIs.
  ///
  /// In fr, this message translates to:
  /// **'Propriétaire : {name}'**
  String ownerIs(String name);

  /// No description provided for @occupiedRatio.
  ///
  /// In fr, this message translates to:
  /// **'{occupied}/{total} occupés'**
  String occupiedRatio(String occupied, String total);

  /// No description provided for @noOwner.
  ///
  /// In fr, this message translates to:
  /// **'Aucun propriétaire'**
  String get noOwner;

  /// No description provided for @noOwnerHelp.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez le ou les propriétaires des biens gérés.'**
  String get noOwnerHelp;

  /// No description provided for @aptCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} appt(s)'**
  String aptCount(String count);

  /// No description provided for @newOwner.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau propriétaire'**
  String get newOwner;

  /// No description provided for @editOwner.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le propriétaire'**
  String get editOwner;

  /// No description provided for @ownerHasBuildings.
  ///
  /// In fr, this message translates to:
  /// **'Ce propriétaire possède des immeubles.'**
  String get ownerHasBuildings;

  /// No description provided for @deleteQ.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ?'**
  String get deleteQ;

  /// No description provided for @fullName.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get fullName;

  /// No description provided for @newBuilding.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel immeuble'**
  String get newBuilding;

  /// No description provided for @editBuilding.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'immeuble'**
  String get editBuilding;

  /// No description provided for @createOwnerFirst.
  ///
  /// In fr, this message translates to:
  /// **'Créez d\'abord le propriétaire de l\'immeuble.'**
  String get createOwnerFirst;

  /// No description provided for @createOwner.
  ///
  /// In fr, this message translates to:
  /// **'Créer un propriétaire'**
  String get createOwner;

  /// No description provided for @buildingHasApts.
  ///
  /// In fr, this message translates to:
  /// **'Cet immeuble contient des appartements.'**
  String get buildingHasApts;

  /// No description provided for @ownerRequired.
  ///
  /// In fr, this message translates to:
  /// **'Propriétaire *'**
  String get ownerRequired;

  /// No description provided for @chooseOwner.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un propriétaire'**
  String get chooseOwner;

  /// No description provided for @buildingName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'immeuble'**
  String get buildingName;

  /// No description provided for @buildingNameHint.
  ///
  /// In fr, this message translates to:
  /// **'ex. Résidence Les Palmiers'**
  String get buildingNameHint;

  /// No description provided for @newApartment.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel appartement'**
  String get newApartment;

  /// No description provided for @editApartment.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'appartement'**
  String get editApartment;

  /// No description provided for @aptNeedsBuilding.
  ///
  /// In fr, this message translates to:
  /// **'Un appartement appartient à un immeuble. Créez-en un d\'abord.'**
  String get aptNeedsBuilding;

  /// No description provided for @createBuilding.
  ///
  /// In fr, this message translates to:
  /// **'Créer un immeuble'**
  String get createBuilding;

  /// No description provided for @buildingRequired.
  ///
  /// In fr, this message translates to:
  /// **'Immeuble *'**
  String get buildingRequired;

  /// No description provided for @chooseBuilding.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un immeuble'**
  String get chooseBuilding;

  /// No description provided for @aptName.
  ///
  /// In fr, this message translates to:
  /// **'Nom / numéro'**
  String get aptName;

  /// No description provided for @aptNameHint.
  ///
  /// In fr, this message translates to:
  /// **'ex. A3, Studio 12'**
  String get aptNameHint;

  /// No description provided for @floor.
  ///
  /// In fr, this message translates to:
  /// **'Étage'**
  String get floor;

  /// No description provided for @description.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @aptDescHint.
  ///
  /// In fr, this message translates to:
  /// **'ex. 2 chambres, salon, cuisine'**
  String get aptDescHint;

  /// No description provided for @defaultRent.
  ///
  /// In fr, this message translates to:
  /// **'Loyer mensuel par défaut'**
  String get defaultRent;

  /// No description provided for @defaultDeposit.
  ///
  /// In fr, this message translates to:
  /// **'Caution par défaut'**
  String get defaultDeposit;

  /// No description provided for @metersToCreate.
  ///
  /// In fr, this message translates to:
  /// **'Compteurs à créer'**
  String get metersToCreate;

  /// No description provided for @newMeter.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau compteur'**
  String get newMeter;

  /// No description provided for @editMeter.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le compteur'**
  String get editMeter;

  /// No description provided for @typeRequired.
  ///
  /// In fr, this message translates to:
  /// **'Type *'**
  String get typeRequired;

  /// No description provided for @chooseType.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un type'**
  String get chooseType;

  /// No description provided for @serialNumber.
  ///
  /// In fr, this message translates to:
  /// **'N° de série'**
  String get serialNumber;

  /// No description provided for @indexInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Index invalide'**
  String get indexInvalid;

  /// No description provided for @deactivate.
  ///
  /// In fr, this message translates to:
  /// **'Désactiver'**
  String get deactivate;

  /// No description provided for @tabOngoing.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get tabOngoing;

  /// No description provided for @tabEnded.
  ///
  /// In fr, this message translates to:
  /// **'Terminées'**
  String get tabEnded;

  /// No description provided for @tenants.
  ///
  /// In fr, this message translates to:
  /// **'Locataires'**
  String get tenants;

  /// No description provided for @noActiveLease.
  ///
  /// In fr, this message translates to:
  /// **'Aucune location en cours'**
  String get noActiveLease;

  /// No description provided for @noEndedLease.
  ///
  /// In fr, this message translates to:
  /// **'Aucune location terminée'**
  String get noEndedLease;

  /// No description provided for @noActiveLeaseHelp.
  ///
  /// In fr, this message translates to:
  /// **'Créez un contrat pour attribuer un appartement libre à un locataire.'**
  String get noActiveLeaseHelp;

  /// No description provided for @leftOn.
  ///
  /// In fr, this message translates to:
  /// **'Sorti le {date}'**
  String leftOn(String date);

  /// No description provided for @dueAmount.
  ///
  /// In fr, this message translates to:
  /// **'Dû {amount}'**
  String dueAmount(String amount);

  /// No description provided for @advanceAmount.
  ///
  /// In fr, this message translates to:
  /// **'Avance {amount}'**
  String advanceAmount(String amount);

  /// No description provided for @toRefund.
  ///
  /// In fr, this message translates to:
  /// **'À rembourser'**
  String get toRefund;

  /// No description provided for @upToDate.
  ///
  /// In fr, this message translates to:
  /// **'À jour'**
  String get upToDate;

  /// No description provided for @noTenant.
  ///
  /// In fr, this message translates to:
  /// **'Aucun locataire'**
  String get noTenant;

  /// No description provided for @newTenant.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau locataire'**
  String get newTenant;

  /// No description provided for @tenantHasLeases.
  ///
  /// In fr, this message translates to:
  /// **'Ce locataire a des contrats : suppression impossible.'**
  String get tenantHasLeases;

  /// No description provided for @idNumber.
  ///
  /// In fr, this message translates to:
  /// **'N° pièce d\'identité'**
  String get idNumber;

  /// No description provided for @emergencyContact.
  ///
  /// In fr, this message translates to:
  /// **'Personne à prévenir'**
  String get emergencyContact;

  /// No description provided for @leases.
  ///
  /// In fr, this message translates to:
  /// **'Contrats'**
  String get leases;

  /// No description provided for @noLease.
  ///
  /// In fr, this message translates to:
  /// **'Aucun contrat.'**
  String get noLease;

  /// No description provided for @newLease.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle location'**
  String get newLease;

  /// No description provided for @noFreeApartment.
  ///
  /// In fr, this message translates to:
  /// **'Aucun appartement libre'**
  String get noFreeApartment;

  /// No description provided for @noFreeApartmentHelp.
  ///
  /// In fr, this message translates to:
  /// **'Tous les appartements sont occupés ou aucun n\'a été créé.'**
  String get noFreeApartmentHelp;

  /// No description provided for @editLease.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le contrat'**
  String get editLease;

  /// No description provided for @createLease.
  ///
  /// In fr, this message translates to:
  /// **'Créer le contrat'**
  String get createLease;

  /// No description provided for @aptAndTenant.
  ///
  /// In fr, this message translates to:
  /// **'Appartement et locataire'**
  String get aptAndTenant;

  /// No description provided for @apartmentRequired.
  ///
  /// In fr, this message translates to:
  /// **'Appartement *'**
  String get apartmentRequired;

  /// No description provided for @chooseApartment.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un appartement'**
  String get chooseApartment;

  /// No description provided for @tenantRequired.
  ///
  /// In fr, this message translates to:
  /// **'Locataire *'**
  String get tenantRequired;

  /// No description provided for @chooseTenant.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un locataire'**
  String get chooseTenant;

  /// No description provided for @conditions.
  ///
  /// In fr, this message translates to:
  /// **'Conditions'**
  String get conditions;

  /// No description provided for @entryDate.
  ///
  /// In fr, this message translates to:
  /// **'Date d\'entrée'**
  String get entryDate;

  /// No description provided for @initialTermEndOptional.
  ///
  /// In fr, this message translates to:
  /// **'Fin de la période initiale (facultatif)'**
  String get initialTermEndOptional;

  /// No description provided for @tacitRenewal.
  ///
  /// In fr, this message translates to:
  /// **'Reconduction tacite'**
  String get tacitRenewal;

  /// No description provided for @tacitOnHelp.
  ///
  /// In fr, this message translates to:
  /// **'À l\'échéance, le bail est prolongé d\'une période de même durée.'**
  String get tacitOnHelp;

  /// No description provided for @tacitOffHelp.
  ///
  /// In fr, this message translates to:
  /// **'Le bail sera signalé comme échu, mais reste actif jusqu\'à sa clôture.'**
  String get tacitOffHelp;

  /// No description provided for @monthlyRent.
  ///
  /// In fr, this message translates to:
  /// **'Loyer mensuel'**
  String get monthlyRent;

  /// No description provided for @depositRequired.
  ///
  /// In fr, this message translates to:
  /// **'Caution exigée'**
  String get depositRequired;

  /// No description provided for @depositPaid.
  ///
  /// In fr, this message translates to:
  /// **'Caution effectivement versée'**
  String get depositPaid;

  /// No description provided for @firstMonthProrata.
  ///
  /// In fr, this message translates to:
  /// **'Premier mois au prorata'**
  String get firstMonthProrata;

  /// No description provided for @firstMonthProrataOn.
  ///
  /// In fr, this message translates to:
  /// **'Le loyer du mois d\'entrée est calculé au nombre de jours.'**
  String get firstMonthProrataOn;

  /// No description provided for @firstMonthProrataOff.
  ///
  /// In fr, this message translates to:
  /// **'Le locataire paie le mois d\'entrée en entier.'**
  String get firstMonthProrataOff;

  /// No description provided for @services.
  ///
  /// In fr, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @noServices.
  ///
  /// In fr, this message translates to:
  /// **'Aucun service (parking, gardiennage…).'**
  String get noServices;

  /// No description provided for @service.
  ///
  /// In fr, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @serviceQtySummary.
  ///
  /// In fr, this message translates to:
  /// **'{qty} au total, {included} inclus → {billed} facturé(s)'**
  String serviceQtySummary(String qty, String included, String billed);

  /// No description provided for @amountPerMonth.
  ///
  /// In fr, this message translates to:
  /// **'{amount}/mois'**
  String amountPerMonth(String amount);

  /// No description provided for @entryReadings.
  ///
  /// In fr, this message translates to:
  /// **'Index d\'entrée'**
  String get entryReadings;

  /// No description provided for @entryReadingHint.
  ///
  /// In fr, this message translates to:
  /// **'Laisser vide pour utiliser le dernier index connu'**
  String get entryReadingHint;

  /// No description provided for @serviceRequired.
  ///
  /// In fr, this message translates to:
  /// **'Service *'**
  String get serviceRequired;

  /// No description provided for @chooseService.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un service'**
  String get chooseService;

  /// No description provided for @totalQuantity.
  ///
  /// In fr, this message translates to:
  /// **'Quantité totale'**
  String get totalQuantity;

  /// No description provided for @includedQuantity.
  ///
  /// In fr, this message translates to:
  /// **'Dont inclus'**
  String get includedQuantity;

  /// No description provided for @number.
  ///
  /// In fr, this message translates to:
  /// **'Nombre'**
  String get number;

  /// No description provided for @extraUnitPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix par unité supplémentaire / mois'**
  String get extraUnitPrice;

  /// No description provided for @extraUnitHelp.
  ///
  /// In fr, this message translates to:
  /// **'ex. 3 véhicules dont 1 autorisé → 2 facturés'**
  String get extraUnitHelp;

  /// No description provided for @tenantSheet.
  ///
  /// In fr, this message translates to:
  /// **'Fiche locataire'**
  String get tenantSheet;

  /// No description provided for @apartmentSheet.
  ///
  /// In fr, this message translates to:
  /// **'Fiche appartement'**
  String get apartmentSheet;

  /// No description provided for @entryInspection.
  ///
  /// In fr, this message translates to:
  /// **'État des lieux d\'entrée'**
  String get entryInspection;

  /// No description provided for @exitInspection.
  ///
  /// In fr, this message translates to:
  /// **'État des lieux de sortie'**
  String get exitInspection;

  /// No description provided for @statusOngoingCaps.
  ///
  /// In fr, this message translates to:
  /// **'EN COURS'**
  String get statusOngoingCaps;

  /// No description provided for @statusEndedCaps.
  ///
  /// In fr, this message translates to:
  /// **'TERMINÉ'**
  String get statusEndedCaps;

  /// No description provided for @remainingToPay.
  ///
  /// In fr, this message translates to:
  /// **'Reste à payer'**
  String get remainingToPay;

  /// No description provided for @tenantAdvance.
  ///
  /// In fr, this message translates to:
  /// **'Avance du locataire'**
  String get tenantAdvance;

  /// No description provided for @refundToTenant.
  ///
  /// In fr, this message translates to:
  /// **'À rembourser au locataire'**
  String get refundToTenant;

  /// No description provided for @accountUpToDate.
  ///
  /// In fr, this message translates to:
  /// **'Compte à jour'**
  String get accountUpToDate;

  /// No description provided for @refund.
  ///
  /// In fr, this message translates to:
  /// **'Rembourser'**
  String get refund;

  /// No description provided for @endLease.
  ///
  /// In fr, this message translates to:
  /// **'Mettre fin au contrat'**
  String get endLease;

  /// No description provided for @endLeaseHelp.
  ///
  /// In fr, this message translates to:
  /// **'Index de sortie, état des lieux, caution et solde'**
  String get endLeaseHelp;

  /// No description provided for @exitDocument.
  ///
  /// In fr, this message translates to:
  /// **'Document de fin de contrat'**
  String get exitDocument;

  /// No description provided for @exitDocumentHelp.
  ///
  /// In fr, this message translates to:
  /// **'Détail complet et solde final'**
  String get exitDocumentHelp;

  /// No description provided for @lease.
  ///
  /// In fr, this message translates to:
  /// **'Contrat'**
  String get lease;

  /// No description provided for @moveIn.
  ///
  /// In fr, this message translates to:
  /// **'Entrée'**
  String get moveIn;

  /// No description provided for @moveOut.
  ///
  /// In fr, this message translates to:
  /// **'Sortie'**
  String get moveOut;

  /// No description provided for @depositPaidShort.
  ///
  /// In fr, this message translates to:
  /// **'Caution versée'**
  String get depositPaidShort;

  /// No description provided for @firstMonth.
  ///
  /// In fr, this message translates to:
  /// **'Premier mois'**
  String get firstMonth;

  /// No description provided for @lastMonth.
  ///
  /// In fr, this message translates to:
  /// **'Dernier mois'**
  String get lastMonth;

  /// No description provided for @prorated.
  ///
  /// In fr, this message translates to:
  /// **'Au prorata'**
  String get prorated;

  /// No description provided for @fullMonth.
  ///
  /// In fr, this message translates to:
  /// **'Mois complet'**
  String get fullMonth;

  /// No description provided for @damagesRetained.
  ///
  /// In fr, this message translates to:
  /// **'Dégâts retenus'**
  String get damagesRetained;

  /// No description provided for @serviceLine.
  ///
  /// In fr, this message translates to:
  /// **'{qty} ({included} inclus) · {price}'**
  String serviceLine(String qty, String included, String price);

  /// No description provided for @totalBilled.
  ///
  /// In fr, this message translates to:
  /// **'Total facturé'**
  String get totalBilled;

  /// No description provided for @totalPaid.
  ///
  /// In fr, this message translates to:
  /// **'Total payé'**
  String get totalPaid;

  /// No description provided for @invoicesCount.
  ///
  /// In fr, this message translates to:
  /// **'Factures ({count})'**
  String invoicesCount(String count);

  /// No description provided for @noInvoiceYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucune facture. Elles sont générées depuis l\'onglet Relevés.'**
  String get noInvoiceYet;

  /// No description provided for @paymentsCount.
  ///
  /// In fr, this message translates to:
  /// **'Paiements ({count})'**
  String paymentsCount(String count);

  /// No description provided for @noPayment.
  ///
  /// In fr, this message translates to:
  /// **'Aucun paiement enregistré.'**
  String get noPayment;

  /// No description provided for @initialTermEnd.
  ///
  /// In fr, this message translates to:
  /// **'Fin de la période initiale'**
  String get initialTermEnd;

  /// No description provided for @renewal.
  ///
  /// In fr, this message translates to:
  /// **'Reconduction'**
  String get renewal;

  /// No description provided for @renewalTacit.
  ///
  /// In fr, this message translates to:
  /// **'Tacite'**
  String get renewalTacit;

  /// No description provided for @renewedTimes.
  ///
  /// In fr, this message translates to:
  /// **'Tacite · reconduit {count} fois'**
  String renewedTimes(String count);

  /// No description provided for @no.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get no;

  /// No description provided for @nextDeadline.
  ///
  /// In fr, this message translates to:
  /// **'Prochaine échéance'**
  String get nextDeadline;

  /// No description provided for @leaseExpired.
  ///
  /// In fr, this message translates to:
  /// **'Bail échu : le locataire est toujours en place, à renouveler ou clôturer'**
  String get leaseExpired;

  /// No description provided for @closeLeaseQ.
  ///
  /// In fr, this message translates to:
  /// **'Clôturer le contrat ?'**
  String get closeLeaseQ;

  /// No description provided for @closeLeaseHelp.
  ///
  /// In fr, this message translates to:
  /// **'La facture de sortie sera créée, la caution imputée et l\'appartement libéré. Cette action est définitive.'**
  String get closeLeaseHelp;

  /// No description provided for @closeAction.
  ///
  /// In fr, this message translates to:
  /// **'Clôturer'**
  String get closeAction;

  /// No description provided for @endOfLease.
  ///
  /// In fr, this message translates to:
  /// **'Fin de contrat'**
  String get endOfLease;

  /// No description provided for @placeSince.
  ///
  /// In fr, this message translates to:
  /// **'{place} · depuis le {date}'**
  String placeSince(String place, String date);

  /// No description provided for @exit.
  ///
  /// In fr, this message translates to:
  /// **'Sortie'**
  String get exit;

  /// No description provided for @exitDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de sortie'**
  String get exitDate;

  /// No description provided for @lastMonthProrata.
  ///
  /// In fr, this message translates to:
  /// **'Dernier mois au prorata'**
  String get lastMonthProrata;

  /// No description provided for @lastMonthProrataOn.
  ///
  /// In fr, this message translates to:
  /// **'Le locataire paie uniquement les jours occupés ({days} j).'**
  String lastMonthProrataOn(String days);

  /// No description provided for @lastMonthProrataOff.
  ///
  /// In fr, this message translates to:
  /// **'Le locataire paie le mois complet.'**
  String get lastMonthProrataOff;

  /// No description provided for @exitReadings.
  ///
  /// In fr, this message translates to:
  /// **'Index de sortie'**
  String get exitReadings;

  /// No description provided for @lastBilledHint.
  ///
  /// In fr, this message translates to:
  /// **'Dernier facturé : {value}'**
  String lastBilledHint(String value);

  /// No description provided for @indexRequired.
  ///
  /// In fr, this message translates to:
  /// **'Index obligatoire'**
  String get indexRequired;

  /// No description provided for @lowerThanLast.
  ///
  /// In fr, this message translates to:
  /// **'Inférieur au dernier index ({value})'**
  String lowerThanLast(String value);

  /// No description provided for @inspectionAndDamages.
  ///
  /// In fr, this message translates to:
  /// **'État des lieux et dégâts'**
  String get inspectionAndDamages;

  /// No description provided for @roomByRoomOptional.
  ///
  /// In fr, this message translates to:
  /// **'Détail pièce par pièce (facultatif)'**
  String get roomByRoomOptional;

  /// No description provided for @totalDamages.
  ///
  /// In fr, this message translates to:
  /// **'Montant total des dégâts'**
  String get totalDamages;

  /// No description provided for @deductedFromDeposit.
  ///
  /// In fr, this message translates to:
  /// **'Déduit de la caution de {amount}'**
  String deductedFromDeposit(String amount);

  /// No description provided for @observations.
  ///
  /// In fr, this message translates to:
  /// **'Observations'**
  String get observations;

  /// No description provided for @statement.
  ///
  /// In fr, this message translates to:
  /// **'Décompte'**
  String get statement;

  /// No description provided for @exitInvoiceTotal.
  ///
  /// In fr, this message translates to:
  /// **'Total facture de sortie'**
  String get exitInvoiceTotal;

  /// No description provided for @previousBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde antérieur'**
  String get previousBalance;

  /// No description provided for @tenantStillOwes.
  ///
  /// In fr, this message translates to:
  /// **'Le locataire doit encore'**
  String get tenantStillOwes;

  /// No description provided for @accountSettled.
  ///
  /// In fr, this message translates to:
  /// **'Compte soldé'**
  String get accountSettled;

  /// No description provided for @depositInsufficient.
  ///
  /// In fr, this message translates to:
  /// **'La caution est insuffisante : le reste sera à régler par le locataire.'**
  String get depositInsufficient;

  /// No description provided for @computeStatement.
  ///
  /// In fr, this message translates to:
  /// **'Calculer le décompte'**
  String get computeStatement;

  /// No description provided for @closeLease.
  ///
  /// In fr, this message translates to:
  /// **'Clôturer le contrat'**
  String get closeLease;

  /// No description provided for @noItem.
  ///
  /// In fr, this message translates to:
  /// **'Aucun élément'**
  String get noItem;

  /// No description provided for @exitInspectionHelp.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez les dégâts constatés pièce par pièce, avec leur coût.'**
  String get exitInspectionHelp;

  /// No description provided for @entryInspectionHelp.
  ///
  /// In fr, this message translates to:
  /// **'Facultatif : décrivez l\'état de chaque pièce à l\'entrée.'**
  String get entryInspectionHelp;

  /// No description provided for @damagesTotal.
  ///
  /// In fr, this message translates to:
  /// **'Total des dégâts'**
  String get damagesTotal;

  /// No description provided for @item.
  ///
  /// In fr, this message translates to:
  /// **'Élément'**
  String get item;

  /// No description provided for @newItemInspection.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel élément'**
  String get newItemInspection;

  /// No description provided for @whichRoom.
  ///
  /// In fr, this message translates to:
  /// **'1. Dans quelle pièce ?'**
  String get whichRoom;

  /// No description provided for @chooseRoom.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez la pièce'**
  String get chooseRoom;

  /// No description provided for @otherRoom.
  ///
  /// In fr, this message translates to:
  /// **'Autre pièce'**
  String get otherRoom;

  /// No description provided for @whichItem.
  ///
  /// In fr, this message translates to:
  /// **'2. Quel élément ?'**
  String get whichItem;

  /// No description provided for @entryWas.
  ///
  /// In fr, this message translates to:
  /// **'{item} (entrée : {condition})'**
  String entryWas(String item, String condition);

  /// No description provided for @itemName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'élément constaté'**
  String get itemName;

  /// No description provided for @itemNameHint.
  ///
  /// In fr, this message translates to:
  /// **'ex. Climatiseur Samsung, porte d\'entrée, lustre'**
  String get itemNameHint;

  /// No description provided for @conditionNoted.
  ///
  /// In fr, this message translates to:
  /// **'3. État constaté'**
  String get conditionNoted;

  /// No description provided for @comment.
  ///
  /// In fr, this message translates to:
  /// **'Commentaire'**
  String get comment;

  /// No description provided for @repairCost.
  ///
  /// In fr, this message translates to:
  /// **'Coût de réparation'**
  String get repairCost;

  /// No description provided for @photo.
  ///
  /// In fr, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @retake.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre'**
  String get retake;

  /// No description provided for @newRoom.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle pièce'**
  String get newRoom;

  /// No description provided for @newRoomHint.
  ///
  /// In fr, this message translates to:
  /// **'ex. Chambre parentale, buanderie'**
  String get newRoomHint;

  /// No description provided for @benefitApplied.
  ///
  /// In fr, this message translates to:
  /// **'Appliqué'**
  String get benefitApplied;

  /// No description provided for @benefitUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get benefitUpcoming;

  /// No description provided for @benefitSuspended.
  ///
  /// In fr, this message translates to:
  /// **'Suspendu'**
  String get benefitSuspended;

  /// No description provided for @leaseStart.
  ///
  /// In fr, this message translates to:
  /// **'Début du bail'**
  String get leaseStart;

  /// No description provided for @noLimit.
  ///
  /// In fr, this message translates to:
  /// **'sans limite'**
  String get noLimit;

  /// No description provided for @benefits.
  ///
  /// In fr, this message translates to:
  /// **'Avantages'**
  String get benefits;

  /// No description provided for @noBenefit.
  ///
  /// In fr, this message translates to:
  /// **'Aucun avantage. Exemple : employé ENEO exonéré d\'électricité.'**
  String get noBenefit;

  /// No description provided for @suspendFrom.
  ///
  /// In fr, this message translates to:
  /// **'Suspendre à partir de…'**
  String get suspendFrom;

  /// No description provided for @resumeFrom.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre à partir de…'**
  String get resumeFrom;

  /// No description provided for @benefitSuspendedFrom.
  ///
  /// In fr, this message translates to:
  /// **'Avantage suspendu à partir de {month}'**
  String benefitSuspendedFrom(String month);

  /// No description provided for @benefitResumedFrom.
  ///
  /// In fr, this message translates to:
  /// **'Avantage repris à partir de {month}'**
  String benefitResumedFrom(String month);

  /// No description provided for @deleteBenefitQ.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'avantage ?'**
  String get deleteBenefitQ;

  /// No description provided for @deleteBenefitHelp.
  ///
  /// In fr, this message translates to:
  /// **'Les factures verrouillées ne changent pas. Les factures modifiables seront à recalculer.'**
  String get deleteBenefitHelp;

  /// No description provided for @reasonEneo.
  ///
  /// In fr, this message translates to:
  /// **'Employé ENEO'**
  String get reasonEneo;

  /// No description provided for @reasonCamwater.
  ///
  /// In fr, this message translates to:
  /// **'Employé CAMWATER'**
  String get reasonCamwater;

  /// No description provided for @reasonOwner.
  ///
  /// In fr, this message translates to:
  /// **'Accord du propriétaire'**
  String get reasonOwner;

  /// No description provided for @reasonGoodwill.
  ///
  /// In fr, this message translates to:
  /// **'Geste commercial'**
  String get reasonGoodwill;

  /// No description provided for @reasonCaretaker.
  ///
  /// In fr, this message translates to:
  /// **'Gardien de l\'immeuble'**
  String get reasonCaretaker;

  /// No description provided for @newBenefit.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel avantage'**
  String get newBenefit;

  /// No description provided for @editBenefit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'avantage'**
  String get editBenefit;

  /// No description provided for @chargeRequired.
  ///
  /// In fr, this message translates to:
  /// **'Charge concernée *'**
  String get chargeRequired;

  /// No description provided for @chooseCharge.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez la charge'**
  String get chooseCharge;

  /// No description provided for @units.
  ///
  /// In fr, this message translates to:
  /// **'Unités'**
  String get units;

  /// No description provided for @amount.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get amount;

  /// No description provided for @percentHelp.
  ///
  /// In fr, this message translates to:
  /// **'Pourcentage de la charge offert (100 % = exonération totale).'**
  String get percentHelp;

  /// No description provided for @unitsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Nombre d\'unités offertes chaque mois ; le surplus est facturé.'**
  String get unitsHelp;

  /// No description provided for @fixedHelp.
  ///
  /// In fr, this message translates to:
  /// **'Montant déduit chaque mois de cette charge.'**
  String get fixedHelp;

  /// No description provided for @amountPerMonthOff.
  ///
  /// In fr, this message translates to:
  /// **'Montant déduit par mois'**
  String get amountPerMonthOff;

  /// No description provided for @percentage.
  ///
  /// In fr, this message translates to:
  /// **'Pourcentage'**
  String get percentage;

  /// No description provided for @freeUnitsPerMonth.
  ///
  /// In fr, this message translates to:
  /// **'Unités gratuites par mois'**
  String get freeUnitsPerMonth;

  /// No description provided for @valueInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Valeur invalide'**
  String get valueInvalid;

  /// No description provided for @max100.
  ///
  /// In fr, this message translates to:
  /// **'100 % maximum'**
  String get max100;

  /// No description provided for @reason.
  ///
  /// In fr, this message translates to:
  /// **'Motif'**
  String get reason;

  /// No description provided for @reasonHint.
  ///
  /// In fr, this message translates to:
  /// **'ex. Employé ENEO'**
  String get reasonHint;

  /// No description provided for @fromLabel.
  ///
  /// In fr, this message translates to:
  /// **'Depuis : {value}'**
  String fromLabel(String value);

  /// No description provided for @toLabel.
  ///
  /// In fr, this message translates to:
  /// **'Jusqu\'à : {value}'**
  String toLabel(String value);

  /// No description provided for @leaseStartLower.
  ///
  /// In fr, this message translates to:
  /// **'début du bail'**
  String get leaseStartLower;

  /// No description provided for @noEndDate.
  ///
  /// In fr, this message translates to:
  /// **'Sans date de fin'**
  String get noEndDate;

  /// No description provided for @endAfterStart.
  ///
  /// In fr, this message translates to:
  /// **'La fin doit être après le début.'**
  String get endAfterStart;

  /// No description provided for @benefitSaved.
  ///
  /// In fr, this message translates to:
  /// **'Avantage enregistré. Recalculez les factures non verrouillées si besoin.'**
  String get benefitSaved;

  /// No description provided for @invoices.
  ///
  /// In fr, this message translates to:
  /// **'Factures'**
  String get invoices;

  /// No description provided for @payments.
  ///
  /// In fr, this message translates to:
  /// **'Paiements'**
  String get payments;

  /// No description provided for @noInvoiceThisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Aucune facture ce mois-ci'**
  String get noInvoiceThisMonth;

  /// No description provided for @noInvoiceThisMonthHelp.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez les relevés du mois puis générez les factures depuis l\'onglet Relevés.'**
  String get noInvoiceThisMonthHelp;

  /// No description provided for @remaining.
  ///
  /// In fr, this message translates to:
  /// **'Reste'**
  String get remaining;

  /// No description provided for @filterAll.
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get filterAll;

  /// No description provided for @filterUnpaid.
  ///
  /// In fr, this message translates to:
  /// **'Impayées'**
  String get filterUnpaid;

  /// No description provided for @filterPaid.
  ///
  /// In fr, this message translates to:
  /// **'Payées'**
  String get filterPaid;

  /// No description provided for @downloadAllInvoices.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger toutes les factures (PDF)'**
  String get downloadAllInvoices;

  /// No description provided for @invoicesOfMonth.
  ///
  /// In fr, this message translates to:
  /// **'Factures {month}'**
  String invoicesOfMonth(String month);

  /// No description provided for @noPaymentThisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Aucun paiement ce mois-ci'**
  String get noPaymentThisMonth;

  /// No description provided for @totalCollected.
  ///
  /// In fr, this message translates to:
  /// **'Total encaissé'**
  String get totalCollected;

  /// No description provided for @overdue.
  ///
  /// In fr, this message translates to:
  /// **'En retard'**
  String get overdue;

  /// No description provided for @remainingAmount.
  ///
  /// In fr, this message translates to:
  /// **'reste {amount}'**
  String remainingAmount(String amount);

  /// No description provided for @depositApplied.
  ///
  /// In fr, this message translates to:
  /// **'Caution imputée'**
  String get depositApplied;

  /// No description provided for @refundKind.
  ///
  /// In fr, this message translates to:
  /// **'Remboursement'**
  String get refundKind;

  /// No description provided for @refundReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Reçu de remboursement'**
  String get refundReceipt;

  /// No description provided for @invoiceNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Facture introuvable'**
  String get invoiceNotFound;

  /// No description provided for @recalculate.
  ///
  /// In fr, this message translates to:
  /// **'Recalculer'**
  String get recalculate;

  /// No description provided for @invoiceRecalculated.
  ///
  /// In fr, this message translates to:
  /// **'Facture recalculée'**
  String get invoiceRecalculated;

  /// No description provided for @recalculatedWarnings.
  ///
  /// In fr, this message translates to:
  /// **'Recalculée · {count} avertissement(s)'**
  String recalculatedWarnings(String count);

  /// No description provided for @deleteInvoiceQ.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la facture ?'**
  String get deleteInvoiceQ;

  /// No description provided for @locked.
  ///
  /// In fr, this message translates to:
  /// **'Verrouillée'**
  String get locked;

  /// No description provided for @editable.
  ///
  /// In fr, this message translates to:
  /// **'Modifiable'**
  String get editable;

  /// No description provided for @remainingToPayAmount.
  ///
  /// In fr, this message translates to:
  /// **'Reste à payer : {amount}'**
  String remainingToPayAmount(String amount);

  /// No description provided for @period.
  ///
  /// In fr, this message translates to:
  /// **'Période'**
  String get period;

  /// No description provided for @type.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @exitInvoice.
  ///
  /// In fr, this message translates to:
  /// **'Facture de sortie'**
  String get exitInvoice;

  /// No description provided for @monthly.
  ///
  /// In fr, this message translates to:
  /// **'Mensuelle'**
  String get monthly;

  /// No description provided for @issuedOn.
  ///
  /// In fr, this message translates to:
  /// **'Émise le'**
  String get issuedOn;

  /// No description provided for @dueDate.
  ///
  /// In fr, this message translates to:
  /// **'Échéance'**
  String get dueDate;

  /// No description provided for @detail.
  ///
  /// In fr, this message translates to:
  /// **'Détail'**
  String get detail;

  /// No description provided for @ofWhichVat.
  ///
  /// In fr, this message translates to:
  /// **'dont TVA'**
  String get ofWhichVat;

  /// No description provided for @total.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @exitInvoiceFinal.
  ///
  /// In fr, this message translates to:
  /// **'Facture de sortie : définitive.'**
  String get exitInvoiceFinal;

  /// No description provided for @laterMonthBilled.
  ///
  /// In fr, this message translates to:
  /// **'Un mois ultérieur a été facturé : cette facture est définitive.'**
  String get laterMonthBilled;

  /// No description provided for @pdf.
  ///
  /// In fr, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @collectPayment.
  ///
  /// In fr, this message translates to:
  /// **'Encaisser un paiement'**
  String get collectPayment;

  /// No description provided for @saveRefund.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer le remboursement'**
  String get saveRefund;

  /// No description provided for @savePayment.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer le paiement'**
  String get savePayment;

  /// No description provided for @refundSaved.
  ///
  /// In fr, this message translates to:
  /// **'Remboursement enregistré'**
  String get refundSaved;

  /// No description provided for @paymentSaved.
  ///
  /// In fr, this message translates to:
  /// **'Paiement enregistré'**
  String get paymentSaved;

  /// No description provided for @receiptNo.
  ///
  /// In fr, this message translates to:
  /// **'Reçu n° {number}'**
  String receiptNo(String number);

  /// No description provided for @viewRefundReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Voir le reçu'**
  String get viewRefundReceipt;

  /// No description provided for @viewReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Voir la quittance'**
  String get viewReceipt;

  /// No description provided for @balanceDue.
  ///
  /// In fr, this message translates to:
  /// **'Solde dû'**
  String get balanceDue;

  /// No description provided for @inTenantFavor.
  ///
  /// In fr, this message translates to:
  /// **'En faveur du locataire'**
  String get inTenantFavor;

  /// No description provided for @amountReceived.
  ///
  /// In fr, this message translates to:
  /// **'Montant reçu'**
  String get amountReceived;

  /// No description provided for @paymentDate.
  ///
  /// In fr, this message translates to:
  /// **'Date du paiement'**
  String get paymentDate;

  /// No description provided for @referenceHint.
  ///
  /// In fr, this message translates to:
  /// **'Référence (transaction, chèque…)'**
  String get referenceHint;

  /// No description provided for @invoicesFor.
  ///
  /// In fr, this message translates to:
  /// **'Factures de {month}'**
  String invoicesFor(String month);

  /// No description provided for @generationSummary.
  ///
  /// In fr, this message translates to:
  /// **'{created} créée(s), {updated} mise(s) à jour.'**
  String generationSummary(String created, String updated);

  /// No description provided for @generationSummaryLocked.
  ///
  /// In fr, this message translates to:
  /// **'{created} créée(s), {updated} mise(s) à jour, {locked} verrouillée(s) non modifiée(s).'**
  String generationSummaryLocked(String created, String updated, String locked);

  /// No description provided for @warnings.
  ///
  /// In fr, this message translates to:
  /// **'Avertissements :'**
  String get warnings;

  /// No description provided for @viewInvoices.
  ///
  /// In fr, this message translates to:
  /// **'Voir les factures'**
  String get viewInvoices;

  /// No description provided for @exportMonthReadings.
  ///
  /// In fr, this message translates to:
  /// **'Exporter les relevés du mois'**
  String get exportMonthReadings;

  /// No description provided for @noMeter.
  ///
  /// In fr, this message translates to:
  /// **'Aucun compteur'**
  String get noMeter;

  /// No description provided for @noMeterHelp.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez des compteurs aux appartements (onglet Biens) pour saisir les relevés.'**
  String get noMeterHelp;

  /// No description provided for @metersRead.
  ///
  /// In fr, this message translates to:
  /// **'compteurs relevés'**
  String get metersRead;

  /// No description provided for @photosCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} photo(s)'**
  String photosCount(String count);

  /// No description provided for @generateInvoices.
  ///
  /// In fr, this message translates to:
  /// **'Générer les factures'**
  String get generateInvoices;

  /// No description provided for @previousValue.
  ///
  /// In fr, this message translates to:
  /// **'Précédent : {value}'**
  String previousValue(String value);

  /// No description provided for @noPhoto.
  ///
  /// In fr, this message translates to:
  /// **'Sans photo'**
  String get noPhoto;

  /// No description provided for @previous.
  ///
  /// In fr, this message translates to:
  /// **'Précédent'**
  String get previous;

  /// No description provided for @readingLocked.
  ///
  /// In fr, this message translates to:
  /// **'Un relevé plus récent existe : ce relevé est verrouillé.'**
  String get readingLocked;

  /// No description provided for @newReading.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel index'**
  String get newReading;

  /// No description provided for @readingLowerThanPrevious.
  ///
  /// In fr, this message translates to:
  /// **'Index inférieur au précédent'**
  String get readingLowerThanPrevious;

  /// No description provided for @anomalyHelp.
  ///
  /// In fr, this message translates to:
  /// **'⚠ Consommation plus de 2× supérieure à la moyenne ({average})'**
  String anomalyHelp(String average);

  /// No description provided for @photographMeter.
  ///
  /// In fr, this message translates to:
  /// **'Photographier le compteur'**
  String get photographMeter;

  /// No description provided for @retakePhoto.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre la photo'**
  String get retakePhoto;

  /// No description provided for @readingDate.
  ///
  /// In fr, this message translates to:
  /// **'Date du relevé'**
  String get readingDate;

  /// No description provided for @noPhotoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune photo'**
  String get noPhotoTitle;

  /// No description provided for @saveWithoutPhoto.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer ce relevé sans photo du compteur ?'**
  String get saveWithoutPhoto;

  /// No description provided for @restoreQ.
  ///
  /// In fr, this message translates to:
  /// **'Restaurer cette sauvegarde ?'**
  String get restoreQ;

  /// No description provided for @restoreHelp.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les données actuelles seront remplacées. Une sauvegarde de sécurité de l\'état actuel est créée automatiquement avant.'**
  String get restoreHelp;

  /// No description provided for @restore.
  ///
  /// In fr, this message translates to:
  /// **'Restaurer'**
  String get restore;

  /// No description provided for @backup.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde'**
  String get backup;

  /// No description provided for @backupHelp.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les données restent sur ce téléphone. Créez régulièrement une sauvegarde et envoyez-la ailleurs (Drive, e-mail, WhatsApp, clé USB) : en cas de perte du téléphone, c\'est votre seule copie.'**
  String get backupHelp;

  /// No description provided for @backupShareText.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde NHimmo'**
  String get backupShareText;

  /// No description provided for @createShareBackup.
  ///
  /// In fr, this message translates to:
  /// **'Créer et partager une sauvegarde'**
  String get createShareBackup;

  /// No description provided for @chooseBackupFile.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une sauvegarde NHimmo (.zip)'**
  String get chooseBackupFile;

  /// No description provided for @restoreFromFile.
  ///
  /// In fr, this message translates to:
  /// **'Restaurer depuis un fichier'**
  String get restoreFromFile;

  /// No description provided for @localBackups.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegardes sur ce téléphone'**
  String get localBackups;

  /// No description provided for @noLocalBackup.
  ///
  /// In fr, this message translates to:
  /// **'Aucune sauvegarde locale.'**
  String get noLocalBackup;

  /// No description provided for @sizeKb.
  ///
  /// In fr, this message translates to:
  /// **'{size} Ko'**
  String sizeKb(String size);

  /// No description provided for @share.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get share;

  /// No description provided for @meterTypes.
  ///
  /// In fr, this message translates to:
  /// **'Types de compteurs'**
  String get meterTypes;

  /// No description provided for @meterTypesHelp.
  ///
  /// In fr, this message translates to:
  /// **'Un seul calcul pour tous : consommation × prix unitaire + entretien, TVA selon le mode choisi. Pour fournir du gaz, ajoutez simplement un type « Gaz ».'**
  String get meterTypesHelp;

  /// No description provided for @inactive.
  ///
  /// In fr, this message translates to:
  /// **'Inactif'**
  String get inactive;

  /// No description provided for @pricePerUnit.
  ///
  /// In fr, this message translates to:
  /// **'{price} / {unit}'**
  String pricePerUnit(String price, String unit);

  /// No description provided for @maintenanceShort.
  ///
  /// In fr, this message translates to:
  /// **'entretien {amount}'**
  String maintenanceShort(String amount);

  /// No description provided for @withRate.
  ///
  /// In fr, this message translates to:
  /// **'{mode} ({rate} %)'**
  String withRate(String mode, String rate);

  /// No description provided for @newType.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau type'**
  String get newType;

  /// No description provided for @newMeterType.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau type de compteur'**
  String get newMeterType;

  /// No description provided for @name.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get name;

  /// No description provided for @gasHint.
  ///
  /// In fr, this message translates to:
  /// **'ex. Gaz'**
  String get gasHint;

  /// No description provided for @unitOfMeasure.
  ///
  /// In fr, this message translates to:
  /// **'Unité de mesure'**
  String get unitOfMeasure;

  /// No description provided for @unitHint.
  ///
  /// In fr, this message translates to:
  /// **'ex. m³, kWh'**
  String get unitHint;

  /// No description provided for @tariff.
  ///
  /// In fr, this message translates to:
  /// **'Tarif'**
  String get tariff;

  /// No description provided for @unitPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix par unité'**
  String get unitPrice;

  /// No description provided for @meterFee.
  ///
  /// In fr, this message translates to:
  /// **'Entretien / location compteur (par mois)'**
  String get meterFee;

  /// No description provided for @vat.
  ///
  /// In fr, this message translates to:
  /// **'TVA'**
  String get vat;

  /// No description provided for @vatNoneShort.
  ///
  /// In fr, this message translates to:
  /// **'Aucune'**
  String get vatNoneShort;

  /// No description provided for @vatIncludedCap.
  ///
  /// In fr, this message translates to:
  /// **'Incluse'**
  String get vatIncludedCap;

  /// No description provided for @vatAddedCap.
  ///
  /// In fr, this message translates to:
  /// **'En sus'**
  String get vatAddedCap;

  /// No description provided for @vatRate.
  ///
  /// In fr, this message translates to:
  /// **'Taux de TVA'**
  String get vatRate;

  /// No description provided for @rateRequired.
  ///
  /// In fr, this message translates to:
  /// **'Taux obligatoire'**
  String get rateRequired;

  /// No description provided for @vatOnFee.
  ///
  /// In fr, this message translates to:
  /// **'TVA aussi sur l\'entretien'**
  String get vatOnFee;

  /// No description provided for @simulation.
  ///
  /// In fr, this message translates to:
  /// **'Simulation'**
  String get simulation;

  /// No description provided for @excludingTax.
  ///
  /// In fr, this message translates to:
  /// **'Hors taxe'**
  String get excludingTax;

  /// No description provided for @totalCharged.
  ///
  /// In fr, this message translates to:
  /// **'Total facturé'**
  String get totalCharged;

  /// No description provided for @active.
  ///
  /// In fr, this message translates to:
  /// **'Actif'**
  String get active;

  /// No description provided for @inactiveTypeHelp.
  ///
  /// In fr, this message translates to:
  /// **'Un type inactif n\'est plus proposé.'**
  String get inactiveTypeHelp;

  /// No description provided for @translations.
  ///
  /// In fr, this message translates to:
  /// **'Traductions'**
  String get translations;

  /// No description provided for @translationsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Nom affiché sur les documents des locataires de chaque langue (vide = nom principal).'**
  String get translationsHelp;

  /// No description provided for @nameIn.
  ///
  /// In fr, this message translates to:
  /// **'Nom ({lang})'**
  String nameIn(String lang);

  /// No description provided for @unitIn.
  ///
  /// In fr, this message translates to:
  /// **'Unité ({lang})'**
  String unitIn(String lang);

  /// No description provided for @noService.
  ///
  /// In fr, this message translates to:
  /// **'Aucun service'**
  String get noService;

  /// No description provided for @servicePriceLine.
  ///
  /// In fr, this message translates to:
  /// **'{price} par {unit} et par mois'**
  String servicePriceLine(String price, String unit);

  /// No description provided for @newService.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau service'**
  String get newService;

  /// No description provided for @defaultUnit.
  ///
  /// In fr, this message translates to:
  /// **'unité'**
  String get defaultUnit;

  /// No description provided for @parkingHint.
  ///
  /// In fr, this message translates to:
  /// **'ex. Parking'**
  String get parkingHint;

  /// No description provided for @unit.
  ///
  /// In fr, this message translates to:
  /// **'Unité'**
  String get unit;

  /// No description provided for @serviceUnitHint.
  ///
  /// In fr, this message translates to:
  /// **'ex. véhicule, place'**
  String get serviceUnitHint;

  /// No description provided for @monthlyPricePerUnit.
  ///
  /// In fr, this message translates to:
  /// **'Prix mensuel par unité'**
  String get monthlyPricePerUnit;

  /// No description provided for @scopeReadings.
  ///
  /// In fr, this message translates to:
  /// **'Relevés'**
  String get scopeReadings;

  /// No description provided for @scopeReadingsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Index, consommations, photos (oui/non), par mois ou période'**
  String get scopeReadingsHelp;

  /// No description provided for @scopeBilling.
  ///
  /// In fr, this message translates to:
  /// **'Facturation'**
  String get scopeBilling;

  /// No description provided for @scopeBillingHelp.
  ///
  /// In fr, this message translates to:
  /// **'Factures, lignes détaillées, paiements, soldes'**
  String get scopeBillingHelp;

  /// No description provided for @scopeAll.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les données'**
  String get scopeAll;

  /// No description provided for @scopeAllHelp.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les tables de l\'application'**
  String get scopeAllHelp;

  /// No description provided for @exports.
  ///
  /// In fr, this message translates to:
  /// **'Exports'**
  String get exports;

  /// No description provided for @whatToExport.
  ///
  /// In fr, this message translates to:
  /// **'Que voulez-vous exporter ?'**
  String get whatToExport;

  /// No description provided for @thisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Ce mois'**
  String get thisMonth;

  /// No description provided for @last3Months.
  ///
  /// In fr, this message translates to:
  /// **'3 derniers mois'**
  String get last3Months;

  /// No description provided for @thisYear.
  ///
  /// In fr, this message translates to:
  /// **'Cette année'**
  String get thisYear;

  /// No description provided for @format.
  ///
  /// In fr, this message translates to:
  /// **'Format'**
  String get format;

  /// No description provided for @fullBackupZip.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde complète (ZIP)'**
  String get fullBackupZip;

  /// No description provided for @fullBackupHelp.
  ///
  /// In fr, this message translates to:
  /// **'Base + photos, réimportable dans l\'application'**
  String get fullBackupHelp;

  /// No description provided for @exportAndShare.
  ///
  /// In fr, this message translates to:
  /// **'Exporter et partager'**
  String get exportAndShare;

  /// No description provided for @fromMonth.
  ///
  /// In fr, this message translates to:
  /// **'Du {month}'**
  String fromMonth(String month);

  /// No description provided for @toMonth.
  ///
  /// In fr, this message translates to:
  /// **'Au {month}'**
  String toMonth(String month);

  /// No description provided for @general.
  ///
  /// In fr, this message translates to:
  /// **'Général'**
  String get general;

  /// No description provided for @generalHelp.
  ///
  /// In fr, this message translates to:
  /// **'Nom, coordonnées, langue, devise, échéance'**
  String get generalHelp;

  /// No description provided for @meterTypesTileHelp.
  ///
  /// In fr, this message translates to:
  /// **'Eau, électricité, gaz… prix, entretien, TVA'**
  String get meterTypesTileHelp;

  /// No description provided for @servicesTileHelp.
  ///
  /// In fr, this message translates to:
  /// **'Parking, gardiennage…'**
  String get servicesTileHelp;

  /// No description provided for @exportsTileHelp.
  ///
  /// In fr, this message translates to:
  /// **'Relevés, facturation, toutes les données'**
  String get exportsTileHelp;

  /// No description provided for @backupRestore.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde et restauration'**
  String get backupRestore;

  /// No description provided for @backupRestoreHelp.
  ///
  /// In fr, this message translates to:
  /// **'Fichier ZIP complet (données + photos)'**
  String get backupRestoreHelp;

  /// No description provided for @demoLoaded.
  ///
  /// In fr, this message translates to:
  /// **'Données de démonstration chargées'**
  String get demoLoaded;

  /// No description provided for @loadDemo.
  ///
  /// In fr, this message translates to:
  /// **'Charger des données de démonstration'**
  String get loadDemo;

  /// No description provided for @loadDemoHelp.
  ///
  /// In fr, this message translates to:
  /// **'Pour découvrir l\'application (visible seulement si elle est vide)'**
  String get loadDemoHelp;

  /// No description provided for @signatureKey.
  ///
  /// In fr, this message translates to:
  /// **'Clé de signature des documents : {key}'**
  String signatureKey(String key);

  /// No description provided for @managerHeader.
  ///
  /// In fr, this message translates to:
  /// **'Gestionnaire (en-tête des documents)'**
  String get managerHeader;

  /// No description provided for @businessName.
  ///
  /// In fr, this message translates to:
  /// **'Nom / raison sociale'**
  String get businessName;

  /// No description provided for @invoiceFooter.
  ///
  /// In fr, this message translates to:
  /// **'Mention en bas des factures'**
  String get invoiceFooter;

  /// No description provided for @currency.
  ///
  /// In fr, this message translates to:
  /// **'Devise'**
  String get currency;

  /// No description provided for @customSymbol.
  ///
  /// In fr, this message translates to:
  /// **'Symbole affiché (devise personnalisée)'**
  String get customSymbol;

  /// No description provided for @symbolBefore.
  ///
  /// In fr, this message translates to:
  /// **'Symbole avant le montant'**
  String get symbolBefore;

  /// No description provided for @preview.
  ///
  /// In fr, this message translates to:
  /// **'Aperçu : {value}'**
  String preview(String value);

  /// No description provided for @billing.
  ///
  /// In fr, this message translates to:
  /// **'Facturation'**
  String get billing;

  /// No description provided for @invoiceDueDay.
  ///
  /// In fr, this message translates to:
  /// **'Jour d\'échéance des factures'**
  String get invoiceDueDay;

  /// No description provided for @scanTitle.
  ///
  /// In fr, this message translates to:
  /// **'Scanner un document'**
  String get scanTitle;

  /// No description provided for @scanHelp.
  ///
  /// In fr, this message translates to:
  /// **'Visez le QR code d\'une facture, d\'une quittance ou d\'un décompte de sortie imprimé.'**
  String get scanHelp;

  /// No description provided for @docWithNumber.
  ///
  /// In fr, this message translates to:
  /// **'{doc} {number}'**
  String docWithNumber(String doc, String number);

  /// No description provided for @balanceAtPrint.
  ///
  /// In fr, this message translates to:
  /// **'Solde au moment de l\'impression : {amount}'**
  String balanceAtPrint(String amount);

  /// No description provided for @result.
  ///
  /// In fr, this message translates to:
  /// **'Résultat'**
  String get result;

  /// No description provided for @qrUnknown.
  ///
  /// In fr, this message translates to:
  /// **'QR code non reconnu'**
  String get qrUnknown;

  /// No description provided for @qrUnknownHelp.
  ///
  /// In fr, this message translates to:
  /// **'Ce QR code ne provient pas d\'un document NHimmo.'**
  String get qrUnknownHelp;

  /// No description provided for @verification.
  ///
  /// In fr, this message translates to:
  /// **'Vérification'**
  String get verification;

  /// No description provided for @signatureInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Signature invalide'**
  String get signatureInvalid;

  /// No description provided for @signatureValid.
  ///
  /// In fr, this message translates to:
  /// **'Signature valide'**
  String get signatureValid;

  /// No description provided for @documentAuthentic.
  ///
  /// In fr, this message translates to:
  /// **'Document authentique'**
  String get documentAuthentic;

  /// No description provided for @documentChanged.
  ///
  /// In fr, this message translates to:
  /// **'Document modifié depuis l\'impression'**
  String get documentChanged;

  /// No description provided for @signatureInvalidHelp.
  ///
  /// In fr, this message translates to:
  /// **'Ce document a été falsifié ou n\'a pas été émis par cette application.'**
  String get signatureInvalidHelp;

  /// No description provided for @signatureValidHelp.
  ///
  /// In fr, this message translates to:
  /// **'Le document a bien été émis avec votre clé, mais il n\'existe plus dans les données.'**
  String get signatureValidHelp;

  /// No description provided for @documentAuthenticHelp.
  ///
  /// In fr, this message translates to:
  /// **'Les informations imprimées correspondent aux données enregistrées.'**
  String get documentAuthenticHelp;

  /// No description provided for @documentChangedHelp.
  ///
  /// In fr, this message translates to:
  /// **'Le document a été régénéré depuis : ouvrez-le pour voir la version actuelle.'**
  String get documentChangedHelp;

  /// No description provided for @numberLabel.
  ///
  /// In fr, this message translates to:
  /// **'Numéro'**
  String get numberLabel;

  /// No description provided for @openDocument.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir le document'**
  String get openDocument;

  /// No description provided for @scanAnother.
  ///
  /// In fr, this message translates to:
  /// **'Scanner un autre document'**
  String get scanAnother;

  /// No description provided for @pdfNumber.
  ///
  /// In fr, this message translates to:
  /// **'N° {number}'**
  String pdfNumber(String number);

  /// No description provided for @pdfDigitalSignature.
  ///
  /// In fr, this message translates to:
  /// **'Signature numérique'**
  String get pdfDigitalSignature;

  /// No description provided for @pdfDesignation.
  ///
  /// In fr, this message translates to:
  /// **'Désignation'**
  String get pdfDesignation;

  /// No description provided for @pdfExclTax.
  ///
  /// In fr, this message translates to:
  /// **'HT'**
  String get pdfExclTax;

  /// No description provided for @pdfAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get pdfAmount;

  /// No description provided for @pdfFooter.
  ///
  /// In fr, this message translates to:
  /// **'Document signé numériquement, vérifiable par QR code dans NHimmo'**
  String get pdfFooter;

  /// No description provided for @pdfPage.
  ///
  /// In fr, this message translates to:
  /// **'Page {page}/{total}'**
  String pdfPage(String page, String total);

  /// No description provided for @pdfDefaultThanks.
  ///
  /// In fr, this message translates to:
  /// **'Merci pour votre règlement.'**
  String get pdfDefaultThanks;

  /// No description provided for @pdfPeriod.
  ///
  /// In fr, this message translates to:
  /// **'Période : {period}'**
  String pdfPeriod(String period);

  /// No description provided for @pdfIssuedDue.
  ///
  /// In fr, this message translates to:
  /// **'Émise le {issued}  ·  Échéance {due}'**
  String pdfIssuedDue(String issued, String due);

  /// No description provided for @pdfLandlord.
  ///
  /// In fr, this message translates to:
  /// **'Bailleur / gestionnaire'**
  String get pdfLandlord;

  /// No description provided for @pdfTenant.
  ///
  /// In fr, this message translates to:
  /// **'Locataire'**
  String get pdfTenant;

  /// No description provided for @pdfTotalExclTax.
  ///
  /// In fr, this message translates to:
  /// **'Total HT'**
  String get pdfTotalExclTax;

  /// No description provided for @pdfTotalDue.
  ///
  /// In fr, this message translates to:
  /// **'Total à payer'**
  String get pdfTotalDue;

  /// No description provided for @pdfStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get pdfStatus;

  /// No description provided for @pdfPaidStamp.
  ///
  /// In fr, this message translates to:
  /// **'PAYÉE'**
  String get pdfPaidStamp;

  /// No description provided for @pdfNotes.
  ///
  /// In fr, this message translates to:
  /// **'Notes : {notes}'**
  String pdfNotes(String notes);

  /// No description provided for @pdfDate.
  ///
  /// In fr, this message translates to:
  /// **'Date : {date}'**
  String pdfDate(String date);

  /// No description provided for @pdfRefundText.
  ///
  /// In fr, this message translates to:
  /// **'Le gestionnaire {manager} a remboursé à {tenant} la somme de :'**
  String pdfRefundText(String manager, String tenant);

  /// No description provided for @pdfReceivedText.
  ///
  /// In fr, this message translates to:
  /// **'Reçu de {tenant}, locataire de {place}, la somme de :'**
  String pdfReceivedText(String tenant, String place);

  /// No description provided for @pdfPaymentMethod.
  ///
  /// In fr, this message translates to:
  /// **'Mode de règlement : {method}'**
  String pdfPaymentMethod(String method);

  /// No description provided for @pdfReference.
  ///
  /// In fr, this message translates to:
  /// **'réf. {ref}'**
  String pdfReference(String ref);

  /// No description provided for @pdfNote.
  ///
  /// In fr, this message translates to:
  /// **'Note : {note}'**
  String pdfNote(String note);

  /// No description provided for @pdfBalanceAfter.
  ///
  /// In fr, this message translates to:
  /// **'Solde du compte locataire après ce règlement : {amount}'**
  String pdfBalanceAfter(String amount);

  /// No description provided for @pdfDoneOn.
  ///
  /// In fr, this message translates to:
  /// **'Fait le {date}'**
  String pdfDoneOn(String date);

  /// No description provided for @pdfExitTitle.
  ///
  /// In fr, this message translates to:
  /// **'Décompte de fin de contrat'**
  String get pdfExitTitle;

  /// No description provided for @pdfMoveInOut.
  ///
  /// In fr, this message translates to:
  /// **'Entrée : {moveIn}  ·  Sortie : {moveOut}'**
  String pdfMoveInOut(String moveIn, String moveOut);

  /// No description provided for @pdfLastMonthProrata.
  ///
  /// In fr, this message translates to:
  /// **'Dernier mois : au prorata des jours'**
  String get pdfLastMonthProrata;

  /// No description provided for @pdfLastMonthFull.
  ///
  /// In fr, this message translates to:
  /// **'Dernier mois : mois complet'**
  String get pdfLastMonthFull;

  /// No description provided for @pdfOutgoingTenant.
  ///
  /// In fr, this message translates to:
  /// **'Locataire sortant'**
  String get pdfOutgoingTenant;

  /// No description provided for @pdfSectionExitInvoice.
  ///
  /// In fr, this message translates to:
  /// **'1. Facture de sortie'**
  String get pdfSectionExitInvoice;

  /// No description provided for @pdfNoLine.
  ///
  /// In fr, this message translates to:
  /// **'Aucune ligne.'**
  String get pdfNoLine;

  /// No description provided for @pdfSectionDamages.
  ///
  /// In fr, this message translates to:
  /// **'2. Détail des dégâts constatés'**
  String get pdfSectionDamages;

  /// No description provided for @pdfRoom.
  ///
  /// In fr, this message translates to:
  /// **'Pièce'**
  String get pdfRoom;

  /// No description provided for @pdfItem.
  ///
  /// In fr, this message translates to:
  /// **'Élément'**
  String get pdfItem;

  /// No description provided for @pdfCondition.
  ///
  /// In fr, this message translates to:
  /// **'État'**
  String get pdfCondition;

  /// No description provided for @pdfComment.
  ///
  /// In fr, this message translates to:
  /// **'Commentaire'**
  String get pdfComment;

  /// No description provided for @pdfCost.
  ///
  /// In fr, this message translates to:
  /// **'Coût'**
  String get pdfCost;

  /// No description provided for @pdfSectionSummary.
  ///
  /// In fr, this message translates to:
  /// **'{n}. Récapitulatif du compte'**
  String pdfSectionSummary(String n);

  /// No description provided for @pdfTotalLease.
  ///
  /// In fr, this message translates to:
  /// **'Total facturé sur toute la durée du contrat'**
  String get pdfTotalLease;

  /// No description provided for @pdfTotalTenantPaid.
  ///
  /// In fr, this message translates to:
  /// **'Total réglé par le locataire'**
  String get pdfTotalTenantPaid;

  /// No description provided for @pdfDepositApplied.
  ///
  /// In fr, this message translates to:
  /// **'Caution versée à l\'entrée (imputée)'**
  String get pdfDepositApplied;

  /// No description provided for @pdfDamagesFromDeposit.
  ///
  /// In fr, this message translates to:
  /// **'dont dégâts retenus sur la caution'**
  String get pdfDamagesFromDeposit;

  /// No description provided for @pdfRefundsDone.
  ///
  /// In fr, this message translates to:
  /// **'Remboursements déjà effectués'**
  String get pdfRefundsDone;

  /// No description provided for @pdfTenantOwes.
  ///
  /// In fr, this message translates to:
  /// **'Reste à payer par le locataire'**
  String get pdfTenantOwes;

  /// No description provided for @pdfToRefund.
  ///
  /// In fr, this message translates to:
  /// **'À rembourser au locataire'**
  String get pdfToRefund;

  /// No description provided for @pdfSettled.
  ///
  /// In fr, this message translates to:
  /// **'Compte soldé'**
  String get pdfSettled;

  /// No description provided for @pdfDepositNotEnough.
  ///
  /// In fr, this message translates to:
  /// **'La caution ne couvre pas la totalité des sommes dues : le locataire doit compléter le montant ci-dessus.'**
  String get pdfDepositNotEnough;

  /// No description provided for @pdfObservations.
  ///
  /// In fr, this message translates to:
  /// **'Observations : {notes}'**
  String pdfObservations(String notes);

  /// No description provided for @pdfManagerSign.
  ///
  /// In fr, this message translates to:
  /// **'Le gestionnaire'**
  String get pdfManagerSign;

  /// No description provided for @pdfTenantSign.
  ///
  /// In fr, this message translates to:
  /// **'Le locataire (lu et approuvé)'**
  String get pdfTenantSign;

  /// No description provided for @xBuilding.
  ///
  /// In fr, this message translates to:
  /// **'Immeuble'**
  String get xBuilding;

  /// No description provided for @xApartment.
  ///
  /// In fr, this message translates to:
  /// **'Appartement'**
  String get xApartment;

  /// No description provided for @xMeter.
  ///
  /// In fr, this message translates to:
  /// **'Compteur'**
  String get xMeter;

  /// No description provided for @xReading.
  ///
  /// In fr, this message translates to:
  /// **'Index'**
  String get xReading;

  /// No description provided for @xPreviousReading.
  ///
  /// In fr, this message translates to:
  /// **'Index précédent'**
  String get xPreviousReading;

  /// No description provided for @xYes.
  ///
  /// In fr, this message translates to:
  /// **'oui'**
  String get xYes;

  /// No description provided for @xNo.
  ///
  /// In fr, this message translates to:
  /// **'non'**
  String get xNo;

  /// No description provided for @xKindMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Mensuel'**
  String get xKindMonthly;

  /// No description provided for @xInvoiceNo.
  ///
  /// In fr, this message translates to:
  /// **'N° facture'**
  String get xInvoiceNo;

  /// No description provided for @xTotalWith.
  ///
  /// In fr, this message translates to:
  /// **'Total ({symbol})'**
  String xTotalWith(String symbol);

  /// No description provided for @xLabel.
  ///
  /// In fr, this message translates to:
  /// **'Libellé'**
  String get xLabel;

  /// No description provided for @xDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails'**
  String get xDetails;

  /// No description provided for @xQuantity.
  ///
  /// In fr, this message translates to:
  /// **'Quantité'**
  String get xQuantity;

  /// No description provided for @xUnitPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix unitaire'**
  String get xUnitPrice;

  /// No description provided for @xInclTax.
  ///
  /// In fr, this message translates to:
  /// **'TTC'**
  String get xInclTax;

  /// No description provided for @xStartReading.
  ///
  /// In fr, this message translates to:
  /// **'Index début'**
  String get xStartReading;

  /// No description provided for @xEndReading.
  ///
  /// In fr, this message translates to:
  /// **'Index fin'**
  String get xEndReading;

  /// No description provided for @xReceiptNo.
  ///
  /// In fr, this message translates to:
  /// **'N° reçu'**
  String get xReceiptNo;

  /// No description provided for @xMethod.
  ///
  /// In fr, this message translates to:
  /// **'Mode'**
  String get xMethod;

  /// No description provided for @xReference.
  ///
  /// In fr, this message translates to:
  /// **'Référence'**
  String get xReference;

  /// No description provided for @xPayment.
  ///
  /// In fr, this message translates to:
  /// **'Paiement'**
  String get xPayment;

  /// No description provided for @xBalanceSigned.
  ///
  /// In fr, this message translates to:
  /// **'Solde (+ dû / − à rembourser)'**
  String get xBalanceSigned;

  /// No description provided for @xSheetLines.
  ///
  /// In fr, this message translates to:
  /// **'Lignes'**
  String get xSheetLines;

  /// No description provided for @xSheetBalances.
  ///
  /// In fr, this message translates to:
  /// **'Soldes'**
  String get xSheetBalances;

  /// No description provided for @backupNotMyImmo.
  ///
  /// In fr, this message translates to:
  /// **'Ce fichier n\'est pas une sauvegarde NHimmo.'**
  String get backupNotMyImmo;

  /// No description provided for @backupUnknownFormat.
  ///
  /// In fr, this message translates to:
  /// **'Format de sauvegarde inconnu.'**
  String get backupUnknownFormat;

  /// No description provided for @backupTooRecent.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde créée par une version plus récente de l\'application.'**
  String get backupTooRecent;

  /// No description provided for @editPayment.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le versement'**
  String get editPayment;

  /// No description provided for @completeDeposit.
  ///
  /// In fr, this message translates to:
  /// **'Compléter la caution'**
  String get completeDeposit;

  /// No description provided for @paymentUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Versement modifié'**
  String get paymentUpdated;

  /// No description provided for @depositMissing.
  ///
  /// In fr, this message translates to:
  /// **'Reste à verser'**
  String get depositMissing;

  /// No description provided for @depositAmountReceived.
  ///
  /// In fr, this message translates to:
  /// **'Montant de caution reçu'**
  String get depositAmountReceived;

  /// No description provided for @depositReceived.
  ///
  /// In fr, this message translates to:
  /// **'Caution reçue'**
  String get depositReceived;

  /// No description provided for @deletePaymentQ.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ce versement ?'**
  String get deletePaymentQ;

  /// No description provided for @deletePaymentHelp.
  ///
  /// In fr, this message translates to:
  /// **'Le versement {number} sera supprimé et le solde du locataire recalculé.'**
  String deletePaymentHelp(String number);

  /// No description provided for @paymentDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Versement supprimé'**
  String get paymentDeleted;

  /// No description provided for @paymentLockedHelp.
  ///
  /// In fr, this message translates to:
  /// **'Un versement plus récent existe : seul le dernier versement peut être modifié ou supprimé.'**
  String get paymentLockedHelp;

  /// No description provided for @paymentAutoLocked.
  ///
  /// In fr, this message translates to:
  /// **'Caution imputée automatiquement à la clôture du contrat : non modifiable.'**
  String get paymentAutoLocked;

  /// No description provided for @depositIncomplete.
  ///
  /// In fr, this message translates to:
  /// **'Caution incomplète'**
  String get depositIncomplete;

  /// No description provided for @depositIncompleteShort.
  ///
  /// In fr, this message translates to:
  /// **'Caution incomplète'**
  String get depositIncompleteShort;

  /// No description provided for @depositIncompleteDetail.
  ///
  /// In fr, this message translates to:
  /// **'Caution versée : {paid} sur {required}'**
  String depositIncompleteDetail(String paid, String required);

  /// No description provided for @depositMissingAmount.
  ///
  /// In fr, this message translates to:
  /// **'Reste à verser : {amount}'**
  String depositMissingAmount(String amount);

  /// No description provided for @complete.
  ///
  /// In fr, this message translates to:
  /// **'Compléter'**
  String get complete;

  /// No description provided for @incompleteDeposits.
  ///
  /// In fr, this message translates to:
  /// **'Cautions incomplètes'**
  String get incompleteDeposits;

  /// No description provided for @creditSettlement.
  ///
  /// In fr, this message translates to:
  /// **'Règlement par avance'**
  String get creditSettlement;

  /// No description provided for @creditAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Avance / paiements disponibles'**
  String get creditAvailable;

  /// No description provided for @creditApplied.
  ///
  /// In fr, this message translates to:
  /// **'Déduit de l\'avance'**
  String get creditApplied;

  /// No description provided for @creditRemaining.
  ///
  /// In fr, this message translates to:
  /// **'Avance restante après cette facture'**
  String get creditRemaining;

  /// No description provided for @depositReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Reçu de caution'**
  String get depositReceipt;

  /// No description provided for @pdfDepositReceivedText.
  ///
  /// In fr, this message translates to:
  /// **'Reçu de {tenant}, locataire de {place}, au titre de la caution, la somme de :'**
  String pdfDepositReceivedText(String tenant, String place);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
