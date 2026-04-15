// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rental_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RentalState {
  int get currentStep => throw _privateConstructorUsedError;
  int? get serviceId => throw _privateConstructorUsedError;
  BookingPackage? get selectedPackage =>
      throw _privateConstructorUsedError; // Step 2 Info (Booking Details)
  int get deliveryMethod =>
      throw _privateConstructorUsedError; // 0 for Branch, 1 for Delivery
  int? get addressId => throw _privateConstructorUsedError;
  String? get address =>
      throw _privateConstructorUsedError; // Step 3 Info (Worker)
  CandidateEntity? get selectedWorker =>
      throw _privateConstructorUsedError; // Step 4 Info (Contract/Signature)
  Uint8List? get signatureBytes => throw _privateConstructorUsedError;
  String? get dob =>
      throw _privateConstructorUsedError; // Step 5 Info (Payment)
  String get paymentMethod => throw _privateConstructorUsedError;
  String? get discountCode => throw _privateConstructorUsedError;
  double get promoDiscount => throw _privateConstructorUsedError;
  OrderDetailsEntity? get createdOrder =>
      throw _privateConstructorUsedError; // API state
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;

  /// Create a copy of RentalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RentalStateCopyWith<RentalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RentalStateCopyWith<$Res> {
  factory $RentalStateCopyWith(
    RentalState value,
    $Res Function(RentalState) then,
  ) = _$RentalStateCopyWithImpl<$Res, RentalState>;
  @useResult
  $Res call({
    int currentStep,
    int? serviceId,
    BookingPackage? selectedPackage,
    int deliveryMethod,
    int? addressId,
    String? address,
    CandidateEntity? selectedWorker,
    Uint8List? signatureBytes,
    String? dob,
    String paymentMethod,
    String? discountCode,
    double promoDiscount,
    OrderDetailsEntity? createdOrder,
    bool isLoading,
    String? errorMessage,
    bool isSuccess,
  });
}

