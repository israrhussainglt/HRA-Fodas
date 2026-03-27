enum UserRole { donor, recipient, volunteer, admin }

enum DonationStatus {
  pending,
  assigned,
  pickedUp,
  delivered,
  cancelled,
  expired,
}

enum DeliveryStatus {
  assigned,
  enRoutePickup,
  pickedUp,
  enRouteDelivery,
  delivered,
  failed,
  cancelled,
}

enum FoodCategory { freshProduce, dairy, meat, bakery, canned, prepared, other }

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.donor:
        return 'Donor';
      case UserRole.recipient:
        return 'Recipient Organization';
      case UserRole.volunteer:
        return 'Volunteer';
      case UserRole.admin:
        return 'Administrator';
    }
  }

  String get dbValue {
    switch (this) {
      case UserRole.donor:
        return 'donor';
      case UserRole.recipient:
        return 'recipient';
      case UserRole.volunteer:
        return 'volunteer';
      case UserRole.admin:
        return 'admin';
    }
  }

  static UserRole fromString(String value) {
    switch (value) {
      case 'donor':
        return UserRole.donor;
      case 'recipient':
        return UserRole.recipient;
      case 'volunteer':
        return UserRole.volunteer;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.donor;
    }
  }
}

extension DonationStatusExtension on DonationStatus {
  String get displayName {
    switch (this) {
      case DonationStatus.pending:
        return 'Pending';
      case DonationStatus.assigned:
        return 'Assigned';
      case DonationStatus.pickedUp:
        return 'Picked Up';
      case DonationStatus.delivered:
        return 'Delivered';
      case DonationStatus.cancelled:
        return 'Cancelled';
      case DonationStatus.expired:
        return 'Expired';
    }
  }

  String get dbValue {
    switch (this) {
      case DonationStatus.pending:
        return 'pending';
      case DonationStatus.assigned:
        return 'assigned';
      case DonationStatus.pickedUp:
        return 'picked_up';
      case DonationStatus.delivered:
        return 'delivered';
      case DonationStatus.cancelled:
        return 'cancelled';
      case DonationStatus.expired:
        return 'expired';
    }
  }

  static DonationStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return DonationStatus.pending;
      case 'assigned':
      case 'scheduled': // Legacy support
        return DonationStatus.assigned;
      case 'picked_up':
        return DonationStatus.pickedUp;
      case 'in_transit': // Legacy support - map to pickedUp
        return DonationStatus.pickedUp;
      case 'delivered':
        return DonationStatus.delivered;
      case 'cancelled':
        return DonationStatus.cancelled;
      case 'expired':
        return DonationStatus.expired;
      default:
        return DonationStatus.pending;
    }
  }
}

extension FoodCategoryExtension on FoodCategory {
  String get displayName {
    switch (this) {
      case FoodCategory.freshProduce:
        return 'Fresh Produce';
      case FoodCategory.dairy:
        return 'Dairy';
      case FoodCategory.meat:
        return 'Meat';
      case FoodCategory.bakery:
        return 'Bakery';
      case FoodCategory.canned:
        return 'Canned Goods';
      case FoodCategory.prepared:
        return 'Prepared Food';
      case FoodCategory.other:
        return 'Other';
    }
  }

  String get dbValue {
    switch (this) {
      case FoodCategory.freshProduce:
        return 'fresh_produce';
      case FoodCategory.dairy:
        return 'dairy';
      case FoodCategory.meat:
        return 'meat';
      case FoodCategory.bakery:
        return 'bakery';
      case FoodCategory.canned:
        return 'canned';
      case FoodCategory.prepared:
        return 'prepared';
      case FoodCategory.other:
        return 'other';
    }
  }

  static FoodCategory fromString(String value) {
    switch (value) {
      case 'fresh_produce':
      case 'fruits': // Legacy support
      case 'vegetables': // Legacy support
        return FoodCategory.freshProduce;
      case 'dairy':
        return FoodCategory.dairy;
      case 'meat':
        return FoodCategory.meat;
      case 'bakery':
        return FoodCategory.bakery;
      case 'canned':
        return FoodCategory.canned;
      case 'prepared':
        return FoodCategory.prepared;
      default:
        return FoodCategory.other;
    }
  }
}

extension DeliveryStatusExtension on DeliveryStatus {
  String get displayName {
    switch (this) {
      case DeliveryStatus.assigned:
        return 'Assigned';
      case DeliveryStatus.enRoutePickup:
        return 'En Route to Pickup';
      case DeliveryStatus.pickedUp:
        return 'Picked Up';
      case DeliveryStatus.enRouteDelivery:
        return 'En Route to Delivery';
      case DeliveryStatus.delivered:
        return 'Delivered';
      case DeliveryStatus.failed:
        return 'Failed';
      case DeliveryStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get dbValue {
    switch (this) {
      case DeliveryStatus.assigned:
        return 'assigned';
      case DeliveryStatus.enRoutePickup:
        return 'en_route_pickup';
      case DeliveryStatus.pickedUp:
        return 'picked_up';
      case DeliveryStatus.enRouteDelivery:
        return 'en_route_delivery';
      case DeliveryStatus.delivered:
        return 'delivered';
      case DeliveryStatus.failed:
        return 'failed';
      case DeliveryStatus.cancelled:
        return 'cancelled';
    }
  }

  static DeliveryStatus fromString(String value) {
    switch (value) {
      case 'assigned':
        return DeliveryStatus.assigned;
      case 'en_route_pickup':
        return DeliveryStatus.enRoutePickup;
      case 'picked_up':
        return DeliveryStatus.pickedUp;
      case 'en_route_delivery':
        return DeliveryStatus.enRouteDelivery;
      case 'delivered':
        return DeliveryStatus.delivered;
      case 'failed':
        return DeliveryStatus.failed;
      case 'cancelled':
        return DeliveryStatus.cancelled;
      default:
        return DeliveryStatus.assigned;
    }
  }
}
