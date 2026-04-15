// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recruitment_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RecruitmentState {
  int get currentStep => throw _privateConstructorUsedError;
  int? get packageId => throw _privateConstructorUsedError;
  BookingPackage? get selectedPackage =>
      throw _privateConstructorUsedError; // Step 2 Info
  int? get addressId => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String get religion =>
      throw _privateConstructorUsedError; // Additional Worker Preferences
  String? get preferredNationality => throw _privateConstructorUsedError;
  int? get ageFrom => throw _privateConstructorUsedError;
  int? get ageTo => throw _privateConstructorUsedError;
  int? get experienceYears =>
      throw _privateConstructorUsedError; // Family Conditions
  bool get hasChildren => throw _privateConstructorUsedError;
  bool get hasElderly => throw _privateConstructorUsedError;
  bool get hasSpecialNeeds =>
      throw _privateConstructorUsedError; // Existing fields
  int get familyMembersCount => throw _privateConstructorUsedError;
  String? get details => throw _privateConstructorUsedError;
  bool get hasVisa => throw _privateConstructorUsedError;
  String? get visaNumber =>
      throw _privateConstructorUsedError; // order API state
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  OrderEntity? get submittedOrder => throw _privateConstructorUsedError;

  /// Create a copy of RecruitmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecruitmentStateCopyWith<RecruitmentState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecruitmentStateCopyWith<$Res> {
  factory $RecruitmentStateCopyWith(
    RecruitmentState value,
    $Res Function(RecruitmentState) then,
  ) = _$RecruitmentStateCopyWithImpl<$Res, RecruitmentState>;
  @useResult
  $Res call({
    int currentStep,
    int? packageId,
    BookingPackage? selectedPackage,
    int? addressId,
    String? address,
    String religion,
    String? preferredNationality,
    int? ageFrom,
    int? ageTo,
    int? experienceYears,
    bool hasChildren,
    bool hasElderly,
    bool hasSpecialNeeds,
    int familyMembersCount,
    String? details,
    bool hasVisa,
    String? visaNumber,
    bool isLoading,
    String? errorMessage,
    OrderEntity? submittedOrder,
  });
}