/// @nodoc
class _$RentalStateCopyWithImpl<$Res, $Val extends RentalState>
    implements $RentalStateCopyWith<$Res> {
  _$RentalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RentalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? serviceId = freezed,
    Object? selectedPackage = freezed,
    Object? deliveryMethod = null,
    Object? addressId = freezed,
    Object? address = freezed,
    Object? selectedWorker = freezed,
    Object? signatureBytes = freezed,
    Object? dob = freezed,
    Object? paymentMethod = null,
    Object? discountCode = freezed,
    Object? promoDiscount = null,
    Object? createdOrder = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? isSuccess = null,
  }) {
    return _then(
      _value.copyWith(
            currentStep: null == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                      as int,
            serviceId: freezed == serviceId
                ? _value.serviceId
                : serviceId // ignore: cast_nullable_to_non_nullable
                      as int?,
            selectedPackage: freezed == selectedPackage
                ? _value.selectedPackage
                : selectedPackage // ignore: cast_nullable_to_non_nullable
                      as BookingPackage?,
            deliveryMethod: null == deliveryMethod
                ? _value.deliveryMethod
                : deliveryMethod // ignore: cast_nullable_to_non_nullable
                      as int,
            addressId: freezed == addressId
                ? _value.addressId
                : addressId // ignore: cast_nullable_to_non_nullable
                      as int?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            selectedWorker: freezed == selectedWorker
                ? _value.selectedWorker
                : selectedWorker // ignore: cast_nullable_to_non_nullable
                      as CandidateEntity?,
            signatureBytes: freezed == signatureBytes
                ? _value.signatureBytes
                : signatureBytes // ignore: cast_nullable_to_non_nullable
                      as Uint8List?,
            dob: freezed == dob
                ? _value.dob
                : dob // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            discountCode: freezed == discountCode
                ? _value.discountCode
                : discountCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            promoDiscount: null == promoDiscount
                ? _value.promoDiscount
                : promoDiscount // ignore: cast_nullable_to_non_nullable
                      as double,
            createdOrder: freezed == createdOrder
                ? _value.createdOrder
                : createdOrder // ignore: cast_nullable_to_non_nullable
                      as OrderDetailsEntity?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            isSuccess: null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RentalStateImplCopyWith<$Res>
    implements $RentalStateCopyWith<$Res> {
  factory _$$RentalStateImplCopyWith(
    _$RentalStateImpl value,
    $Res Function(_$RentalStateImpl) then,
  ) = __$$RentalStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentStep,
    int? serviceId,
    BookingPackage? selectedPackage,
    int deliveryMethod,
    int? addressId,
    String? address,
    CandidateEntity? selectedWorker,
    Uint8List? signatureBytes,
    String? dob,
    String paymentMethod,
    String? discountCode,
    double promoDiscount,
    OrderDetailsEntity? createdOrder,
    bool isLoading,
    String? errorMessage,
    bool isSuccess,
  });
}

/// @nodoc
class __$$RentalStateImplCopyWithImpl<$Res>
    extends _$RentalStateCopyWithImpl<$Res, _$RentalStateImpl>
    implements _$$RentalStateImplCopyWith<$Res> {
  __$$RentalStateImplCopyWithImpl(
    _$RentalStateImpl _value,
    $Res Function(_$RentalStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RentalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? serviceId = freezed,
    Object? selectedPackage = freezed,
    Object? deliveryMethod = null,
    Object? addressId = freezed,
    Object? address = freezed,
    Object? selectedWorker = freezed,
    Object? signatureBytes = freezed,
    Object? dob = freezed,
    Object? paymentMethod = null,
    Object? discountCode = freezed,
    Object? promoDiscount = null,
    Object? createdOrder = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? isSuccess = null,
  }) {
    return _then(
      _$RentalStateImpl(
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as int,
        serviceId: freezed == serviceId
            ? _value.serviceId
            : serviceId // ignore: cast_nullable_to_non_nullable
                  as int?,
        selectedPackage: freezed == selectedPackage
            ? _value.selectedPackage
            : selectedPackage // ignore: cast_nullable_to_non_nullable
                  as BookingPackage?,
        deliveryMethod: null == deliveryMethod
            ? _value.deliveryMethod
            : deliveryMethod // ignore: cast_nullable_to_non_nullable
                  as int,
        addressId: freezed == addressId
            ? _value.addressId
            : addressId // ignore: cast_nullable_to_non_nullable
                  as int?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedWorker: freezed == selectedWorker
            ? _value.selectedWorker
            : selectedWorker // ignore: cast_nullable_to_non_nullable
                  as CandidateEntity?,
        signatureBytes: freezed == signatureBytes
            ? _value.signatureBytes
            : signatureBytes // ignore: cast_nullable_to_non_nullable
                  as Uint8List?,
        dob: freezed == dob
            ? _value.dob
            : dob // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        discountCode: freezed == discountCode
            ? _value.discountCode
            : discountCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        promoDiscount: null == promoDiscount
            ? _value.promoDiscount
            : promoDiscount // ignore: cast_nullable_to_non_nullable
                  as double,
        createdOrder: freezed == createdOrder
            ? _value.createdOrder
            : createdOrder // ignore: cast_nullable_to_non_nullable
                  as OrderDetailsEntity?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        isSuccess: null == isSuccess
            ? _value.isSuccess
            : isSuccess // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$RentalStateImpl extends _RentalState {
  const _$RentalStateImpl({
    this.currentStep = 0,
    this.serviceId,
    this.selectedPackage,
    this.deliveryMethod = 0,
    this.addressId,
    this.address,
    this.selectedWorker,
    this.signatureBytes,
    this.dob,
    this.paymentMethod = 'visa',
    this.discountCode,
    this.promoDiscount = 0.0,
    this.createdOrder,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  }) : super._();

  @override
  @JsonKey()
  final int currentStep;
  @override
  final int? serviceId;
  @override
  final BookingPackage? selectedPackage;
  // Step 2 Info (Booking Details)
  @override
  @JsonKey()
  final int deliveryMethod;
  // 0 for Branch, 1 for Delivery
  @override
  final int? addressId;
  @override
  final String? address;
  // Step 3 Info (Worker)
  @override
  final CandidateEntity? selectedWorker;
  // Step 4 Info (Contract/Signature)
  @override
  final Uint8List? signatureBytes;
  @override
  final String? dob;
  // Step 5 Info (Payment)
  @override
  @JsonKey()
  final String paymentMethod;
  @override
  final String? discountCode;
  @override
  @JsonKey()
  final double promoDiscount;
  @override
  final OrderDetailsEntity? createdOrder;
  // API state
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool isSuccess;

  @override
  String toString() {
    return 'RentalState(currentStep: $currentStep, serviceId: $serviceId, selectedPackage: $selectedPackage, deliveryMethod: $deliveryMethod, addressId: $addressId, address: $address, selectedWorker: $selectedWorker, signatureBytes: $signatureBytes, dob: $dob, paymentMethod: $paymentMethod, discountCode: $discountCode, promoDiscount: $promoDiscount, createdOrder: $createdOrder, isLoading: $isLoading, errorMessage: $errorMessage, isSuccess: $isSuccess)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RentalStateImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.selectedPackage, selectedPackage) ||
                other.selectedPackage == selectedPackage) &&
            (identical(other.deliveryMethod, deliveryMethod) ||
                other.deliveryMethod == deliveryMethod) &&
            (identical(other.addressId, addressId) ||
                other.addressId == addressId) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.selectedWorker, selectedWorker) ||
                other.selectedWorker == selectedWorker) &&
            const DeepCollectionEquality().equals(
              other.signatureBytes,
              signatureBytes,
            ) &&
            (identical(other.dob, dob) || other.dob == dob) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.discountCode, discountCode) ||
                other.discountCode == discountCode) &&
            (identical(other.promoDiscount, promoDiscount) ||
                other.promoDiscount == promoDiscount) &&
            (identical(other.createdOrder, createdOrder) ||
                other.createdOrder == createdOrder) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentStep,
    serviceId,
    selectedPackage,
    deliveryMethod,
    addressId,
    address,
    selectedWorker,
    const DeepCollectionEquality().hash(signatureBytes),
    dob,
    paymentMethod,
    discountCode,
    promoDiscount,
    createdOrder,
    isLoading,
    errorMessage,
    isSuccess,
  );

  /// Create a copy of RentalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RentalStateImplCopyWith<_$RentalStateImpl> get copyWith =>
      __$$RentalStateImplCopyWithImpl<_$RentalStateImpl>(this, _$identity);
}

