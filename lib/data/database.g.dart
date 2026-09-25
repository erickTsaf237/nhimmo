// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $OwnersTable extends Owners with TableInfo<$OwnersTable, Owner> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OwnersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    email,
    address,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'owners';
  @override
  VerificationContext validateIntegrity(
    Insertable<Owner> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Owner map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Owner(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $OwnersTable createAlias(String alias) {
    return $OwnersTable(attachedDatabase, alias);
  }
}

class Owner extends DataClass implements Insertable<Owner> {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  const Owner({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  OwnersCompanion toCompanion(bool nullToAbsent) {
    return OwnersCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Owner.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Owner(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Owner copyWith({
    int? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Owner(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    address: address.present ? address.value : this.address,
    notes: notes.present ? notes.value : this.notes,
  );
  Owner copyWithCompanion(OwnersCompanion data) {
    return Owner(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Owner(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, email, address, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Owner &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.notes == this.notes);
}

class OwnersCompanion extends UpdateCompanion<Owner> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> notes;
  const OwnersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
  });
  OwnersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Owner> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
    });
  }

  OwnersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? address,
    Value<String?>? notes,
  }) {
    return OwnersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OwnersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $BuildingsTable extends Buildings
    with TableInfo<$BuildingsTable, Building> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BuildingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES owners (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, ownerId, name, address, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'buildings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Building> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Building map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Building(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $BuildingsTable createAlias(String alias) {
    return $BuildingsTable(attachedDatabase, alias);
  }
}

class Building extends DataClass implements Insertable<Building> {
  final int id;
  final int ownerId;
  final String name;
  final String? address;
  final String? notes;
  const Building({
    required this.id,
    required this.ownerId,
    required this.name,
    this.address,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_id'] = Variable<int>(ownerId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  BuildingsCompanion toCompanion(bool nullToAbsent) {
    return BuildingsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Building.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Building(
      id: serializer.fromJson<int>(json['id']),
      ownerId: serializer.fromJson<int>(json['ownerId']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerId': serializer.toJson<int>(ownerId),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Building copyWith({
    int? id,
    int? ownerId,
    String? name,
    Value<String?> address = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Building(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    name: name ?? this.name,
    address: address.present ? address.value : this.address,
    notes: notes.present ? notes.value : this.notes,
  );
  Building copyWithCompanion(BuildingsCompanion data) {
    return Building(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Building(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ownerId, name, address, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Building &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.name == this.name &&
          other.address == this.address &&
          other.notes == this.notes);
}

class BuildingsCompanion extends UpdateCompanion<Building> {
  final Value<int> id;
  final Value<int> ownerId;
  final Value<String> name;
  final Value<String?> address;
  final Value<String?> notes;
  const BuildingsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
  });
  BuildingsCompanion.insert({
    this.id = const Value.absent(),
    required int ownerId,
    required String name,
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
  }) : ownerId = Value(ownerId),
       name = Value(name);
  static Insertable<Building> custom({
    Expression<int>? id,
    Expression<int>? ownerId,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
    });
  }

  BuildingsCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerId,
    Value<String>? name,
    Value<String?>? address,
    Value<String?>? notes,
  }) {
    return BuildingsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      address: address ?? this.address,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BuildingsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $ApartmentsTable extends Apartments
    with TableInfo<$ApartmentsTable, Apartment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApartmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _buildingIdMeta = const VerificationMeta(
    'buildingId',
  );
  @override
  late final GeneratedColumn<int> buildingId = GeneratedColumn<int>(
    'building_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES buildings (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _floorMeta = const VerificationMeta('floor');
  @override
  late final GeneratedColumn<String> floor = GeneratedColumn<String>(
    'floor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rentMeta = const VerificationMeta('rent');
  @override
  late final GeneratedColumn<int> rent = GeneratedColumn<int>(
    'rent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _depositMeta = const VerificationMeta(
    'deposit',
  );
  @override
  late final GeneratedColumn<int> deposit = GeneratedColumn<int>(
    'deposit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    buildingId,
    name,
    floor,
    description,
    rent,
    deposit,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'apartments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Apartment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('building_id')) {
      context.handle(
        _buildingIdMeta,
        buildingId.isAcceptableOrUnknown(data['building_id']!, _buildingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_buildingIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('floor')) {
      context.handle(
        _floorMeta,
        floor.isAcceptableOrUnknown(data['floor']!, _floorMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('rent')) {
      context.handle(
        _rentMeta,
        rent.isAcceptableOrUnknown(data['rent']!, _rentMeta),
      );
    }
    if (data.containsKey('deposit')) {
      context.handle(
        _depositMeta,
        deposit.isAcceptableOrUnknown(data['deposit']!, _depositMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Apartment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Apartment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      buildingId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}building_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      floor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}floor'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      rent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rent'],
      )!,
      deposit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deposit'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $ApartmentsTable createAlias(String alias) {
    return $ApartmentsTable(attachedDatabase, alias);
  }
}

class Apartment extends DataClass implements Insertable<Apartment> {
  final int id;
  final int buildingId;
  final String name;
  final String? floor;
  final String? description;

  /// Loyer et caution proposés par défaut (centimes).
  final int rent;
  final int deposit;
  final bool archived;
  const Apartment({
    required this.id,
    required this.buildingId,
    required this.name,
    this.floor,
    this.description,
    required this.rent,
    required this.deposit,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['building_id'] = Variable<int>(buildingId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || floor != null) {
      map['floor'] = Variable<String>(floor);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['rent'] = Variable<int>(rent);
    map['deposit'] = Variable<int>(deposit);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  ApartmentsCompanion toCompanion(bool nullToAbsent) {
    return ApartmentsCompanion(
      id: Value(id),
      buildingId: Value(buildingId),
      name: Value(name),
      floor: floor == null && nullToAbsent
          ? const Value.absent()
          : Value(floor),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      rent: Value(rent),
      deposit: Value(deposit),
      archived: Value(archived),
    );
  }

  factory Apartment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Apartment(
      id: serializer.fromJson<int>(json['id']),
      buildingId: serializer.fromJson<int>(json['buildingId']),
      name: serializer.fromJson<String>(json['name']),
      floor: serializer.fromJson<String?>(json['floor']),
      description: serializer.fromJson<String?>(json['description']),
      rent: serializer.fromJson<int>(json['rent']),
      deposit: serializer.fromJson<int>(json['deposit']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'buildingId': serializer.toJson<int>(buildingId),
      'name': serializer.toJson<String>(name),
      'floor': serializer.toJson<String?>(floor),
      'description': serializer.toJson<String?>(description),
      'rent': serializer.toJson<int>(rent),
      'deposit': serializer.toJson<int>(deposit),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  Apartment copyWith({
    int? id,
    int? buildingId,
    String? name,
    Value<String?> floor = const Value.absent(),
    Value<String?> description = const Value.absent(),
    int? rent,
    int? deposit,
    bool? archived,
  }) => Apartment(
    id: id ?? this.id,
    buildingId: buildingId ?? this.buildingId,
    name: name ?? this.name,
    floor: floor.present ? floor.value : this.floor,
    description: description.present ? description.value : this.description,
    rent: rent ?? this.rent,
    deposit: deposit ?? this.deposit,
    archived: archived ?? this.archived,
  );
  Apartment copyWithCompanion(ApartmentsCompanion data) {
    return Apartment(
      id: data.id.present ? data.id.value : this.id,
      buildingId: data.buildingId.present
          ? data.buildingId.value
          : this.buildingId,
      name: data.name.present ? data.name.value : this.name,
      floor: data.floor.present ? data.floor.value : this.floor,
      description: data.description.present
          ? data.description.value
          : this.description,
      rent: data.rent.present ? data.rent.value : this.rent,
      deposit: data.deposit.present ? data.deposit.value : this.deposit,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Apartment(')
          ..write('id: $id, ')
          ..write('buildingId: $buildingId, ')
          ..write('name: $name, ')
          ..write('floor: $floor, ')
          ..write('description: $description, ')
          ..write('rent: $rent, ')
          ..write('deposit: $deposit, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    buildingId,
    name,
    floor,
    description,
    rent,
    deposit,
    archived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Apartment &&
          other.id == this.id &&
          other.buildingId == this.buildingId &&
          other.name == this.name &&
          other.floor == this.floor &&
          other.description == this.description &&
          other.rent == this.rent &&
          other.deposit == this.deposit &&
          other.archived == this.archived);
}

class ApartmentsCompanion extends UpdateCompanion<Apartment> {
  final Value<int> id;
  final Value<int> buildingId;
  final Value<String> name;
  final Value<String?> floor;
  final Value<String?> description;
  final Value<int> rent;
  final Value<int> deposit;
  final Value<bool> archived;
  const ApartmentsCompanion({
    this.id = const Value.absent(),
    this.buildingId = const Value.absent(),
    this.name = const Value.absent(),
    this.floor = const Value.absent(),
    this.description = const Value.absent(),
    this.rent = const Value.absent(),
    this.deposit = const Value.absent(),
    this.archived = const Value.absent(),
  });
  ApartmentsCompanion.insert({
    this.id = const Value.absent(),
    required int buildingId,
    required String name,
    this.floor = const Value.absent(),
    this.description = const Value.absent(),
    this.rent = const Value.absent(),
    this.deposit = const Value.absent(),
    this.archived = const Value.absent(),
  }) : buildingId = Value(buildingId),
       name = Value(name);
  static Insertable<Apartment> custom({
    Expression<int>? id,
    Expression<int>? buildingId,
    Expression<String>? name,
    Expression<String>? floor,
    Expression<String>? description,
    Expression<int>? rent,
    Expression<int>? deposit,
    Expression<bool>? archived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (buildingId != null) 'building_id': buildingId,
      if (name != null) 'name': name,
      if (floor != null) 'floor': floor,
      if (description != null) 'description': description,
      if (rent != null) 'rent': rent,
      if (deposit != null) 'deposit': deposit,
      if (archived != null) 'archived': archived,
    });
  }

  ApartmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? buildingId,
    Value<String>? name,
    Value<String?>? floor,
    Value<String?>? description,
    Value<int>? rent,
    Value<int>? deposit,
    Value<bool>? archived,
  }) {
    return ApartmentsCompanion(
      id: id ?? this.id,
      buildingId: buildingId ?? this.buildingId,
      name: name ?? this.name,
      floor: floor ?? this.floor,
      description: description ?? this.description,
      rent: rent ?? this.rent,
      deposit: deposit ?? this.deposit,
      archived: archived ?? this.archived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (buildingId.present) {
      map['building_id'] = Variable<int>(buildingId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (floor.present) {
      map['floor'] = Variable<String>(floor.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rent.present) {
      map['rent'] = Variable<int>(rent.value);
    }
    if (deposit.present) {
      map['deposit'] = Variable<int>(deposit.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApartmentsCompanion(')
          ..write('id: $id, ')
          ..write('buildingId: $buildingId, ')
          ..write('name: $name, ')
          ..write('floor: $floor, ')
          ..write('description: $description, ')
          ..write('rent: $rent, ')
          ..write('deposit: $deposit, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }
}

class $TenantsTable extends Tenants with TableInfo<$TenantsTable, Tenant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TenantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idNumberMeta = const VerificationMeta(
    'idNumber',
  );
  @override
  late final GeneratedColumn<String> idNumber = GeneratedColumn<String>(
    'id_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emergencyContactMeta = const VerificationMeta(
    'emergencyContact',
  );
  @override
  late final GeneratedColumn<String> emergencyContact = GeneratedColumn<String>(
    'emergency_contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fullName,
    phone,
    email,
    idNumber,
    emergencyContact,
    language,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tenants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tenant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('id_number')) {
      context.handle(
        _idNumberMeta,
        idNumber.isAcceptableOrUnknown(data['id_number']!, _idNumberMeta),
      );
    }
    if (data.containsKey('emergency_contact')) {
      context.handle(
        _emergencyContactMeta,
        emergencyContact.isAcceptableOrUnknown(
          data['emergency_contact']!,
          _emergencyContactMeta,
        ),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tenant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tenant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      idNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_number'],
      ),
      emergencyContact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emergency_contact'],
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $TenantsTable createAlias(String alias) {
    return $TenantsTable(attachedDatabase, alias);
  }
}

class Tenant extends DataClass implements Insertable<Tenant> {
  final int id;
  final String fullName;
  final String? phone;
  final String? email;
  final String? idNumber;
  final String? emergencyContact;

  /// Langue des documents du locataire (null = langue de l'application).
  final String? language;
  final String? notes;
  const Tenant({
    required this.id,
    required this.fullName,
    this.phone,
    this.email,
    this.idNumber,
    this.emergencyContact,
    this.language,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || idNumber != null) {
      map['id_number'] = Variable<String>(idNumber);
    }
    if (!nullToAbsent || emergencyContact != null) {
      map['emergency_contact'] = Variable<String>(emergencyContact);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  TenantsCompanion toCompanion(bool nullToAbsent) {
    return TenantsCompanion(
      id: Value(id),
      fullName: Value(fullName),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      idNumber: idNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(idNumber),
      emergencyContact: emergencyContact == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyContact),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Tenant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tenant(
      id: serializer.fromJson<int>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      idNumber: serializer.fromJson<String?>(json['idNumber']),
      emergencyContact: serializer.fromJson<String?>(json['emergencyContact']),
      language: serializer.fromJson<String?>(json['language']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fullName': serializer.toJson<String>(fullName),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'idNumber': serializer.toJson<String?>(idNumber),
      'emergencyContact': serializer.toJson<String?>(emergencyContact),
      'language': serializer.toJson<String?>(language),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Tenant copyWith({
    int? id,
    String? fullName,
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> idNumber = const Value.absent(),
    Value<String?> emergencyContact = const Value.absent(),
    Value<String?> language = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Tenant(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    idNumber: idNumber.present ? idNumber.value : this.idNumber,
    emergencyContact: emergencyContact.present
        ? emergencyContact.value
        : this.emergencyContact,
    language: language.present ? language.value : this.language,
    notes: notes.present ? notes.value : this.notes,
  );
  Tenant copyWithCompanion(TenantsCompanion data) {
    return Tenant(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      idNumber: data.idNumber.present ? data.idNumber.value : this.idNumber,
      emergencyContact: data.emergencyContact.present
          ? data.emergencyContact.value
          : this.emergencyContact,
      language: data.language.present ? data.language.value : this.language,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tenant(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('idNumber: $idNumber, ')
          ..write('emergencyContact: $emergencyContact, ')
          ..write('language: $language, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fullName,
    phone,
    email,
    idNumber,
    emergencyContact,
    language,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tenant &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.idNumber == this.idNumber &&
          other.emergencyContact == this.emergencyContact &&
          other.language == this.language &&
          other.notes == this.notes);
}

class TenantsCompanion extends UpdateCompanion<Tenant> {
  final Value<int> id;
  final Value<String> fullName;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> idNumber;
  final Value<String?> emergencyContact;
  final Value<String?> language;
  final Value<String?> notes;
  const TenantsCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.idNumber = const Value.absent(),
    this.emergencyContact = const Value.absent(),
    this.language = const Value.absent(),
    this.notes = const Value.absent(),
  });
  TenantsCompanion.insert({
    this.id = const Value.absent(),
    required String fullName,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.idNumber = const Value.absent(),
    this.emergencyContact = const Value.absent(),
    this.language = const Value.absent(),
    this.notes = const Value.absent(),
  }) : fullName = Value(fullName);
  static Insertable<Tenant> custom({
    Expression<int>? id,
    Expression<String>? fullName,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? idNumber,
    Expression<String>? emergencyContact,
    Expression<String>? language,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (idNumber != null) 'id_number': idNumber,
      if (emergencyContact != null) 'emergency_contact': emergencyContact,
      if (language != null) 'language': language,
      if (notes != null) 'notes': notes,
    });
  }

  TenantsCompanion copyWith({
    Value<int>? id,
    Value<String>? fullName,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? idNumber,
    Value<String?>? emergencyContact,
    Value<String?>? language,
    Value<String?>? notes,
  }) {
    return TenantsCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      idNumber: idNumber ?? this.idNumber,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      language: language ?? this.language,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (idNumber.present) {
      map['id_number'] = Variable<String>(idNumber.value);
    }
    if (emergencyContact.present) {
      map['emergency_contact'] = Variable<String>(emergencyContact.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TenantsCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('idNumber: $idNumber, ')
          ..write('emergencyContact: $emergencyContact, ')
          ..write('language: $language, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $UtilityTypesTable extends UtilityTypes
    with TableInfo<$UtilityTypesTable, UtilityType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UtilityTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<int> unitPrice = GeneratedColumn<int>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fixedFeeMeta = const VerificationMeta(
    'fixedFee',
  );
  @override
  late final GeneratedColumn<int> fixedFee = GeneratedColumn<int>(
    'fixed_fee',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _vatRateMeta = const VerificationMeta(
    'vatRate',
  );
  @override
  late final GeneratedColumn<double> vatRate = GeneratedColumn<double>(
    'vat_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _vatModeMeta = const VerificationMeta(
    'vatMode',
  );
  @override
  late final GeneratedColumn<int> vatMode = GeneratedColumn<int>(
    'vat_mode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _vatOnFixedFeeMeta = const VerificationMeta(
    'vatOnFixedFee',
  );
  @override
  late final GeneratedColumn<bool> vatOnFixedFee = GeneratedColumn<bool>(
    'vat_on_fixed_fee',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vat_on_fixed_fee" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bolt'),
  );
  static const VerificationMeta _translationsMeta = const VerificationMeta(
    'translations',
  );
  @override
  late final GeneratedColumn<String> translations = GeneratedColumn<String>(
    'translations',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF0E7C7B),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    unit,
    unitPrice,
    fixedFee,
    vatRate,
    vatMode,
    vatOnFixedFee,
    iconKey,
    translations,
    colorValue,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'utility_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<UtilityType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('fixed_fee')) {
      context.handle(
        _fixedFeeMeta,
        fixedFee.isAcceptableOrUnknown(data['fixed_fee']!, _fixedFeeMeta),
      );
    }
    if (data.containsKey('vat_rate')) {
      context.handle(
        _vatRateMeta,
        vatRate.isAcceptableOrUnknown(data['vat_rate']!, _vatRateMeta),
      );
    }
    if (data.containsKey('vat_mode')) {
      context.handle(
        _vatModeMeta,
        vatMode.isAcceptableOrUnknown(data['vat_mode']!, _vatModeMeta),
      );
    }
    if (data.containsKey('vat_on_fixed_fee')) {
      context.handle(
        _vatOnFixedFeeMeta,
        vatOnFixedFee.isAcceptableOrUnknown(
          data['vat_on_fixed_fee']!,
          _vatOnFixedFeeMeta,
        ),
      );
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('translations')) {
      context.handle(
        _translationsMeta,
        translations.isAcceptableOrUnknown(
          data['translations']!,
          _translationsMeta,
        ),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UtilityType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UtilityType(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price'],
      )!,
      fixedFee: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fixed_fee'],
      )!,
      vatRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vat_rate'],
      )!,
      vatMode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vat_mode'],
      )!,
      vatOnFixedFee: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vat_on_fixed_fee'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      translations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translations'],
      ),
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $UtilityTypesTable createAlias(String alias) {
    return $UtilityTypesTable(attachedDatabase, alias);
  }
}

class UtilityType extends DataClass implements Insertable<UtilityType> {
  final int id;
  final String name;
  final String unit;
  final int unitPrice;
  final int fixedFee;
  final double vatRate;

  /// Index de [VatMode].
  final int vatMode;
  final bool vatOnFixedFee;
  final String iconKey;

  /// Noms dans les autres langues, JSON : {"en": "Water"}.
  final String? translations;
  final int colorValue;
  final bool active;
  const UtilityType({
    required this.id,
    required this.name,
    required this.unit,
    required this.unitPrice,
    required this.fixedFee,
    required this.vatRate,
    required this.vatMode,
    required this.vatOnFixedFee,
    required this.iconKey,
    this.translations,
    required this.colorValue,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['unit'] = Variable<String>(unit);
    map['unit_price'] = Variable<int>(unitPrice);
    map['fixed_fee'] = Variable<int>(fixedFee);
    map['vat_rate'] = Variable<double>(vatRate);
    map['vat_mode'] = Variable<int>(vatMode);
    map['vat_on_fixed_fee'] = Variable<bool>(vatOnFixedFee);
    map['icon_key'] = Variable<String>(iconKey);
    if (!nullToAbsent || translations != null) {
      map['translations'] = Variable<String>(translations);
    }
    map['color_value'] = Variable<int>(colorValue);
    map['active'] = Variable<bool>(active);
    return map;
  }

  UtilityTypesCompanion toCompanion(bool nullToAbsent) {
    return UtilityTypesCompanion(
      id: Value(id),
      name: Value(name),
      unit: Value(unit),
      unitPrice: Value(unitPrice),
      fixedFee: Value(fixedFee),
      vatRate: Value(vatRate),
      vatMode: Value(vatMode),
      vatOnFixedFee: Value(vatOnFixedFee),
      iconKey: Value(iconKey),
      translations: translations == null && nullToAbsent
          ? const Value.absent()
          : Value(translations),
      colorValue: Value(colorValue),
      active: Value(active),
    );
  }

  factory UtilityType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UtilityType(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<String>(json['unit']),
      unitPrice: serializer.fromJson<int>(json['unitPrice']),
      fixedFee: serializer.fromJson<int>(json['fixedFee']),
      vatRate: serializer.fromJson<double>(json['vatRate']),
      vatMode: serializer.fromJson<int>(json['vatMode']),
      vatOnFixedFee: serializer.fromJson<bool>(json['vatOnFixedFee']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      translations: serializer.fromJson<String?>(json['translations']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<String>(unit),
      'unitPrice': serializer.toJson<int>(unitPrice),
      'fixedFee': serializer.toJson<int>(fixedFee),
      'vatRate': serializer.toJson<double>(vatRate),
      'vatMode': serializer.toJson<int>(vatMode),
      'vatOnFixedFee': serializer.toJson<bool>(vatOnFixedFee),
      'iconKey': serializer.toJson<String>(iconKey),
      'translations': serializer.toJson<String?>(translations),
      'colorValue': serializer.toJson<int>(colorValue),
      'active': serializer.toJson<bool>(active),
    };
  }

  UtilityType copyWith({
    int? id,
    String? name,
    String? unit,
    int? unitPrice,
    int? fixedFee,
    double? vatRate,
    int? vatMode,
    bool? vatOnFixedFee,
    String? iconKey,
    Value<String?> translations = const Value.absent(),
    int? colorValue,
    bool? active,
  }) => UtilityType(
    id: id ?? this.id,
    name: name ?? this.name,
    unit: unit ?? this.unit,
    unitPrice: unitPrice ?? this.unitPrice,
    fixedFee: fixedFee ?? this.fixedFee,
    vatRate: vatRate ?? this.vatRate,
    vatMode: vatMode ?? this.vatMode,
    vatOnFixedFee: vatOnFixedFee ?? this.vatOnFixedFee,
    iconKey: iconKey ?? this.iconKey,
    translations: translations.present ? translations.value : this.translations,
    colorValue: colorValue ?? this.colorValue,
    active: active ?? this.active,
  );
  UtilityType copyWithCompanion(UtilityTypesCompanion data) {
    return UtilityType(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      fixedFee: data.fixedFee.present ? data.fixedFee.value : this.fixedFee,
      vatRate: data.vatRate.present ? data.vatRate.value : this.vatRate,
      vatMode: data.vatMode.present ? data.vatMode.value : this.vatMode,
      vatOnFixedFee: data.vatOnFixedFee.present
          ? data.vatOnFixedFee.value
          : this.vatOnFixedFee,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      translations: data.translations.present
          ? data.translations.value
          : this.translations,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UtilityType(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('fixedFee: $fixedFee, ')
          ..write('vatRate: $vatRate, ')
          ..write('vatMode: $vatMode, ')
          ..write('vatOnFixedFee: $vatOnFixedFee, ')
          ..write('iconKey: $iconKey, ')
          ..write('translations: $translations, ')
          ..write('colorValue: $colorValue, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    unit,
    unitPrice,
    fixedFee,
    vatRate,
    vatMode,
    vatOnFixedFee,
    iconKey,
    translations,
    colorValue,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UtilityType &&
          other.id == this.id &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.unitPrice == this.unitPrice &&
          other.fixedFee == this.fixedFee &&
          other.vatRate == this.vatRate &&
          other.vatMode == this.vatMode &&
          other.vatOnFixedFee == this.vatOnFixedFee &&
          other.iconKey == this.iconKey &&
          other.translations == this.translations &&
          other.colorValue == this.colorValue &&
          other.active == this.active);
}

class UtilityTypesCompanion extends UpdateCompanion<UtilityType> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> unit;
  final Value<int> unitPrice;
  final Value<int> fixedFee;
  final Value<double> vatRate;
  final Value<int> vatMode;
  final Value<bool> vatOnFixedFee;
  final Value<String> iconKey;
  final Value<String?> translations;
  final Value<int> colorValue;
  final Value<bool> active;
  const UtilityTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.fixedFee = const Value.absent(),
    this.vatRate = const Value.absent(),
    this.vatMode = const Value.absent(),
    this.vatOnFixedFee = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.translations = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.active = const Value.absent(),
  });
  UtilityTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String unit,
    required int unitPrice,
    this.fixedFee = const Value.absent(),
    this.vatRate = const Value.absent(),
    this.vatMode = const Value.absent(),
    this.vatOnFixedFee = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.translations = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.active = const Value.absent(),
  }) : name = Value(name),
       unit = Value(unit),
       unitPrice = Value(unitPrice);
  static Insertable<UtilityType> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? unit,
    Expression<int>? unitPrice,
    Expression<int>? fixedFee,
    Expression<double>? vatRate,
    Expression<int>? vatMode,
    Expression<bool>? vatOnFixedFee,
    Expression<String>? iconKey,
    Expression<String>? translations,
    Expression<int>? colorValue,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (fixedFee != null) 'fixed_fee': fixedFee,
      if (vatRate != null) 'vat_rate': vatRate,
      if (vatMode != null) 'vat_mode': vatMode,
      if (vatOnFixedFee != null) 'vat_on_fixed_fee': vatOnFixedFee,
      if (iconKey != null) 'icon_key': iconKey,
      if (translations != null) 'translations': translations,
      if (colorValue != null) 'color_value': colorValue,
      if (active != null) 'active': active,
    });
  }

  UtilityTypesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? unit,
    Value<int>? unitPrice,
    Value<int>? fixedFee,
    Value<double>? vatRate,
    Value<int>? vatMode,
    Value<bool>? vatOnFixedFee,
    Value<String>? iconKey,
    Value<String?>? translations,
    Value<int>? colorValue,
    Value<bool>? active,
  }) {
    return UtilityTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      fixedFee: fixedFee ?? this.fixedFee,
      vatRate: vatRate ?? this.vatRate,
      vatMode: vatMode ?? this.vatMode,
      vatOnFixedFee: vatOnFixedFee ?? this.vatOnFixedFee,
      iconKey: iconKey ?? this.iconKey,
      translations: translations ?? this.translations,
      colorValue: colorValue ?? this.colorValue,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<int>(unitPrice.value);
    }
    if (fixedFee.present) {
      map['fixed_fee'] = Variable<int>(fixedFee.value);
    }
    if (vatRate.present) {
      map['vat_rate'] = Variable<double>(vatRate.value);
    }
    if (vatMode.present) {
      map['vat_mode'] = Variable<int>(vatMode.value);
    }
    if (vatOnFixedFee.present) {
      map['vat_on_fixed_fee'] = Variable<bool>(vatOnFixedFee.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (translations.present) {
      map['translations'] = Variable<String>(translations.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UtilityTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('fixedFee: $fixedFee, ')
          ..write('vatRate: $vatRate, ')
          ..write('vatMode: $vatMode, ')
          ..write('vatOnFixedFee: $vatOnFixedFee, ')
          ..write('iconKey: $iconKey, ')
          ..write('translations: $translations, ')
          ..write('colorValue: $colorValue, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $MetersTable extends Meters with TableInfo<$MetersTable, Meter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _apartmentIdMeta = const VerificationMeta(
    'apartmentId',
  );
  @override
  late final GeneratedColumn<int> apartmentId = GeneratedColumn<int>(
    'apartment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES apartments (id)',
    ),
  );
  static const VerificationMeta _utilityTypeIdMeta = const VerificationMeta(
    'utilityTypeId',
  );
  @override
  late final GeneratedColumn<int> utilityTypeId = GeneratedColumn<int>(
    'utility_type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES utility_types (id)',
    ),
  );
  static const VerificationMeta _serialMeta = const VerificationMeta('serial');
  @override
  late final GeneratedColumn<String> serial = GeneratedColumn<String>(
    'serial',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _initialIndexMeta = const VerificationMeta(
    'initialIndex',
  );
  @override
  late final GeneratedColumn<double> initialIndex = GeneratedColumn<double>(
    'initial_index',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    apartmentId,
    utilityTypeId,
    serial,
    initialIndex,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Meter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('apartment_id')) {
      context.handle(
        _apartmentIdMeta,
        apartmentId.isAcceptableOrUnknown(
          data['apartment_id']!,
          _apartmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_apartmentIdMeta);
    }
    if (data.containsKey('utility_type_id')) {
      context.handle(
        _utilityTypeIdMeta,
        utilityTypeId.isAcceptableOrUnknown(
          data['utility_type_id']!,
          _utilityTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_utilityTypeIdMeta);
    }
    if (data.containsKey('serial')) {
      context.handle(
        _serialMeta,
        serial.isAcceptableOrUnknown(data['serial']!, _serialMeta),
      );
    }
    if (data.containsKey('initial_index')) {
      context.handle(
        _initialIndexMeta,
        initialIndex.isAcceptableOrUnknown(
          data['initial_index']!,
          _initialIndexMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Meter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Meter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      apartmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}apartment_id'],
      )!,
      utilityTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}utility_type_id'],
      )!,
      serial: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial'],
      ),
      initialIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}initial_index'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $MetersTable createAlias(String alias) {
    return $MetersTable(attachedDatabase, alias);
  }
}

class Meter extends DataClass implements Insertable<Meter> {
  final int id;
  final int apartmentId;
  final int utilityTypeId;
  final String? serial;
  final double initialIndex;
  final bool active;
  const Meter({
    required this.id,
    required this.apartmentId,
    required this.utilityTypeId,
    this.serial,
    required this.initialIndex,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['apartment_id'] = Variable<int>(apartmentId);
    map['utility_type_id'] = Variable<int>(utilityTypeId);
    if (!nullToAbsent || serial != null) {
      map['serial'] = Variable<String>(serial);
    }
    map['initial_index'] = Variable<double>(initialIndex);
    map['active'] = Variable<bool>(active);
    return map;
  }

  MetersCompanion toCompanion(bool nullToAbsent) {
    return MetersCompanion(
      id: Value(id),
      apartmentId: Value(apartmentId),
      utilityTypeId: Value(utilityTypeId),
      serial: serial == null && nullToAbsent
          ? const Value.absent()
          : Value(serial),
      initialIndex: Value(initialIndex),
      active: Value(active),
    );
  }

  factory Meter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Meter(
      id: serializer.fromJson<int>(json['id']),
      apartmentId: serializer.fromJson<int>(json['apartmentId']),
      utilityTypeId: serializer.fromJson<int>(json['utilityTypeId']),
      serial: serializer.fromJson<String?>(json['serial']),
      initialIndex: serializer.fromJson<double>(json['initialIndex']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'apartmentId': serializer.toJson<int>(apartmentId),
      'utilityTypeId': serializer.toJson<int>(utilityTypeId),
      'serial': serializer.toJson<String?>(serial),
      'initialIndex': serializer.toJson<double>(initialIndex),
      'active': serializer.toJson<bool>(active),
    };
  }

  Meter copyWith({
    int? id,
    int? apartmentId,
    int? utilityTypeId,
    Value<String?> serial = const Value.absent(),
    double? initialIndex,
    bool? active,
  }) => Meter(
    id: id ?? this.id,
    apartmentId: apartmentId ?? this.apartmentId,
    utilityTypeId: utilityTypeId ?? this.utilityTypeId,
    serial: serial.present ? serial.value : this.serial,
    initialIndex: initialIndex ?? this.initialIndex,
    active: active ?? this.active,
  );
  Meter copyWithCompanion(MetersCompanion data) {
    return Meter(
      id: data.id.present ? data.id.value : this.id,
      apartmentId: data.apartmentId.present
          ? data.apartmentId.value
          : this.apartmentId,
      utilityTypeId: data.utilityTypeId.present
          ? data.utilityTypeId.value
          : this.utilityTypeId,
      serial: data.serial.present ? data.serial.value : this.serial,
      initialIndex: data.initialIndex.present
          ? data.initialIndex.value
          : this.initialIndex,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Meter(')
          ..write('id: $id, ')
          ..write('apartmentId: $apartmentId, ')
          ..write('utilityTypeId: $utilityTypeId, ')
          ..write('serial: $serial, ')
          ..write('initialIndex: $initialIndex, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, apartmentId, utilityTypeId, serial, initialIndex, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meter &&
          other.id == this.id &&
          other.apartmentId == this.apartmentId &&
          other.utilityTypeId == this.utilityTypeId &&
          other.serial == this.serial &&
          other.initialIndex == this.initialIndex &&
          other.active == this.active);
}

class MetersCompanion extends UpdateCompanion<Meter> {
  final Value<int> id;
  final Value<int> apartmentId;
  final Value<int> utilityTypeId;
  final Value<String?> serial;
  final Value<double> initialIndex;
  final Value<bool> active;
  const MetersCompanion({
    this.id = const Value.absent(),
    this.apartmentId = const Value.absent(),
    this.utilityTypeId = const Value.absent(),
    this.serial = const Value.absent(),
    this.initialIndex = const Value.absent(),
    this.active = const Value.absent(),
  });
  MetersCompanion.insert({
    this.id = const Value.absent(),
    required int apartmentId,
    required int utilityTypeId,
    this.serial = const Value.absent(),
    this.initialIndex = const Value.absent(),
    this.active = const Value.absent(),
  }) : apartmentId = Value(apartmentId),
       utilityTypeId = Value(utilityTypeId);
  static Insertable<Meter> custom({
    Expression<int>? id,
    Expression<int>? apartmentId,
    Expression<int>? utilityTypeId,
    Expression<String>? serial,
    Expression<double>? initialIndex,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (apartmentId != null) 'apartment_id': apartmentId,
      if (utilityTypeId != null) 'utility_type_id': utilityTypeId,
      if (serial != null) 'serial': serial,
      if (initialIndex != null) 'initial_index': initialIndex,
      if (active != null) 'active': active,
    });
  }

  MetersCompanion copyWith({
    Value<int>? id,
    Value<int>? apartmentId,
    Value<int>? utilityTypeId,
    Value<String?>? serial,
    Value<double>? initialIndex,
    Value<bool>? active,
  }) {
    return MetersCompanion(
      id: id ?? this.id,
      apartmentId: apartmentId ?? this.apartmentId,
      utilityTypeId: utilityTypeId ?? this.utilityTypeId,
      serial: serial ?? this.serial,
      initialIndex: initialIndex ?? this.initialIndex,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (apartmentId.present) {
      map['apartment_id'] = Variable<int>(apartmentId.value);
    }
    if (utilityTypeId.present) {
      map['utility_type_id'] = Variable<int>(utilityTypeId.value);
    }
    if (serial.present) {
      map['serial'] = Variable<String>(serial.value);
    }
    if (initialIndex.present) {
      map['initial_index'] = Variable<double>(initialIndex.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetersCompanion(')
          ..write('id: $id, ')
          ..write('apartmentId: $apartmentId, ')
          ..write('utilityTypeId: $utilityTypeId, ')
          ..write('serial: $serial, ')
          ..write('initialIndex: $initialIndex, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $ServiceTypesTable extends ServiceTypes
    with TableInfo<$ServiceTypesTable, ServiceType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<int> unitPrice = GeneratedColumn<int>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitLabelMeta = const VerificationMeta(
    'unitLabel',
  );
  @override
  late final GeneratedColumn<String> unitLabel = GeneratedColumn<String>(
    'unit_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unité'),
  );
  static const VerificationMeta _translationsMeta = const VerificationMeta(
    'translations',
  );
  @override
  late final GeneratedColumn<String> translations = GeneratedColumn<String>(
    'translations',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    unitPrice,
    unitLabel,
    translations,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('unit_label')) {
      context.handle(
        _unitLabelMeta,
        unitLabel.isAcceptableOrUnknown(data['unit_label']!, _unitLabelMeta),
      );
    }
    if (data.containsKey('translations')) {
      context.handle(
        _translationsMeta,
        translations.isAcceptableOrUnknown(
          data['translations']!,
          _translationsMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceType(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price'],
      )!,
      unitLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_label'],
      )!,
      translations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translations'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $ServiceTypesTable createAlias(String alias) {
    return $ServiceTypesTable(attachedDatabase, alias);
  }
}

class ServiceType extends DataClass implements Insertable<ServiceType> {
  final int id;
  final String name;
  final int unitPrice;
  final String unitLabel;

  /// Noms / unités dans les autres langues, JSON : {"en": {"name": "Parking", "unit": "vehicle"}}.
  final String? translations;
  final bool active;
  const ServiceType({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.unitLabel,
    this.translations,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['unit_price'] = Variable<int>(unitPrice);
    map['unit_label'] = Variable<String>(unitLabel);
    if (!nullToAbsent || translations != null) {
      map['translations'] = Variable<String>(translations);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  ServiceTypesCompanion toCompanion(bool nullToAbsent) {
    return ServiceTypesCompanion(
      id: Value(id),
      name: Value(name),
      unitPrice: Value(unitPrice),
      unitLabel: Value(unitLabel),
      translations: translations == null && nullToAbsent
          ? const Value.absent()
          : Value(translations),
      active: Value(active),
    );
  }

  factory ServiceType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceType(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      unitPrice: serializer.fromJson<int>(json['unitPrice']),
      unitLabel: serializer.fromJson<String>(json['unitLabel']),
      translations: serializer.fromJson<String?>(json['translations']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'unitPrice': serializer.toJson<int>(unitPrice),
      'unitLabel': serializer.toJson<String>(unitLabel),
      'translations': serializer.toJson<String?>(translations),
      'active': serializer.toJson<bool>(active),
    };
  }

  ServiceType copyWith({
    int? id,
    String? name,
    int? unitPrice,
    String? unitLabel,
    Value<String?> translations = const Value.absent(),
    bool? active,
  }) => ServiceType(
    id: id ?? this.id,
    name: name ?? this.name,
    unitPrice: unitPrice ?? this.unitPrice,
    unitLabel: unitLabel ?? this.unitLabel,
    translations: translations.present ? translations.value : this.translations,
    active: active ?? this.active,
  );
  ServiceType copyWithCompanion(ServiceTypesCompanion data) {
    return ServiceType(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      unitLabel: data.unitLabel.present ? data.unitLabel.value : this.unitLabel,
      translations: data.translations.present
          ? data.translations.value
          : this.translations,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceType(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('unitLabel: $unitLabel, ')
          ..write('translations: $translations, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, unitPrice, unitLabel, translations, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceType &&
          other.id == this.id &&
          other.name == this.name &&
          other.unitPrice == this.unitPrice &&
          other.unitLabel == this.unitLabel &&
          other.translations == this.translations &&
          other.active == this.active);
}

class ServiceTypesCompanion extends UpdateCompanion<ServiceType> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> unitPrice;
  final Value<String> unitLabel;
  final Value<String?> translations;
  final Value<bool> active;
  const ServiceTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.unitLabel = const Value.absent(),
    this.translations = const Value.absent(),
    this.active = const Value.absent(),
  });
  ServiceTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int unitPrice,
    this.unitLabel = const Value.absent(),
    this.translations = const Value.absent(),
    this.active = const Value.absent(),
  }) : name = Value(name),
       unitPrice = Value(unitPrice);
  static Insertable<ServiceType> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? unitPrice,
    Expression<String>? unitLabel,
    Expression<String>? translations,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (unitLabel != null) 'unit_label': unitLabel,
      if (translations != null) 'translations': translations,
      if (active != null) 'active': active,
    });
  }

  ServiceTypesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? unitPrice,
    Value<String>? unitLabel,
    Value<String?>? translations,
    Value<bool>? active,
  }) {
    return ServiceTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      unitLabel: unitLabel ?? this.unitLabel,
      translations: translations ?? this.translations,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<int>(unitPrice.value);
    }
    if (unitLabel.present) {
      map['unit_label'] = Variable<String>(unitLabel.value);
    }
    if (translations.present) {
      map['translations'] = Variable<String>(translations.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('unitLabel: $unitLabel, ')
          ..write('translations: $translations, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $ContractsTable extends Contracts
    with TableInfo<$ContractsTable, Contract> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContractsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _apartmentIdMeta = const VerificationMeta(
    'apartmentId',
  );
  @override
  late final GeneratedColumn<int> apartmentId = GeneratedColumn<int>(
    'apartment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES apartments (id)',
    ),
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tenants (id)',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedEndDateMeta = const VerificationMeta(
    'plannedEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> plannedEndDate =
      GeneratedColumn<DateTime>(
        'planned_end_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _tacitRenewalMeta = const VerificationMeta(
    'tacitRenewal',
  );
  @override
  late final GeneratedColumn<bool> tacitRenewal = GeneratedColumn<bool>(
    'tacit_renewal',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tacit_renewal" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _rentMeta = const VerificationMeta('rent');
  @override
  late final GeneratedColumn<int> rent = GeneratedColumn<int>(
    'rent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _depositMeta = const VerificationMeta(
    'deposit',
  );
  @override
  late final GeneratedColumn<int> deposit = GeneratedColumn<int>(
    'deposit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _depositPaidMeta = const VerificationMeta(
    'depositPaid',
  );
  @override
  late final GeneratedColumn<int> depositPaid = GeneratedColumn<int>(
    'deposit_paid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _entryProrataMeta = const VerificationMeta(
    'entryProrata',
  );
  @override
  late final GeneratedColumn<bool> entryProrata = GeneratedColumn<bool>(
    'entry_prorata',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("entry_prorata" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _exitDateMeta = const VerificationMeta(
    'exitDate',
  );
  @override
  late final GeneratedColumn<DateTime> exitDate = GeneratedColumn<DateTime>(
    'exit_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exitProrataMeta = const VerificationMeta(
    'exitProrata',
  );
  @override
  late final GeneratedColumn<bool> exitProrata = GeneratedColumn<bool>(
    'exit_prorata',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("exit_prorata" IN (0, 1))',
    ),
  );
  static const VerificationMeta _damagesAmountMeta = const VerificationMeta(
    'damagesAmount',
  );
  @override
  late final GeneratedColumn<int> damagesAmount = GeneratedColumn<int>(
    'damages_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _exitNotesMeta = const VerificationMeta(
    'exitNotes',
  );
  @override
  late final GeneratedColumn<String> exitNotes = GeneratedColumn<String>(
    'exit_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    apartmentId,
    tenantId,
    startDate,
    plannedEndDate,
    tacitRenewal,
    rent,
    deposit,
    depositPaid,
    entryProrata,
    status,
    exitDate,
    exitProrata,
    damagesAmount,
    exitNotes,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contracts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Contract> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('apartment_id')) {
      context.handle(
        _apartmentIdMeta,
        apartmentId.isAcceptableOrUnknown(
          data['apartment_id']!,
          _apartmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_apartmentIdMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('planned_end_date')) {
      context.handle(
        _plannedEndDateMeta,
        plannedEndDate.isAcceptableOrUnknown(
          data['planned_end_date']!,
          _plannedEndDateMeta,
        ),
      );
    }
    if (data.containsKey('tacit_renewal')) {
      context.handle(
        _tacitRenewalMeta,
        tacitRenewal.isAcceptableOrUnknown(
          data['tacit_renewal']!,
          _tacitRenewalMeta,
        ),
      );
    }
    if (data.containsKey('rent')) {
      context.handle(
        _rentMeta,
        rent.isAcceptableOrUnknown(data['rent']!, _rentMeta),
      );
    } else if (isInserting) {
      context.missing(_rentMeta);
    }
    if (data.containsKey('deposit')) {
      context.handle(
        _depositMeta,
        deposit.isAcceptableOrUnknown(data['deposit']!, _depositMeta),
      );
    }
    if (data.containsKey('deposit_paid')) {
      context.handle(
        _depositPaidMeta,
        depositPaid.isAcceptableOrUnknown(
          data['deposit_paid']!,
          _depositPaidMeta,
        ),
      );
    }
    if (data.containsKey('entry_prorata')) {
      context.handle(
        _entryProrataMeta,
        entryProrata.isAcceptableOrUnknown(
          data['entry_prorata']!,
          _entryProrataMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('exit_date')) {
      context.handle(
        _exitDateMeta,
        exitDate.isAcceptableOrUnknown(data['exit_date']!, _exitDateMeta),
      );
    }
    if (data.containsKey('exit_prorata')) {
      context.handle(
        _exitProrataMeta,
        exitProrata.isAcceptableOrUnknown(
          data['exit_prorata']!,
          _exitProrataMeta,
        ),
      );
    }
    if (data.containsKey('damages_amount')) {
      context.handle(
        _damagesAmountMeta,
        damagesAmount.isAcceptableOrUnknown(
          data['damages_amount']!,
          _damagesAmountMeta,
        ),
      );
    }
    if (data.containsKey('exit_notes')) {
      context.handle(
        _exitNotesMeta,
        exitNotes.isAcceptableOrUnknown(data['exit_notes']!, _exitNotesMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contract map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contract(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      apartmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}apartment_id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tenant_id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      plannedEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}planned_end_date'],
      ),
      tacitRenewal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tacit_renewal'],
      )!,
      rent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rent'],
      )!,
      deposit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deposit'],
      )!,
      depositPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deposit_paid'],
      )!,
      entryProrata: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}entry_prorata'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      exitDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}exit_date'],
      ),
      exitProrata: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}exit_prorata'],
      ),
      damagesAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}damages_amount'],
      )!,
      exitNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exit_notes'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ContractsTable createAlias(String alias) {
    return $ContractsTable(attachedDatabase, alias);
  }
}

class Contract extends DataClass implements Insertable<Contract> {
  final int id;
  final int apartmentId;
  final int tenantId;
  final DateTime startDate;

  /// Fin de la période initiale du bail (le bail n'est jamais arrêté automatiquement).
  final DateTime? plannedEndDate;

  /// Reconduction tacite : à l'échéance, le bail est prolongé d'une période de même durée.
  final bool tacitRenewal;
  final int rent;
  final int deposit;
  final int depositPaid;

  /// Mois d'entrée : au prorata des jours (true) ou mois complet (false).
  final bool entryProrata;

  /// 0 = actif, 1 = terminé.
  final int status;
  final DateTime? exitDate;
  final bool? exitProrata;
  final int damagesAmount;
  final String? exitNotes;
  final String? notes;
  const Contract({
    required this.id,
    required this.apartmentId,
    required this.tenantId,
    required this.startDate,
    this.plannedEndDate,
    required this.tacitRenewal,
    required this.rent,
    required this.deposit,
    required this.depositPaid,
    required this.entryProrata,
    required this.status,
    this.exitDate,
    this.exitProrata,
    required this.damagesAmount,
    this.exitNotes,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['apartment_id'] = Variable<int>(apartmentId);
    map['tenant_id'] = Variable<int>(tenantId);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || plannedEndDate != null) {
      map['planned_end_date'] = Variable<DateTime>(plannedEndDate);
    }
    map['tacit_renewal'] = Variable<bool>(tacitRenewal);
    map['rent'] = Variable<int>(rent);
    map['deposit'] = Variable<int>(deposit);
    map['deposit_paid'] = Variable<int>(depositPaid);
    map['entry_prorata'] = Variable<bool>(entryProrata);
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || exitDate != null) {
      map['exit_date'] = Variable<DateTime>(exitDate);
    }
    if (!nullToAbsent || exitProrata != null) {
      map['exit_prorata'] = Variable<bool>(exitProrata);
    }
    map['damages_amount'] = Variable<int>(damagesAmount);
    if (!nullToAbsent || exitNotes != null) {
      map['exit_notes'] = Variable<String>(exitNotes);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ContractsCompanion toCompanion(bool nullToAbsent) {
    return ContractsCompanion(
      id: Value(id),
      apartmentId: Value(apartmentId),
      tenantId: Value(tenantId),
      startDate: Value(startDate),
      plannedEndDate: plannedEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedEndDate),
      tacitRenewal: Value(tacitRenewal),
      rent: Value(rent),
      deposit: Value(deposit),
      depositPaid: Value(depositPaid),
      entryProrata: Value(entryProrata),
      status: Value(status),
      exitDate: exitDate == null && nullToAbsent
          ? const Value.absent()
          : Value(exitDate),
      exitProrata: exitProrata == null && nullToAbsent
          ? const Value.absent()
          : Value(exitProrata),
      damagesAmount: Value(damagesAmount),
      exitNotes: exitNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(exitNotes),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Contract.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contract(
      id: serializer.fromJson<int>(json['id']),
      apartmentId: serializer.fromJson<int>(json['apartmentId']),
      tenantId: serializer.fromJson<int>(json['tenantId']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      plannedEndDate: serializer.fromJson<DateTime?>(json['plannedEndDate']),
      tacitRenewal: serializer.fromJson<bool>(json['tacitRenewal']),
      rent: serializer.fromJson<int>(json['rent']),
      deposit: serializer.fromJson<int>(json['deposit']),
      depositPaid: serializer.fromJson<int>(json['depositPaid']),
      entryProrata: serializer.fromJson<bool>(json['entryProrata']),
      status: serializer.fromJson<int>(json['status']),
      exitDate: serializer.fromJson<DateTime?>(json['exitDate']),
      exitProrata: serializer.fromJson<bool?>(json['exitProrata']),
      damagesAmount: serializer.fromJson<int>(json['damagesAmount']),
      exitNotes: serializer.fromJson<String?>(json['exitNotes']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'apartmentId': serializer.toJson<int>(apartmentId),
      'tenantId': serializer.toJson<int>(tenantId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'plannedEndDate': serializer.toJson<DateTime?>(plannedEndDate),
      'tacitRenewal': serializer.toJson<bool>(tacitRenewal),
      'rent': serializer.toJson<int>(rent),
      'deposit': serializer.toJson<int>(deposit),
      'depositPaid': serializer.toJson<int>(depositPaid),
      'entryProrata': serializer.toJson<bool>(entryProrata),
      'status': serializer.toJson<int>(status),
      'exitDate': serializer.toJson<DateTime?>(exitDate),
      'exitProrata': serializer.toJson<bool?>(exitProrata),
      'damagesAmount': serializer.toJson<int>(damagesAmount),
      'exitNotes': serializer.toJson<String?>(exitNotes),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Contract copyWith({
    int? id,
    int? apartmentId,
    int? tenantId,
    DateTime? startDate,
    Value<DateTime?> plannedEndDate = const Value.absent(),
    bool? tacitRenewal,
    int? rent,
    int? deposit,
    int? depositPaid,
    bool? entryProrata,
    int? status,
    Value<DateTime?> exitDate = const Value.absent(),
    Value<bool?> exitProrata = const Value.absent(),
    int? damagesAmount,
    Value<String?> exitNotes = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Contract(
    id: id ?? this.id,
    apartmentId: apartmentId ?? this.apartmentId,
    tenantId: tenantId ?? this.tenantId,
    startDate: startDate ?? this.startDate,
    plannedEndDate: plannedEndDate.present
        ? plannedEndDate.value
        : this.plannedEndDate,
    tacitRenewal: tacitRenewal ?? this.tacitRenewal,
    rent: rent ?? this.rent,
    deposit: deposit ?? this.deposit,
    depositPaid: depositPaid ?? this.depositPaid,
    entryProrata: entryProrata ?? this.entryProrata,
    status: status ?? this.status,
    exitDate: exitDate.present ? exitDate.value : this.exitDate,
    exitProrata: exitProrata.present ? exitProrata.value : this.exitProrata,
    damagesAmount: damagesAmount ?? this.damagesAmount,
    exitNotes: exitNotes.present ? exitNotes.value : this.exitNotes,
    notes: notes.present ? notes.value : this.notes,
  );
  Contract copyWithCompanion(ContractsCompanion data) {
    return Contract(
      id: data.id.present ? data.id.value : this.id,
      apartmentId: data.apartmentId.present
          ? data.apartmentId.value
          : this.apartmentId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      plannedEndDate: data.plannedEndDate.present
          ? data.plannedEndDate.value
          : this.plannedEndDate,
      tacitRenewal: data.tacitRenewal.present
          ? data.tacitRenewal.value
          : this.tacitRenewal,
      rent: data.rent.present ? data.rent.value : this.rent,
      deposit: data.deposit.present ? data.deposit.value : this.deposit,
      depositPaid: data.depositPaid.present
          ? data.depositPaid.value
          : this.depositPaid,
      entryProrata: data.entryProrata.present
          ? data.entryProrata.value
          : this.entryProrata,
      status: data.status.present ? data.status.value : this.status,
      exitDate: data.exitDate.present ? data.exitDate.value : this.exitDate,
      exitProrata: data.exitProrata.present
          ? data.exitProrata.value
          : this.exitProrata,
      damagesAmount: data.damagesAmount.present
          ? data.damagesAmount.value
          : this.damagesAmount,
      exitNotes: data.exitNotes.present ? data.exitNotes.value : this.exitNotes,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contract(')
          ..write('id: $id, ')
          ..write('apartmentId: $apartmentId, ')
          ..write('tenantId: $tenantId, ')
          ..write('startDate: $startDate, ')
          ..write('plannedEndDate: $plannedEndDate, ')
          ..write('tacitRenewal: $tacitRenewal, ')
          ..write('rent: $rent, ')
          ..write('deposit: $deposit, ')
          ..write('depositPaid: $depositPaid, ')
          ..write('entryProrata: $entryProrata, ')
          ..write('status: $status, ')
          ..write('exitDate: $exitDate, ')
          ..write('exitProrata: $exitProrata, ')
          ..write('damagesAmount: $damagesAmount, ')
          ..write('exitNotes: $exitNotes, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    apartmentId,
    tenantId,
    startDate,
    plannedEndDate,
    tacitRenewal,
    rent,
    deposit,
    depositPaid,
    entryProrata,
    status,
    exitDate,
    exitProrata,
    damagesAmount,
    exitNotes,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contract &&
          other.id == this.id &&
          other.apartmentId == this.apartmentId &&
          other.tenantId == this.tenantId &&
          other.startDate == this.startDate &&
          other.plannedEndDate == this.plannedEndDate &&
          other.tacitRenewal == this.tacitRenewal &&
          other.rent == this.rent &&
          other.deposit == this.deposit &&
          other.depositPaid == this.depositPaid &&
          other.entryProrata == this.entryProrata &&
          other.status == this.status &&
          other.exitDate == this.exitDate &&
          other.exitProrata == this.exitProrata &&
          other.damagesAmount == this.damagesAmount &&
          other.exitNotes == this.exitNotes &&
          other.notes == this.notes);
}

class ContractsCompanion extends UpdateCompanion<Contract> {
  final Value<int> id;
  final Value<int> apartmentId;
  final Value<int> tenantId;
  final Value<DateTime> startDate;
  final Value<DateTime?> plannedEndDate;
  final Value<bool> tacitRenewal;
  final Value<int> rent;
  final Value<int> deposit;
  final Value<int> depositPaid;
  final Value<bool> entryProrata;
  final Value<int> status;
  final Value<DateTime?> exitDate;
  final Value<bool?> exitProrata;
  final Value<int> damagesAmount;
  final Value<String?> exitNotes;
  final Value<String?> notes;
  const ContractsCompanion({
    this.id = const Value.absent(),
    this.apartmentId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.plannedEndDate = const Value.absent(),
    this.tacitRenewal = const Value.absent(),
    this.rent = const Value.absent(),
    this.deposit = const Value.absent(),
    this.depositPaid = const Value.absent(),
    this.entryProrata = const Value.absent(),
    this.status = const Value.absent(),
    this.exitDate = const Value.absent(),
    this.exitProrata = const Value.absent(),
    this.damagesAmount = const Value.absent(),
    this.exitNotes = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ContractsCompanion.insert({
    this.id = const Value.absent(),
    required int apartmentId,
    required int tenantId,
    required DateTime startDate,
    this.plannedEndDate = const Value.absent(),
    this.tacitRenewal = const Value.absent(),
    required int rent,
    this.deposit = const Value.absent(),
    this.depositPaid = const Value.absent(),
    this.entryProrata = const Value.absent(),
    this.status = const Value.absent(),
    this.exitDate = const Value.absent(),
    this.exitProrata = const Value.absent(),
    this.damagesAmount = const Value.absent(),
    this.exitNotes = const Value.absent(),
    this.notes = const Value.absent(),
  }) : apartmentId = Value(apartmentId),
       tenantId = Value(tenantId),
       startDate = Value(startDate),
       rent = Value(rent);
  static Insertable<Contract> custom({
    Expression<int>? id,
    Expression<int>? apartmentId,
    Expression<int>? tenantId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? plannedEndDate,
    Expression<bool>? tacitRenewal,
    Expression<int>? rent,
    Expression<int>? deposit,
    Expression<int>? depositPaid,
    Expression<bool>? entryProrata,
    Expression<int>? status,
    Expression<DateTime>? exitDate,
    Expression<bool>? exitProrata,
    Expression<int>? damagesAmount,
    Expression<String>? exitNotes,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (apartmentId != null) 'apartment_id': apartmentId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (startDate != null) 'start_date': startDate,
      if (plannedEndDate != null) 'planned_end_date': plannedEndDate,
      if (tacitRenewal != null) 'tacit_renewal': tacitRenewal,
      if (rent != null) 'rent': rent,
      if (deposit != null) 'deposit': deposit,
      if (depositPaid != null) 'deposit_paid': depositPaid,
      if (entryProrata != null) 'entry_prorata': entryProrata,
      if (status != null) 'status': status,
      if (exitDate != null) 'exit_date': exitDate,
      if (exitProrata != null) 'exit_prorata': exitProrata,
      if (damagesAmount != null) 'damages_amount': damagesAmount,
      if (exitNotes != null) 'exit_notes': exitNotes,
      if (notes != null) 'notes': notes,
    });
  }

  ContractsCompanion copyWith({
    Value<int>? id,
    Value<int>? apartmentId,
    Value<int>? tenantId,
    Value<DateTime>? startDate,
    Value<DateTime?>? plannedEndDate,
    Value<bool>? tacitRenewal,
    Value<int>? rent,
    Value<int>? deposit,
    Value<int>? depositPaid,
    Value<bool>? entryProrata,
    Value<int>? status,
    Value<DateTime?>? exitDate,
    Value<bool?>? exitProrata,
    Value<int>? damagesAmount,
    Value<String?>? exitNotes,
    Value<String?>? notes,
  }) {
    return ContractsCompanion(
      id: id ?? this.id,
      apartmentId: apartmentId ?? this.apartmentId,
      tenantId: tenantId ?? this.tenantId,
      startDate: startDate ?? this.startDate,
      plannedEndDate: plannedEndDate ?? this.plannedEndDate,
      tacitRenewal: tacitRenewal ?? this.tacitRenewal,
      rent: rent ?? this.rent,
      deposit: deposit ?? this.deposit,
      depositPaid: depositPaid ?? this.depositPaid,
      entryProrata: entryProrata ?? this.entryProrata,
      status: status ?? this.status,
      exitDate: exitDate ?? this.exitDate,
      exitProrata: exitProrata ?? this.exitProrata,
      damagesAmount: damagesAmount ?? this.damagesAmount,
      exitNotes: exitNotes ?? this.exitNotes,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (apartmentId.present) {
      map['apartment_id'] = Variable<int>(apartmentId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (plannedEndDate.present) {
      map['planned_end_date'] = Variable<DateTime>(plannedEndDate.value);
    }
    if (tacitRenewal.present) {
      map['tacit_renewal'] = Variable<bool>(tacitRenewal.value);
    }
    if (rent.present) {
      map['rent'] = Variable<int>(rent.value);
    }
    if (deposit.present) {
      map['deposit'] = Variable<int>(deposit.value);
    }
    if (depositPaid.present) {
      map['deposit_paid'] = Variable<int>(depositPaid.value);
    }
    if (entryProrata.present) {
      map['entry_prorata'] = Variable<bool>(entryProrata.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (exitDate.present) {
      map['exit_date'] = Variable<DateTime>(exitDate.value);
    }
    if (exitProrata.present) {
      map['exit_prorata'] = Variable<bool>(exitProrata.value);
    }
    if (damagesAmount.present) {
      map['damages_amount'] = Variable<int>(damagesAmount.value);
    }
    if (exitNotes.present) {
      map['exit_notes'] = Variable<String>(exitNotes.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContractsCompanion(')
          ..write('id: $id, ')
          ..write('apartmentId: $apartmentId, ')
          ..write('tenantId: $tenantId, ')
          ..write('startDate: $startDate, ')
          ..write('plannedEndDate: $plannedEndDate, ')
          ..write('tacitRenewal: $tacitRenewal, ')
          ..write('rent: $rent, ')
          ..write('deposit: $deposit, ')
          ..write('depositPaid: $depositPaid, ')
          ..write('entryProrata: $entryProrata, ')
          ..write('status: $status, ')
          ..write('exitDate: $exitDate, ')
          ..write('exitProrata: $exitProrata, ')
          ..write('damagesAmount: $damagesAmount, ')
          ..write('exitNotes: $exitNotes, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $ContractServicesTable extends ContractServices
    with TableInfo<$ContractServicesTable, ContractService> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContractServicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _contractIdMeta = const VerificationMeta(
    'contractId',
  );
  @override
  late final GeneratedColumn<int> contractId = GeneratedColumn<int>(
    'contract_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES contracts (id)',
    ),
  );
  static const VerificationMeta _serviceTypeIdMeta = const VerificationMeta(
    'serviceTypeId',
  );
  @override
  late final GeneratedColumn<int> serviceTypeId = GeneratedColumn<int>(
    'service_type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES service_types (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _includedQuantityMeta = const VerificationMeta(
    'includedQuantity',
  );
  @override
  late final GeneratedColumn<int> includedQuantity = GeneratedColumn<int>(
    'included_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<int> unitPrice = GeneratedColumn<int>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    contractId,
    serviceTypeId,
    quantity,
    includedQuantity,
    unitPrice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contract_services';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContractService> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('contract_id')) {
      context.handle(
        _contractIdMeta,
        contractId.isAcceptableOrUnknown(data['contract_id']!, _contractIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contractIdMeta);
    }
    if (data.containsKey('service_type_id')) {
      context.handle(
        _serviceTypeIdMeta,
        serviceTypeId.isAcceptableOrUnknown(
          data['service_type_id']!,
          _serviceTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceTypeIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('included_quantity')) {
      context.handle(
        _includedQuantityMeta,
        includedQuantity.isAcceptableOrUnknown(
          data['included_quantity']!,
          _includedQuantityMeta,
        ),
      );
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContractService map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContractService(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      contractId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contract_id'],
      )!,
      serviceTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}service_type_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      includedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}included_quantity'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price'],
      )!,
    );
  }

  @override
  $ContractServicesTable createAlias(String alias) {
    return $ContractServicesTable(attachedDatabase, alias);
  }
}

class ContractService extends DataClass implements Insertable<ContractService> {
  final int id;
  final int contractId;
  final int serviceTypeId;
  final int quantity;
  final int includedQuantity;
  final int unitPrice;
  const ContractService({
    required this.id,
    required this.contractId,
    required this.serviceTypeId,
    required this.quantity,
    required this.includedQuantity,
    required this.unitPrice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['contract_id'] = Variable<int>(contractId);
    map['service_type_id'] = Variable<int>(serviceTypeId);
    map['quantity'] = Variable<int>(quantity);
    map['included_quantity'] = Variable<int>(includedQuantity);
    map['unit_price'] = Variable<int>(unitPrice);
    return map;
  }

  ContractServicesCompanion toCompanion(bool nullToAbsent) {
    return ContractServicesCompanion(
      id: Value(id),
      contractId: Value(contractId),
      serviceTypeId: Value(serviceTypeId),
      quantity: Value(quantity),
      includedQuantity: Value(includedQuantity),
      unitPrice: Value(unitPrice),
    );
  }

  factory ContractService.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContractService(
      id: serializer.fromJson<int>(json['id']),
      contractId: serializer.fromJson<int>(json['contractId']),
      serviceTypeId: serializer.fromJson<int>(json['serviceTypeId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      includedQuantity: serializer.fromJson<int>(json['includedQuantity']),
      unitPrice: serializer.fromJson<int>(json['unitPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'contractId': serializer.toJson<int>(contractId),
      'serviceTypeId': serializer.toJson<int>(serviceTypeId),
      'quantity': serializer.toJson<int>(quantity),
      'includedQuantity': serializer.toJson<int>(includedQuantity),
      'unitPrice': serializer.toJson<int>(unitPrice),
    };
  }

  ContractService copyWith({
    int? id,
    int? contractId,
    int? serviceTypeId,
    int? quantity,
    int? includedQuantity,
    int? unitPrice,
  }) => ContractService(
    id: id ?? this.id,
    contractId: contractId ?? this.contractId,
    serviceTypeId: serviceTypeId ?? this.serviceTypeId,
    quantity: quantity ?? this.quantity,
    includedQuantity: includedQuantity ?? this.includedQuantity,
    unitPrice: unitPrice ?? this.unitPrice,
  );
  ContractService copyWithCompanion(ContractServicesCompanion data) {
    return ContractService(
      id: data.id.present ? data.id.value : this.id,
      contractId: data.contractId.present
          ? data.contractId.value
          : this.contractId,
      serviceTypeId: data.serviceTypeId.present
          ? data.serviceTypeId.value
          : this.serviceTypeId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      includedQuantity: data.includedQuantity.present
          ? data.includedQuantity.value
          : this.includedQuantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContractService(')
          ..write('id: $id, ')
          ..write('contractId: $contractId, ')
          ..write('serviceTypeId: $serviceTypeId, ')
          ..write('quantity: $quantity, ')
          ..write('includedQuantity: $includedQuantity, ')
          ..write('unitPrice: $unitPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    contractId,
    serviceTypeId,
    quantity,
    includedQuantity,
    unitPrice,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContractService &&
          other.id == this.id &&
          other.contractId == this.contractId &&
          other.serviceTypeId == this.serviceTypeId &&
          other.quantity == this.quantity &&
          other.includedQuantity == this.includedQuantity &&
          other.unitPrice == this.unitPrice);
}

class ContractServicesCompanion extends UpdateCompanion<ContractService> {
  final Value<int> id;
  final Value<int> contractId;
  final Value<int> serviceTypeId;
  final Value<int> quantity;
  final Value<int> includedQuantity;
  final Value<int> unitPrice;
  const ContractServicesCompanion({
    this.id = const Value.absent(),
    this.contractId = const Value.absent(),
    this.serviceTypeId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.includedQuantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
  });
  ContractServicesCompanion.insert({
    this.id = const Value.absent(),
    required int contractId,
    required int serviceTypeId,
    this.quantity = const Value.absent(),
    this.includedQuantity = const Value.absent(),
    required int unitPrice,
  }) : contractId = Value(contractId),
       serviceTypeId = Value(serviceTypeId),
       unitPrice = Value(unitPrice);
  static Insertable<ContractService> custom({
    Expression<int>? id,
    Expression<int>? contractId,
    Expression<int>? serviceTypeId,
    Expression<int>? quantity,
    Expression<int>? includedQuantity,
    Expression<int>? unitPrice,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contractId != null) 'contract_id': contractId,
      if (serviceTypeId != null) 'service_type_id': serviceTypeId,
      if (quantity != null) 'quantity': quantity,
      if (includedQuantity != null) 'included_quantity': includedQuantity,
      if (unitPrice != null) 'unit_price': unitPrice,
    });
  }

  ContractServicesCompanion copyWith({
    Value<int>? id,
    Value<int>? contractId,
    Value<int>? serviceTypeId,
    Value<int>? quantity,
    Value<int>? includedQuantity,
    Value<int>? unitPrice,
  }) {
    return ContractServicesCompanion(
      id: id ?? this.id,
      contractId: contractId ?? this.contractId,
      serviceTypeId: serviceTypeId ?? this.serviceTypeId,
      quantity: quantity ?? this.quantity,
      includedQuantity: includedQuantity ?? this.includedQuantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (contractId.present) {
      map['contract_id'] = Variable<int>(contractId.value);
    }
    if (serviceTypeId.present) {
      map['service_type_id'] = Variable<int>(serviceTypeId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (includedQuantity.present) {
      map['included_quantity'] = Variable<int>(includedQuantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<int>(unitPrice.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContractServicesCompanion(')
          ..write('id: $id, ')
          ..write('contractId: $contractId, ')
          ..write('serviceTypeId: $serviceTypeId, ')
          ..write('quantity: $quantity, ')
          ..write('includedQuantity: $includedQuantity, ')
          ..write('unitPrice: $unitPrice')
          ..write(')'))
        .toString();
  }
}

class $ContractBenefitsTable extends ContractBenefits
    with TableInfo<$ContractBenefitsTable, ContractBenefit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContractBenefitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _contractIdMeta = const VerificationMeta(
    'contractId',
  );
  @override
  late final GeneratedColumn<int> contractId = GeneratedColumn<int>(
    'contract_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES contracts (id)',
    ),
  );
  static const VerificationMeta _utilityTypeIdMeta = const VerificationMeta(
    'utilityTypeId',
  );
  @override
  late final GeneratedColumn<int> utilityTypeId = GeneratedColumn<int>(
    'utility_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES utility_types (id)',
    ),
  );
  static const VerificationMeta _serviceTypeIdMeta = const VerificationMeta(
    'serviceTypeId',
  );
  @override
  late final GeneratedColumn<int> serviceTypeId = GeneratedColumn<int>(
    'service_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES service_types (id)',
    ),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<int> mode = GeneratedColumn<int>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromPeriodMeta = const VerificationMeta(
    'fromPeriod',
  );
  @override
  late final GeneratedColumn<int> fromPeriod = GeneratedColumn<int>(
    'from_period',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toPeriodMeta = const VerificationMeta(
    'toPeriod',
  );
  @override
  late final GeneratedColumn<int> toPeriod = GeneratedColumn<int>(
    'to_period',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    contractId,
    utilityTypeId,
    serviceTypeId,
    mode,
    value,
    amount,
    reason,
    fromPeriod,
    toPeriod,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contract_benefits';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContractBenefit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('contract_id')) {
      context.handle(
        _contractIdMeta,
        contractId.isAcceptableOrUnknown(data['contract_id']!, _contractIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contractIdMeta);
    }
    if (data.containsKey('utility_type_id')) {
      context.handle(
        _utilityTypeIdMeta,
        utilityTypeId.isAcceptableOrUnknown(
          data['utility_type_id']!,
          _utilityTypeIdMeta,
        ),
      );
    }
    if (data.containsKey('service_type_id')) {
      context.handle(
        _serviceTypeIdMeta,
        serviceTypeId.isAcceptableOrUnknown(
          data['service_type_id']!,
          _serviceTypeIdMeta,
        ),
      );
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('from_period')) {
      context.handle(
        _fromPeriodMeta,
        fromPeriod.isAcceptableOrUnknown(data['from_period']!, _fromPeriodMeta),
      );
    }
    if (data.containsKey('to_period')) {
      context.handle(
        _toPeriodMeta,
        toPeriod.isAcceptableOrUnknown(data['to_period']!, _toPeriodMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContractBenefit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContractBenefit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      contractId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contract_id'],
      )!,
      utilityTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}utility_type_id'],
      ),
      serviceTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}service_type_id'],
      ),
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mode'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      fromPeriod: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_period'],
      ),
      toPeriod: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_period'],
      ),
    );
  }

  @override
  $ContractBenefitsTable createAlias(String alias) {
    return $ContractBenefitsTable(attachedDatabase, alias);
  }
}

class ContractBenefit extends DataClass implements Insertable<ContractBenefit> {
  final int id;
  final int contractId;
  final int? utilityTypeId;
  final int? serviceTypeId;
  final int mode;
  final double value;
  final int amount;
  final String? reason;
  final int? fromPeriod;
  final int? toPeriod;
  const ContractBenefit({
    required this.id,
    required this.contractId,
    this.utilityTypeId,
    this.serviceTypeId,
    required this.mode,
    required this.value,
    required this.amount,
    this.reason,
    this.fromPeriod,
    this.toPeriod,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['contract_id'] = Variable<int>(contractId);
    if (!nullToAbsent || utilityTypeId != null) {
      map['utility_type_id'] = Variable<int>(utilityTypeId);
    }
    if (!nullToAbsent || serviceTypeId != null) {
      map['service_type_id'] = Variable<int>(serviceTypeId);
    }
    map['mode'] = Variable<int>(mode);
    map['value'] = Variable<double>(value);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || fromPeriod != null) {
      map['from_period'] = Variable<int>(fromPeriod);
    }
    if (!nullToAbsent || toPeriod != null) {
      map['to_period'] = Variable<int>(toPeriod);
    }
    return map;
  }

  ContractBenefitsCompanion toCompanion(bool nullToAbsent) {
    return ContractBenefitsCompanion(
      id: Value(id),
      contractId: Value(contractId),
      utilityTypeId: utilityTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(utilityTypeId),
      serviceTypeId: serviceTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceTypeId),
      mode: Value(mode),
      value: Value(value),
      amount: Value(amount),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      fromPeriod: fromPeriod == null && nullToAbsent
          ? const Value.absent()
          : Value(fromPeriod),
      toPeriod: toPeriod == null && nullToAbsent
          ? const Value.absent()
          : Value(toPeriod),
    );
  }

  factory ContractBenefit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContractBenefit(
      id: serializer.fromJson<int>(json['id']),
      contractId: serializer.fromJson<int>(json['contractId']),
      utilityTypeId: serializer.fromJson<int?>(json['utilityTypeId']),
      serviceTypeId: serializer.fromJson<int?>(json['serviceTypeId']),
      mode: serializer.fromJson<int>(json['mode']),
      value: serializer.fromJson<double>(json['value']),
      amount: serializer.fromJson<int>(json['amount']),
      reason: serializer.fromJson<String?>(json['reason']),
      fromPeriod: serializer.fromJson<int?>(json['fromPeriod']),
      toPeriod: serializer.fromJson<int?>(json['toPeriod']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'contractId': serializer.toJson<int>(contractId),
      'utilityTypeId': serializer.toJson<int?>(utilityTypeId),
      'serviceTypeId': serializer.toJson<int?>(serviceTypeId),
      'mode': serializer.toJson<int>(mode),
      'value': serializer.toJson<double>(value),
      'amount': serializer.toJson<int>(amount),
      'reason': serializer.toJson<String?>(reason),
      'fromPeriod': serializer.toJson<int?>(fromPeriod),
      'toPeriod': serializer.toJson<int?>(toPeriod),
    };
  }

  ContractBenefit copyWith({
    int? id,
    int? contractId,
    Value<int?> utilityTypeId = const Value.absent(),
    Value<int?> serviceTypeId = const Value.absent(),
    int? mode,
    double? value,
    int? amount,
    Value<String?> reason = const Value.absent(),
    Value<int?> fromPeriod = const Value.absent(),
    Value<int?> toPeriod = const Value.absent(),
  }) => ContractBenefit(
    id: id ?? this.id,
    contractId: contractId ?? this.contractId,
    utilityTypeId: utilityTypeId.present
        ? utilityTypeId.value
        : this.utilityTypeId,
    serviceTypeId: serviceTypeId.present
        ? serviceTypeId.value
        : this.serviceTypeId,
    mode: mode ?? this.mode,
    value: value ?? this.value,
    amount: amount ?? this.amount,
    reason: reason.present ? reason.value : this.reason,
    fromPeriod: fromPeriod.present ? fromPeriod.value : this.fromPeriod,
    toPeriod: toPeriod.present ? toPeriod.value : this.toPeriod,
  );
  ContractBenefit copyWithCompanion(ContractBenefitsCompanion data) {
    return ContractBenefit(
      id: data.id.present ? data.id.value : this.id,
      contractId: data.contractId.present
          ? data.contractId.value
          : this.contractId,
      utilityTypeId: data.utilityTypeId.present
          ? data.utilityTypeId.value
          : this.utilityTypeId,
      serviceTypeId: data.serviceTypeId.present
          ? data.serviceTypeId.value
          : this.serviceTypeId,
      mode: data.mode.present ? data.mode.value : this.mode,
      value: data.value.present ? data.value.value : this.value,
      amount: data.amount.present ? data.amount.value : this.amount,
      reason: data.reason.present ? data.reason.value : this.reason,
      fromPeriod: data.fromPeriod.present
          ? data.fromPeriod.value
          : this.fromPeriod,
      toPeriod: data.toPeriod.present ? data.toPeriod.value : this.toPeriod,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContractBenefit(')
          ..write('id: $id, ')
          ..write('contractId: $contractId, ')
          ..write('utilityTypeId: $utilityTypeId, ')
          ..write('serviceTypeId: $serviceTypeId, ')
          ..write('mode: $mode, ')
          ..write('value: $value, ')
          ..write('amount: $amount, ')
          ..write('reason: $reason, ')
          ..write('fromPeriod: $fromPeriod, ')
          ..write('toPeriod: $toPeriod')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    contractId,
    utilityTypeId,
    serviceTypeId,
    mode,
    value,
    amount,
    reason,
    fromPeriod,
    toPeriod,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContractBenefit &&
          other.id == this.id &&
          other.contractId == this.contractId &&
          other.utilityTypeId == this.utilityTypeId &&
          other.serviceTypeId == this.serviceTypeId &&
          other.mode == this.mode &&
          other.value == this.value &&
          other.amount == this.amount &&
          other.reason == this.reason &&
          other.fromPeriod == this.fromPeriod &&
          other.toPeriod == this.toPeriod);
}

class ContractBenefitsCompanion extends UpdateCompanion<ContractBenefit> {
  final Value<int> id;
  final Value<int> contractId;
  final Value<int?> utilityTypeId;
  final Value<int?> serviceTypeId;
  final Value<int> mode;
  final Value<double> value;
  final Value<int> amount;
  final Value<String?> reason;
  final Value<int?> fromPeriod;
  final Value<int?> toPeriod;
  const ContractBenefitsCompanion({
    this.id = const Value.absent(),
    this.contractId = const Value.absent(),
    this.utilityTypeId = const Value.absent(),
    this.serviceTypeId = const Value.absent(),
    this.mode = const Value.absent(),
    this.value = const Value.absent(),
    this.amount = const Value.absent(),
    this.reason = const Value.absent(),
    this.fromPeriod = const Value.absent(),
    this.toPeriod = const Value.absent(),
  });
  ContractBenefitsCompanion.insert({
    this.id = const Value.absent(),
    required int contractId,
    this.utilityTypeId = const Value.absent(),
    this.serviceTypeId = const Value.absent(),
    this.mode = const Value.absent(),
    this.value = const Value.absent(),
    this.amount = const Value.absent(),
    this.reason = const Value.absent(),
    this.fromPeriod = const Value.absent(),
    this.toPeriod = const Value.absent(),
  }) : contractId = Value(contractId);
  static Insertable<ContractBenefit> custom({
    Expression<int>? id,
    Expression<int>? contractId,
    Expression<int>? utilityTypeId,
    Expression<int>? serviceTypeId,
    Expression<int>? mode,
    Expression<double>? value,
    Expression<int>? amount,
    Expression<String>? reason,
    Expression<int>? fromPeriod,
    Expression<int>? toPeriod,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contractId != null) 'contract_id': contractId,
      if (utilityTypeId != null) 'utility_type_id': utilityTypeId,
      if (serviceTypeId != null) 'service_type_id': serviceTypeId,
      if (mode != null) 'mode': mode,
      if (value != null) 'value': value,
      if (amount != null) 'amount': amount,
      if (reason != null) 'reason': reason,
      if (fromPeriod != null) 'from_period': fromPeriod,
      if (toPeriod != null) 'to_period': toPeriod,
    });
  }

  ContractBenefitsCompanion copyWith({
    Value<int>? id,
    Value<int>? contractId,
    Value<int?>? utilityTypeId,
    Value<int?>? serviceTypeId,
    Value<int>? mode,
    Value<double>? value,
    Value<int>? amount,
    Value<String?>? reason,
    Value<int?>? fromPeriod,
    Value<int?>? toPeriod,
  }) {
    return ContractBenefitsCompanion(
      id: id ?? this.id,
      contractId: contractId ?? this.contractId,
      utilityTypeId: utilityTypeId ?? this.utilityTypeId,
      serviceTypeId: serviceTypeId ?? this.serviceTypeId,
      mode: mode ?? this.mode,
      value: value ?? this.value,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      fromPeriod: fromPeriod ?? this.fromPeriod,
      toPeriod: toPeriod ?? this.toPeriod,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (contractId.present) {
      map['contract_id'] = Variable<int>(contractId.value);
    }
    if (utilityTypeId.present) {
      map['utility_type_id'] = Variable<int>(utilityTypeId.value);
    }
    if (serviceTypeId.present) {
      map['service_type_id'] = Variable<int>(serviceTypeId.value);
    }
    if (mode.present) {
      map['mode'] = Variable<int>(mode.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (fromPeriod.present) {
      map['from_period'] = Variable<int>(fromPeriod.value);
    }
    if (toPeriod.present) {
      map['to_period'] = Variable<int>(toPeriod.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContractBenefitsCompanion(')
          ..write('id: $id, ')
          ..write('contractId: $contractId, ')
          ..write('utilityTypeId: $utilityTypeId, ')
          ..write('serviceTypeId: $serviceTypeId, ')
          ..write('mode: $mode, ')
          ..write('value: $value, ')
          ..write('amount: $amount, ')
          ..write('reason: $reason, ')
          ..write('fromPeriod: $fromPeriod, ')
          ..write('toPeriod: $toPeriod')
          ..write(')'))
        .toString();
  }
}

class $ReadingsTable extends Readings with TableInfo<$ReadingsTable, Reading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _meterIdMeta = const VerificationMeta(
    'meterId',
  );
  @override
  late final GeneratedColumn<int> meterId = GeneratedColumn<int>(
    'meter_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meters (id)',
    ),
  );
  static const VerificationMeta _contractIdMeta = const VerificationMeta(
    'contractId',
  );
  @override
  late final GeneratedColumn<int> contractId = GeneratedColumn<int>(
    'contract_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES contracts (id)',
    ),
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<int> period = GeneratedColumn<int>(
    'period',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<int> kind = GeneratedColumn<int>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    meterId,
    contractId,
    period,
    kind,
    date,
    value,
    photoPath,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meter_id')) {
      context.handle(
        _meterIdMeta,
        meterId.isAcceptableOrUnknown(data['meter_id']!, _meterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_meterIdMeta);
    }
    if (data.containsKey('contract_id')) {
      context.handle(
        _contractIdMeta,
        contractId.isAcceptableOrUnknown(data['contract_id']!, _contractIdMeta),
      );
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reading(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      meterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meter_id'],
      )!,
      contractId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contract_id'],
      ),
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kind'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $ReadingsTable createAlias(String alias) {
    return $ReadingsTable(attachedDatabase, alias);
  }
}

class Reading extends DataClass implements Insertable<Reading> {
  final int id;
  final int meterId;
  final int? contractId;
  final int? period;
  final int kind;
  final DateTime date;
  final double value;
  final String? photoPath;
  final String? note;
  const Reading({
    required this.id,
    required this.meterId,
    this.contractId,
    this.period,
    required this.kind,
    required this.date,
    required this.value,
    this.photoPath,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meter_id'] = Variable<int>(meterId);
    if (!nullToAbsent || contractId != null) {
      map['contract_id'] = Variable<int>(contractId);
    }
    if (!nullToAbsent || period != null) {
      map['period'] = Variable<int>(period);
    }
    map['kind'] = Variable<int>(kind);
    map['date'] = Variable<DateTime>(date);
    map['value'] = Variable<double>(value);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  ReadingsCompanion toCompanion(bool nullToAbsent) {
    return ReadingsCompanion(
      id: Value(id),
      meterId: Value(meterId),
      contractId: contractId == null && nullToAbsent
          ? const Value.absent()
          : Value(contractId),
      period: period == null && nullToAbsent
          ? const Value.absent()
          : Value(period),
      kind: Value(kind),
      date: Value(date),
      value: Value(value),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Reading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reading(
      id: serializer.fromJson<int>(json['id']),
      meterId: serializer.fromJson<int>(json['meterId']),
      contractId: serializer.fromJson<int?>(json['contractId']),
      period: serializer.fromJson<int?>(json['period']),
      kind: serializer.fromJson<int>(json['kind']),
      date: serializer.fromJson<DateTime>(json['date']),
      value: serializer.fromJson<double>(json['value']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'meterId': serializer.toJson<int>(meterId),
      'contractId': serializer.toJson<int?>(contractId),
      'period': serializer.toJson<int?>(period),
      'kind': serializer.toJson<int>(kind),
      'date': serializer.toJson<DateTime>(date),
      'value': serializer.toJson<double>(value),
      'photoPath': serializer.toJson<String?>(photoPath),
      'note': serializer.toJson<String?>(note),
    };
  }

  Reading copyWith({
    int? id,
    int? meterId,
    Value<int?> contractId = const Value.absent(),
    Value<int?> period = const Value.absent(),
    int? kind,
    DateTime? date,
    double? value,
    Value<String?> photoPath = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Reading(
    id: id ?? this.id,
    meterId: meterId ?? this.meterId,
    contractId: contractId.present ? contractId.value : this.contractId,
    period: period.present ? period.value : this.period,
    kind: kind ?? this.kind,
    date: date ?? this.date,
    value: value ?? this.value,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    note: note.present ? note.value : this.note,
  );
  Reading copyWithCompanion(ReadingsCompanion data) {
    return Reading(
      id: data.id.present ? data.id.value : this.id,
      meterId: data.meterId.present ? data.meterId.value : this.meterId,
      contractId: data.contractId.present
          ? data.contractId.value
          : this.contractId,
      period: data.period.present ? data.period.value : this.period,
      kind: data.kind.present ? data.kind.value : this.kind,
      date: data.date.present ? data.date.value : this.date,
      value: data.value.present ? data.value.value : this.value,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reading(')
          ..write('id: $id, ')
          ..write('meterId: $meterId, ')
          ..write('contractId: $contractId, ')
          ..write('period: $period, ')
          ..write('kind: $kind, ')
          ..write('date: $date, ')
          ..write('value: $value, ')
          ..write('photoPath: $photoPath, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    meterId,
    contractId,
    period,
    kind,
    date,
    value,
    photoPath,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reading &&
          other.id == this.id &&
          other.meterId == this.meterId &&
          other.contractId == this.contractId &&
          other.period == this.period &&
          other.kind == this.kind &&
          other.date == this.date &&
          other.value == this.value &&
          other.photoPath == this.photoPath &&
          other.note == this.note);
}

class ReadingsCompanion extends UpdateCompanion<Reading> {
  final Value<int> id;
  final Value<int> meterId;
  final Value<int?> contractId;
  final Value<int?> period;
  final Value<int> kind;
  final Value<DateTime> date;
  final Value<double> value;
  final Value<String?> photoPath;
  final Value<String?> note;
  const ReadingsCompanion({
    this.id = const Value.absent(),
    this.meterId = const Value.absent(),
    this.contractId = const Value.absent(),
    this.period = const Value.absent(),
    this.kind = const Value.absent(),
    this.date = const Value.absent(),
    this.value = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.note = const Value.absent(),
  });
  ReadingsCompanion.insert({
    this.id = const Value.absent(),
    required int meterId,
    this.contractId = const Value.absent(),
    this.period = const Value.absent(),
    this.kind = const Value.absent(),
    required DateTime date,
    required double value,
    this.photoPath = const Value.absent(),
    this.note = const Value.absent(),
  }) : meterId = Value(meterId),
       date = Value(date),
       value = Value(value);
  static Insertable<Reading> custom({
    Expression<int>? id,
    Expression<int>? meterId,
    Expression<int>? contractId,
    Expression<int>? period,
    Expression<int>? kind,
    Expression<DateTime>? date,
    Expression<double>? value,
    Expression<String>? photoPath,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (meterId != null) 'meter_id': meterId,
      if (contractId != null) 'contract_id': contractId,
      if (period != null) 'period': period,
      if (kind != null) 'kind': kind,
      if (date != null) 'date': date,
      if (value != null) 'value': value,
      if (photoPath != null) 'photo_path': photoPath,
      if (note != null) 'note': note,
    });
  }

  ReadingsCompanion copyWith({
    Value<int>? id,
    Value<int>? meterId,
    Value<int?>? contractId,
    Value<int?>? period,
    Value<int>? kind,
    Value<DateTime>? date,
    Value<double>? value,
    Value<String?>? photoPath,
    Value<String?>? note,
  }) {
    return ReadingsCompanion(
      id: id ?? this.id,
      meterId: meterId ?? this.meterId,
      contractId: contractId ?? this.contractId,
      period: period ?? this.period,
      kind: kind ?? this.kind,
      date: date ?? this.date,
      value: value ?? this.value,
      photoPath: photoPath ?? this.photoPath,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (meterId.present) {
      map['meter_id'] = Variable<int>(meterId.value);
    }
    if (contractId.present) {
      map['contract_id'] = Variable<int>(contractId.value);
    }
    if (period.present) {
      map['period'] = Variable<int>(period.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(kind.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingsCompanion(')
          ..write('id: $id, ')
          ..write('meterId: $meterId, ')
          ..write('contractId: $contractId, ')
          ..write('period: $period, ')
          ..write('kind: $kind, ')
          ..write('date: $date, ')
          ..write('value: $value, ')
          ..write('photoPath: $photoPath, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contractIdMeta = const VerificationMeta(
    'contractId',
  );
  @override
  late final GeneratedColumn<int> contractId = GeneratedColumn<int>(
    'contract_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES contracts (id)',
    ),
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<int> period = GeneratedColumn<int>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<int> kind = GeneratedColumn<int>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _issueDateMeta = const VerificationMeta(
    'issueDate',
  );
  @override
  late final GeneratedColumn<DateTime> issueDate = GeneratedColumn<DateTime>(
    'issue_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    number,
    contractId,
    period,
    kind,
    issueDate,
    dueDate,
    total,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Invoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('contract_id')) {
      context.handle(
        _contractIdMeta,
        contractId.isAcceptableOrUnknown(data['contract_id']!, _contractIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contractIdMeta);
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('issue_date')) {
      context.handle(
        _issueDateMeta,
        issueDate.isAcceptableOrUnknown(data['issue_date']!, _issueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_issueDateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Invoice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}number'],
      )!,
      contractId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contract_id'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kind'],
      )!,
      issueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}issue_date'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }
}

class Invoice extends DataClass implements Insertable<Invoice> {
  final int id;
  final String number;
  final int contractId;
  final int period;
  final int kind;
  final DateTime issueDate;
  final DateTime dueDate;
  final int total;
  final String? notes;
  const Invoice({
    required this.id,
    required this.number,
    required this.contractId,
    required this.period,
    required this.kind,
    required this.issueDate,
    required this.dueDate,
    required this.total,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['number'] = Variable<String>(number);
    map['contract_id'] = Variable<int>(contractId);
    map['period'] = Variable<int>(period);
    map['kind'] = Variable<int>(kind);
    map['issue_date'] = Variable<DateTime>(issueDate);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['total'] = Variable<int>(total);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      number: Value(number),
      contractId: Value(contractId),
      period: Value(period),
      kind: Value(kind),
      issueDate: Value(issueDate),
      dueDate: Value(dueDate),
      total: Value(total),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Invoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Invoice(
      id: serializer.fromJson<int>(json['id']),
      number: serializer.fromJson<String>(json['number']),
      contractId: serializer.fromJson<int>(json['contractId']),
      period: serializer.fromJson<int>(json['period']),
      kind: serializer.fromJson<int>(json['kind']),
      issueDate: serializer.fromJson<DateTime>(json['issueDate']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      total: serializer.fromJson<int>(json['total']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'number': serializer.toJson<String>(number),
      'contractId': serializer.toJson<int>(contractId),
      'period': serializer.toJson<int>(period),
      'kind': serializer.toJson<int>(kind),
      'issueDate': serializer.toJson<DateTime>(issueDate),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'total': serializer.toJson<int>(total),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Invoice copyWith({
    int? id,
    String? number,
    int? contractId,
    int? period,
    int? kind,
    DateTime? issueDate,
    DateTime? dueDate,
    int? total,
    Value<String?> notes = const Value.absent(),
  }) => Invoice(
    id: id ?? this.id,
    number: number ?? this.number,
    contractId: contractId ?? this.contractId,
    period: period ?? this.period,
    kind: kind ?? this.kind,
    issueDate: issueDate ?? this.issueDate,
    dueDate: dueDate ?? this.dueDate,
    total: total ?? this.total,
    notes: notes.present ? notes.value : this.notes,
  );
  Invoice copyWithCompanion(InvoicesCompanion data) {
    return Invoice(
      id: data.id.present ? data.id.value : this.id,
      number: data.number.present ? data.number.value : this.number,
      contractId: data.contractId.present
          ? data.contractId.value
          : this.contractId,
      period: data.period.present ? data.period.value : this.period,
      kind: data.kind.present ? data.kind.value : this.kind,
      issueDate: data.issueDate.present ? data.issueDate.value : this.issueDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      total: data.total.present ? data.total.value : this.total,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Invoice(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('contractId: $contractId, ')
          ..write('period: $period, ')
          ..write('kind: $kind, ')
          ..write('issueDate: $issueDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('total: $total, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    number,
    contractId,
    period,
    kind,
    issueDate,
    dueDate,
    total,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice &&
          other.id == this.id &&
          other.number == this.number &&
          other.contractId == this.contractId &&
          other.period == this.period &&
          other.kind == this.kind &&
          other.issueDate == this.issueDate &&
          other.dueDate == this.dueDate &&
          other.total == this.total &&
          other.notes == this.notes);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<int> id;
  final Value<String> number;
  final Value<int> contractId;
  final Value<int> period;
  final Value<int> kind;
  final Value<DateTime> issueDate;
  final Value<DateTime> dueDate;
  final Value<int> total;
  final Value<String?> notes;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.contractId = const Value.absent(),
    this.period = const Value.absent(),
    this.kind = const Value.absent(),
    this.issueDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.total = const Value.absent(),
    this.notes = const Value.absent(),
  });
  InvoicesCompanion.insert({
    this.id = const Value.absent(),
    required String number,
    required int contractId,
    required int period,
    this.kind = const Value.absent(),
    required DateTime issueDate,
    required DateTime dueDate,
    required int total,
    this.notes = const Value.absent(),
  }) : number = Value(number),
       contractId = Value(contractId),
       period = Value(period),
       issueDate = Value(issueDate),
       dueDate = Value(dueDate),
       total = Value(total);
  static Insertable<Invoice> custom({
    Expression<int>? id,
    Expression<String>? number,
    Expression<int>? contractId,
    Expression<int>? period,
    Expression<int>? kind,
    Expression<DateTime>? issueDate,
    Expression<DateTime>? dueDate,
    Expression<int>? total,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (contractId != null) 'contract_id': contractId,
      if (period != null) 'period': period,
      if (kind != null) 'kind': kind,
      if (issueDate != null) 'issue_date': issueDate,
      if (dueDate != null) 'due_date': dueDate,
      if (total != null) 'total': total,
      if (notes != null) 'notes': notes,
    });
  }

  InvoicesCompanion copyWith({
    Value<int>? id,
    Value<String>? number,
    Value<int>? contractId,
    Value<int>? period,
    Value<int>? kind,
    Value<DateTime>? issueDate,
    Value<DateTime>? dueDate,
    Value<int>? total,
    Value<String?>? notes,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      contractId: contractId ?? this.contractId,
      period: period ?? this.period,
      kind: kind ?? this.kind,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      total: total ?? this.total,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (contractId.present) {
      map['contract_id'] = Variable<int>(contractId.value);
    }
    if (period.present) {
      map['period'] = Variable<int>(period.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(kind.value);
    }
    if (issueDate.present) {
      map['issue_date'] = Variable<DateTime>(issueDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('contractId: $contractId, ')
          ..write('period: $period, ')
          ..write('kind: $kind, ')
          ..write('issueDate: $issueDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('total: $total, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $InvoiceLinesTable extends InvoiceLines
    with TableInfo<$InvoiceLinesTable, InvoiceLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<int> kind = GeneratedColumn<int>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<int> unitPrice = GeneratedColumn<int>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _htMeta = const VerificationMeta('ht');
  @override
  late final GeneratedColumn<int> ht = GeneratedColumn<int>(
    'ht',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vatMeta = const VerificationMeta('vat');
  @override
  late final GeneratedColumn<int> vat = GeneratedColumn<int>(
    'vat',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ttcMeta = const VerificationMeta('ttc');
  @override
  late final GeneratedColumn<int> ttc = GeneratedColumn<int>(
    'ttc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meterIdMeta = const VerificationMeta(
    'meterId',
  );
  @override
  late final GeneratedColumn<int> meterId = GeneratedColumn<int>(
    'meter_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _utilityTypeIdMeta = const VerificationMeta(
    'utilityTypeId',
  );
  @override
  late final GeneratedColumn<int> utilityTypeId = GeneratedColumn<int>(
    'utility_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startIndexMeta = const VerificationMeta(
    'startIndex',
  );
  @override
  late final GeneratedColumn<double> startIndex = GeneratedColumn<double>(
    'start_index',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endIndexMeta = const VerificationMeta(
    'endIndex',
  );
  @override
  late final GeneratedColumn<double> endIndex = GeneratedColumn<double>(
    'end_index',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metaMeta = const VerificationMeta('meta');
  @override
  late final GeneratedColumn<String> meta = GeneratedColumn<String>(
    'meta',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceId,
    position,
    kind,
    label,
    details,
    quantity,
    unit,
    unitPrice,
    ht,
    vat,
    ttc,
    meterId,
    utilityTypeId,
    startIndex,
    endIndex,
    meta,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    }
    if (data.containsKey('ht')) {
      context.handle(_htMeta, ht.isAcceptableOrUnknown(data['ht']!, _htMeta));
    } else if (isInserting) {
      context.missing(_htMeta);
    }
    if (data.containsKey('vat')) {
      context.handle(
        _vatMeta,
        vat.isAcceptableOrUnknown(data['vat']!, _vatMeta),
      );
    }
    if (data.containsKey('ttc')) {
      context.handle(
        _ttcMeta,
        ttc.isAcceptableOrUnknown(data['ttc']!, _ttcMeta),
      );
    } else if (isInserting) {
      context.missing(_ttcMeta);
    }
    if (data.containsKey('meter_id')) {
      context.handle(
        _meterIdMeta,
        meterId.isAcceptableOrUnknown(data['meter_id']!, _meterIdMeta),
      );
    }
    if (data.containsKey('utility_type_id')) {
      context.handle(
        _utilityTypeIdMeta,
        utilityTypeId.isAcceptableOrUnknown(
          data['utility_type_id']!,
          _utilityTypeIdMeta,
        ),
      );
    }
    if (data.containsKey('start_index')) {
      context.handle(
        _startIndexMeta,
        startIndex.isAcceptableOrUnknown(data['start_index']!, _startIndexMeta),
      );
    }
    if (data.containsKey('end_index')) {
      context.handle(
        _endIndexMeta,
        endIndex.isAcceptableOrUnknown(data['end_index']!, _endIndexMeta),
      );
    }
    if (data.containsKey('meta')) {
      context.handle(
        _metaMeta,
        meta.isAcceptableOrUnknown(data['meta']!, _metaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kind'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price'],
      )!,
      ht: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ht'],
      )!,
      vat: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vat'],
      )!,
      ttc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ttc'],
      )!,
      meterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meter_id'],
      ),
      utilityTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}utility_type_id'],
      ),
      startIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_index'],
      ),
      endIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}end_index'],
      ),
      meta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meta'],
      ),
    );
  }

  @override
  $InvoiceLinesTable createAlias(String alias) {
    return $InvoiceLinesTable(attachedDatabase, alias);
  }
}

class InvoiceLine extends DataClass implements Insertable<InvoiceLine> {
  final int id;
  final int invoiceId;
  final int position;
  final int kind;
  final String label;
  final String? details;
  final double quantity;
  final String? unit;
  final int unitPrice;
  final int ht;
  final int vat;
  final int ttc;
  final int? meterId;
  final int? utilityTypeId;
  final double? startIndex;
  final double? endIndex;

  /// Données structurées (JSON) pour reconstruire le libellé dans la langue du document.
  final String? meta;
  const InvoiceLine({
    required this.id,
    required this.invoiceId,
    required this.position,
    required this.kind,
    required this.label,
    this.details,
    required this.quantity,
    this.unit,
    required this.unitPrice,
    required this.ht,
    required this.vat,
    required this.ttc,
    this.meterId,
    this.utilityTypeId,
    this.startIndex,
    this.endIndex,
    this.meta,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<int>(invoiceId);
    map['position'] = Variable<int>(position);
    map['kind'] = Variable<int>(kind);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['quantity'] = Variable<double>(quantity);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['unit_price'] = Variable<int>(unitPrice);
    map['ht'] = Variable<int>(ht);
    map['vat'] = Variable<int>(vat);
    map['ttc'] = Variable<int>(ttc);
    if (!nullToAbsent || meterId != null) {
      map['meter_id'] = Variable<int>(meterId);
    }
    if (!nullToAbsent || utilityTypeId != null) {
      map['utility_type_id'] = Variable<int>(utilityTypeId);
    }
    if (!nullToAbsent || startIndex != null) {
      map['start_index'] = Variable<double>(startIndex);
    }
    if (!nullToAbsent || endIndex != null) {
      map['end_index'] = Variable<double>(endIndex);
    }
    if (!nullToAbsent || meta != null) {
      map['meta'] = Variable<String>(meta);
    }
    return map;
  }

  InvoiceLinesCompanion toCompanion(bool nullToAbsent) {
    return InvoiceLinesCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      position: Value(position),
      kind: Value(kind),
      label: Value(label),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      quantity: Value(quantity),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      unitPrice: Value(unitPrice),
      ht: Value(ht),
      vat: Value(vat),
      ttc: Value(ttc),
      meterId: meterId == null && nullToAbsent
          ? const Value.absent()
          : Value(meterId),
      utilityTypeId: utilityTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(utilityTypeId),
      startIndex: startIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(startIndex),
      endIndex: endIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(endIndex),
      meta: meta == null && nullToAbsent ? const Value.absent() : Value(meta),
    );
  }

  factory InvoiceLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceLine(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
      position: serializer.fromJson<int>(json['position']),
      kind: serializer.fromJson<int>(json['kind']),
      label: serializer.fromJson<String>(json['label']),
      details: serializer.fromJson<String?>(json['details']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String?>(json['unit']),
      unitPrice: serializer.fromJson<int>(json['unitPrice']),
      ht: serializer.fromJson<int>(json['ht']),
      vat: serializer.fromJson<int>(json['vat']),
      ttc: serializer.fromJson<int>(json['ttc']),
      meterId: serializer.fromJson<int?>(json['meterId']),
      utilityTypeId: serializer.fromJson<int?>(json['utilityTypeId']),
      startIndex: serializer.fromJson<double?>(json['startIndex']),
      endIndex: serializer.fromJson<double?>(json['endIndex']),
      meta: serializer.fromJson<String?>(json['meta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<int>(invoiceId),
      'position': serializer.toJson<int>(position),
      'kind': serializer.toJson<int>(kind),
      'label': serializer.toJson<String>(label),
      'details': serializer.toJson<String?>(details),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String?>(unit),
      'unitPrice': serializer.toJson<int>(unitPrice),
      'ht': serializer.toJson<int>(ht),
      'vat': serializer.toJson<int>(vat),
      'ttc': serializer.toJson<int>(ttc),
      'meterId': serializer.toJson<int?>(meterId),
      'utilityTypeId': serializer.toJson<int?>(utilityTypeId),
      'startIndex': serializer.toJson<double?>(startIndex),
      'endIndex': serializer.toJson<double?>(endIndex),
      'meta': serializer.toJson<String?>(meta),
    };
  }

  InvoiceLine copyWith({
    int? id,
    int? invoiceId,
    int? position,
    int? kind,
    String? label,
    Value<String?> details = const Value.absent(),
    double? quantity,
    Value<String?> unit = const Value.absent(),
    int? unitPrice,
    int? ht,
    int? vat,
    int? ttc,
    Value<int?> meterId = const Value.absent(),
    Value<int?> utilityTypeId = const Value.absent(),
    Value<double?> startIndex = const Value.absent(),
    Value<double?> endIndex = const Value.absent(),
    Value<String?> meta = const Value.absent(),
  }) => InvoiceLine(
    id: id ?? this.id,
    invoiceId: invoiceId ?? this.invoiceId,
    position: position ?? this.position,
    kind: kind ?? this.kind,
    label: label ?? this.label,
    details: details.present ? details.value : this.details,
    quantity: quantity ?? this.quantity,
    unit: unit.present ? unit.value : this.unit,
    unitPrice: unitPrice ?? this.unitPrice,
    ht: ht ?? this.ht,
    vat: vat ?? this.vat,
    ttc: ttc ?? this.ttc,
    meterId: meterId.present ? meterId.value : this.meterId,
    utilityTypeId: utilityTypeId.present
        ? utilityTypeId.value
        : this.utilityTypeId,
    startIndex: startIndex.present ? startIndex.value : this.startIndex,
    endIndex: endIndex.present ? endIndex.value : this.endIndex,
    meta: meta.present ? meta.value : this.meta,
  );
  InvoiceLine copyWithCompanion(InvoiceLinesCompanion data) {
    return InvoiceLine(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      position: data.position.present ? data.position.value : this.position,
      kind: data.kind.present ? data.kind.value : this.kind,
      label: data.label.present ? data.label.value : this.label,
      details: data.details.present ? data.details.value : this.details,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      ht: data.ht.present ? data.ht.value : this.ht,
      vat: data.vat.present ? data.vat.value : this.vat,
      ttc: data.ttc.present ? data.ttc.value : this.ttc,
      meterId: data.meterId.present ? data.meterId.value : this.meterId,
      utilityTypeId: data.utilityTypeId.present
          ? data.utilityTypeId.value
          : this.utilityTypeId,
      startIndex: data.startIndex.present
          ? data.startIndex.value
          : this.startIndex,
      endIndex: data.endIndex.present ? data.endIndex.value : this.endIndex,
      meta: data.meta.present ? data.meta.value : this.meta,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceLine(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('position: $position, ')
          ..write('kind: $kind, ')
          ..write('label: $label, ')
          ..write('details: $details, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('ht: $ht, ')
          ..write('vat: $vat, ')
          ..write('ttc: $ttc, ')
          ..write('meterId: $meterId, ')
          ..write('utilityTypeId: $utilityTypeId, ')
          ..write('startIndex: $startIndex, ')
          ..write('endIndex: $endIndex, ')
          ..write('meta: $meta')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    invoiceId,
    position,
    kind,
    label,
    details,
    quantity,
    unit,
    unitPrice,
    ht,
    vat,
    ttc,
    meterId,
    utilityTypeId,
    startIndex,
    endIndex,
    meta,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceLine &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.position == this.position &&
          other.kind == this.kind &&
          other.label == this.label &&
          other.details == this.details &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.unitPrice == this.unitPrice &&
          other.ht == this.ht &&
          other.vat == this.vat &&
          other.ttc == this.ttc &&
          other.meterId == this.meterId &&
          other.utilityTypeId == this.utilityTypeId &&
          other.startIndex == this.startIndex &&
          other.endIndex == this.endIndex &&
          other.meta == this.meta);
}

class InvoiceLinesCompanion extends UpdateCompanion<InvoiceLine> {
  final Value<int> id;
  final Value<int> invoiceId;
  final Value<int> position;
  final Value<int> kind;
  final Value<String> label;
  final Value<String?> details;
  final Value<double> quantity;
  final Value<String?> unit;
  final Value<int> unitPrice;
  final Value<int> ht;
  final Value<int> vat;
  final Value<int> ttc;
  final Value<int?> meterId;
  final Value<int?> utilityTypeId;
  final Value<double?> startIndex;
  final Value<double?> endIndex;
  final Value<String?> meta;
  const InvoiceLinesCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.position = const Value.absent(),
    this.kind = const Value.absent(),
    this.label = const Value.absent(),
    this.details = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.ht = const Value.absent(),
    this.vat = const Value.absent(),
    this.ttc = const Value.absent(),
    this.meterId = const Value.absent(),
    this.utilityTypeId = const Value.absent(),
    this.startIndex = const Value.absent(),
    this.endIndex = const Value.absent(),
    this.meta = const Value.absent(),
  });
  InvoiceLinesCompanion.insert({
    this.id = const Value.absent(),
    required int invoiceId,
    this.position = const Value.absent(),
    required int kind,
    required String label,
    this.details = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitPrice = const Value.absent(),
    required int ht,
    this.vat = const Value.absent(),
    required int ttc,
    this.meterId = const Value.absent(),
    this.utilityTypeId = const Value.absent(),
    this.startIndex = const Value.absent(),
    this.endIndex = const Value.absent(),
    this.meta = const Value.absent(),
  }) : invoiceId = Value(invoiceId),
       kind = Value(kind),
       label = Value(label),
       ht = Value(ht),
       ttc = Value(ttc);
  static Insertable<InvoiceLine> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
    Expression<int>? position,
    Expression<int>? kind,
    Expression<String>? label,
    Expression<String>? details,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<int>? unitPrice,
    Expression<int>? ht,
    Expression<int>? vat,
    Expression<int>? ttc,
    Expression<int>? meterId,
    Expression<int>? utilityTypeId,
    Expression<double>? startIndex,
    Expression<double>? endIndex,
    Expression<String>? meta,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (position != null) 'position': position,
      if (kind != null) 'kind': kind,
      if (label != null) 'label': label,
      if (details != null) 'details': details,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (ht != null) 'ht': ht,
      if (vat != null) 'vat': vat,
      if (ttc != null) 'ttc': ttc,
      if (meterId != null) 'meter_id': meterId,
      if (utilityTypeId != null) 'utility_type_id': utilityTypeId,
      if (startIndex != null) 'start_index': startIndex,
      if (endIndex != null) 'end_index': endIndex,
      if (meta != null) 'meta': meta,
    });
  }

  InvoiceLinesCompanion copyWith({
    Value<int>? id,
    Value<int>? invoiceId,
    Value<int>? position,
    Value<int>? kind,
    Value<String>? label,
    Value<String?>? details,
    Value<double>? quantity,
    Value<String?>? unit,
    Value<int>? unitPrice,
    Value<int>? ht,
    Value<int>? vat,
    Value<int>? ttc,
    Value<int?>? meterId,
    Value<int?>? utilityTypeId,
    Value<double?>? startIndex,
    Value<double?>? endIndex,
    Value<String?>? meta,
  }) {
    return InvoiceLinesCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      position: position ?? this.position,
      kind: kind ?? this.kind,
      label: label ?? this.label,
      details: details ?? this.details,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      ht: ht ?? this.ht,
      vat: vat ?? this.vat,
      ttc: ttc ?? this.ttc,
      meterId: meterId ?? this.meterId,
      utilityTypeId: utilityTypeId ?? this.utilityTypeId,
      startIndex: startIndex ?? this.startIndex,
      endIndex: endIndex ?? this.endIndex,
      meta: meta ?? this.meta,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(kind.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<int>(unitPrice.value);
    }
    if (ht.present) {
      map['ht'] = Variable<int>(ht.value);
    }
    if (vat.present) {
      map['vat'] = Variable<int>(vat.value);
    }
    if (ttc.present) {
      map['ttc'] = Variable<int>(ttc.value);
    }
    if (meterId.present) {
      map['meter_id'] = Variable<int>(meterId.value);
    }
    if (utilityTypeId.present) {
      map['utility_type_id'] = Variable<int>(utilityTypeId.value);
    }
    if (startIndex.present) {
      map['start_index'] = Variable<double>(startIndex.value);
    }
    if (endIndex.present) {
      map['end_index'] = Variable<double>(endIndex.value);
    }
    if (meta.present) {
      map['meta'] = Variable<String>(meta.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceLinesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('position: $position, ')
          ..write('kind: $kind, ')
          ..write('label: $label, ')
          ..write('details: $details, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('ht: $ht, ')
          ..write('vat: $vat, ')
          ..write('ttc: $ttc, ')
          ..write('meterId: $meterId, ')
          ..write('utilityTypeId: $utilityTypeId, ')
          ..write('startIndex: $startIndex, ')
          ..write('endIndex: $endIndex, ')
          ..write('meta: $meta')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _contractIdMeta = const VerificationMeta(
    'contractId',
  );
  @override
  late final GeneratedColumn<int> contractId = GeneratedColumn<int>(
    'contract_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES contracts (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<int> kind = GeneratedColumn<int>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Espèces'),
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptNumberMeta = const VerificationMeta(
    'receiptNumber',
  );
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
    'receipt_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    contractId,
    date,
    amount,
    kind,
    method,
    reference,
    note,
    receiptNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('contract_id')) {
      context.handle(
        _contractIdMeta,
        contractId.isAcceptableOrUnknown(data['contract_id']!, _contractIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contractIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
        _receiptNumberMeta,
        receiptNumber.isAcceptableOrUnknown(
          data['receipt_number']!,
          _receiptNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiptNumberMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      contractId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contract_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kind'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      receiptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_number'],
      )!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final int id;
  final int contractId;
  final DateTime date;
  final int amount;
  final int kind;
  final String method;
  final String? reference;
  final String? note;
  final String receiptNumber;
  const Payment({
    required this.id,
    required this.contractId,
    required this.date,
    required this.amount,
    required this.kind,
    required this.method,
    this.reference,
    this.note,
    required this.receiptNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['contract_id'] = Variable<int>(contractId);
    map['date'] = Variable<DateTime>(date);
    map['amount'] = Variable<int>(amount);
    map['kind'] = Variable<int>(kind);
    map['method'] = Variable<String>(method);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['receipt_number'] = Variable<String>(receiptNumber);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      contractId: Value(contractId),
      date: Value(date),
      amount: Value(amount),
      kind: Value(kind),
      method: Value(method),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      receiptNumber: Value(receiptNumber),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      contractId: serializer.fromJson<int>(json['contractId']),
      date: serializer.fromJson<DateTime>(json['date']),
      amount: serializer.fromJson<int>(json['amount']),
      kind: serializer.fromJson<int>(json['kind']),
      method: serializer.fromJson<String>(json['method']),
      reference: serializer.fromJson<String?>(json['reference']),
      note: serializer.fromJson<String?>(json['note']),
      receiptNumber: serializer.fromJson<String>(json['receiptNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'contractId': serializer.toJson<int>(contractId),
      'date': serializer.toJson<DateTime>(date),
      'amount': serializer.toJson<int>(amount),
      'kind': serializer.toJson<int>(kind),
      'method': serializer.toJson<String>(method),
      'reference': serializer.toJson<String?>(reference),
      'note': serializer.toJson<String?>(note),
      'receiptNumber': serializer.toJson<String>(receiptNumber),
    };
  }

  Payment copyWith({
    int? id,
    int? contractId,
    DateTime? date,
    int? amount,
    int? kind,
    String? method,
    Value<String?> reference = const Value.absent(),
    Value<String?> note = const Value.absent(),
    String? receiptNumber,
  }) => Payment(
    id: id ?? this.id,
    contractId: contractId ?? this.contractId,
    date: date ?? this.date,
    amount: amount ?? this.amount,
    kind: kind ?? this.kind,
    method: method ?? this.method,
    reference: reference.present ? reference.value : this.reference,
    note: note.present ? note.value : this.note,
    receiptNumber: receiptNumber ?? this.receiptNumber,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      contractId: data.contractId.present
          ? data.contractId.value
          : this.contractId,
      date: data.date.present ? data.date.value : this.date,
      amount: data.amount.present ? data.amount.value : this.amount,
      kind: data.kind.present ? data.kind.value : this.kind,
      method: data.method.present ? data.method.value : this.method,
      reference: data.reference.present ? data.reference.value : this.reference,
      note: data.note.present ? data.note.value : this.note,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('contractId: $contractId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('kind: $kind, ')
          ..write('method: $method, ')
          ..write('reference: $reference, ')
          ..write('note: $note, ')
          ..write('receiptNumber: $receiptNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    contractId,
    date,
    amount,
    kind,
    method,
    reference,
    note,
    receiptNumber,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.contractId == this.contractId &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.kind == this.kind &&
          other.method == this.method &&
          other.reference == this.reference &&
          other.note == this.note &&
          other.receiptNumber == this.receiptNumber);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<int> contractId;
  final Value<DateTime> date;
  final Value<int> amount;
  final Value<int> kind;
  final Value<String> method;
  final Value<String?> reference;
  final Value<String?> note;
  final Value<String> receiptNumber;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.contractId = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.kind = const Value.absent(),
    this.method = const Value.absent(),
    this.reference = const Value.absent(),
    this.note = const Value.absent(),
    this.receiptNumber = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int contractId,
    required DateTime date,
    required int amount,
    this.kind = const Value.absent(),
    this.method = const Value.absent(),
    this.reference = const Value.absent(),
    this.note = const Value.absent(),
    required String receiptNumber,
  }) : contractId = Value(contractId),
       date = Value(date),
       amount = Value(amount),
       receiptNumber = Value(receiptNumber);
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<int>? contractId,
    Expression<DateTime>? date,
    Expression<int>? amount,
    Expression<int>? kind,
    Expression<String>? method,
    Expression<String>? reference,
    Expression<String>? note,
    Expression<String>? receiptNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contractId != null) 'contract_id': contractId,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (kind != null) 'kind': kind,
      if (method != null) 'method': method,
      if (reference != null) 'reference': reference,
      if (note != null) 'note': note,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
    });
  }

  PaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? contractId,
    Value<DateTime>? date,
    Value<int>? amount,
    Value<int>? kind,
    Value<String>? method,
    Value<String?>? reference,
    Value<String?>? note,
    Value<String>? receiptNumber,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      contractId: contractId ?? this.contractId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      kind: kind ?? this.kind,
      method: method ?? this.method,
      reference: reference ?? this.reference,
      note: note ?? this.note,
      receiptNumber: receiptNumber ?? this.receiptNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (contractId.present) {
      map['contract_id'] = Variable<int>(contractId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(kind.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('contractId: $contractId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('kind: $kind, ')
          ..write('method: $method, ')
          ..write('reference: $reference, ')
          ..write('note: $note, ')
          ..write('receiptNumber: $receiptNumber')
          ..write(')'))
        .toString();
  }
}

class $InspectionsTable extends Inspections
    with TableInfo<$InspectionsTable, Inspection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _contractIdMeta = const VerificationMeta(
    'contractId',
  );
  @override
  late final GeneratedColumn<int> contractId = GeneratedColumn<int>(
    'contract_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES contracts (id)',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<int> kind = GeneratedColumn<int>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, contractId, kind, date, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Inspection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('contract_id')) {
      context.handle(
        _contractIdMeta,
        contractId.isAcceptableOrUnknown(data['contract_id']!, _contractIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contractIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Inspection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Inspection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      contractId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contract_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kind'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $InspectionsTable createAlias(String alias) {
    return $InspectionsTable(attachedDatabase, alias);
  }
}

class Inspection extends DataClass implements Insertable<Inspection> {
  final int id;
  final int contractId;
  final int kind;
  final DateTime date;
  final String? notes;
  const Inspection({
    required this.id,
    required this.contractId,
    required this.kind,
    required this.date,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['contract_id'] = Variable<int>(contractId);
    map['kind'] = Variable<int>(kind);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  InspectionsCompanion toCompanion(bool nullToAbsent) {
    return InspectionsCompanion(
      id: Value(id),
      contractId: Value(contractId),
      kind: Value(kind),
      date: Value(date),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Inspection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Inspection(
      id: serializer.fromJson<int>(json['id']),
      contractId: serializer.fromJson<int>(json['contractId']),
      kind: serializer.fromJson<int>(json['kind']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'contractId': serializer.toJson<int>(contractId),
      'kind': serializer.toJson<int>(kind),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Inspection copyWith({
    int? id,
    int? contractId,
    int? kind,
    DateTime? date,
    Value<String?> notes = const Value.absent(),
  }) => Inspection(
    id: id ?? this.id,
    contractId: contractId ?? this.contractId,
    kind: kind ?? this.kind,
    date: date ?? this.date,
    notes: notes.present ? notes.value : this.notes,
  );
  Inspection copyWithCompanion(InspectionsCompanion data) {
    return Inspection(
      id: data.id.present ? data.id.value : this.id,
      contractId: data.contractId.present
          ? data.contractId.value
          : this.contractId,
      kind: data.kind.present ? data.kind.value : this.kind,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Inspection(')
          ..write('id: $id, ')
          ..write('contractId: $contractId, ')
          ..write('kind: $kind, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, contractId, kind, date, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Inspection &&
          other.id == this.id &&
          other.contractId == this.contractId &&
          other.kind == this.kind &&
          other.date == this.date &&
          other.notes == this.notes);
}

class InspectionsCompanion extends UpdateCompanion<Inspection> {
  final Value<int> id;
  final Value<int> contractId;
  final Value<int> kind;
  final Value<DateTime> date;
  final Value<String?> notes;
  const InspectionsCompanion({
    this.id = const Value.absent(),
    this.contractId = const Value.absent(),
    this.kind = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
  });
  InspectionsCompanion.insert({
    this.id = const Value.absent(),
    required int contractId,
    required int kind,
    required DateTime date,
    this.notes = const Value.absent(),
  }) : contractId = Value(contractId),
       kind = Value(kind),
       date = Value(date);
  static Insertable<Inspection> custom({
    Expression<int>? id,
    Expression<int>? contractId,
    Expression<int>? kind,
    Expression<DateTime>? date,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contractId != null) 'contract_id': contractId,
      if (kind != null) 'kind': kind,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
    });
  }

  InspectionsCompanion copyWith({
    Value<int>? id,
    Value<int>? contractId,
    Value<int>? kind,
    Value<DateTime>? date,
    Value<String?>? notes,
  }) {
    return InspectionsCompanion(
      id: id ?? this.id,
      contractId: contractId ?? this.contractId,
      kind: kind ?? this.kind,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (contractId.present) {
      map['contract_id'] = Variable<int>(contractId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(kind.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionsCompanion(')
          ..write('id: $id, ')
          ..write('contractId: $contractId, ')
          ..write('kind: $kind, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $InspectionItemsTable extends InspectionItems
    with TableInfo<$InspectionItemsTable, InspectionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _inspectionIdMeta = const VerificationMeta(
    'inspectionId',
  );
  @override
  late final GeneratedColumn<int> inspectionId = GeneratedColumn<int>(
    'inspection_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES inspections (id)',
    ),
  );
  static const VerificationMeta _roomMeta = const VerificationMeta('room');
  @override
  late final GeneratedColumn<String> room = GeneratedColumn<String>(
    'room',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _elementMeta = const VerificationMeta(
    'element',
  );
  @override
  late final GeneratedColumn<String> element = GeneratedColumn<String>(
    'element',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conditionMeta = const VerificationMeta(
    'condition',
  );
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Bon'),
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    inspectionId,
    room,
    element,
    condition,
    comment,
    cost,
    photoPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspection_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InspectionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('inspection_id')) {
      context.handle(
        _inspectionIdMeta,
        inspectionId.isAcceptableOrUnknown(
          data['inspection_id']!,
          _inspectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectionIdMeta);
    }
    if (data.containsKey('room')) {
      context.handle(
        _roomMeta,
        room.isAcceptableOrUnknown(data['room']!, _roomMeta),
      );
    } else if (isInserting) {
      context.missing(_roomMeta);
    }
    if (data.containsKey('element')) {
      context.handle(
        _elementMeta,
        element.isAcceptableOrUnknown(data['element']!, _elementMeta),
      );
    } else if (isInserting) {
      context.missing(_elementMeta);
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InspectionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspectionItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      inspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}inspection_id'],
      )!,
      room: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room'],
      )!,
      element: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}element'],
      )!,
      condition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
    );
  }

  @override
  $InspectionItemsTable createAlias(String alias) {
    return $InspectionItemsTable(attachedDatabase, alias);
  }
}

class InspectionItem extends DataClass implements Insertable<InspectionItem> {
  final int id;
  final int inspectionId;
  final String room;
  final String element;
  final String condition;
  final String? comment;
  final int cost;
  final String? photoPath;
  const InspectionItem({
    required this.id,
    required this.inspectionId,
    required this.room,
    required this.element,
    required this.condition,
    this.comment,
    required this.cost,
    this.photoPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['inspection_id'] = Variable<int>(inspectionId);
    map['room'] = Variable<String>(room);
    map['element'] = Variable<String>(element);
    map['condition'] = Variable<String>(condition);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    map['cost'] = Variable<int>(cost);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    return map;
  }

  InspectionItemsCompanion toCompanion(bool nullToAbsent) {
    return InspectionItemsCompanion(
      id: Value(id),
      inspectionId: Value(inspectionId),
      room: Value(room),
      element: Value(element),
      condition: Value(condition),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      cost: Value(cost),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
    );
  }

  factory InspectionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspectionItem(
      id: serializer.fromJson<int>(json['id']),
      inspectionId: serializer.fromJson<int>(json['inspectionId']),
      room: serializer.fromJson<String>(json['room']),
      element: serializer.fromJson<String>(json['element']),
      condition: serializer.fromJson<String>(json['condition']),
      comment: serializer.fromJson<String?>(json['comment']),
      cost: serializer.fromJson<int>(json['cost']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'inspectionId': serializer.toJson<int>(inspectionId),
      'room': serializer.toJson<String>(room),
      'element': serializer.toJson<String>(element),
      'condition': serializer.toJson<String>(condition),
      'comment': serializer.toJson<String?>(comment),
      'cost': serializer.toJson<int>(cost),
      'photoPath': serializer.toJson<String?>(photoPath),
    };
  }

  InspectionItem copyWith({
    int? id,
    int? inspectionId,
    String? room,
    String? element,
    String? condition,
    Value<String?> comment = const Value.absent(),
    int? cost,
    Value<String?> photoPath = const Value.absent(),
  }) => InspectionItem(
    id: id ?? this.id,
    inspectionId: inspectionId ?? this.inspectionId,
    room: room ?? this.room,
    element: element ?? this.element,
    condition: condition ?? this.condition,
    comment: comment.present ? comment.value : this.comment,
    cost: cost ?? this.cost,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
  );
  InspectionItem copyWithCompanion(InspectionItemsCompanion data) {
    return InspectionItem(
      id: data.id.present ? data.id.value : this.id,
      inspectionId: data.inspectionId.present
          ? data.inspectionId.value
          : this.inspectionId,
      room: data.room.present ? data.room.value : this.room,
      element: data.element.present ? data.element.value : this.element,
      condition: data.condition.present ? data.condition.value : this.condition,
      comment: data.comment.present ? data.comment.value : this.comment,
      cost: data.cost.present ? data.cost.value : this.cost,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspectionItem(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('room: $room, ')
          ..write('element: $element, ')
          ..write('condition: $condition, ')
          ..write('comment: $comment, ')
          ..write('cost: $cost, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    inspectionId,
    room,
    element,
    condition,
    comment,
    cost,
    photoPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspectionItem &&
          other.id == this.id &&
          other.inspectionId == this.inspectionId &&
          other.room == this.room &&
          other.element == this.element &&
          other.condition == this.condition &&
          other.comment == this.comment &&
          other.cost == this.cost &&
          other.photoPath == this.photoPath);
}

class InspectionItemsCompanion extends UpdateCompanion<InspectionItem> {
  final Value<int> id;
  final Value<int> inspectionId;
  final Value<String> room;
  final Value<String> element;
  final Value<String> condition;
  final Value<String?> comment;
  final Value<int> cost;
  final Value<String?> photoPath;
  const InspectionItemsCompanion({
    this.id = const Value.absent(),
    this.inspectionId = const Value.absent(),
    this.room = const Value.absent(),
    this.element = const Value.absent(),
    this.condition = const Value.absent(),
    this.comment = const Value.absent(),
    this.cost = const Value.absent(),
    this.photoPath = const Value.absent(),
  });
  InspectionItemsCompanion.insert({
    this.id = const Value.absent(),
    required int inspectionId,
    required String room,
    required String element,
    this.condition = const Value.absent(),
    this.comment = const Value.absent(),
    this.cost = const Value.absent(),
    this.photoPath = const Value.absent(),
  }) : inspectionId = Value(inspectionId),
       room = Value(room),
       element = Value(element);
  static Insertable<InspectionItem> custom({
    Expression<int>? id,
    Expression<int>? inspectionId,
    Expression<String>? room,
    Expression<String>? element,
    Expression<String>? condition,
    Expression<String>? comment,
    Expression<int>? cost,
    Expression<String>? photoPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (room != null) 'room': room,
      if (element != null) 'element': element,
      if (condition != null) 'condition': condition,
      if (comment != null) 'comment': comment,
      if (cost != null) 'cost': cost,
      if (photoPath != null) 'photo_path': photoPath,
    });
  }

  InspectionItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? inspectionId,
    Value<String>? room,
    Value<String>? element,
    Value<String>? condition,
    Value<String?>? comment,
    Value<int>? cost,
    Value<String?>? photoPath,
  }) {
    return InspectionItemsCompanion(
      id: id ?? this.id,
      inspectionId: inspectionId ?? this.inspectionId,
      room: room ?? this.room,
      element: element ?? this.element,
      condition: condition ?? this.condition,
      comment: comment ?? this.comment,
      cost: cost ?? this.cost,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (inspectionId.present) {
      map['inspection_id'] = Variable<int>(inspectionId.value);
    }
    if (room.present) {
      map['room'] = Variable<String>(room.value);
    }
    if (element.present) {
      map['element'] = Variable<String>(element.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionItemsCompanion(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('room: $room, ')
          ..write('element: $element, ')
          ..write('condition: $condition, ')
          ..write('comment: $comment, ')
          ..write('cost: $cost, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OwnersTable owners = $OwnersTable(this);
  late final $BuildingsTable buildings = $BuildingsTable(this);
  late final $ApartmentsTable apartments = $ApartmentsTable(this);
  late final $TenantsTable tenants = $TenantsTable(this);
  late final $UtilityTypesTable utilityTypes = $UtilityTypesTable(this);
  late final $MetersTable meters = $MetersTable(this);
  late final $ServiceTypesTable serviceTypes = $ServiceTypesTable(this);
  late final $ContractsTable contracts = $ContractsTable(this);
  late final $ContractServicesTable contractServices = $ContractServicesTable(
    this,
  );
  late final $ContractBenefitsTable contractBenefits = $ContractBenefitsTable(
    this,
  );
  late final $ReadingsTable readings = $ReadingsTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $InvoiceLinesTable invoiceLines = $InvoiceLinesTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $InspectionsTable inspections = $InspectionsTable(this);
  late final $InspectionItemsTable inspectionItems = $InspectionItemsTable(
    this,
  );
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    owners,
    buildings,
    apartments,
    tenants,
    utilityTypes,
    meters,
    serviceTypes,
    contracts,
    contractServices,
    contractBenefits,
    readings,
    invoices,
    invoiceLines,
    payments,
    inspections,
    inspectionItems,
    settings,
  ];
}

typedef $$OwnersTableCreateCompanionBuilder =
    OwnersCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> address,
      Value<String?> notes,
    });
typedef $$OwnersTableUpdateCompanionBuilder =
    OwnersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> address,
      Value<String?> notes,
    });

final class $$OwnersTableReferences
    extends BaseReferences<_$AppDatabase, $OwnersTable, Owner> {
  $$OwnersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BuildingsTable, List<Building>>
  _buildingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.buildings,
    aliasName: $_aliasNameGenerator(db.owners.id, db.buildings.ownerId),
  );

  $$BuildingsTableProcessedTableManager get buildingsRefs {
    final manager = $$BuildingsTableTableManager(
      $_db,
      $_db.buildings,
    ).filter((f) => f.ownerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_buildingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OwnersTableFilterComposer
    extends Composer<_$AppDatabase, $OwnersTable> {
  $$OwnersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> buildingsRefs(
    Expression<bool> Function($$BuildingsTableFilterComposer f) f,
  ) {
    final $$BuildingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.buildings,
      getReferencedColumn: (t) => t.ownerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BuildingsTableFilterComposer(
            $db: $db,
            $table: $db.buildings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OwnersTableOrderingComposer
    extends Composer<_$AppDatabase, $OwnersTable> {
  $$OwnersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OwnersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OwnersTable> {
  $$OwnersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> buildingsRefs<T extends Object>(
    Expression<T> Function($$BuildingsTableAnnotationComposer a) f,
  ) {
    final $$BuildingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.buildings,
      getReferencedColumn: (t) => t.ownerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BuildingsTableAnnotationComposer(
            $db: $db,
            $table: $db.buildings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OwnersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OwnersTable,
          Owner,
          $$OwnersTableFilterComposer,
          $$OwnersTableOrderingComposer,
          $$OwnersTableAnnotationComposer,
          $$OwnersTableCreateCompanionBuilder,
          $$OwnersTableUpdateCompanionBuilder,
          (Owner, $$OwnersTableReferences),
          Owner,
          PrefetchHooks Function({bool buildingsRefs})
        > {
  $$OwnersTableTableManager(_$AppDatabase db, $OwnersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OwnersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OwnersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OwnersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => OwnersCompanion(
                id: id,
                name: name,
                phone: phone,
                email: email,
                address: address,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => OwnersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                email: email,
                address: address,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$OwnersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({buildingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (buildingsRefs) db.buildings],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (buildingsRefs)
                    await $_getPrefetchedData<Owner, $OwnersTable, Building>(
                      currentTable: table,
                      referencedTable: $$OwnersTableReferences
                          ._buildingsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$OwnersTableReferences(db, table, p0).buildingsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.ownerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$OwnersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OwnersTable,
      Owner,
      $$OwnersTableFilterComposer,
      $$OwnersTableOrderingComposer,
      $$OwnersTableAnnotationComposer,
      $$OwnersTableCreateCompanionBuilder,
      $$OwnersTableUpdateCompanionBuilder,
      (Owner, $$OwnersTableReferences),
      Owner,
      PrefetchHooks Function({bool buildingsRefs})
    >;
typedef $$BuildingsTableCreateCompanionBuilder =
    BuildingsCompanion Function({
      Value<int> id,
      required int ownerId,
      required String name,
      Value<String?> address,
      Value<String?> notes,
    });
typedef $$BuildingsTableUpdateCompanionBuilder =
    BuildingsCompanion Function({
      Value<int> id,
      Value<int> ownerId,
      Value<String> name,
      Value<String?> address,
      Value<String?> notes,
    });

final class $$BuildingsTableReferences
    extends BaseReferences<_$AppDatabase, $BuildingsTable, Building> {
  $$BuildingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OwnersTable _ownerIdTable(_$AppDatabase db) => db.owners.createAlias(
    $_aliasNameGenerator(db.buildings.ownerId, db.owners.id),
  );

  $$OwnersTableProcessedTableManager get ownerId {
    final $_column = $_itemColumn<int>('owner_id')!;

    final manager = $$OwnersTableTableManager(
      $_db,
      $_db.owners,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ApartmentsTable, List<Apartment>>
  _apartmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.apartments,
    aliasName: $_aliasNameGenerator(db.buildings.id, db.apartments.buildingId),
  );

  $$ApartmentsTableProcessedTableManager get apartmentsRefs {
    final manager = $$ApartmentsTableTableManager(
      $_db,
      $_db.apartments,
    ).filter((f) => f.buildingId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_apartmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BuildingsTableFilterComposer
    extends Composer<_$AppDatabase, $BuildingsTable> {
  $$BuildingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$OwnersTableFilterComposer get ownerId {
    final $$OwnersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableFilterComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> apartmentsRefs(
    Expression<bool> Function($$ApartmentsTableFilterComposer f) f,
  ) {
    final $$ApartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.buildingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableFilterComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BuildingsTableOrderingComposer
    extends Composer<_$AppDatabase, $BuildingsTable> {
  $$BuildingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$OwnersTableOrderingComposer get ownerId {
    final $$OwnersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableOrderingComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BuildingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BuildingsTable> {
  $$BuildingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$OwnersTableAnnotationComposer get ownerId {
    final $$OwnersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableAnnotationComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> apartmentsRefs<T extends Object>(
    Expression<T> Function($$ApartmentsTableAnnotationComposer a) f,
  ) {
    final $$ApartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.buildingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BuildingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BuildingsTable,
          Building,
          $$BuildingsTableFilterComposer,
          $$BuildingsTableOrderingComposer,
          $$BuildingsTableAnnotationComposer,
          $$BuildingsTableCreateCompanionBuilder,
          $$BuildingsTableUpdateCompanionBuilder,
          (Building, $$BuildingsTableReferences),
          Building,
          PrefetchHooks Function({bool ownerId, bool apartmentsRefs})
        > {
  $$BuildingsTableTableManager(_$AppDatabase db, $BuildingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BuildingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BuildingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BuildingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => BuildingsCompanion(
                id: id,
                ownerId: ownerId,
                name: name,
                address: address,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerId,
                required String name,
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => BuildingsCompanion.insert(
                id: id,
                ownerId: ownerId,
                name: name,
                address: address,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BuildingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ownerId = false, apartmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (apartmentsRefs) db.apartments],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ownerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ownerId,
                                referencedTable: $$BuildingsTableReferences
                                    ._ownerIdTable(db),
                                referencedColumn: $$BuildingsTableReferences
                                    ._ownerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (apartmentsRefs)
                    await $_getPrefetchedData<
                      Building,
                      $BuildingsTable,
                      Apartment
                    >(
                      currentTable: table,
                      referencedTable: $$BuildingsTableReferences
                          ._apartmentsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BuildingsTableReferences(
                            db,
                            table,
                            p0,
                          ).apartmentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.buildingId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BuildingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BuildingsTable,
      Building,
      $$BuildingsTableFilterComposer,
      $$BuildingsTableOrderingComposer,
      $$BuildingsTableAnnotationComposer,
      $$BuildingsTableCreateCompanionBuilder,
      $$BuildingsTableUpdateCompanionBuilder,
      (Building, $$BuildingsTableReferences),
      Building,
      PrefetchHooks Function({bool ownerId, bool apartmentsRefs})
    >;
typedef $$ApartmentsTableCreateCompanionBuilder =
    ApartmentsCompanion Function({
      Value<int> id,
      required int buildingId,
      required String name,
      Value<String?> floor,
      Value<String?> description,
      Value<int> rent,
      Value<int> deposit,
      Value<bool> archived,
    });
typedef $$ApartmentsTableUpdateCompanionBuilder =
    ApartmentsCompanion Function({
      Value<int> id,
      Value<int> buildingId,
      Value<String> name,
      Value<String?> floor,
      Value<String?> description,
      Value<int> rent,
      Value<int> deposit,
      Value<bool> archived,
    });

final class $$ApartmentsTableReferences
    extends BaseReferences<_$AppDatabase, $ApartmentsTable, Apartment> {
  $$ApartmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BuildingsTable _buildingIdTable(_$AppDatabase db) =>
      db.buildings.createAlias(
        $_aliasNameGenerator(db.apartments.buildingId, db.buildings.id),
      );

  $$BuildingsTableProcessedTableManager get buildingId {
    final $_column = $_itemColumn<int>('building_id')!;

    final manager = $$BuildingsTableTableManager(
      $_db,
      $_db.buildings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_buildingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MetersTable, List<Meter>> _metersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.meters,
    aliasName: $_aliasNameGenerator(db.apartments.id, db.meters.apartmentId),
  );

  $$MetersTableProcessedTableManager get metersRefs {
    final manager = $$MetersTableTableManager(
      $_db,
      $_db.meters,
    ).filter((f) => f.apartmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_metersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ContractsTable, List<Contract>>
  _contractsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contracts,
    aliasName: $_aliasNameGenerator(db.apartments.id, db.contracts.apartmentId),
  );

  $$ContractsTableProcessedTableManager get contractsRefs {
    final manager = $$ContractsTableTableManager(
      $_db,
      $_db.contracts,
    ).filter((f) => f.apartmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_contractsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ApartmentsTableFilterComposer
    extends Composer<_$AppDatabase, $ApartmentsTable> {
  $$ApartmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get floor => $composableBuilder(
    column: $table.floor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rent => $composableBuilder(
    column: $table.rent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deposit => $composableBuilder(
    column: $table.deposit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  $$BuildingsTableFilterComposer get buildingId {
    final $$BuildingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.buildingId,
      referencedTable: $db.buildings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BuildingsTableFilterComposer(
            $db: $db,
            $table: $db.buildings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> metersRefs(
    Expression<bool> Function($$MetersTableFilterComposer f) f,
  ) {
    final $$MetersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meters,
      getReferencedColumn: (t) => t.apartmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetersTableFilterComposer(
            $db: $db,
            $table: $db.meters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> contractsRefs(
    Expression<bool> Function($$ContractsTableFilterComposer f) f,
  ) {
    final $$ContractsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.apartmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableFilterComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ApartmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ApartmentsTable> {
  $$ApartmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get floor => $composableBuilder(
    column: $table.floor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rent => $composableBuilder(
    column: $table.rent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deposit => $composableBuilder(
    column: $table.deposit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  $$BuildingsTableOrderingComposer get buildingId {
    final $$BuildingsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.buildingId,
      referencedTable: $db.buildings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BuildingsTableOrderingComposer(
            $db: $db,
            $table: $db.buildings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ApartmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ApartmentsTable> {
  $$ApartmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get floor =>
      $composableBuilder(column: $table.floor, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rent =>
      $composableBuilder(column: $table.rent, builder: (column) => column);

  GeneratedColumn<int> get deposit =>
      $composableBuilder(column: $table.deposit, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  $$BuildingsTableAnnotationComposer get buildingId {
    final $$BuildingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.buildingId,
      referencedTable: $db.buildings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BuildingsTableAnnotationComposer(
            $db: $db,
            $table: $db.buildings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> metersRefs<T extends Object>(
    Expression<T> Function($$MetersTableAnnotationComposer a) f,
  ) {
    final $$MetersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meters,
      getReferencedColumn: (t) => t.apartmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetersTableAnnotationComposer(
            $db: $db,
            $table: $db.meters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> contractsRefs<T extends Object>(
    Expression<T> Function($$ContractsTableAnnotationComposer a) f,
  ) {
    final $$ContractsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.apartmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableAnnotationComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ApartmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ApartmentsTable,
          Apartment,
          $$ApartmentsTableFilterComposer,
          $$ApartmentsTableOrderingComposer,
          $$ApartmentsTableAnnotationComposer,
          $$ApartmentsTableCreateCompanionBuilder,
          $$ApartmentsTableUpdateCompanionBuilder,
          (Apartment, $$ApartmentsTableReferences),
          Apartment,
          PrefetchHooks Function({
            bool buildingId,
            bool metersRefs,
            bool contractsRefs,
          })
        > {
  $$ApartmentsTableTableManager(_$AppDatabase db, $ApartmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ApartmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ApartmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ApartmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> buildingId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> floor = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rent = const Value.absent(),
                Value<int> deposit = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => ApartmentsCompanion(
                id: id,
                buildingId: buildingId,
                name: name,
                floor: floor,
                description: description,
                rent: rent,
                deposit: deposit,
                archived: archived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int buildingId,
                required String name,
                Value<String?> floor = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rent = const Value.absent(),
                Value<int> deposit = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => ApartmentsCompanion.insert(
                id: id,
                buildingId: buildingId,
                name: name,
                floor: floor,
                description: description,
                rent: rent,
                deposit: deposit,
                archived: archived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ApartmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                buildingId = false,
                metersRefs = false,
                contractsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (metersRefs) db.meters,
                    if (contractsRefs) db.contracts,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (buildingId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.buildingId,
                                    referencedTable: $$ApartmentsTableReferences
                                        ._buildingIdTable(db),
                                    referencedColumn:
                                        $$ApartmentsTableReferences
                                            ._buildingIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (metersRefs)
                        await $_getPrefetchedData<
                          Apartment,
                          $ApartmentsTable,
                          Meter
                        >(
                          currentTable: table,
                          referencedTable: $$ApartmentsTableReferences
                              ._metersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ApartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).metersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.apartmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (contractsRefs)
                        await $_getPrefetchedData<
                          Apartment,
                          $ApartmentsTable,
                          Contract
                        >(
                          currentTable: table,
                          referencedTable: $$ApartmentsTableReferences
                              ._contractsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ApartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).contractsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.apartmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ApartmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ApartmentsTable,
      Apartment,
      $$ApartmentsTableFilterComposer,
      $$ApartmentsTableOrderingComposer,
      $$ApartmentsTableAnnotationComposer,
      $$ApartmentsTableCreateCompanionBuilder,
      $$ApartmentsTableUpdateCompanionBuilder,
      (Apartment, $$ApartmentsTableReferences),
      Apartment,
      PrefetchHooks Function({
        bool buildingId,
        bool metersRefs,
        bool contractsRefs,
      })
    >;
typedef $$TenantsTableCreateCompanionBuilder =
    TenantsCompanion Function({
      Value<int> id,
      required String fullName,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> idNumber,
      Value<String?> emergencyContact,
      Value<String?> language,
      Value<String?> notes,
    });
typedef $$TenantsTableUpdateCompanionBuilder =
    TenantsCompanion Function({
      Value<int> id,
      Value<String> fullName,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> idNumber,
      Value<String?> emergencyContact,
      Value<String?> language,
      Value<String?> notes,
    });

final class $$TenantsTableReferences
    extends BaseReferences<_$AppDatabase, $TenantsTable, Tenant> {
  $$TenantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ContractsTable, List<Contract>>
  _contractsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contracts,
    aliasName: $_aliasNameGenerator(db.tenants.id, db.contracts.tenantId),
  );

  $$ContractsTableProcessedTableManager get contractsRefs {
    final manager = $$ContractsTableTableManager(
      $_db,
      $_db.contracts,
    ).filter((f) => f.tenantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_contractsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TenantsTableFilterComposer
    extends Composer<_$AppDatabase, $TenantsTable> {
  $$TenantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idNumber => $composableBuilder(
    column: $table.idNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emergencyContact => $composableBuilder(
    column: $table.emergencyContact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> contractsRefs(
    Expression<bool> Function($$ContractsTableFilterComposer f) f,
  ) {
    final $$ContractsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.tenantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableFilterComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TenantsTableOrderingComposer
    extends Composer<_$AppDatabase, $TenantsTable> {
  $$TenantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idNumber => $composableBuilder(
    column: $table.idNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emergencyContact => $composableBuilder(
    column: $table.emergencyContact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TenantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TenantsTable> {
  $$TenantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get idNumber =>
      $composableBuilder(column: $table.idNumber, builder: (column) => column);

  GeneratedColumn<String> get emergencyContact => $composableBuilder(
    column: $table.emergencyContact,
    builder: (column) => column,
  );

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> contractsRefs<T extends Object>(
    Expression<T> Function($$ContractsTableAnnotationComposer a) f,
  ) {
    final $$ContractsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.tenantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableAnnotationComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TenantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TenantsTable,
          Tenant,
          $$TenantsTableFilterComposer,
          $$TenantsTableOrderingComposer,
          $$TenantsTableAnnotationComposer,
          $$TenantsTableCreateCompanionBuilder,
          $$TenantsTableUpdateCompanionBuilder,
          (Tenant, $$TenantsTableReferences),
          Tenant,
          PrefetchHooks Function({bool contractsRefs})
        > {
  $$TenantsTableTableManager(_$AppDatabase db, $TenantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TenantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TenantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TenantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> idNumber = const Value.absent(),
                Value<String?> emergencyContact = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => TenantsCompanion(
                id: id,
                fullName: fullName,
                phone: phone,
                email: email,
                idNumber: idNumber,
                emergencyContact: emergencyContact,
                language: language,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String fullName,
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> idNumber = const Value.absent(),
                Value<String?> emergencyContact = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => TenantsCompanion.insert(
                id: id,
                fullName: fullName,
                phone: phone,
                email: email,
                idNumber: idNumber,
                emergencyContact: emergencyContact,
                language: language,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TenantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contractsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (contractsRefs) db.contracts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (contractsRefs)
                    await $_getPrefetchedData<Tenant, $TenantsTable, Contract>(
                      currentTable: table,
                      referencedTable: $$TenantsTableReferences
                          ._contractsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TenantsTableReferences(db, table, p0).contractsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tenantId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TenantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TenantsTable,
      Tenant,
      $$TenantsTableFilterComposer,
      $$TenantsTableOrderingComposer,
      $$TenantsTableAnnotationComposer,
      $$TenantsTableCreateCompanionBuilder,
      $$TenantsTableUpdateCompanionBuilder,
      (Tenant, $$TenantsTableReferences),
      Tenant,
      PrefetchHooks Function({bool contractsRefs})
    >;
typedef $$UtilityTypesTableCreateCompanionBuilder =
    UtilityTypesCompanion Function({
      Value<int> id,
      required String name,
      required String unit,
      required int unitPrice,
      Value<int> fixedFee,
      Value<double> vatRate,
      Value<int> vatMode,
      Value<bool> vatOnFixedFee,
      Value<String> iconKey,
      Value<String?> translations,
      Value<int> colorValue,
      Value<bool> active,
    });
typedef $$UtilityTypesTableUpdateCompanionBuilder =
    UtilityTypesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> unit,
      Value<int> unitPrice,
      Value<int> fixedFee,
      Value<double> vatRate,
      Value<int> vatMode,
      Value<bool> vatOnFixedFee,
      Value<String> iconKey,
      Value<String?> translations,
      Value<int> colorValue,
      Value<bool> active,
    });

final class $$UtilityTypesTableReferences
    extends BaseReferences<_$AppDatabase, $UtilityTypesTable, UtilityType> {
  $$UtilityTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MetersTable, List<Meter>> _metersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.meters,
    aliasName: $_aliasNameGenerator(
      db.utilityTypes.id,
      db.meters.utilityTypeId,
    ),
  );

  $$MetersTableProcessedTableManager get metersRefs {
    final manager = $$MetersTableTableManager(
      $_db,
      $_db.meters,
    ).filter((f) => f.utilityTypeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_metersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ContractBenefitsTable, List<ContractBenefit>>
  _contractBenefitsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contractBenefits,
    aliasName: $_aliasNameGenerator(
      db.utilityTypes.id,
      db.contractBenefits.utilityTypeId,
    ),
  );

  $$ContractBenefitsTableProcessedTableManager get contractBenefitsRefs {
    final manager = $$ContractBenefitsTableTableManager(
      $_db,
      $_db.contractBenefits,
    ).filter((f) => f.utilityTypeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _contractBenefitsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UtilityTypesTableFilterComposer
    extends Composer<_$AppDatabase, $UtilityTypesTable> {
  $$UtilityTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fixedFee => $composableBuilder(
    column: $table.fixedFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get vatRate => $composableBuilder(
    column: $table.vatRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vatMode => $composableBuilder(
    column: $table.vatMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get vatOnFixedFee => $composableBuilder(
    column: $table.vatOnFixedFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translations => $composableBuilder(
    column: $table.translations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> metersRefs(
    Expression<bool> Function($$MetersTableFilterComposer f) f,
  ) {
    final $$MetersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meters,
      getReferencedColumn: (t) => t.utilityTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetersTableFilterComposer(
            $db: $db,
            $table: $db.meters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> contractBenefitsRefs(
    Expression<bool> Function($$ContractBenefitsTableFilterComposer f) f,
  ) {
    final $$ContractBenefitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contractBenefits,
      getReferencedColumn: (t) => t.utilityTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractBenefitsTableFilterComposer(
            $db: $db,
            $table: $db.contractBenefits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UtilityTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $UtilityTypesTable> {
  $$UtilityTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fixedFee => $composableBuilder(
    column: $table.fixedFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get vatRate => $composableBuilder(
    column: $table.vatRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vatMode => $composableBuilder(
    column: $table.vatMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get vatOnFixedFee => $composableBuilder(
    column: $table.vatOnFixedFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translations => $composableBuilder(
    column: $table.translations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UtilityTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UtilityTypesTable> {
  $$UtilityTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<int> get fixedFee =>
      $composableBuilder(column: $table.fixedFee, builder: (column) => column);

  GeneratedColumn<double> get vatRate =>
      $composableBuilder(column: $table.vatRate, builder: (column) => column);

  GeneratedColumn<int> get vatMode =>
      $composableBuilder(column: $table.vatMode, builder: (column) => column);

  GeneratedColumn<bool> get vatOnFixedFee => $composableBuilder(
    column: $table.vatOnFixedFee,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<String> get translations => $composableBuilder(
    column: $table.translations,
    builder: (column) => column,
  );

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  Expression<T> metersRefs<T extends Object>(
    Expression<T> Function($$MetersTableAnnotationComposer a) f,
  ) {
    final $$MetersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meters,
      getReferencedColumn: (t) => t.utilityTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetersTableAnnotationComposer(
            $db: $db,
            $table: $db.meters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> contractBenefitsRefs<T extends Object>(
    Expression<T> Function($$ContractBenefitsTableAnnotationComposer a) f,
  ) {
    final $$ContractBenefitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contractBenefits,
      getReferencedColumn: (t) => t.utilityTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractBenefitsTableAnnotationComposer(
            $db: $db,
            $table: $db.contractBenefits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UtilityTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UtilityTypesTable,
          UtilityType,
          $$UtilityTypesTableFilterComposer,
          $$UtilityTypesTableOrderingComposer,
          $$UtilityTypesTableAnnotationComposer,
          $$UtilityTypesTableCreateCompanionBuilder,
          $$UtilityTypesTableUpdateCompanionBuilder,
          (UtilityType, $$UtilityTypesTableReferences),
          UtilityType,
          PrefetchHooks Function({bool metersRefs, bool contractBenefitsRefs})
        > {
  $$UtilityTypesTableTableManager(_$AppDatabase db, $UtilityTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UtilityTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UtilityTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UtilityTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> unitPrice = const Value.absent(),
                Value<int> fixedFee = const Value.absent(),
                Value<double> vatRate = const Value.absent(),
                Value<int> vatMode = const Value.absent(),
                Value<bool> vatOnFixedFee = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<String?> translations = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => UtilityTypesCompanion(
                id: id,
                name: name,
                unit: unit,
                unitPrice: unitPrice,
                fixedFee: fixedFee,
                vatRate: vatRate,
                vatMode: vatMode,
                vatOnFixedFee: vatOnFixedFee,
                iconKey: iconKey,
                translations: translations,
                colorValue: colorValue,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String unit,
                required int unitPrice,
                Value<int> fixedFee = const Value.absent(),
                Value<double> vatRate = const Value.absent(),
                Value<int> vatMode = const Value.absent(),
                Value<bool> vatOnFixedFee = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<String?> translations = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => UtilityTypesCompanion.insert(
                id: id,
                name: name,
                unit: unit,
                unitPrice: unitPrice,
                fixedFee: fixedFee,
                vatRate: vatRate,
                vatMode: vatMode,
                vatOnFixedFee: vatOnFixedFee,
                iconKey: iconKey,
                translations: translations,
                colorValue: colorValue,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UtilityTypesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({metersRefs = false, contractBenefitsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (metersRefs) db.meters,
                    if (contractBenefitsRefs) db.contractBenefits,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (metersRefs)
                        await $_getPrefetchedData<
                          UtilityType,
                          $UtilityTypesTable,
                          Meter
                        >(
                          currentTable: table,
                          referencedTable: $$UtilityTypesTableReferences
                              ._metersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UtilityTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).metersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.utilityTypeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (contractBenefitsRefs)
                        await $_getPrefetchedData<
                          UtilityType,
                          $UtilityTypesTable,
                          ContractBenefit
                        >(
                          currentTable: table,
                          referencedTable: $$UtilityTypesTableReferences
                              ._contractBenefitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UtilityTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).contractBenefitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.utilityTypeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UtilityTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UtilityTypesTable,
      UtilityType,
      $$UtilityTypesTableFilterComposer,
      $$UtilityTypesTableOrderingComposer,
      $$UtilityTypesTableAnnotationComposer,
      $$UtilityTypesTableCreateCompanionBuilder,
      $$UtilityTypesTableUpdateCompanionBuilder,
      (UtilityType, $$UtilityTypesTableReferences),
      UtilityType,
      PrefetchHooks Function({bool metersRefs, bool contractBenefitsRefs})
    >;
typedef $$MetersTableCreateCompanionBuilder =
    MetersCompanion Function({
      Value<int> id,
      required int apartmentId,
      required int utilityTypeId,
      Value<String?> serial,
      Value<double> initialIndex,
      Value<bool> active,
    });
typedef $$MetersTableUpdateCompanionBuilder =
    MetersCompanion Function({
      Value<int> id,
      Value<int> apartmentId,
      Value<int> utilityTypeId,
      Value<String?> serial,
      Value<double> initialIndex,
      Value<bool> active,
    });

final class $$MetersTableReferences
    extends BaseReferences<_$AppDatabase, $MetersTable, Meter> {
  $$MetersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ApartmentsTable _apartmentIdTable(_$AppDatabase db) =>
      db.apartments.createAlias(
        $_aliasNameGenerator(db.meters.apartmentId, db.apartments.id),
      );

  $$ApartmentsTableProcessedTableManager get apartmentId {
    final $_column = $_itemColumn<int>('apartment_id')!;

    final manager = $$ApartmentsTableTableManager(
      $_db,
      $_db.apartments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_apartmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UtilityTypesTable _utilityTypeIdTable(_$AppDatabase db) =>
      db.utilityTypes.createAlias(
        $_aliasNameGenerator(db.meters.utilityTypeId, db.utilityTypes.id),
      );

  $$UtilityTypesTableProcessedTableManager get utilityTypeId {
    final $_column = $_itemColumn<int>('utility_type_id')!;

    final manager = $$UtilityTypesTableTableManager(
      $_db,
      $_db.utilityTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_utilityTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReadingsTable, List<Reading>> _readingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.readings,
    aliasName: $_aliasNameGenerator(db.meters.id, db.readings.meterId),
  );

  $$ReadingsTableProcessedTableManager get readingsRefs {
    final manager = $$ReadingsTableTableManager(
      $_db,
      $_db.readings,
    ).filter((f) => f.meterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_readingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MetersTableFilterComposer
    extends Composer<_$AppDatabase, $MetersTable> {
  $$MetersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serial => $composableBuilder(
    column: $table.serial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get initialIndex => $composableBuilder(
    column: $table.initialIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  $$ApartmentsTableFilterComposer get apartmentId {
    final $$ApartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableFilterComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UtilityTypesTableFilterComposer get utilityTypeId {
    final $$UtilityTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.utilityTypeId,
      referencedTable: $db.utilityTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UtilityTypesTableFilterComposer(
            $db: $db,
            $table: $db.utilityTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> readingsRefs(
    Expression<bool> Function($$ReadingsTableFilterComposer f) f,
  ) {
    final $$ReadingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.meterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableFilterComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MetersTableOrderingComposer
    extends Composer<_$AppDatabase, $MetersTable> {
  $$MetersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serial => $composableBuilder(
    column: $table.serial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get initialIndex => $composableBuilder(
    column: $table.initialIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  $$ApartmentsTableOrderingComposer get apartmentId {
    final $$ApartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UtilityTypesTableOrderingComposer get utilityTypeId {
    final $$UtilityTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.utilityTypeId,
      referencedTable: $db.utilityTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UtilityTypesTableOrderingComposer(
            $db: $db,
            $table: $db.utilityTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MetersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetersTable> {
  $$MetersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serial =>
      $composableBuilder(column: $table.serial, builder: (column) => column);

  GeneratedColumn<double> get initialIndex => $composableBuilder(
    column: $table.initialIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  $$ApartmentsTableAnnotationComposer get apartmentId {
    final $$ApartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UtilityTypesTableAnnotationComposer get utilityTypeId {
    final $$UtilityTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.utilityTypeId,
      referencedTable: $db.utilityTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UtilityTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.utilityTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> readingsRefs<T extends Object>(
    Expression<T> Function($$ReadingsTableAnnotationComposer a) f,
  ) {
    final $$ReadingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.meterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableAnnotationComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MetersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MetersTable,
          Meter,
          $$MetersTableFilterComposer,
          $$MetersTableOrderingComposer,
          $$MetersTableAnnotationComposer,
          $$MetersTableCreateCompanionBuilder,
          $$MetersTableUpdateCompanionBuilder,
          (Meter, $$MetersTableReferences),
          Meter,
          PrefetchHooks Function({
            bool apartmentId,
            bool utilityTypeId,
            bool readingsRefs,
          })
        > {
  $$MetersTableTableManager(_$AppDatabase db, $MetersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> apartmentId = const Value.absent(),
                Value<int> utilityTypeId = const Value.absent(),
                Value<String?> serial = const Value.absent(),
                Value<double> initialIndex = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => MetersCompanion(
                id: id,
                apartmentId: apartmentId,
                utilityTypeId: utilityTypeId,
                serial: serial,
                initialIndex: initialIndex,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int apartmentId,
                required int utilityTypeId,
                Value<String?> serial = const Value.absent(),
                Value<double> initialIndex = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => MetersCompanion.insert(
                id: id,
                apartmentId: apartmentId,
                utilityTypeId: utilityTypeId,
                serial: serial,
                initialIndex: initialIndex,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MetersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                apartmentId = false,
                utilityTypeId = false,
                readingsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (readingsRefs) db.readings],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (apartmentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.apartmentId,
                                    referencedTable: $$MetersTableReferences
                                        ._apartmentIdTable(db),
                                    referencedColumn: $$MetersTableReferences
                                        ._apartmentIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (utilityTypeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.utilityTypeId,
                                    referencedTable: $$MetersTableReferences
                                        ._utilityTypeIdTable(db),
                                    referencedColumn: $$MetersTableReferences
                                        ._utilityTypeIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (readingsRefs)
                        await $_getPrefetchedData<Meter, $MetersTable, Reading>(
                          currentTable: table,
                          referencedTable: $$MetersTableReferences
                              ._readingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MetersTableReferences(
                                db,
                                table,
                                p0,
                              ).readingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.meterId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MetersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MetersTable,
      Meter,
      $$MetersTableFilterComposer,
      $$MetersTableOrderingComposer,
      $$MetersTableAnnotationComposer,
      $$MetersTableCreateCompanionBuilder,
      $$MetersTableUpdateCompanionBuilder,
      (Meter, $$MetersTableReferences),
      Meter,
      PrefetchHooks Function({
        bool apartmentId,
        bool utilityTypeId,
        bool readingsRefs,
      })
    >;
typedef $$ServiceTypesTableCreateCompanionBuilder =
    ServiceTypesCompanion Function({
      Value<int> id,
      required String name,
      required int unitPrice,
      Value<String> unitLabel,
      Value<String?> translations,
      Value<bool> active,
    });
typedef $$ServiceTypesTableUpdateCompanionBuilder =
    ServiceTypesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> unitPrice,
      Value<String> unitLabel,
      Value<String?> translations,
      Value<bool> active,
    });

final class $$ServiceTypesTableReferences
    extends BaseReferences<_$AppDatabase, $ServiceTypesTable, ServiceType> {
  $$ServiceTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ContractServicesTable, List<ContractService>>
  _contractServicesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contractServices,
    aliasName: $_aliasNameGenerator(
      db.serviceTypes.id,
      db.contractServices.serviceTypeId,
    ),
  );

  $$ContractServicesTableProcessedTableManager get contractServicesRefs {
    final manager = $$ContractServicesTableTableManager(
      $_db,
      $_db.contractServices,
    ).filter((f) => f.serviceTypeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _contractServicesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ContractBenefitsTable, List<ContractBenefit>>
  _contractBenefitsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contractBenefits,
    aliasName: $_aliasNameGenerator(
      db.serviceTypes.id,
      db.contractBenefits.serviceTypeId,
    ),
  );

  $$ContractBenefitsTableProcessedTableManager get contractBenefitsRefs {
    final manager = $$ContractBenefitsTableTableManager(
      $_db,
      $_db.contractBenefits,
    ).filter((f) => f.serviceTypeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _contractBenefitsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServiceTypesTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceTypesTable> {
  $$ServiceTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitLabel => $composableBuilder(
    column: $table.unitLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translations => $composableBuilder(
    column: $table.translations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> contractServicesRefs(
    Expression<bool> Function($$ContractServicesTableFilterComposer f) f,
  ) {
    final $$ContractServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contractServices,
      getReferencedColumn: (t) => t.serviceTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractServicesTableFilterComposer(
            $db: $db,
            $table: $db.contractServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> contractBenefitsRefs(
    Expression<bool> Function($$ContractBenefitsTableFilterComposer f) f,
  ) {
    final $$ContractBenefitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contractBenefits,
      getReferencedColumn: (t) => t.serviceTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractBenefitsTableFilterComposer(
            $db: $db,
            $table: $db.contractBenefits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceTypesTable> {
  $$ServiceTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitLabel => $composableBuilder(
    column: $table.unitLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translations => $composableBuilder(
    column: $table.translations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServiceTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceTypesTable> {
  $$ServiceTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<String> get unitLabel =>
      $composableBuilder(column: $table.unitLabel, builder: (column) => column);

  GeneratedColumn<String> get translations => $composableBuilder(
    column: $table.translations,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  Expression<T> contractServicesRefs<T extends Object>(
    Expression<T> Function($$ContractServicesTableAnnotationComposer a) f,
  ) {
    final $$ContractServicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contractServices,
      getReferencedColumn: (t) => t.serviceTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractServicesTableAnnotationComposer(
            $db: $db,
            $table: $db.contractServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> contractBenefitsRefs<T extends Object>(
    Expression<T> Function($$ContractBenefitsTableAnnotationComposer a) f,
  ) {
    final $$ContractBenefitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contractBenefits,
      getReferencedColumn: (t) => t.serviceTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractBenefitsTableAnnotationComposer(
            $db: $db,
            $table: $db.contractBenefits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiceTypesTable,
          ServiceType,
          $$ServiceTypesTableFilterComposer,
          $$ServiceTypesTableOrderingComposer,
          $$ServiceTypesTableAnnotationComposer,
          $$ServiceTypesTableCreateCompanionBuilder,
          $$ServiceTypesTableUpdateCompanionBuilder,
          (ServiceType, $$ServiceTypesTableReferences),
          ServiceType,
          PrefetchHooks Function({
            bool contractServicesRefs,
            bool contractBenefitsRefs,
          })
        > {
  $$ServiceTypesTableTableManager(_$AppDatabase db, $ServiceTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> unitPrice = const Value.absent(),
                Value<String> unitLabel = const Value.absent(),
                Value<String?> translations = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => ServiceTypesCompanion(
                id: id,
                name: name,
                unitPrice: unitPrice,
                unitLabel: unitLabel,
                translations: translations,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int unitPrice,
                Value<String> unitLabel = const Value.absent(),
                Value<String?> translations = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => ServiceTypesCompanion.insert(
                id: id,
                name: name,
                unitPrice: unitPrice,
                unitLabel: unitLabel,
                translations: translations,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServiceTypesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({contractServicesRefs = false, contractBenefitsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (contractServicesRefs) db.contractServices,
                    if (contractBenefitsRefs) db.contractBenefits,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (contractServicesRefs)
                        await $_getPrefetchedData<
                          ServiceType,
                          $ServiceTypesTable,
                          ContractService
                        >(
                          currentTable: table,
                          referencedTable: $$ServiceTypesTableReferences
                              ._contractServicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServiceTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).contractServicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.serviceTypeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (contractBenefitsRefs)
                        await $_getPrefetchedData<
                          ServiceType,
                          $ServiceTypesTable,
                          ContractBenefit
                        >(
                          currentTable: table,
                          referencedTable: $$ServiceTypesTableReferences
                              ._contractBenefitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServiceTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).contractBenefitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.serviceTypeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ServiceTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiceTypesTable,
      ServiceType,
      $$ServiceTypesTableFilterComposer,
      $$ServiceTypesTableOrderingComposer,
      $$ServiceTypesTableAnnotationComposer,
      $$ServiceTypesTableCreateCompanionBuilder,
      $$ServiceTypesTableUpdateCompanionBuilder,
      (ServiceType, $$ServiceTypesTableReferences),
      ServiceType,
      PrefetchHooks Function({
        bool contractServicesRefs,
        bool contractBenefitsRefs,
      })
    >;
typedef $$ContractsTableCreateCompanionBuilder =
    ContractsCompanion Function({
      Value<int> id,
      required int apartmentId,
      required int tenantId,
      required DateTime startDate,
      Value<DateTime?> plannedEndDate,
      Value<bool> tacitRenewal,
      required int rent,
      Value<int> deposit,
      Value<int> depositPaid,
      Value<bool> entryProrata,
      Value<int> status,
      Value<DateTime?> exitDate,
      Value<bool?> exitProrata,
      Value<int> damagesAmount,
      Value<String?> exitNotes,
      Value<String?> notes,
    });
typedef $$ContractsTableUpdateCompanionBuilder =
    ContractsCompanion Function({
      Value<int> id,
      Value<int> apartmentId,
      Value<int> tenantId,
      Value<DateTime> startDate,
      Value<DateTime?> plannedEndDate,
      Value<bool> tacitRenewal,
      Value<int> rent,
      Value<int> deposit,
      Value<int> depositPaid,
      Value<bool> entryProrata,
      Value<int> status,
      Value<DateTime?> exitDate,
      Value<bool?> exitProrata,
      Value<int> damagesAmount,
      Value<String?> exitNotes,
      Value<String?> notes,
    });

final class $$ContractsTableReferences
    extends BaseReferences<_$AppDatabase, $ContractsTable, Contract> {
  $$ContractsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ApartmentsTable _apartmentIdTable(_$AppDatabase db) =>
      db.apartments.createAlias(
        $_aliasNameGenerator(db.contracts.apartmentId, db.apartments.id),
      );

  $$ApartmentsTableProcessedTableManager get apartmentId {
    final $_column = $_itemColumn<int>('apartment_id')!;

    final manager = $$ApartmentsTableTableManager(
      $_db,
      $_db.apartments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_apartmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TenantsTable _tenantIdTable(_$AppDatabase db) => db.tenants
      .createAlias($_aliasNameGenerator(db.contracts.tenantId, db.tenants.id));

  $$TenantsTableProcessedTableManager get tenantId {
    final $_column = $_itemColumn<int>('tenant_id')!;

    final manager = $$TenantsTableTableManager(
      $_db,
      $_db.tenants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tenantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ContractServicesTable, List<ContractService>>
  _contractServicesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contractServices,
    aliasName: $_aliasNameGenerator(
      db.contracts.id,
      db.contractServices.contractId,
    ),
  );

  $$ContractServicesTableProcessedTableManager get contractServicesRefs {
    final manager = $$ContractServicesTableTableManager(
      $_db,
      $_db.contractServices,
    ).filter((f) => f.contractId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _contractServicesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ContractBenefitsTable, List<ContractBenefit>>
  _contractBenefitsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contractBenefits,
    aliasName: $_aliasNameGenerator(
      db.contracts.id,
      db.contractBenefits.contractId,
    ),
  );

  $$ContractBenefitsTableProcessedTableManager get contractBenefitsRefs {
    final manager = $$ContractBenefitsTableTableManager(
      $_db,
      $_db.contractBenefits,
    ).filter((f) => f.contractId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _contractBenefitsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReadingsTable, List<Reading>> _readingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.readings,
    aliasName: $_aliasNameGenerator(db.contracts.id, db.readings.contractId),
  );

  $$ReadingsTableProcessedTableManager get readingsRefs {
    final manager = $$ReadingsTableTableManager(
      $_db,
      $_db.readings,
    ).filter((f) => f.contractId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_readingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InvoicesTable, List<Invoice>> _invoicesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.invoices,
    aliasName: $_aliasNameGenerator(db.contracts.id, db.invoices.contractId),
  );

  $$InvoicesTableProcessedTableManager get invoicesRefs {
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.contractId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: $_aliasNameGenerator(db.contracts.id, db.payments.contractId),
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.contractId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InspectionsTable, List<Inspection>>
  _inspectionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inspections,
    aliasName: $_aliasNameGenerator(db.contracts.id, db.inspections.contractId),
  );

  $$InspectionsTableProcessedTableManager get inspectionsRefs {
    final manager = $$InspectionsTableTableManager(
      $_db,
      $_db.inspections,
    ).filter((f) => f.contractId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_inspectionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ContractsTableFilterComposer
    extends Composer<_$AppDatabase, $ContractsTable> {
  $$ContractsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get plannedEndDate => $composableBuilder(
    column: $table.plannedEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get tacitRenewal => $composableBuilder(
    column: $table.tacitRenewal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rent => $composableBuilder(
    column: $table.rent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deposit => $composableBuilder(
    column: $table.deposit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get depositPaid => $composableBuilder(
    column: $table.depositPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get entryProrata => $composableBuilder(
    column: $table.entryProrata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get exitDate => $composableBuilder(
    column: $table.exitDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get exitProrata => $composableBuilder(
    column: $table.exitProrata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get damagesAmount => $composableBuilder(
    column: $table.damagesAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exitNotes => $composableBuilder(
    column: $table.exitNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$ApartmentsTableFilterComposer get apartmentId {
    final $$ApartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableFilterComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TenantsTableFilterComposer get tenantId {
    final $$TenantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableFilterComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> contractServicesRefs(
    Expression<bool> Function($$ContractServicesTableFilterComposer f) f,
  ) {
    final $$ContractServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contractServices,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractServicesTableFilterComposer(
            $db: $db,
            $table: $db.contractServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> contractBenefitsRefs(
    Expression<bool> Function($$ContractBenefitsTableFilterComposer f) f,
  ) {
    final $$ContractBenefitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contractBenefits,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractBenefitsTableFilterComposer(
            $db: $db,
            $table: $db.contractBenefits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readingsRefs(
    Expression<bool> Function($$ReadingsTableFilterComposer f) f,
  ) {
    final $$ReadingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableFilterComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> invoicesRefs(
    Expression<bool> Function($$InvoicesTableFilterComposer f) f,
  ) {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inspectionsRefs(
    Expression<bool> Function($$InspectionsTableFilterComposer f) f,
  ) {
    final $$InspectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableFilterComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContractsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContractsTable> {
  $$ContractsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get plannedEndDate => $composableBuilder(
    column: $table.plannedEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get tacitRenewal => $composableBuilder(
    column: $table.tacitRenewal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rent => $composableBuilder(
    column: $table.rent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deposit => $composableBuilder(
    column: $table.deposit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get depositPaid => $composableBuilder(
    column: $table.depositPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get entryProrata => $composableBuilder(
    column: $table.entryProrata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get exitDate => $composableBuilder(
    column: $table.exitDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get exitProrata => $composableBuilder(
    column: $table.exitProrata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get damagesAmount => $composableBuilder(
    column: $table.damagesAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exitNotes => $composableBuilder(
    column: $table.exitNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ApartmentsTableOrderingComposer get apartmentId {
    final $$ApartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TenantsTableOrderingComposer get tenantId {
    final $$TenantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableOrderingComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContractsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContractsTable> {
  $$ContractsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get plannedEndDate => $composableBuilder(
    column: $table.plannedEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get tacitRenewal => $composableBuilder(
    column: $table.tacitRenewal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rent =>
      $composableBuilder(column: $table.rent, builder: (column) => column);

  GeneratedColumn<int> get deposit =>
      $composableBuilder(column: $table.deposit, builder: (column) => column);

  GeneratedColumn<int> get depositPaid => $composableBuilder(
    column: $table.depositPaid,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get entryProrata => $composableBuilder(
    column: $table.entryProrata,
    builder: (column) => column,
  );

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get exitDate =>
      $composableBuilder(column: $table.exitDate, builder: (column) => column);

  GeneratedColumn<bool> get exitProrata => $composableBuilder(
    column: $table.exitProrata,
    builder: (column) => column,
  );

  GeneratedColumn<int> get damagesAmount => $composableBuilder(
    column: $table.damagesAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exitNotes =>
      $composableBuilder(column: $table.exitNotes, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$ApartmentsTableAnnotationComposer get apartmentId {
    final $$ApartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.apartmentId,
      referencedTable: $db.apartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.apartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TenantsTableAnnotationComposer get tenantId {
    final $$TenantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableAnnotationComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> contractServicesRefs<T extends Object>(
    Expression<T> Function($$ContractServicesTableAnnotationComposer a) f,
  ) {
    final $$ContractServicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contractServices,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractServicesTableAnnotationComposer(
            $db: $db,
            $table: $db.contractServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> contractBenefitsRefs<T extends Object>(
    Expression<T> Function($$ContractBenefitsTableAnnotationComposer a) f,
  ) {
    final $$ContractBenefitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contractBenefits,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractBenefitsTableAnnotationComposer(
            $db: $db,
            $table: $db.contractBenefits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> readingsRefs<T extends Object>(
    Expression<T> Function($$ReadingsTableAnnotationComposer a) f,
  ) {
    final $$ReadingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableAnnotationComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> invoicesRefs<T extends Object>(
    Expression<T> Function($$InvoicesTableAnnotationComposer a) f,
  ) {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> inspectionsRefs<T extends Object>(
    Expression<T> Function($$InspectionsTableAnnotationComposer a) f,
  ) {
    final $$InspectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.contractId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContractsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContractsTable,
          Contract,
          $$ContractsTableFilterComposer,
          $$ContractsTableOrderingComposer,
          $$ContractsTableAnnotationComposer,
          $$ContractsTableCreateCompanionBuilder,
          $$ContractsTableUpdateCompanionBuilder,
          (Contract, $$ContractsTableReferences),
          Contract,
          PrefetchHooks Function({
            bool apartmentId,
            bool tenantId,
            bool contractServicesRefs,
            bool contractBenefitsRefs,
            bool readingsRefs,
            bool invoicesRefs,
            bool paymentsRefs,
            bool inspectionsRefs,
          })
        > {
  $$ContractsTableTableManager(_$AppDatabase db, $ContractsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContractsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContractsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContractsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> apartmentId = const Value.absent(),
                Value<int> tenantId = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> plannedEndDate = const Value.absent(),
                Value<bool> tacitRenewal = const Value.absent(),
                Value<int> rent = const Value.absent(),
                Value<int> deposit = const Value.absent(),
                Value<int> depositPaid = const Value.absent(),
                Value<bool> entryProrata = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<DateTime?> exitDate = const Value.absent(),
                Value<bool?> exitProrata = const Value.absent(),
                Value<int> damagesAmount = const Value.absent(),
                Value<String?> exitNotes = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ContractsCompanion(
                id: id,
                apartmentId: apartmentId,
                tenantId: tenantId,
                startDate: startDate,
                plannedEndDate: plannedEndDate,
                tacitRenewal: tacitRenewal,
                rent: rent,
                deposit: deposit,
                depositPaid: depositPaid,
                entryProrata: entryProrata,
                status: status,
                exitDate: exitDate,
                exitProrata: exitProrata,
                damagesAmount: damagesAmount,
                exitNotes: exitNotes,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int apartmentId,
                required int tenantId,
                required DateTime startDate,
                Value<DateTime?> plannedEndDate = const Value.absent(),
                Value<bool> tacitRenewal = const Value.absent(),
                required int rent,
                Value<int> deposit = const Value.absent(),
                Value<int> depositPaid = const Value.absent(),
                Value<bool> entryProrata = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<DateTime?> exitDate = const Value.absent(),
                Value<bool?> exitProrata = const Value.absent(),
                Value<int> damagesAmount = const Value.absent(),
                Value<String?> exitNotes = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ContractsCompanion.insert(
                id: id,
                apartmentId: apartmentId,
                tenantId: tenantId,
                startDate: startDate,
                plannedEndDate: plannedEndDate,
                tacitRenewal: tacitRenewal,
                rent: rent,
                deposit: deposit,
                depositPaid: depositPaid,
                entryProrata: entryProrata,
                status: status,
                exitDate: exitDate,
                exitProrata: exitProrata,
                damagesAmount: damagesAmount,
                exitNotes: exitNotes,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContractsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                apartmentId = false,
                tenantId = false,
                contractServicesRefs = false,
                contractBenefitsRefs = false,
                readingsRefs = false,
                invoicesRefs = false,
                paymentsRefs = false,
                inspectionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (contractServicesRefs) db.contractServices,
                    if (contractBenefitsRefs) db.contractBenefits,
                    if (readingsRefs) db.readings,
                    if (invoicesRefs) db.invoices,
                    if (paymentsRefs) db.payments,
                    if (inspectionsRefs) db.inspections,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (apartmentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.apartmentId,
                                    referencedTable: $$ContractsTableReferences
                                        ._apartmentIdTable(db),
                                    referencedColumn: $$ContractsTableReferences
                                        ._apartmentIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (tenantId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tenantId,
                                    referencedTable: $$ContractsTableReferences
                                        ._tenantIdTable(db),
                                    referencedColumn: $$ContractsTableReferences
                                        ._tenantIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (contractServicesRefs)
                        await $_getPrefetchedData<
                          Contract,
                          $ContractsTable,
                          ContractService
                        >(
                          currentTable: table,
                          referencedTable: $$ContractsTableReferences
                              ._contractServicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContractsTableReferences(
                                db,
                                table,
                                p0,
                              ).contractServicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contractId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (contractBenefitsRefs)
                        await $_getPrefetchedData<
                          Contract,
                          $ContractsTable,
                          ContractBenefit
                        >(
                          currentTable: table,
                          referencedTable: $$ContractsTableReferences
                              ._contractBenefitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContractsTableReferences(
                                db,
                                table,
                                p0,
                              ).contractBenefitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contractId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (readingsRefs)
                        await $_getPrefetchedData<
                          Contract,
                          $ContractsTable,
                          Reading
                        >(
                          currentTable: table,
                          referencedTable: $$ContractsTableReferences
                              ._readingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContractsTableReferences(
                                db,
                                table,
                                p0,
                              ).readingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contractId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (invoicesRefs)
                        await $_getPrefetchedData<
                          Contract,
                          $ContractsTable,
                          Invoice
                        >(
                          currentTable: table,
                          referencedTable: $$ContractsTableReferences
                              ._invoicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContractsTableReferences(
                                db,
                                table,
                                p0,
                              ).invoicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contractId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentsRefs)
                        await $_getPrefetchedData<
                          Contract,
                          $ContractsTable,
                          Payment
                        >(
                          currentTable: table,
                          referencedTable: $$ContractsTableReferences
                              ._paymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContractsTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contractId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (inspectionsRefs)
                        await $_getPrefetchedData<
                          Contract,
                          $ContractsTable,
                          Inspection
                        >(
                          currentTable: table,
                          referencedTable: $$ContractsTableReferences
                              ._inspectionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContractsTableReferences(
                                db,
                                table,
                                p0,
                              ).inspectionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contractId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ContractsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContractsTable,
      Contract,
      $$ContractsTableFilterComposer,
      $$ContractsTableOrderingComposer,
      $$ContractsTableAnnotationComposer,
      $$ContractsTableCreateCompanionBuilder,
      $$ContractsTableUpdateCompanionBuilder,
      (Contract, $$ContractsTableReferences),
      Contract,
      PrefetchHooks Function({
        bool apartmentId,
        bool tenantId,
        bool contractServicesRefs,
        bool contractBenefitsRefs,
        bool readingsRefs,
        bool invoicesRefs,
        bool paymentsRefs,
        bool inspectionsRefs,
      })
    >;
typedef $$ContractServicesTableCreateCompanionBuilder =
    ContractServicesCompanion Function({
      Value<int> id,
      required int contractId,
      required int serviceTypeId,
      Value<int> quantity,
      Value<int> includedQuantity,
      required int unitPrice,
    });
typedef $$ContractServicesTableUpdateCompanionBuilder =
    ContractServicesCompanion Function({
      Value<int> id,
      Value<int> contractId,
      Value<int> serviceTypeId,
      Value<int> quantity,
      Value<int> includedQuantity,
      Value<int> unitPrice,
    });

final class $$ContractServicesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ContractServicesTable, ContractService> {
  $$ContractServicesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContractsTable _contractIdTable(_$AppDatabase db) =>
      db.contracts.createAlias(
        $_aliasNameGenerator(db.contractServices.contractId, db.contracts.id),
      );

  $$ContractsTableProcessedTableManager get contractId {
    final $_column = $_itemColumn<int>('contract_id')!;

    final manager = $$ContractsTableTableManager(
      $_db,
      $_db.contracts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contractIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ServiceTypesTable _serviceTypeIdTable(_$AppDatabase db) =>
      db.serviceTypes.createAlias(
        $_aliasNameGenerator(
          db.contractServices.serviceTypeId,
          db.serviceTypes.id,
        ),
      );

  $$ServiceTypesTableProcessedTableManager get serviceTypeId {
    final $_column = $_itemColumn<int>('service_type_id')!;

    final manager = $$ServiceTypesTableTableManager(
      $_db,
      $_db.serviceTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serviceTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ContractServicesTableFilterComposer
    extends Composer<_$AppDatabase, $ContractServicesTable> {
  $$ContractServicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get includedQuantity => $composableBuilder(
    column: $table.includedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  $$ContractsTableFilterComposer get contractId {
    final $$ContractsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableFilterComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceTypesTableFilterComposer get serviceTypeId {
    final $$ServiceTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceTypeId,
      referencedTable: $db.serviceTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceTypesTableFilterComposer(
            $db: $db,
            $table: $db.serviceTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContractServicesTableOrderingComposer
    extends Composer<_$AppDatabase, $ContractServicesTable> {
  $$ContractServicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get includedQuantity => $composableBuilder(
    column: $table.includedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContractsTableOrderingComposer get contractId {
    final $$ContractsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableOrderingComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceTypesTableOrderingComposer get serviceTypeId {
    final $$ServiceTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceTypeId,
      referencedTable: $db.serviceTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceTypesTableOrderingComposer(
            $db: $db,
            $table: $db.serviceTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContractServicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContractServicesTable> {
  $$ContractServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get includedQuantity => $composableBuilder(
    column: $table.includedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  $$ContractsTableAnnotationComposer get contractId {
    final $$ContractsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableAnnotationComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceTypesTableAnnotationComposer get serviceTypeId {
    final $$ServiceTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceTypeId,
      referencedTable: $db.serviceTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContractServicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContractServicesTable,
          ContractService,
          $$ContractServicesTableFilterComposer,
          $$ContractServicesTableOrderingComposer,
          $$ContractServicesTableAnnotationComposer,
          $$ContractServicesTableCreateCompanionBuilder,
          $$ContractServicesTableUpdateCompanionBuilder,
          (ContractService, $$ContractServicesTableReferences),
          ContractService,
          PrefetchHooks Function({bool contractId, bool serviceTypeId})
        > {
  $$ContractServicesTableTableManager(
    _$AppDatabase db,
    $ContractServicesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContractServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContractServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContractServicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> contractId = const Value.absent(),
                Value<int> serviceTypeId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> includedQuantity = const Value.absent(),
                Value<int> unitPrice = const Value.absent(),
              }) => ContractServicesCompanion(
                id: id,
                contractId: contractId,
                serviceTypeId: serviceTypeId,
                quantity: quantity,
                includedQuantity: includedQuantity,
                unitPrice: unitPrice,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int contractId,
                required int serviceTypeId,
                Value<int> quantity = const Value.absent(),
                Value<int> includedQuantity = const Value.absent(),
                required int unitPrice,
              }) => ContractServicesCompanion.insert(
                id: id,
                contractId: contractId,
                serviceTypeId: serviceTypeId,
                quantity: quantity,
                includedQuantity: includedQuantity,
                unitPrice: unitPrice,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContractServicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contractId = false, serviceTypeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (contractId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.contractId,
                                referencedTable:
                                    $$ContractServicesTableReferences
                                        ._contractIdTable(db),
                                referencedColumn:
                                    $$ContractServicesTableReferences
                                        ._contractIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (serviceTypeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.serviceTypeId,
                                referencedTable:
                                    $$ContractServicesTableReferences
                                        ._serviceTypeIdTable(db),
                                referencedColumn:
                                    $$ContractServicesTableReferences
                                        ._serviceTypeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ContractServicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContractServicesTable,
      ContractService,
      $$ContractServicesTableFilterComposer,
      $$ContractServicesTableOrderingComposer,
      $$ContractServicesTableAnnotationComposer,
      $$ContractServicesTableCreateCompanionBuilder,
      $$ContractServicesTableUpdateCompanionBuilder,
      (ContractService, $$ContractServicesTableReferences),
      ContractService,
      PrefetchHooks Function({bool contractId, bool serviceTypeId})
    >;
typedef $$ContractBenefitsTableCreateCompanionBuilder =
    ContractBenefitsCompanion Function({
      Value<int> id,
      required int contractId,
      Value<int?> utilityTypeId,
      Value<int?> serviceTypeId,
      Value<int> mode,
      Value<double> value,
      Value<int> amount,
      Value<String?> reason,
      Value<int?> fromPeriod,
      Value<int?> toPeriod,
    });
typedef $$ContractBenefitsTableUpdateCompanionBuilder =
    ContractBenefitsCompanion Function({
      Value<int> id,
      Value<int> contractId,
      Value<int?> utilityTypeId,
      Value<int?> serviceTypeId,
      Value<int> mode,
      Value<double> value,
      Value<int> amount,
      Value<String?> reason,
      Value<int?> fromPeriod,
      Value<int?> toPeriod,
    });

final class $$ContractBenefitsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ContractBenefitsTable, ContractBenefit> {
  $$ContractBenefitsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContractsTable _contractIdTable(_$AppDatabase db) =>
      db.contracts.createAlias(
        $_aliasNameGenerator(db.contractBenefits.contractId, db.contracts.id),
      );

  $$ContractsTableProcessedTableManager get contractId {
    final $_column = $_itemColumn<int>('contract_id')!;

    final manager = $$ContractsTableTableManager(
      $_db,
      $_db.contracts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contractIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UtilityTypesTable _utilityTypeIdTable(_$AppDatabase db) =>
      db.utilityTypes.createAlias(
        $_aliasNameGenerator(
          db.contractBenefits.utilityTypeId,
          db.utilityTypes.id,
        ),
      );

  $$UtilityTypesTableProcessedTableManager? get utilityTypeId {
    final $_column = $_itemColumn<int>('utility_type_id');
    if ($_column == null) return null;
    final manager = $$UtilityTypesTableTableManager(
      $_db,
      $_db.utilityTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_utilityTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ServiceTypesTable _serviceTypeIdTable(_$AppDatabase db) =>
      db.serviceTypes.createAlias(
        $_aliasNameGenerator(
          db.contractBenefits.serviceTypeId,
          db.serviceTypes.id,
        ),
      );

  $$ServiceTypesTableProcessedTableManager? get serviceTypeId {
    final $_column = $_itemColumn<int>('service_type_id');
    if ($_column == null) return null;
    final manager = $$ServiceTypesTableTableManager(
      $_db,
      $_db.serviceTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serviceTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ContractBenefitsTableFilterComposer
    extends Composer<_$AppDatabase, $ContractBenefitsTable> {
  $$ContractBenefitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fromPeriod => $composableBuilder(
    column: $table.fromPeriod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toPeriod => $composableBuilder(
    column: $table.toPeriod,
    builder: (column) => ColumnFilters(column),
  );

  $$ContractsTableFilterComposer get contractId {
    final $$ContractsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableFilterComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UtilityTypesTableFilterComposer get utilityTypeId {
    final $$UtilityTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.utilityTypeId,
      referencedTable: $db.utilityTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UtilityTypesTableFilterComposer(
            $db: $db,
            $table: $db.utilityTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceTypesTableFilterComposer get serviceTypeId {
    final $$ServiceTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceTypeId,
      referencedTable: $db.serviceTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceTypesTableFilterComposer(
            $db: $db,
            $table: $db.serviceTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContractBenefitsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContractBenefitsTable> {
  $$ContractBenefitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fromPeriod => $composableBuilder(
    column: $table.fromPeriod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toPeriod => $composableBuilder(
    column: $table.toPeriod,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContractsTableOrderingComposer get contractId {
    final $$ContractsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableOrderingComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UtilityTypesTableOrderingComposer get utilityTypeId {
    final $$UtilityTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.utilityTypeId,
      referencedTable: $db.utilityTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UtilityTypesTableOrderingComposer(
            $db: $db,
            $table: $db.utilityTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceTypesTableOrderingComposer get serviceTypeId {
    final $$ServiceTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceTypeId,
      referencedTable: $db.serviceTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceTypesTableOrderingComposer(
            $db: $db,
            $table: $db.serviceTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContractBenefitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContractBenefitsTable> {
  $$ContractBenefitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<int> get fromPeriod => $composableBuilder(
    column: $table.fromPeriod,
    builder: (column) => column,
  );

  GeneratedColumn<int> get toPeriod =>
      $composableBuilder(column: $table.toPeriod, builder: (column) => column);

  $$ContractsTableAnnotationComposer get contractId {
    final $$ContractsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableAnnotationComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UtilityTypesTableAnnotationComposer get utilityTypeId {
    final $$UtilityTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.utilityTypeId,
      referencedTable: $db.utilityTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UtilityTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.utilityTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceTypesTableAnnotationComposer get serviceTypeId {
    final $$ServiceTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceTypeId,
      referencedTable: $db.serviceTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContractBenefitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContractBenefitsTable,
          ContractBenefit,
          $$ContractBenefitsTableFilterComposer,
          $$ContractBenefitsTableOrderingComposer,
          $$ContractBenefitsTableAnnotationComposer,
          $$ContractBenefitsTableCreateCompanionBuilder,
          $$ContractBenefitsTableUpdateCompanionBuilder,
          (ContractBenefit, $$ContractBenefitsTableReferences),
          ContractBenefit,
          PrefetchHooks Function({
            bool contractId,
            bool utilityTypeId,
            bool serviceTypeId,
          })
        > {
  $$ContractBenefitsTableTableManager(
    _$AppDatabase db,
    $ContractBenefitsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContractBenefitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContractBenefitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContractBenefitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> contractId = const Value.absent(),
                Value<int?> utilityTypeId = const Value.absent(),
                Value<int?> serviceTypeId = const Value.absent(),
                Value<int> mode = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<int?> fromPeriod = const Value.absent(),
                Value<int?> toPeriod = const Value.absent(),
              }) => ContractBenefitsCompanion(
                id: id,
                contractId: contractId,
                utilityTypeId: utilityTypeId,
                serviceTypeId: serviceTypeId,
                mode: mode,
                value: value,
                amount: amount,
                reason: reason,
                fromPeriod: fromPeriod,
                toPeriod: toPeriod,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int contractId,
                Value<int?> utilityTypeId = const Value.absent(),
                Value<int?> serviceTypeId = const Value.absent(),
                Value<int> mode = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<int?> fromPeriod = const Value.absent(),
                Value<int?> toPeriod = const Value.absent(),
              }) => ContractBenefitsCompanion.insert(
                id: id,
                contractId: contractId,
                utilityTypeId: utilityTypeId,
                serviceTypeId: serviceTypeId,
                mode: mode,
                value: value,
                amount: amount,
                reason: reason,
                fromPeriod: fromPeriod,
                toPeriod: toPeriod,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContractBenefitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                contractId = false,
                utilityTypeId = false,
                serviceTypeId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (contractId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.contractId,
                                    referencedTable:
                                        $$ContractBenefitsTableReferences
                                            ._contractIdTable(db),
                                    referencedColumn:
                                        $$ContractBenefitsTableReferences
                                            ._contractIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (utilityTypeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.utilityTypeId,
                                    referencedTable:
                                        $$ContractBenefitsTableReferences
                                            ._utilityTypeIdTable(db),
                                    referencedColumn:
                                        $$ContractBenefitsTableReferences
                                            ._utilityTypeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (serviceTypeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.serviceTypeId,
                                    referencedTable:
                                        $$ContractBenefitsTableReferences
                                            ._serviceTypeIdTable(db),
                                    referencedColumn:
                                        $$ContractBenefitsTableReferences
                                            ._serviceTypeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ContractBenefitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContractBenefitsTable,
      ContractBenefit,
      $$ContractBenefitsTableFilterComposer,
      $$ContractBenefitsTableOrderingComposer,
      $$ContractBenefitsTableAnnotationComposer,
      $$ContractBenefitsTableCreateCompanionBuilder,
      $$ContractBenefitsTableUpdateCompanionBuilder,
      (ContractBenefit, $$ContractBenefitsTableReferences),
      ContractBenefit,
      PrefetchHooks Function({
        bool contractId,
        bool utilityTypeId,
        bool serviceTypeId,
      })
    >;
typedef $$ReadingsTableCreateCompanionBuilder =
    ReadingsCompanion Function({
      Value<int> id,
      required int meterId,
      Value<int?> contractId,
      Value<int?> period,
      Value<int> kind,
      required DateTime date,
      required double value,
      Value<String?> photoPath,
      Value<String?> note,
    });
typedef $$ReadingsTableUpdateCompanionBuilder =
    ReadingsCompanion Function({
      Value<int> id,
      Value<int> meterId,
      Value<int?> contractId,
      Value<int?> period,
      Value<int> kind,
      Value<DateTime> date,
      Value<double> value,
      Value<String?> photoPath,
      Value<String?> note,
    });

final class $$ReadingsTableReferences
    extends BaseReferences<_$AppDatabase, $ReadingsTable, Reading> {
  $$ReadingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MetersTable _meterIdTable(_$AppDatabase db) => db.meters.createAlias(
    $_aliasNameGenerator(db.readings.meterId, db.meters.id),
  );

  $$MetersTableProcessedTableManager get meterId {
    final $_column = $_itemColumn<int>('meter_id')!;

    final manager = $$MetersTableTableManager(
      $_db,
      $_db.meters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_meterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ContractsTable _contractIdTable(_$AppDatabase db) =>
      db.contracts.createAlias(
        $_aliasNameGenerator(db.readings.contractId, db.contracts.id),
      );

  $$ContractsTableProcessedTableManager? get contractId {
    final $_column = $_itemColumn<int>('contract_id');
    if ($_column == null) return null;
    final manager = $$ContractsTableTableManager(
      $_db,
      $_db.contracts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contractIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$MetersTableFilterComposer get meterId {
    final $$MetersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meterId,
      referencedTable: $db.meters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetersTableFilterComposer(
            $db: $db,
            $table: $db.meters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ContractsTableFilterComposer get contractId {
    final $$ContractsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableFilterComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$MetersTableOrderingComposer get meterId {
    final $$MetersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meterId,
      referencedTable: $db.meters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetersTableOrderingComposer(
            $db: $db,
            $table: $db.meters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ContractsTableOrderingComposer get contractId {
    final $$ContractsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableOrderingComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$MetersTableAnnotationComposer get meterId {
    final $$MetersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meterId,
      referencedTable: $db.meters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetersTableAnnotationComposer(
            $db: $db,
            $table: $db.meters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ContractsTableAnnotationComposer get contractId {
    final $$ContractsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableAnnotationComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingsTable,
          Reading,
          $$ReadingsTableFilterComposer,
          $$ReadingsTableOrderingComposer,
          $$ReadingsTableAnnotationComposer,
          $$ReadingsTableCreateCompanionBuilder,
          $$ReadingsTableUpdateCompanionBuilder,
          (Reading, $$ReadingsTableReferences),
          Reading,
          PrefetchHooks Function({bool meterId, bool contractId})
        > {
  $$ReadingsTableTableManager(_$AppDatabase db, $ReadingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> meterId = const Value.absent(),
                Value<int?> contractId = const Value.absent(),
                Value<int?> period = const Value.absent(),
                Value<int> kind = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => ReadingsCompanion(
                id: id,
                meterId: meterId,
                contractId: contractId,
                period: period,
                kind: kind,
                date: date,
                value: value,
                photoPath: photoPath,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int meterId,
                Value<int?> contractId = const Value.absent(),
                Value<int?> period = const Value.absent(),
                Value<int> kind = const Value.absent(),
                required DateTime date,
                required double value,
                Value<String?> photoPath = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => ReadingsCompanion.insert(
                id: id,
                meterId: meterId,
                contractId: contractId,
                period: period,
                kind: kind,
                date: date,
                value: value,
                photoPath: photoPath,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReadingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({meterId = false, contractId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (meterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.meterId,
                                referencedTable: $$ReadingsTableReferences
                                    ._meterIdTable(db),
                                referencedColumn: $$ReadingsTableReferences
                                    ._meterIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (contractId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.contractId,
                                referencedTable: $$ReadingsTableReferences
                                    ._contractIdTable(db),
                                referencedColumn: $$ReadingsTableReferences
                                    ._contractIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReadingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingsTable,
      Reading,
      $$ReadingsTableFilterComposer,
      $$ReadingsTableOrderingComposer,
      $$ReadingsTableAnnotationComposer,
      $$ReadingsTableCreateCompanionBuilder,
      $$ReadingsTableUpdateCompanionBuilder,
      (Reading, $$ReadingsTableReferences),
      Reading,
      PrefetchHooks Function({bool meterId, bool contractId})
    >;
typedef $$InvoicesTableCreateCompanionBuilder =
    InvoicesCompanion Function({
      Value<int> id,
      required String number,
      required int contractId,
      required int period,
      Value<int> kind,
      required DateTime issueDate,
      required DateTime dueDate,
      required int total,
      Value<String?> notes,
    });
typedef $$InvoicesTableUpdateCompanionBuilder =
    InvoicesCompanion Function({
      Value<int> id,
      Value<String> number,
      Value<int> contractId,
      Value<int> period,
      Value<int> kind,
      Value<DateTime> issueDate,
      Value<DateTime> dueDate,
      Value<int> total,
      Value<String?> notes,
    });

final class $$InvoicesTableReferences
    extends BaseReferences<_$AppDatabase, $InvoicesTable, Invoice> {
  $$InvoicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContractsTable _contractIdTable(_$AppDatabase db) =>
      db.contracts.createAlias(
        $_aliasNameGenerator(db.invoices.contractId, db.contracts.id),
      );

  $$ContractsTableProcessedTableManager get contractId {
    final $_column = $_itemColumn<int>('contract_id')!;

    final manager = $$ContractsTableTableManager(
      $_db,
      $_db.contracts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contractIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InvoiceLinesTable, List<InvoiceLine>>
  _invoiceLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoiceLines,
    aliasName: $_aliasNameGenerator(db.invoices.id, db.invoiceLines.invoiceId),
  );

  $$InvoiceLinesTableProcessedTableManager get invoiceLinesRefs {
    final manager = $$InvoiceLinesTableTableManager(
      $_db,
      $_db.invoiceLines,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoiceLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get issueDate => $composableBuilder(
    column: $table.issueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$ContractsTableFilterComposer get contractId {
    final $$ContractsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableFilterComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> invoiceLinesRefs(
    Expression<bool> Function($$InvoiceLinesTableFilterComposer f) f,
  ) {
    final $$InvoiceLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceLines,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceLinesTableFilterComposer(
            $db: $db,
            $table: $db.invoiceLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get issueDate => $composableBuilder(
    column: $table.issueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContractsTableOrderingComposer get contractId {
    final $$ContractsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableOrderingComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<int> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get issueDate =>
      $composableBuilder(column: $table.issueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$ContractsTableAnnotationComposer get contractId {
    final $$ContractsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableAnnotationComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> invoiceLinesRefs<T extends Object>(
    Expression<T> Function($$InvoiceLinesTableAnnotationComposer a) f,
  ) {
    final $$InvoiceLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceLines,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoiceLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicesTable,
          Invoice,
          $$InvoicesTableFilterComposer,
          $$InvoicesTableOrderingComposer,
          $$InvoicesTableAnnotationComposer,
          $$InvoicesTableCreateCompanionBuilder,
          $$InvoicesTableUpdateCompanionBuilder,
          (Invoice, $$InvoicesTableReferences),
          Invoice,
          PrefetchHooks Function({bool contractId, bool invoiceLinesRefs})
        > {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> number = const Value.absent(),
                Value<int> contractId = const Value.absent(),
                Value<int> period = const Value.absent(),
                Value<int> kind = const Value.absent(),
                Value<DateTime> issueDate = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                number: number,
                contractId: contractId,
                period: period,
                kind: kind,
                issueDate: issueDate,
                dueDate: dueDate,
                total: total,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String number,
                required int contractId,
                required int period,
                Value<int> kind = const Value.absent(),
                required DateTime issueDate,
                required DateTime dueDate,
                required int total,
                Value<String?> notes = const Value.absent(),
              }) => InvoicesCompanion.insert(
                id: id,
                number: number,
                contractId: contractId,
                period: period,
                kind: kind,
                issueDate: issueDate,
                dueDate: dueDate,
                total: total,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({contractId = false, invoiceLinesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoiceLinesRefs) db.invoiceLines,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (contractId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.contractId,
                                    referencedTable: $$InvoicesTableReferences
                                        ._contractIdTable(db),
                                    referencedColumn: $$InvoicesTableReferences
                                        ._contractIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (invoiceLinesRefs)
                        await $_getPrefetchedData<
                          Invoice,
                          $InvoicesTable,
                          InvoiceLine
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._invoiceLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicesTable,
      Invoice,
      $$InvoicesTableFilterComposer,
      $$InvoicesTableOrderingComposer,
      $$InvoicesTableAnnotationComposer,
      $$InvoicesTableCreateCompanionBuilder,
      $$InvoicesTableUpdateCompanionBuilder,
      (Invoice, $$InvoicesTableReferences),
      Invoice,
      PrefetchHooks Function({bool contractId, bool invoiceLinesRefs})
    >;
typedef $$InvoiceLinesTableCreateCompanionBuilder =
    InvoiceLinesCompanion Function({
      Value<int> id,
      required int invoiceId,
      Value<int> position,
      required int kind,
      required String label,
      Value<String?> details,
      Value<double> quantity,
      Value<String?> unit,
      Value<int> unitPrice,
      required int ht,
      Value<int> vat,
      required int ttc,
      Value<int?> meterId,
      Value<int?> utilityTypeId,
      Value<double?> startIndex,
      Value<double?> endIndex,
      Value<String?> meta,
    });
typedef $$InvoiceLinesTableUpdateCompanionBuilder =
    InvoiceLinesCompanion Function({
      Value<int> id,
      Value<int> invoiceId,
      Value<int> position,
      Value<int> kind,
      Value<String> label,
      Value<String?> details,
      Value<double> quantity,
      Value<String?> unit,
      Value<int> unitPrice,
      Value<int> ht,
      Value<int> vat,
      Value<int> ttc,
      Value<int?> meterId,
      Value<int?> utilityTypeId,
      Value<double?> startIndex,
      Value<double?> endIndex,
      Value<String?> meta,
    });

final class $$InvoiceLinesTableReferences
    extends BaseReferences<_$AppDatabase, $InvoiceLinesTable, InvoiceLine> {
  $$InvoiceLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias(
        $_aliasNameGenerator(db.invoiceLines.invoiceId, db.invoices.id),
      );

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<int>('invoice_id')!;

    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InvoiceLinesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoiceLinesTable> {
  $$InvoiceLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ht => $composableBuilder(
    column: $table.ht,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vat => $composableBuilder(
    column: $table.vat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ttc => $composableBuilder(
    column: $table.ttc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get meterId => $composableBuilder(
    column: $table.meterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get utilityTypeId => $composableBuilder(
    column: $table.utilityTypeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startIndex => $composableBuilder(
    column: $table.startIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get endIndex => $composableBuilder(
    column: $table.endIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meta => $composableBuilder(
    column: $table.meta,
    builder: (column) => ColumnFilters(column),
  );

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoiceLinesTable> {
  $$InvoiceLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ht => $composableBuilder(
    column: $table.ht,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vat => $composableBuilder(
    column: $table.vat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ttc => $composableBuilder(
    column: $table.ttc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get meterId => $composableBuilder(
    column: $table.meterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get utilityTypeId => $composableBuilder(
    column: $table.utilityTypeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startIndex => $composableBuilder(
    column: $table.startIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get endIndex => $composableBuilder(
    column: $table.endIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meta => $composableBuilder(
    column: $table.meta,
    builder: (column) => ColumnOrderings(column),
  );

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoiceLinesTable> {
  $$InvoiceLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<int> get ht =>
      $composableBuilder(column: $table.ht, builder: (column) => column);

  GeneratedColumn<int> get vat =>
      $composableBuilder(column: $table.vat, builder: (column) => column);

  GeneratedColumn<int> get ttc =>
      $composableBuilder(column: $table.ttc, builder: (column) => column);

  GeneratedColumn<int> get meterId =>
      $composableBuilder(column: $table.meterId, builder: (column) => column);

  GeneratedColumn<int> get utilityTypeId => $composableBuilder(
    column: $table.utilityTypeId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get startIndex => $composableBuilder(
    column: $table.startIndex,
    builder: (column) => column,
  );

  GeneratedColumn<double> get endIndex =>
      $composableBuilder(column: $table.endIndex, builder: (column) => column);

  GeneratedColumn<String> get meta =>
      $composableBuilder(column: $table.meta, builder: (column) => column);

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoiceLinesTable,
          InvoiceLine,
          $$InvoiceLinesTableFilterComposer,
          $$InvoiceLinesTableOrderingComposer,
          $$InvoiceLinesTableAnnotationComposer,
          $$InvoiceLinesTableCreateCompanionBuilder,
          $$InvoiceLinesTableUpdateCompanionBuilder,
          (InvoiceLine, $$InvoiceLinesTableReferences),
          InvoiceLine,
          PrefetchHooks Function({bool invoiceId})
        > {
  $$InvoiceLinesTableTableManager(_$AppDatabase db, $InvoiceLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> invoiceId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> kind = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<int> unitPrice = const Value.absent(),
                Value<int> ht = const Value.absent(),
                Value<int> vat = const Value.absent(),
                Value<int> ttc = const Value.absent(),
                Value<int?> meterId = const Value.absent(),
                Value<int?> utilityTypeId = const Value.absent(),
                Value<double?> startIndex = const Value.absent(),
                Value<double?> endIndex = const Value.absent(),
                Value<String?> meta = const Value.absent(),
              }) => InvoiceLinesCompanion(
                id: id,
                invoiceId: invoiceId,
                position: position,
                kind: kind,
                label: label,
                details: details,
                quantity: quantity,
                unit: unit,
                unitPrice: unitPrice,
                ht: ht,
                vat: vat,
                ttc: ttc,
                meterId: meterId,
                utilityTypeId: utilityTypeId,
                startIndex: startIndex,
                endIndex: endIndex,
                meta: meta,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int invoiceId,
                Value<int> position = const Value.absent(),
                required int kind,
                required String label,
                Value<String?> details = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<int> unitPrice = const Value.absent(),
                required int ht,
                Value<int> vat = const Value.absent(),
                required int ttc,
                Value<int?> meterId = const Value.absent(),
                Value<int?> utilityTypeId = const Value.absent(),
                Value<double?> startIndex = const Value.absent(),
                Value<double?> endIndex = const Value.absent(),
                Value<String?> meta = const Value.absent(),
              }) => InvoiceLinesCompanion.insert(
                id: id,
                invoiceId: invoiceId,
                position: position,
                kind: kind,
                label: label,
                details: details,
                quantity: quantity,
                unit: unit,
                unitPrice: unitPrice,
                ht: ht,
                vat: vat,
                ttc: ttc,
                meterId: meterId,
                utilityTypeId: utilityTypeId,
                startIndex: startIndex,
                endIndex: endIndex,
                meta: meta,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoiceLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({invoiceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (invoiceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.invoiceId,
                                referencedTable: $$InvoiceLinesTableReferences
                                    ._invoiceIdTable(db),
                                referencedColumn: $$InvoiceLinesTableReferences
                                    ._invoiceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InvoiceLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoiceLinesTable,
      InvoiceLine,
      $$InvoiceLinesTableFilterComposer,
      $$InvoiceLinesTableOrderingComposer,
      $$InvoiceLinesTableAnnotationComposer,
      $$InvoiceLinesTableCreateCompanionBuilder,
      $$InvoiceLinesTableUpdateCompanionBuilder,
      (InvoiceLine, $$InvoiceLinesTableReferences),
      InvoiceLine,
      PrefetchHooks Function({bool invoiceId})
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      required int contractId,
      required DateTime date,
      required int amount,
      Value<int> kind,
      Value<String> method,
      Value<String?> reference,
      Value<String?> note,
      required String receiptNumber,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      Value<int> contractId,
      Value<DateTime> date,
      Value<int> amount,
      Value<int> kind,
      Value<String> method,
      Value<String?> reference,
      Value<String?> note,
      Value<String> receiptNumber,
    });

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContractsTable _contractIdTable(_$AppDatabase db) =>
      db.contracts.createAlias(
        $_aliasNameGenerator(db.payments.contractId, db.contracts.id),
      );

  $$ContractsTableProcessedTableManager get contractId {
    final $_column = $_itemColumn<int>('contract_id')!;

    final manager = $$ContractsTableTableManager(
      $_db,
      $_db.contracts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contractIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnFilters(column),
  );

  $$ContractsTableFilterComposer get contractId {
    final $$ContractsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableFilterComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContractsTableOrderingComposer get contractId {
    final $$ContractsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableOrderingComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => column,
  );

  $$ContractsTableAnnotationComposer get contractId {
    final $$ContractsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableAnnotationComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, $$PaymentsTableReferences),
          Payment,
          PrefetchHooks Function({bool contractId})
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> contractId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<int> kind = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> receiptNumber = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                contractId: contractId,
                date: date,
                amount: amount,
                kind: kind,
                method: method,
                reference: reference,
                note: note,
                receiptNumber: receiptNumber,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int contractId,
                required DateTime date,
                required int amount,
                Value<int> kind = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required String receiptNumber,
              }) => PaymentsCompanion.insert(
                id: id,
                contractId: contractId,
                date: date,
                amount: amount,
                kind: kind,
                method: method,
                reference: reference,
                note: note,
                receiptNumber: receiptNumber,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contractId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (contractId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.contractId,
                                referencedTable: $$PaymentsTableReferences
                                    ._contractIdTable(db),
                                referencedColumn: $$PaymentsTableReferences
                                    ._contractIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, $$PaymentsTableReferences),
      Payment,
      PrefetchHooks Function({bool contractId})
    >;
typedef $$InspectionsTableCreateCompanionBuilder =
    InspectionsCompanion Function({
      Value<int> id,
      required int contractId,
      required int kind,
      required DateTime date,
      Value<String?> notes,
    });
typedef $$InspectionsTableUpdateCompanionBuilder =
    InspectionsCompanion Function({
      Value<int> id,
      Value<int> contractId,
      Value<int> kind,
      Value<DateTime> date,
      Value<String?> notes,
    });

final class $$InspectionsTableReferences
    extends BaseReferences<_$AppDatabase, $InspectionsTable, Inspection> {
  $$InspectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContractsTable _contractIdTable(_$AppDatabase db) =>
      db.contracts.createAlias(
        $_aliasNameGenerator(db.inspections.contractId, db.contracts.id),
      );

  $$ContractsTableProcessedTableManager get contractId {
    final $_column = $_itemColumn<int>('contract_id')!;

    final manager = $$ContractsTableTableManager(
      $_db,
      $_db.contracts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contractIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InspectionItemsTable, List<InspectionItem>>
  _inspectionItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inspectionItems,
    aliasName: $_aliasNameGenerator(
      db.inspections.id,
      db.inspectionItems.inspectionId,
    ),
  );

  $$InspectionItemsTableProcessedTableManager get inspectionItemsRefs {
    final manager = $$InspectionItemsTableTableManager(
      $_db,
      $_db.inspectionItems,
    ).filter((f) => f.inspectionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inspectionItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InspectionsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$ContractsTableFilterComposer get contractId {
    final $$ContractsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableFilterComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> inspectionItemsRefs(
    Expression<bool> Function($$InspectionItemsTableFilterComposer f) f,
  ) {
    final $$InspectionItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspectionItems,
      getReferencedColumn: (t) => t.inspectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionItemsTableFilterComposer(
            $db: $db,
            $table: $db.inspectionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InspectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContractsTableOrderingComposer get contractId {
    final $$ContractsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableOrderingComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$ContractsTableAnnotationComposer get contractId {
    final $$ContractsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contractId,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableAnnotationComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> inspectionItemsRefs<T extends Object>(
    Expression<T> Function($$InspectionItemsTableAnnotationComposer a) f,
  ) {
    final $$InspectionItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspectionItems,
      getReferencedColumn: (t) => t.inspectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.inspectionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InspectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionsTable,
          Inspection,
          $$InspectionsTableFilterComposer,
          $$InspectionsTableOrderingComposer,
          $$InspectionsTableAnnotationComposer,
          $$InspectionsTableCreateCompanionBuilder,
          $$InspectionsTableUpdateCompanionBuilder,
          (Inspection, $$InspectionsTableReferences),
          Inspection,
          PrefetchHooks Function({bool contractId, bool inspectionItemsRefs})
        > {
  $$InspectionsTableTableManager(_$AppDatabase db, $InspectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> contractId = const Value.absent(),
                Value<int> kind = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => InspectionsCompanion(
                id: id,
                contractId: contractId,
                kind: kind,
                date: date,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int contractId,
                required int kind,
                required DateTime date,
                Value<String?> notes = const Value.absent(),
              }) => InspectionsCompanion.insert(
                id: id,
                contractId: contractId,
                kind: kind,
                date: date,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InspectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({contractId = false, inspectionItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (inspectionItemsRefs) db.inspectionItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (contractId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.contractId,
                                    referencedTable:
                                        $$InspectionsTableReferences
                                            ._contractIdTable(db),
                                    referencedColumn:
                                        $$InspectionsTableReferences
                                            ._contractIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (inspectionItemsRefs)
                        await $_getPrefetchedData<
                          Inspection,
                          $InspectionsTable,
                          InspectionItem
                        >(
                          currentTable: table,
                          referencedTable: $$InspectionsTableReferences
                              ._inspectionItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InspectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).inspectionItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.inspectionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InspectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionsTable,
      Inspection,
      $$InspectionsTableFilterComposer,
      $$InspectionsTableOrderingComposer,
      $$InspectionsTableAnnotationComposer,
      $$InspectionsTableCreateCompanionBuilder,
      $$InspectionsTableUpdateCompanionBuilder,
      (Inspection, $$InspectionsTableReferences),
      Inspection,
      PrefetchHooks Function({bool contractId, bool inspectionItemsRefs})
    >;
typedef $$InspectionItemsTableCreateCompanionBuilder =
    InspectionItemsCompanion Function({
      Value<int> id,
      required int inspectionId,
      required String room,
      required String element,
      Value<String> condition,
      Value<String?> comment,
      Value<int> cost,
      Value<String?> photoPath,
    });
typedef $$InspectionItemsTableUpdateCompanionBuilder =
    InspectionItemsCompanion Function({
      Value<int> id,
      Value<int> inspectionId,
      Value<String> room,
      Value<String> element,
      Value<String> condition,
      Value<String?> comment,
      Value<int> cost,
      Value<String?> photoPath,
    });

final class $$InspectionItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $InspectionItemsTable, InspectionItem> {
  $$InspectionItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $InspectionsTable _inspectionIdTable(_$AppDatabase db) =>
      db.inspections.createAlias(
        $_aliasNameGenerator(
          db.inspectionItems.inspectionId,
          db.inspections.id,
        ),
      );

  $$InspectionsTableProcessedTableManager get inspectionId {
    final $_column = $_itemColumn<int>('inspection_id')!;

    final manager = $$InspectionsTableTableManager(
      $_db,
      $_db.inspections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inspectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InspectionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionItemsTable> {
  $$InspectionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get element => $composableBuilder(
    column: $table.element,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  $$InspectionsTableFilterComposer get inspectionId {
    final $$InspectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableFilterComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspectionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionItemsTable> {
  $$InspectionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get element => $composableBuilder(
    column: $table.element,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  $$InspectionsTableOrderingComposer get inspectionId {
    final $$InspectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableOrderingComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspectionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionItemsTable> {
  $$InspectionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get room =>
      $composableBuilder(column: $table.room, builder: (column) => column);

  GeneratedColumn<String> get element =>
      $composableBuilder(column: $table.element, builder: (column) => column);

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  $$InspectionsTableAnnotationComposer get inspectionId {
    final $$InspectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspectionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionItemsTable,
          InspectionItem,
          $$InspectionItemsTableFilterComposer,
          $$InspectionItemsTableOrderingComposer,
          $$InspectionItemsTableAnnotationComposer,
          $$InspectionItemsTableCreateCompanionBuilder,
          $$InspectionItemsTableUpdateCompanionBuilder,
          (InspectionItem, $$InspectionItemsTableReferences),
          InspectionItem,
          PrefetchHooks Function({bool inspectionId})
        > {
  $$InspectionItemsTableTableManager(
    _$AppDatabase db,
    $InspectionItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> inspectionId = const Value.absent(),
                Value<String> room = const Value.absent(),
                Value<String> element = const Value.absent(),
                Value<String> condition = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int> cost = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
              }) => InspectionItemsCompanion(
                id: id,
                inspectionId: inspectionId,
                room: room,
                element: element,
                condition: condition,
                comment: comment,
                cost: cost,
                photoPath: photoPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int inspectionId,
                required String room,
                required String element,
                Value<String> condition = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int> cost = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
              }) => InspectionItemsCompanion.insert(
                id: id,
                inspectionId: inspectionId,
                room: room,
                element: element,
                condition: condition,
                comment: comment,
                cost: cost,
                photoPath: photoPath,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InspectionItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({inspectionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (inspectionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.inspectionId,
                                referencedTable:
                                    $$InspectionItemsTableReferences
                                        ._inspectionIdTable(db),
                                referencedColumn:
                                    $$InspectionItemsTableReferences
                                        ._inspectionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InspectionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionItemsTable,
      InspectionItem,
      $$InspectionItemsTableFilterComposer,
      $$InspectionItemsTableOrderingComposer,
      $$InspectionItemsTableAnnotationComposer,
      $$InspectionItemsTableCreateCompanionBuilder,
      $$InspectionItemsTableUpdateCompanionBuilder,
      (InspectionItem, $$InspectionItemsTableReferences),
      InspectionItem,
      PrefetchHooks Function({bool inspectionId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OwnersTableTableManager get owners =>
      $$OwnersTableTableManager(_db, _db.owners);
  $$BuildingsTableTableManager get buildings =>
      $$BuildingsTableTableManager(_db, _db.buildings);
  $$ApartmentsTableTableManager get apartments =>
      $$ApartmentsTableTableManager(_db, _db.apartments);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db, _db.tenants);
  $$UtilityTypesTableTableManager get utilityTypes =>
      $$UtilityTypesTableTableManager(_db, _db.utilityTypes);
  $$MetersTableTableManager get meters =>
      $$MetersTableTableManager(_db, _db.meters);
  $$ServiceTypesTableTableManager get serviceTypes =>
      $$ServiceTypesTableTableManager(_db, _db.serviceTypes);
  $$ContractsTableTableManager get contracts =>
      $$ContractsTableTableManager(_db, _db.contracts);
  $$ContractServicesTableTableManager get contractServices =>
      $$ContractServicesTableTableManager(_db, _db.contractServices);
  $$ContractBenefitsTableTableManager get contractBenefits =>
      $$ContractBenefitsTableTableManager(_db, _db.contractBenefits);
  $$ReadingsTableTableManager get readings =>
      $$ReadingsTableTableManager(_db, _db.readings);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$InvoiceLinesTableTableManager get invoiceLines =>
      $$InvoiceLinesTableTableManager(_db, _db.invoiceLines);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$InspectionsTableTableManager get inspections =>
      $$InspectionsTableTableManager(_db, _db.inspections);
  $$InspectionItemsTableTableManager get inspectionItems =>
      $$InspectionItemsTableTableManager(_db, _db.inspectionItems);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