/// @nodoc
class _$RecruitmentStateCopyWithImpl<$Res, $Val extends RecruitmentState>
    implements $RecruitmentStateCopyWith<$Res> {
  _$RecruitmentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecruitmentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? packageId = freezed,
    Object? selectedPackage = freezed,
    Object? addressId = freezed,
    Object? address = freezed,
    Object? religion = null,
    Object? preferredNationality = freezed,
    Object? ageFrom = freezed,
    Object? ageTo = freezed,
    Object? experienceYears = freezed,
    Object? hasChildren = null,
    Object? hasElderly = null,
    Object? hasSpecialNeeds = null,
    Object? familyMembersCount = null,
    Object? details = freezed,
    Object? hasVisa = null,
    Object? visaNumber = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? submittedOrder = freezed,
  }) {
    return _then(
      _value.copyWith(
            currentStep: null == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                      as int,
            packageId: freezed == packageId
                ? _value.packageId
                : packageId // ignore: cast_nullable_to_non_nullable
                      as int?,
            selectedPackage: freezed == selectedPackage
                ? _value.selectedPackage
                : selectedPackage // ignore: cast_nullable_to_non_nullable
                      as BookingPackage?,
            addressId: freezed == addressId
                ? _value.addressId
                : addressId // ignore: cast_nullable_to_non_nullable
                      as int?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            religion: null == religion
                ? _value.religion
                : religion // ignore: cast_nullable_to_non_nullable
                      as String,
            preferredNationality: freezed == preferredNationality
                ? _value.preferredNationality
                : preferredNationality // ignore: cast_nullable_to_non_nullable
                      as String?,
            ageFrom: freezed == ageFrom
                ? _value.ageFrom
                : ageFrom // ignore: cast_nullable_to_non_nullable
                      as int?,
            ageTo: freezed == ageTo
                ? _value.ageTo
                : ageTo // ignore: cast_nullable_to_non_nullable
                      as int?,
            experienceYears: freezed == experienceYears
                ? _value.experienceYears
                : experienceYears // ignore: cast_nullable_to_non_nullable
                      as int?,
            hasChildren: null == hasChildren
                ? _value.hasChildren
                : hasChildren // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasElderly: null == hasElderly
                ? _value.hasElderly
                : hasElderly // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasSpecialNeeds: null == hasSpecialNeeds
                ? _value.hasSpecialNeeds
                : hasSpecialNeeds // ignore: cast_nullable_to_non_nullable
                      as bool,
            familyMembersCount: null == familyMembersCount
                ? _value.familyMembersCount
                : familyMembersCount // ignore: cast_nullable_to_non_nullable
                      as int,
            details: freezed == details
                ? _value.details
                : details // ignore: cast_nullable_to_non_nullable
                      as String?,
            hasVisa: null == hasVisa
                ? _value.hasVisa
                : hasVisa // ignore: cast_nullable_to_non_nullable
                      as bool,
            visaNumber: freezed == visaNumber
                ? _value.visaNumber
                : visaNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            submittedOrder: freezed == submittedOrder
                ? _value.submittedOrder
                : submittedOrder // ignore: cast_nullable_to_non_nullable
                      as OrderEntity?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecruitmentStateImplCopyWith<$Res>
    implements $RecruitmentStateCopyWith<$Res> {
  factory _$$RecruitmentStateImplCopyWith(
    _$RecruitmentStateImpl value,
    $Res Function(_$RecruitmentStateImpl) then,
  ) = __$$RecruitmentStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentStep,
    int? packageId,
    BookingPackage? selectedPackage,
    int? addressId,
    String? address,
    String religion,
    String? preferredNationality,
    int? ageFrom,
    int? ageTo,
    int? experienceYears,
    bool hasChildren,
    bool hasElderly,
    bool hasSpecialNeeds,
    int familyMembersCount,
    String? details,
    bool hasVisa,
    String? visaNumber,
    bool isLoading,
    String? errorMessage,
    OrderEntity? submittedOrder,
  });
}

/// @nodoc
class __$$RecruitmentStateImplCopyWithImpl<$Res>
    extends _$RecruitmentStateCopyWithImpl<$Res, _$RecruitmentStateImpl>
    implements _$$RecruitmentStateImplCopyWith<$Res> {
  __$$RecruitmentStateImplCopyWithImpl(
    _$RecruitmentStateImpl _value,
    $Res Function(_$RecruitmentStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecruitmentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? packageId = freezed,
    Object? selectedPackage = freezed,
    Object? addressId = freezed,
    Object? address = freezed,
    Object? religion = null,
    Object? preferredNationality = freezed,
    Object? ageFrom = freezed,
    Object? ageTo = freezed,
    Object? experienceYears = freezed,
    Object? hasChildren = null,
    Object? hasElderly = null,
    Object? hasSpecialNeeds = null,
    Object? familyMembersCount = null,
    Object? details = freezed,
    Object? hasVisa = null,
    Object? visaNumber = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? submittedOrder = freezed,
  }) {
    return _then(
      _$RecruitmentStateImpl(
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as int,
        packageId: freezed == packageId
            ? _value.packageId
            : packageId // ignore: cast_nullable_to_non_nullable
                  as int?,
        selectedPackage: freezed == selectedPackage
            ? _value.selectedPackage
            : selectedPackage // ignore: cast_nullable_to_non_nullable
                  as BookingPackage?,
        addressId: freezed == addressId
            ? _value.addressId
            : addressId // ignore: cast_nullable_to_non_nullable
                  as int?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        religion: null == religion
            ? _value.religion
            : religion // ignore: cast_nullable_to_non_nullable
                  as String,
        preferredNationality: freezed == preferredNationality
            ? _value.preferredNationality
            : preferredNationality // ignore: cast_nullable_to_non_nullable
                  as String?,
        ageFrom: freezed == ageFrom
            ? _value.ageFrom
            : ageFrom // ignore: cast_nullable_to_non_nullable
                  as int?,
        ageTo: freezed == ageTo
            ? _value.ageTo
            : ageTo // ignore: cast_nullable_to_non_nullable
                  as int?,
        experienceYears: freezed == experienceYears
            ? _value.experienceYears
            : experienceYears // ignore: cast_nullable_to_non_nullable
                  as int?,
        hasChildren: null == hasChildren
            ? _value.hasChildren
            : hasChildren // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasElderly: null == hasElderly
            ? _value.hasElderly
            : hasElderly // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasSpecialNeeds: null == hasSpecialNeeds
            ? _value.hasSpecialNeeds
            : hasSpecialNeeds // ignore: cast_nullable_to_non_nullable
                  as bool,
        familyMembersCount: null == familyMembersCount
            ? _value.familyMembersCount
            : familyMembersCount // ignore: cast_nullable_to_non_nullable
                  as int,
        details: freezed == details
            ? _value.details
            : details // ignore: cast_nullable_to_non_nullable
                  as String?,
        hasVisa: null == hasVisa
            ? _value.hasVisa
            : hasVisa // ignore: cast_nullable_to_non_nullable
                  as bool,
        visaNumber: freezed == visaNumber
            ? _value.visaNumber
            : visaNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        submittedOrder: freezed == submittedOrder
            ? _value.submittedOrder
            : submittedOrder // ignore: cast_nullable_to_non_nullable
                  as OrderEntity?,
      ),
    );
  }
}

/// @nodoc

class _$RecruitmentStateImpl extends _RecruitmentState {
  const _$RecruitmentStateImpl({
    this.currentStep = 0,
    this.packageId,
    this.selectedPackage,
    this.addressId,
    this.address,
    this.religion = 'لا يهم',
    this.preferredNationality,
    this.ageFrom,
    this.ageTo,
    this.experienceYears,
    this.hasChildren = false,
    this.hasElderly = false,
    this.hasSpecialNeeds = false,
    this.familyMembersCount = 0,
    this.details,
    this.hasVisa = false,
    this.visaNumber,
    this.isLoading = false,
    this.errorMessage,
    this.submittedOrder,
  }) : super._();

  @override
  @JsonKey()
  final int currentStep;
  @override
  final int? packageId;
  @override
  final BookingPackage? selectedPackage;
  // Step 2 Info
  @override
  final int? addressId;
  @override
  final String? address;
  @override
  @JsonKey()
  final String religion;
  // Additional Worker Preferences
  @override
  final String? preferredNationality;
  @override
  final int? ageFrom;
  @override
  final int? ageTo;
  @override
  final int? experienceYears;
  // Family Conditions
  @override
  @JsonKey()
  final bool hasChildren;
  @override
  @JsonKey()
  final bool hasElderly;
  @override
  @JsonKey()
  final bool hasSpecialNeeds;
  // Existing fields
  @override
  @JsonKey()
  final int familyMembersCount;
  @override
  final String? details;
  @override
  @JsonKey()
  final bool hasVisa;
  @override
  final String? visaNumber;
  // order API state
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  final OrderEntity? submittedOrder;

  @override
  String toString() {
    return 'RecruitmentState(currentStep: $currentStep, packageId: $packageId, selectedPackage: $selectedPackage, addressId: $addressId, address: $address, religion: $religion, preferredNationality: $preferredNationality, ageFrom: $ageFrom, ageTo: $ageTo, experienceYears: $experienceYears, hasChildren: $hasChildren, hasElderly: $hasElderly, hasSpecialNeeds: $hasSpecialNeeds, familyMembersCount: $familyMembersCount, details: $details, hasVisa: $hasVisa, visaNumber: $visaNumber, isLoading: $isLoading, errorMessage: $errorMessage, submittedOrder: $submittedOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecruitmentStateImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.packageId, packageId) ||
                other.packageId == packageId) &&
            (identical(other.selectedPackage, selectedPackage) ||
                other.selectedPackage == selectedPackage) &&
            (identical(other.addressId, addressId) ||
                other.addressId == addressId) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.religion, religion) ||
                other.religion == religion) &&
            (identical(other.preferredNationality, preferredNationality) ||
                other.preferredNationality == preferredNationality) &&
            (identical(other.ageFrom, ageFrom) || other.ageFrom == ageFrom) &&
            (identical(other.ageTo, ageTo) || other.ageTo == ageTo) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            (identical(other.hasChildren, hasChildren) ||
                other.hasChildren == hasChildren) &&
            (identical(other.hasElderly, hasElderly) ||
                other.hasElderly == hasElderly) &&
            (identical(other.hasSpecialNeeds, hasSpecialNeeds) ||
                other.hasSpecialNeeds == hasSpecialNeeds) &&
            (identical(other.familyMembersCount, familyMembersCount) ||
                other.familyMembersCount == familyMembersCount) &&
            (identical(other.details, details) || other.details == details) &&
            (identical(other.hasVisa, hasVisa) || other.hasVisa == hasVisa) &&
            (identical(other.visaNumber, visaNumber) ||
                other.visaNumber == visaNumber) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.submittedOrder, submittedOrder) ||
                other.submittedOrder == submittedOrder));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    currentStep,
    packageId,
    selectedPackage,
    addressId,
    address,
    religion,
    preferredNationality,
    ageFrom,
    ageTo,
    experienceYears,
    hasChildren,
    hasElderly,
    hasSpecialNeeds,
    familyMembersCount,
    details,
    hasVisa,
    visaNumber,
    isLoading,
    errorMessage,
    submittedOrder,
  ]);

  /// Create a copy of RecruitmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecruitmentStateImplCopyWith<_$RecruitmentStateImpl> get copyWith =>
      __$$RecruitmentStateImplCopyWithImpl<_$RecruitmentStateImpl>(
        this,
        _$identity,
      );
}