abstract class _RentalState extends RentalState {
  const factory _RentalState({
    final int currentStep,
    final int? serviceId,
    final BookingPackage? selectedPackage,
    final int deliveryMethod,
    final int? addressId,
    final String? address,
    final CandidateEntity? selectedWorker,
    final Uint8List? signatureBytes,
    final String? dob,
    final String paymentMethod,
    final String? discountCode,
    final double promoDiscount,
    final OrderDetailsEntity? createdOrder,
    final bool isLoading,
    final String? errorMessage,
    final bool isSuccess,
  }) = _$RentalStateImpl;
  const _RentalState._() : super._();

  @override
  int get currentStep;
  @override
  int? get serviceId;
  @override
  BookingPackage? get selectedPackage; // Step 2 Info (Booking Details)
  @override
  int get deliveryMethod; // 0 for Branch, 1 for Delivery
  @override
  int? get addressId;
  @override
  String? get address; // Step 3 Info (Worker)
  @override
  CandidateEntity? get selectedWorker; // Step 4 Info (Contract/Signature)
  @override
  Uint8List? get signatureBytes;
  @override
  String? get dob; // Step 5 Info (Payment)
  @override
  String get paymentMethod;
  @override
  String? get discountCode;
  @override
  double get promoDiscount;
  @override
  OrderDetailsEntity? get createdOrder; // API state
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  bool get isSuccess;

  /// Create a copy of RentalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RentalStateImplCopyWith<_$RentalStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
