// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageName => 'English';

  @override
  String get appTitle => 'NHimmo';

  @override
  String lineRent(String month) {
    return 'Rent $month';
  }

  @override
  String lineProrata(String days, String total) {
    return '$days/$total days';
  }

  @override
  String lineIndex(String from, String to) {
    return 'Meter $from to $to';
  }

  @override
  String lineConsumption(String qty, String unit, String price) {
    return '$qty $unit × $price';
  }

  @override
  String lineMaintenance(String amount) {
    return 'Meter maintenance $amount';
  }

  @override
  String lineVat(String rate, String mode) {
    return 'VAT $rate% ($mode)';
  }

  @override
  String get vatIncludedShort => 'included';

  @override
  String get vatAddedShort => 'added';

  @override
  String lineServiceIncluded(
    String qty,
    String unit,
    String included,
    String billed,
  ) {
    return '$qty $unit(s), $included included, $billed billed';
  }

  @override
  String lineServiceQty(String qty, String unit) {
    return '$qty $unit(s)';
  }

  @override
  String get lineDamages => 'Damages noted (move-out inspection)';

  @override
  String lineCredit(String days) {
    return 'Rent and services deduction – $days unoccupied day(s)';
  }

  @override
  String lineBenefit(String name) {
    return 'Benefit $name';
  }

  @override
  String get benefitFull => 'Full exemption';

  @override
  String benefitPercent(String value) {
    return '$value% discount';
  }

  @override
  String benefitUnits(String value, String unit) {
    return '$value $unit free per month';
  }

  @override
  String benefitAmount(String amount) {
    return '$amount deducted per month';
  }

  @override
  String get benefitModePercent => 'Percentage discount';

  @override
  String get benefitModeUnits => 'Free units / month';

  @override
  String get benefitModeAmount => 'Fixed amount off / month';

  @override
  String get vatNone => 'No VAT';

  @override
  String get vatIncluded => 'VAT included in price';

  @override
  String get vatAdded => 'VAT added';

  @override
  String get roomLiving => 'Living room';

  @override
  String get roomDining => 'Dining room';

  @override
  String get roomKitchen => 'Kitchen';

  @override
  String get roomBedroom => 'Bedroom';

  @override
  String roomBedroomN(String n) {
    return 'Bedroom $n';
  }

  @override
  String get roomBathroom => 'Bathroom';

  @override
  String get roomToilet => 'Toilet';

  @override
  String get roomHallway => 'Hallway';

  @override
  String get roomBalcony => 'Balcony';

  @override
  String get roomTerrace => 'Terrace';

  @override
  String get roomGarage => 'Garage';

  @override
  String get roomOutside => 'Outside';

  @override
  String get condNew => 'New';

  @override
  String get condGood => 'Good';

  @override
  String get condWorn => 'Worn';

  @override
  String get condDamaged => 'Damaged';

  @override
  String get condBroken => 'Out of order';

  @override
  String get methodCash => 'Cash';

  @override
  String get methodMobile => 'Mobile Money';

  @override
  String get methodTransfer => 'Bank transfer';

  @override
  String get methodCheque => 'Cheque';

  @override
  String get methodOther => 'Other';

  @override
  String get methodDeposit => 'Deposit';

  @override
  String get payStatusPaid => 'Paid';

  @override
  String get payStatusPartial => 'Partial';

  @override
  String get payStatusUnpaid => 'Unpaid';

  @override
  String warnMissingReading(String place, String meter) {
    return '$place: $meter reading missing';
  }

  @override
  String warnIndexLower(String place, String meter) {
    return '$place: $meter index lower than previous';
  }

  @override
  String warnExitIndexMissing(String meter) {
    return '$meter move-out reading not entered';
  }

  @override
  String warnExitIndexLower(String meter) {
    return '$meter index lower than last billed index';
  }

  @override
  String get docInvoice => 'Invoice';

  @override
  String get docReceipt => 'Rent receipt';

  @override
  String get docExit => 'Move-out statement';

  @override
  String errorWith(String error) {
    return 'Error: $error';
  }

  @override
  String get requiredField => 'Required field';

  @override
  String get amountRequired => 'Amount required';

  @override
  String get amountInvalid => 'Invalid amount';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get close => 'Close';

  @override
  String get validate => 'OK';

  @override
  String get newItem => 'New';

  @override
  String get notes => 'Notes';

  @override
  String get note => 'Note';

  @override
  String get phone => 'Phone';

  @override
  String get email => 'Email';

  @override
  String get address => 'Address';

  @override
  String get navHome => 'Home';

  @override
  String get navProperties => 'Properties';

  @override
  String get navRentals => 'Rentals';

  @override
  String get navReadings => 'Readings';

  @override
  String get navFinance => 'Finance';

  @override
  String get language => 'Language';

  @override
  String get appLanguage => 'App language';

  @override
  String get systemLanguage => 'Phone language';

  @override
  String get documentLanguage => 'Document language';

  @override
  String get documentLanguageHelp =>
      'This tenant\'s invoices, receipts and statement will be produced in this language.';

  @override
  String sameAsApp(String lang) {
    return 'Same as app ($lang)';
  }

  @override
  String get hello => 'Hello 👋';

  @override
  String get scanDocument => 'Scan a document';

  @override
  String get settings => 'Settings';

  @override
  String get collectedThisMonth => 'Collected this month';

  @override
  String forBilledIn(String amount, String month) {
    return 'for $amount billed in $month';
  }

  @override
  String get actionRead => 'Read';

  @override
  String get actionCollect => 'Collect';

  @override
  String get actionScan => 'Scan';

  @override
  String get actionExport => 'Export';

  @override
  String get occupancy => 'Occupancy';

  @override
  String apartmentsCount(String occupied, String total) {
    return '$occupied / $total apartments';
  }

  @override
  String get unpaid => 'Outstanding';

  @override
  String lateInvoices(String count) {
    return '$count overdue invoice(s)';
  }

  @override
  String get noDelay => 'Nothing overdue';

  @override
  String get readingsOfMonth => 'Readings this month';

  @override
  String get done => 'Done';

  @override
  String get toComplete => 'To complete';

  @override
  String get lastBilling => 'Last billing';

  @override
  String get billedVsCollected => 'Billed vs collected';

  @override
  String get billed => 'Billed';

  @override
  String get collected => 'Collected';

  @override
  String consumptionOf(String month) {
    return 'Consumption · $month';
  }

  @override
  String get balancesToRecover => 'Balances to recover';

  @override
  String get endContractFirst => 'End the current lease first.';

  @override
  String get reactivateQ => 'Reactivate?';

  @override
  String get archiveQ => 'Archive?';

  @override
  String get aptWillReappear =>
      'The apartment will appear again in lists and readings.';

  @override
  String get aptWillDisappear =>
      'The apartment will no longer appear in lists and readings.';

  @override
  String get reactivate => 'Reactivate';

  @override
  String get archive => 'Archive';

  @override
  String get rent => 'Rent';

  @override
  String get deposit => 'Deposit';

  @override
  String sinceDate(String date) {
    return 'Since $date';
  }

  @override
  String get aptFree => 'Vacant apartment';

  @override
  String get rentOut => 'Rent out';

  @override
  String get meters => 'Meters';

  @override
  String get noMeters => 'No meters. Add some to bill consumption.';

  @override
  String get serialUnknown => 'No serial number';

  @override
  String serialNo(String serial) {
    return 'No. $serial';
  }

  @override
  String get initialIndex => 'Initial reading';

  @override
  String readOn(String date) {
    return 'read $date';
  }

  @override
  String get consumption => 'Consumption';

  @override
  String get leaseHistory => 'Lease history';

  @override
  String get ongoing => 'ongoing';

  @override
  String get buildings => 'Buildings';

  @override
  String get monthlyRents => 'Monthly rents';

  @override
  String billedYear(String year) {
    return 'Billed $year';
  }

  @override
  String collectedYear(String year) {
    return 'Collected $year';
  }

  @override
  String unpaidAmount(String amount) {
    return 'Outstanding: $amount';
  }

  @override
  String get apartments => 'Apartments';

  @override
  String get owners => 'Owners';

  @override
  String get noApartment => 'No apartments';

  @override
  String get noApartmentHelp =>
      'Start by creating an owner, then a building, then its apartments.';

  @override
  String get pillApartments => 'apartments';

  @override
  String get pillOccupied => 'occupied';

  @override
  String get pillFree => 'vacant';

  @override
  String floorN(String floor) {
    return 'Floor $floor';
  }

  @override
  String get free => 'Vacant';

  @override
  String get perMonth => '/ month';

  @override
  String get noBuilding => 'No buildings';

  @override
  String get noBuildingHelp => 'A building groups an owner\'s apartments.';

  @override
  String get addressUnknown => 'No address';

  @override
  String ownerIs(String name) {
    return 'Owner: $name';
  }

  @override
  String occupiedRatio(String occupied, String total) {
    return '$occupied/$total occupied';
  }

  @override
  String get noOwner => 'No owners';

  @override
  String get noOwnerHelp => 'Add the owners of the managed properties.';

  @override
  String aptCount(String count) {
    return '$count apt(s)';
  }

  @override
  String get newOwner => 'New owner';

  @override
  String get editOwner => 'Edit owner';

  @override
  String get ownerHasBuildings => 'This owner has buildings.';

  @override
  String get deleteQ => 'Delete?';

  @override
  String get fullName => 'Full name';

  @override
  String get newBuilding => 'New building';

  @override
  String get editBuilding => 'Edit building';

  @override
  String get createOwnerFirst => 'Create the building\'s owner first.';

  @override
  String get createOwner => 'Create an owner';

  @override
  String get buildingHasApts => 'This building contains apartments.';

  @override
  String get ownerRequired => 'Owner *';

  @override
  String get chooseOwner => 'Choose an owner';

  @override
  String get buildingName => 'Building name';

  @override
  String get buildingNameHint => 'e.g. Palm Residence';

  @override
  String get newApartment => 'New apartment';

  @override
  String get editApartment => 'Edit apartment';

  @override
  String get aptNeedsBuilding =>
      'An apartment belongs to a building. Create one first.';

  @override
  String get createBuilding => 'Create a building';

  @override
  String get buildingRequired => 'Building *';

  @override
  String get chooseBuilding => 'Choose a building';

  @override
  String get aptName => 'Name / number';

  @override
  String get aptNameHint => 'e.g. A3, Studio 12';

  @override
  String get floor => 'Floor';

  @override
  String get description => 'Description';

  @override
  String get aptDescHint => 'e.g. 2 bedrooms, living room, kitchen';

  @override
  String get defaultRent => 'Default monthly rent';

  @override
  String get defaultDeposit => 'Default deposit';

  @override
  String get metersToCreate => 'Meters to create';

  @override
  String get newMeter => 'New meter';

  @override
  String get editMeter => 'Edit meter';

  @override
  String get typeRequired => 'Type *';

  @override
  String get chooseType => 'Choose a type';

  @override
  String get serialNumber => 'Serial number';

  @override
  String get indexInvalid => 'Invalid reading';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get tabOngoing => 'Ongoing';

  @override
  String get tabEnded => 'Ended';

  @override
  String get tenants => 'Tenants';

  @override
  String get noActiveLease => 'No ongoing lease';

  @override
  String get noEndedLease => 'No ended lease';

  @override
  String get noActiveLeaseHelp =>
      'Create a lease to assign a vacant apartment to a tenant.';

  @override
  String leftOn(String date) {
    return 'Left on $date';
  }

  @override
  String dueAmount(String amount) {
    return 'Due $amount';
  }

  @override
  String advanceAmount(String amount) {
    return 'Credit $amount';
  }

  @override
  String get toRefund => 'To refund';

  @override
  String get upToDate => 'Up to date';

  @override
  String get noTenant => 'No tenants';

  @override
  String get newTenant => 'New tenant';

  @override
  String get tenantHasLeases => 'This tenant has leases and cannot be deleted.';

  @override
  String get idNumber => 'ID number';

  @override
  String get emergencyContact => 'Emergency contact';

  @override
  String get leases => 'Leases';

  @override
  String get noLease => 'No leases.';

  @override
  String get newLease => 'New lease';

  @override
  String get noFreeApartment => 'No vacant apartment';

  @override
  String get noFreeApartmentHelp =>
      'All apartments are occupied or none has been created.';

  @override
  String get editLease => 'Edit lease';

  @override
  String get createLease => 'Create lease';

  @override
  String get aptAndTenant => 'Apartment and tenant';

  @override
  String get apartmentRequired => 'Apartment *';

  @override
  String get chooseApartment => 'Choose an apartment';

  @override
  String get tenantRequired => 'Tenant *';

  @override
  String get chooseTenant => 'Choose a tenant';

  @override
  String get conditions => 'Terms';

  @override
  String get entryDate => 'Move-in date';

  @override
  String get initialTermEndOptional => 'End of initial term (optional)';

  @override
  String get tacitRenewal => 'Automatic renewal';

  @override
  String get tacitOnHelp =>
      'At the end of the term, the lease is extended for the same duration.';

  @override
  String get tacitOffHelp =>
      'The lease will be flagged as expired but stays active until it is closed.';

  @override
  String get monthlyRent => 'Monthly rent';

  @override
  String get depositRequired => 'Required deposit';

  @override
  String get depositPaid => 'Deposit actually paid';

  @override
  String get firstMonthProrata => 'Prorated first month';

  @override
  String get firstMonthProrataOn =>
      'The move-in month\'s rent is calculated by the number of days.';

  @override
  String get firstMonthProrataOff => 'The tenant pays the full move-in month.';

  @override
  String get services => 'Services';

  @override
  String get noServices => 'No services (parking, security…).';

  @override
  String get service => 'Service';

  @override
  String serviceQtySummary(String qty, String included, String billed) {
    return '$qty in total, $included included → $billed billed';
  }

  @override
  String amountPerMonth(String amount) {
    return '$amount/month';
  }

  @override
  String get entryReadings => 'Move-in readings';

  @override
  String get entryReadingHint => 'Leave empty to use the last known reading';

  @override
  String get serviceRequired => 'Service *';

  @override
  String get chooseService => 'Choose a service';

  @override
  String get totalQuantity => 'Total quantity';

  @override
  String get includedQuantity => 'Of which included';

  @override
  String get number => 'Number';

  @override
  String get extraUnitPrice => 'Price per extra unit / month';

  @override
  String get extraUnitHelp => 'e.g. 3 vehicles with 1 allowed → 2 billed';

  @override
  String get tenantSheet => 'Tenant record';

  @override
  String get apartmentSheet => 'Apartment record';

  @override
  String get entryInspection => 'Move-in inspection';

  @override
  String get exitInspection => 'Move-out inspection';

  @override
  String get statusOngoingCaps => 'ONGOING';

  @override
  String get statusEndedCaps => 'ENDED';

  @override
  String get remainingToPay => 'Balance due';

  @override
  String get tenantAdvance => 'Tenant credit';

  @override
  String get refundToTenant => 'To refund to tenant';

  @override
  String get accountUpToDate => 'Account up to date';

  @override
  String get refund => 'Refund';

  @override
  String get endLease => 'End the lease';

  @override
  String get endLeaseHelp =>
      'Move-out readings, inspection, deposit and balance';

  @override
  String get exitDocument => 'End-of-lease document';

  @override
  String get exitDocumentHelp => 'Full details and final balance';

  @override
  String get lease => 'Lease';

  @override
  String get moveIn => 'Move-in';

  @override
  String get moveOut => 'Move-out';

  @override
  String get depositPaidShort => 'Deposit paid';

  @override
  String get firstMonth => 'First month';

  @override
  String get lastMonth => 'Last month';

  @override
  String get prorated => 'Prorated';

  @override
  String get fullMonth => 'Full month';

  @override
  String get damagesRetained => 'Damages withheld';

  @override
  String serviceLine(String qty, String included, String price) {
    return '$qty ($included included) · $price';
  }

  @override
  String get totalBilled => 'Total billed';

  @override
  String get totalPaid => 'Total paid';

  @override
  String invoicesCount(String count) {
    return 'Invoices ($count)';
  }

  @override
  String get noInvoiceYet =>
      'No invoices. They are generated from the Readings tab.';

  @override
  String paymentsCount(String count) {
    return 'Payments ($count)';
  }

  @override
  String get noPayment => 'No payments recorded.';

  @override
  String get initialTermEnd => 'End of initial term';

  @override
  String get renewal => 'Renewal';

  @override
  String get renewalTacit => 'Automatic';

  @override
  String renewedTimes(String count) {
    return 'Automatic · renewed $count time(s)';
  }

  @override
  String get no => 'No';

  @override
  String get nextDeadline => 'Next due date';

  @override
  String get leaseExpired =>
      'Lease expired: tenant still in place, renew or close it';

  @override
  String get closeLeaseQ => 'Close the lease?';

  @override
  String get closeLeaseHelp =>
      'The move-out invoice will be created, the deposit applied and the apartment released. This cannot be undone.';

  @override
  String get closeAction => 'Close';

  @override
  String get endOfLease => 'End of lease';

  @override
  String placeSince(String place, String date) {
    return '$place · since $date';
  }

  @override
  String get exit => 'Move-out';

  @override
  String get exitDate => 'Move-out date';

  @override
  String get lastMonthProrata => 'Prorated last month';

  @override
  String lastMonthProrataOn(String days) {
    return 'The tenant only pays for occupied days ($days d).';
  }

  @override
  String get lastMonthProrataOff => 'The tenant pays the full month.';

  @override
  String get exitReadings => 'Move-out readings';

  @override
  String lastBilledHint(String value) {
    return 'Last billed: $value';
  }

  @override
  String get indexRequired => 'Reading required';

  @override
  String lowerThanLast(String value) {
    return 'Lower than last reading ($value)';
  }

  @override
  String get inspectionAndDamages => 'Inspection and damages';

  @override
  String get roomByRoomOptional => 'Room-by-room details (optional)';

  @override
  String get totalDamages => 'Total damages';

  @override
  String deductedFromDeposit(String amount) {
    return 'Deducted from the $amount deposit';
  }

  @override
  String get observations => 'Remarks';

  @override
  String get statement => 'Statement';

  @override
  String get exitInvoiceTotal => 'Move-out invoice total';

  @override
  String get previousBalance => 'Previous balance';

  @override
  String get tenantStillOwes => 'Tenant still owes';

  @override
  String get accountSettled => 'Account settled';

  @override
  String get depositInsufficient =>
      'The deposit is insufficient: the tenant must pay the remainder.';

  @override
  String get computeStatement => 'Compute statement';

  @override
  String get closeLease => 'Close the lease';

  @override
  String get noItem => 'No items';

  @override
  String get exitInspectionHelp =>
      'Add the damages noted room by room, with their cost.';

  @override
  String get entryInspectionHelp =>
      'Optional: describe the condition of each room at move-in.';

  @override
  String get damagesTotal => 'Total damages';

  @override
  String get item => 'Item';

  @override
  String get newItemInspection => 'New item';

  @override
  String get whichRoom => '1. Which room?';

  @override
  String get chooseRoom => 'Choose the room';

  @override
  String get otherRoom => 'Other room';

  @override
  String get whichItem => '2. Which item?';

  @override
  String entryWas(String item, String condition) {
    return '$item (move-in: $condition)';
  }

  @override
  String get itemName => 'Name of the inspected item';

  @override
  String get itemNameHint =>
      'e.g. Samsung air conditioner, front door, chandelier';

  @override
  String get conditionNoted => '3. Condition noted';

  @override
  String get comment => 'Comment';

  @override
  String get repairCost => 'Repair cost';

  @override
  String get photo => 'Photo';

  @override
  String get retake => 'Retake';

  @override
  String get newRoom => 'New room';

  @override
  String get newRoomHint => 'e.g. Master bedroom, laundry room';

  @override
  String get benefitApplied => 'Applied';

  @override
  String get benefitUpcoming => 'Upcoming';

  @override
  String get benefitSuspended => 'Suspended';

  @override
  String get leaseStart => 'Start of lease';

  @override
  String get noLimit => 'no end date';

  @override
  String get benefits => 'Benefits';

  @override
  String get noBenefit =>
      'No benefits. Example: ENEO employee exempt from electricity.';

  @override
  String get suspendFrom => 'Suspend from…';

  @override
  String get resumeFrom => 'Resume from…';

  @override
  String benefitSuspendedFrom(String month) {
    return 'Benefit suspended from $month';
  }

  @override
  String benefitResumedFrom(String month) {
    return 'Benefit resumed from $month';
  }

  @override
  String get deleteBenefitQ => 'Delete the benefit?';

  @override
  String get deleteBenefitHelp =>
      'Locked invoices do not change. Editable invoices will need to be recalculated.';

  @override
  String get reasonEneo => 'ENEO employee';

  @override
  String get reasonCamwater => 'CAMWATER employee';

  @override
  String get reasonOwner => 'Owner\'s agreement';

  @override
  String get reasonGoodwill => 'Goodwill gesture';

  @override
  String get reasonCaretaker => 'Building caretaker';

  @override
  String get newBenefit => 'New benefit';

  @override
  String get editBenefit => 'Edit benefit';

  @override
  String get chargeRequired => 'Charge concerned *';

  @override
  String get chooseCharge => 'Choose the charge';

  @override
  String get units => 'Units';

  @override
  String get amount => 'Amount';

  @override
  String get percentHelp =>
      'Percentage of the charge waived (100% = full exemption).';

  @override
  String get unitsHelp =>
      'Number of units free each month; any excess is billed.';

  @override
  String get fixedHelp => 'Amount deducted from this charge each month.';

  @override
  String get amountPerMonthOff => 'Amount deducted per month';

  @override
  String get percentage => 'Percentage';

  @override
  String get freeUnitsPerMonth => 'Free units per month';

  @override
  String get valueInvalid => 'Invalid value';

  @override
  String get max100 => '100% maximum';

  @override
  String get reason => 'Reason';

  @override
  String get reasonHint => 'e.g. ENEO employee';

  @override
  String fromLabel(String value) {
    return 'From: $value';
  }

  @override
  String toLabel(String value) {
    return 'Until: $value';
  }

  @override
  String get leaseStartLower => 'start of lease';

  @override
  String get noEndDate => 'No end date';

  @override
  String get endAfterStart => 'The end must be after the start.';

  @override
  String get benefitSaved =>
      'Benefit saved. Recalculate unlocked invoices if needed.';

  @override
  String get invoices => 'Invoices';

  @override
  String get payments => 'Payments';

  @override
  String get noInvoiceThisMonth => 'No invoices this month';

  @override
  String get noInvoiceThisMonthHelp =>
      'Enter this month\'s readings, then generate invoices from the Readings tab.';

  @override
  String get remaining => 'Remaining';

  @override
  String get filterAll => 'All';

  @override
  String get filterUnpaid => 'Unpaid';

  @override
  String get filterPaid => 'Paid';

  @override
  String get downloadAllInvoices => 'Download all invoices (PDF)';

  @override
  String invoicesOfMonth(String month) {
    return 'Invoices $month';
  }

  @override
  String get noPaymentThisMonth => 'No payments this month';

  @override
  String get totalCollected => 'Total collected';

  @override
  String get overdue => 'Overdue';

  @override
  String remainingAmount(String amount) {
    return '$amount left';
  }

  @override
  String get depositApplied => 'Deposit applied';

  @override
  String get refundKind => 'Refund';

  @override
  String get refundReceipt => 'Refund receipt';

  @override
  String get invoiceNotFound => 'Invoice not found';

  @override
  String get recalculate => 'Recalculate';

  @override
  String get invoiceRecalculated => 'Invoice recalculated';

  @override
  String recalculatedWarnings(String count) {
    return 'Recalculated · $count warning(s)';
  }

  @override
  String get deleteInvoiceQ => 'Delete the invoice?';

  @override
  String get locked => 'Locked';

  @override
  String get editable => 'Editable';

  @override
  String remainingToPayAmount(String amount) {
    return 'Balance due: $amount';
  }

  @override
  String get period => 'Period';

  @override
  String get type => 'Type';

  @override
  String get exitInvoice => 'Move-out invoice';

  @override
  String get monthly => 'Monthly';

  @override
  String get issuedOn => 'Issued on';

  @override
  String get dueDate => 'Due date';

  @override
  String get detail => 'Details';

  @override
  String get ofWhichVat => 'of which VAT';

  @override
  String get total => 'Total';

  @override
  String get exitInvoiceFinal => 'Move-out invoice: final.';

  @override
  String get laterMonthBilled =>
      'A later month has been billed: this invoice is final.';

  @override
  String get pdf => 'PDF';

  @override
  String get collectPayment => 'Record a payment';

  @override
  String get saveRefund => 'Save refund';

  @override
  String get savePayment => 'Save payment';

  @override
  String get refundSaved => 'Refund saved';

  @override
  String get paymentSaved => 'Payment saved';

  @override
  String receiptNo(String number) {
    return 'Receipt no. $number';
  }

  @override
  String get viewRefundReceipt => 'View receipt';

  @override
  String get viewReceipt => 'View receipt';

  @override
  String get balanceDue => 'Balance due';

  @override
  String get inTenantFavor => 'In tenant\'s favour';

  @override
  String get amountReceived => 'Amount received';

  @override
  String get paymentDate => 'Payment date';

  @override
  String get referenceHint => 'Reference (transaction, cheque…)';

  @override
  String invoicesFor(String month) {
    return 'Invoices for $month';
  }

  @override
  String generationSummary(String created, String updated) {
    return '$created created, $updated updated.';
  }

  @override
  String generationSummaryLocked(
    String created,
    String updated,
    String locked,
  ) {
    return '$created created, $updated updated, $locked locked and unchanged.';
  }

  @override
  String get warnings => 'Warnings:';

  @override
  String get viewInvoices => 'View invoices';

  @override
  String get exportMonthReadings => 'Export this month\'s readings';

  @override
  String get noMeter => 'No meters';

  @override
  String get noMeterHelp =>
      'Add meters to apartments (Properties tab) to enter readings.';

  @override
  String get metersRead => 'meters read';

  @override
  String photosCount(String count) {
    return '$count photo(s)';
  }

  @override
  String get generateInvoices => 'Generate invoices';

  @override
  String previousValue(String value) {
    return 'Previous: $value';
  }

  @override
  String get noPhoto => 'No photo';

  @override
  String get previous => 'Previous';

  @override
  String get readingLocked =>
      'A more recent reading exists: this reading is locked.';

  @override
  String get newReading => 'New reading';

  @override
  String get readingLowerThanPrevious => 'Reading lower than previous';

  @override
  String anomalyHelp(String average) {
    return '⚠ Consumption more than 2× the average ($average)';
  }

  @override
  String get photographMeter => 'Photograph the meter';

  @override
  String get retakePhoto => 'Retake photo';

  @override
  String get readingDate => 'Reading date';

  @override
  String get noPhotoTitle => 'No photo';

  @override
  String get saveWithoutPhoto => 'Save this reading without a meter photo?';

  @override
  String get restoreQ => 'Restore this backup?';

  @override
  String get restoreHelp =>
      'All current data will be replaced. A safety backup of the current state is created automatically first.';

  @override
  String get restore => 'Restore';

  @override
  String get backup => 'Backup';

  @override
  String get backupHelp =>
      'All data stays on this phone. Create a backup regularly and send it elsewhere (Drive, email, WhatsApp, USB stick): if the phone is lost, it is your only copy.';

  @override
  String get backupShareText => 'NHimmo backup';

  @override
  String get createShareBackup => 'Create and share a backup';

  @override
  String get chooseBackupFile => 'Choose a NHimmo backup (.zip)';

  @override
  String get restoreFromFile => 'Restore from a file';

  @override
  String get localBackups => 'Backups on this phone';

  @override
  String get noLocalBackup => 'No local backup.';

  @override
  String sizeKb(String size) {
    return '$size KB';
  }

  @override
  String get share => 'Share';

  @override
  String get meterTypes => 'Meter types';

  @override
  String get meterTypesHelp =>
      'One calculation for all: consumption × unit price + maintenance, VAT according to the chosen mode. To supply gas, simply add a “Gas” type.';

  @override
  String get inactive => 'Inactive';

  @override
  String pricePerUnit(String price, String unit) {
    return '$price / $unit';
  }

  @override
  String maintenanceShort(String amount) {
    return 'maintenance $amount';
  }

  @override
  String withRate(String mode, String rate) {
    return '$mode ($rate%)';
  }

  @override
  String get newType => 'New type';

  @override
  String get newMeterType => 'New meter type';

  @override
  String get name => 'Name';

  @override
  String get gasHint => 'e.g. Gas';

  @override
  String get unitOfMeasure => 'Unit of measure';

  @override
  String get unitHint => 'e.g. m³, kWh';

  @override
  String get tariff => 'Rate';

  @override
  String get unitPrice => 'Price per unit';

  @override
  String get meterFee => 'Meter maintenance / rental (per month)';

  @override
  String get vat => 'VAT';

  @override
  String get vatNoneShort => 'None';

  @override
  String get vatIncludedCap => 'Included';

  @override
  String get vatAddedCap => 'Added';

  @override
  String get vatRate => 'VAT rate';

  @override
  String get rateRequired => 'Rate required';

  @override
  String get vatOnFee => 'VAT also on maintenance';

  @override
  String get simulation => 'Simulation';

  @override
  String get excludingTax => 'Excl. tax';

  @override
  String get totalCharged => 'Total charged';

  @override
  String get active => 'Active';

  @override
  String get inactiveTypeHelp => 'An inactive type is no longer offered.';

  @override
  String get translations => 'Translations';

  @override
  String get translationsHelp =>
      'Name shown on documents for tenants of each language (empty = main name).';

  @override
  String nameIn(String lang) {
    return 'Name ($lang)';
  }

  @override
  String unitIn(String lang) {
    return 'Unit ($lang)';
  }

  @override
  String get noService => 'No services';

  @override
  String servicePriceLine(String price, String unit) {
    return '$price per $unit per month';
  }

  @override
  String get newService => 'New service';

  @override
  String get defaultUnit => 'unit';

  @override
  String get parkingHint => 'e.g. Parking';

  @override
  String get unit => 'Unit';

  @override
  String get serviceUnitHint => 'e.g. vehicle, space';

  @override
  String get monthlyPricePerUnit => 'Monthly price per unit';

  @override
  String get scopeReadings => 'Readings';

  @override
  String get scopeReadingsHelp =>
      'Readings, consumption, photos (yes/no), by month or period';

  @override
  String get scopeBilling => 'Billing';

  @override
  String get scopeBillingHelp => 'Invoices, detailed lines, payments, balances';

  @override
  String get scopeAll => 'All data';

  @override
  String get scopeAllHelp => 'All the app\'s tables';

  @override
  String get exports => 'Exports';

  @override
  String get whatToExport => 'What do you want to export?';

  @override
  String get thisMonth => 'This month';

  @override
  String get last3Months => 'Last 3 months';

  @override
  String get thisYear => 'This year';

  @override
  String get format => 'Format';

  @override
  String get fullBackupZip => 'Full backup (ZIP)';

  @override
  String get fullBackupHelp =>
      'Database + photos, can be re-imported into the app';

  @override
  String get exportAndShare => 'Export and share';

  @override
  String fromMonth(String month) {
    return 'From $month';
  }

  @override
  String toMonth(String month) {
    return 'To $month';
  }

  @override
  String get general => 'General';

  @override
  String get generalHelp =>
      'Name, contact details, language, currency, due date';

  @override
  String get meterTypesTileHelp =>
      'Water, electricity, gas… price, maintenance, VAT';

  @override
  String get servicesTileHelp => 'Parking, security…';

  @override
  String get exportsTileHelp => 'Readings, billing, all data';

  @override
  String get backupRestore => 'Backup and restore';

  @override
  String get backupRestoreHelp => 'Full ZIP file (data + photos)';

  @override
  String get demoLoaded => 'Demo data loaded';

  @override
  String get loadDemo => 'Load demo data';

  @override
  String get loadDemoHelp =>
      'To discover the app (only shown when it is empty)';

  @override
  String signatureKey(String key) {
    return 'Document signing key: $key';
  }

  @override
  String get managerHeader => 'Manager (document header)';

  @override
  String get businessName => 'Name / company name';

  @override
  String get invoiceFooter => 'Invoice footer note';

  @override
  String get currency => 'Currency';

  @override
  String get customSymbol => 'Displayed symbol (custom currency)';

  @override
  String get symbolBefore => 'Symbol before the amount';

  @override
  String preview(String value) {
    return 'Preview: $value';
  }

  @override
  String get billing => 'Billing';

  @override
  String get invoiceDueDay => 'Invoice due day';

  @override
  String get scanTitle => 'Scan a document';

  @override
  String get scanHelp =>
      'Point at the QR code of a printed invoice, receipt or move-out statement.';

  @override
  String docWithNumber(String doc, String number) {
    return '$doc $number';
  }

  @override
  String balanceAtPrint(String amount) {
    return 'Balance when printed: $amount';
  }

  @override
  String get result => 'Result';

  @override
  String get qrUnknown => 'QR code not recognised';

  @override
  String get qrUnknownHelp =>
      'This QR code does not come from a NHimmo document.';

  @override
  String get verification => 'Verification';

  @override
  String get signatureInvalid => 'Invalid signature';

  @override
  String get signatureValid => 'Valid signature';

  @override
  String get documentAuthentic => 'Authentic document';

  @override
  String get documentChanged => 'Document changed since printing';

  @override
  String get signatureInvalidHelp =>
      'This document has been tampered with or was not issued by this app.';

  @override
  String get signatureValidHelp =>
      'The document was issued with your key, but it no longer exists in the data.';

  @override
  String get documentAuthenticHelp =>
      'The printed information matches the recorded data.';

  @override
  String get documentChangedHelp =>
      'The document has been regenerated since: open it to see the current version.';

  @override
  String get numberLabel => 'Number';

  @override
  String get openDocument => 'Open document';

  @override
  String get scanAnother => 'Scan another document';

  @override
  String pdfNumber(String number) {
    return 'No. $number';
  }

  @override
  String get pdfDigitalSignature => 'Digital signature';

  @override
  String get pdfDesignation => 'Description';

  @override
  String get pdfExclTax => 'Excl. tax';

  @override
  String get pdfAmount => 'Amount';

  @override
  String get pdfFooter =>
      'Digitally signed document, verifiable by QR code in NHimmo';

  @override
  String pdfPage(String page, String total) {
    return 'Page $page/$total';
  }

  @override
  String get pdfDefaultThanks => 'Thank you for your payment.';

  @override
  String pdfPeriod(String period) {
    return 'Period: $period';
  }

  @override
  String pdfIssuedDue(String issued, String due) {
    return 'Issued $issued  ·  Due $due';
  }

  @override
  String get pdfLandlord => 'Landlord / manager';

  @override
  String get pdfTenant => 'Tenant';

  @override
  String get pdfTotalExclTax => 'Total excl. tax';

  @override
  String get pdfTotalDue => 'Total due';

  @override
  String get pdfStatus => 'Status';

  @override
  String get pdfPaidStamp => 'PAID';

  @override
  String pdfNotes(String notes) {
    return 'Notes: $notes';
  }

  @override
  String pdfDate(String date) {
    return 'Date: $date';
  }

  @override
  String pdfRefundText(String manager, String tenant) {
    return 'The manager $manager has refunded $tenant the sum of:';
  }

  @override
  String pdfReceivedText(String tenant, String place) {
    return 'Received from $tenant, tenant of $place, the sum of:';
  }

  @override
  String pdfPaymentMethod(String method) {
    return 'Payment method: $method';
  }

  @override
  String pdfReference(String ref) {
    return 'ref. $ref';
  }

  @override
  String pdfNote(String note) {
    return 'Note: $note';
  }

  @override
  String pdfBalanceAfter(String amount) {
    return 'Tenant account balance after this payment: $amount';
  }

  @override
  String pdfDoneOn(String date) {
    return 'Issued on $date';
  }

  @override
  String get pdfExitTitle => 'End-of-lease statement';

  @override
  String pdfMoveInOut(String moveIn, String moveOut) {
    return 'Move-in: $moveIn  ·  Move-out: $moveOut';
  }

  @override
  String get pdfLastMonthProrata => 'Last month: prorated by days';

  @override
  String get pdfLastMonthFull => 'Last month: full month';

  @override
  String get pdfOutgoingTenant => 'Outgoing tenant';

  @override
  String get pdfSectionExitInvoice => '1. Move-out invoice';

  @override
  String get pdfNoLine => 'No lines.';

  @override
  String get pdfSectionDamages => '2. Damages noted';

  @override
  String get pdfRoom => 'Room';

  @override
  String get pdfItem => 'Item';

  @override
  String get pdfCondition => 'Condition';

  @override
  String get pdfComment => 'Comment';

  @override
  String get pdfCost => 'Cost';

  @override
  String pdfSectionSummary(String n) {
    return '$n. Account summary';
  }

  @override
  String get pdfTotalLease => 'Total billed over the whole lease';

  @override
  String get pdfTotalTenantPaid => 'Total paid by the tenant';

  @override
  String get pdfDepositApplied => 'Deposit paid at move-in (applied)';

  @override
  String get pdfDamagesFromDeposit => 'of which damages withheld from deposit';

  @override
  String get pdfRefundsDone => 'Refunds already made';

  @override
  String get pdfTenantOwes => 'Balance payable by the tenant';

  @override
  String get pdfToRefund => 'To be refunded to the tenant';

  @override
  String get pdfSettled => 'Account settled';

  @override
  String get pdfDepositNotEnough =>
      'The deposit does not cover all amounts due: the tenant must pay the amount above.';

  @override
  String pdfObservations(String notes) {
    return 'Remarks: $notes';
  }

  @override
  String get pdfManagerSign => 'The manager';

  @override
  String get pdfTenantSign => 'The tenant (read and approved)';

  @override
  String get xBuilding => 'Building';

  @override
  String get xApartment => 'Apartment';

  @override
  String get xMeter => 'Meter';

  @override
  String get xReading => 'Reading';

  @override
  String get xPreviousReading => 'Previous reading';

  @override
  String get xYes => 'yes';

  @override
  String get xNo => 'no';

  @override
  String get xKindMonthly => 'Monthly';

  @override
  String get xInvoiceNo => 'Invoice no.';

  @override
  String xTotalWith(String symbol) {
    return 'Total ($symbol)';
  }

  @override
  String get xLabel => 'Label';

  @override
  String get xDetails => 'Details';

  @override
  String get xQuantity => 'Quantity';

  @override
  String get xUnitPrice => 'Unit price';

  @override
  String get xInclTax => 'Incl. tax';

  @override
  String get xStartReading => 'Start reading';

  @override
  String get xEndReading => 'End reading';

  @override
  String get xReceiptNo => 'Receipt no.';

  @override
  String get xMethod => 'Method';

  @override
  String get xReference => 'Reference';

  @override
  String get xPayment => 'Payment';

  @override
  String get xBalanceSigned => 'Balance (+ due / − to refund)';

  @override
  String get xSheetLines => 'Lines';

  @override
  String get xSheetBalances => 'Balances';

  @override
  String get backupNotMyImmo => 'This file is not a NHimmo backup.';

  @override
  String get backupUnknownFormat => 'Unknown backup format.';

  @override
  String get backupTooRecent => 'Backup created by a newer version of the app.';

  @override
  String get editPayment => 'Edit payment';

  @override
  String get completeDeposit => 'Complete the deposit';

  @override
  String get paymentUpdated => 'Payment updated';

  @override
  String get depositMissing => 'Still to pay';

  @override
  String get depositAmountReceived => 'Deposit amount received';

  @override
  String get depositReceived => 'Deposit received';

  @override
  String get deletePaymentQ => 'Delete this payment?';

  @override
  String deletePaymentHelp(String number) {
    return 'Payment $number will be deleted and the tenant\'s balance recalculated.';
  }

  @override
  String get paymentDeleted => 'Payment deleted';

  @override
  String get paymentLockedHelp =>
      'A more recent payment exists: only the latest payment can be edited or deleted.';

  @override
  String get paymentAutoLocked =>
      'Deposit applied automatically when the lease was closed: cannot be edited.';

  @override
  String get depositIncomplete => 'Deposit incomplete';

  @override
  String get depositIncompleteShort => 'Deposit incomplete';

  @override
  String depositIncompleteDetail(String paid, String required) {
    return 'Deposit paid: $paid of $required';
  }

  @override
  String depositMissingAmount(String amount) {
    return 'Still to pay: $amount';
  }

  @override
  String get complete => 'Complete';

  @override
  String get incompleteDeposits => 'Incomplete deposits';

  @override
  String get creditSettlement => 'Settlement from credit';

  @override
  String get creditAvailable => 'Credit / payments available';

  @override
  String get creditApplied => 'Deducted from credit';

  @override
  String get creditRemaining => 'Credit remaining after this invoice';

  @override
  String get depositReceipt => 'Deposit receipt';

  @override
  String pdfDepositReceivedText(String tenant, String place) {
    return 'Received from $tenant, tenant of $place, as security deposit, the sum of:';
  }
}