abstract class _RecruitmentState extends RecruitmentState {
  const factory _RecruitmentState({
    final int currentStep,
    final int? packageId,
    final BookingPackage? selectedPackage,
    final int? addressId,
    final String? address,
    final String religion,
    final String? preferredNationality,
    final int? ageFrom,
    final int? ageTo,
    final int? experienceYears,
    final bool hasChildren,
    final bool hasElderly,
    final bool hasSpecialNeeds,
    final int familyMembersCount,
    final String? details,
    final bool hasVisa,
    final String? visaNumber,
    final bool isLoading,
    final String? errorMessage,
    final OrderEntity? submittedOrder,
  }) = _$RecruitmentStateImpl;
  const _RecruitmentState._() : super._();

  @override
  int get currentStep;
  @override
  int? get packageId;
  @override
  BookingPackage? get selectedPackage; // Step 2 Info
  @override
  int? get addressId;
  @override
  String? get address;
  @override
  String get religion; // Additional Worker Preferences
  @override
  String? get preferredNationality;
  @override
  int? get ageFrom;
  @override
  int? get ageTo;
  @override
  int? get experienceYears; // Family Conditions
  @override
  bool get hasChildren;
  @override
  bool get hasElderly;
  @override
  bool get hasSpecialNeeds; // Existing fields
  @override
  int get familyMembersCount;
  @override
  String? get details;
  @override
  bool get hasVisa;
  @override
  String? get visaNumber; // order API state
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  OrderEntity? get submittedOrder;

  /// Create a copy of RecruitmentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecruitmentStateImplCopyWith<_$RecruitmentStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
