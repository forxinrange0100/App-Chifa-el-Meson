// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final typeId = 0;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      id: (fields[15] as num).toInt(),
      publicId: (fields[0] as num).toInt(),
      subtotal: (fields[1] as num).toInt(),
      total: (fields[2] as num).toInt(),
      timestamp: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime?,
      deliveryType: fields[5] as String,
      deliveryCost: (fields[6] as num).toInt(),
      status: fields[7] as String,
      paymentStatus: fields[8] as String,
      paymentType: fields[9] as String,
      clientAddress: fields[10] as String?,
      clientPhone: fields[11] as String,
      clientEmail: fields[12] as String,
      clientName: fields[13] as String,
      orderProducts: (fields[14] as List).cast<OrderProduct>(),
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.publicId)
      ..writeByte(1)
      ..write(obj.subtotal)
      ..writeByte(2)
      ..write(obj.total)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.deliveryType)
      ..writeByte(6)
      ..write(obj.deliveryCost)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.paymentStatus)
      ..writeByte(9)
      ..write(obj.paymentType)
      ..writeByte(10)
      ..write(obj.clientAddress)
      ..writeByte(11)
      ..write(obj.clientPhone)
      ..writeByte(12)
      ..write(obj.clientEmail)
      ..writeByte(13)
      ..write(obj.clientName)
      ..writeByte(14)
      ..write(obj.orderProducts)
      ..writeByte(15)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderTrackingAdapter extends TypeAdapter<OrderTracking> {
  @override
  final typeId = 1;

  @override
  OrderTracking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderTracking(
      orderPublicId: (fields[0] as num).toInt(),
      timestamps: (fields[1] as Map).cast<OrderStatusEnum, DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderTracking obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.orderPublicId)
      ..writeByte(1)
      ..write(obj.timestamps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderTrackingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ShoppingCartAdapter extends TypeAdapter<ShoppingCart> {
  @override
  final typeId = 2;

  @override
  ShoppingCart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShoppingCart(cartItems: (fields[0] as List?)?.cast<CartItem>());
  }

  @override
  void write(BinaryWriter writer, ShoppingCart obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.cartItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingCartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderProductAdapter extends TypeAdapter<OrderProduct> {
  @override
  final typeId = 6;

  @override
  OrderProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderProduct(
      product: fields[0] as Product,
      quantity: (fields[1] as num).toInt(),
      note: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderProduct obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.product)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final typeId = 7;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: (fields[0] as num).toInt(),
      createdAt: fields[1] as DateTime,
      updatedAt: fields[2] as DateTime,
      name: fields[3] as String,
      description: fields[4] as String,
      regularPrice: (fields[5] as num).toInt(),
      discountedPrice: (fields[6] as num?)?.toInt(),
      image: fields[7] as String?,
      categoryId: (fields[8] as num?)?.toInt(),
      enabled: fields[9] as bool,
      displayOrder: (fields[10] as num).toInt(),
      units: (fields[11] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.regularPrice)
      ..writeByte(6)
      ..write(obj.discountedPrice)
      ..writeByte(7)
      ..write(obj.image)
      ..writeByte(8)
      ..write(obj.categoryId)
      ..writeByte(9)
      ..write(obj.enabled)
      ..writeByte(10)
      ..write(obj.displayOrder)
      ..writeByte(11)
      ..write(obj.units);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderStatusEnumAdapter extends TypeAdapter<OrderStatusEnum> {
  @override
  final typeId = 8;

  @override
  OrderStatusEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OrderStatusEnum.pending;
      case 1:
        return OrderStatusEnum.in_progress;
      case 2:
        return OrderStatusEnum.ready_for_pickup;
      case 3:
        return OrderStatusEnum.out_for_delivery;
      case 4:
        return OrderStatusEnum.completed;
      case 5:
        return OrderStatusEnum.canceled;
      case 6:
        return OrderStatusEnum.unknown;
      default:
        return OrderStatusEnum.pending;
    }
  }

  @override
  void write(BinaryWriter writer, OrderStatusEnum obj) {
    switch (obj) {
      case OrderStatusEnum.pending:
        writer.writeByte(0);
      case OrderStatusEnum.in_progress:
        writer.writeByte(1);
      case OrderStatusEnum.ready_for_pickup:
        writer.writeByte(2);
      case OrderStatusEnum.out_for_delivery:
        writer.writeByte(3);
      case OrderStatusEnum.completed:
        writer.writeByte(4);
      case OrderStatusEnum.canceled:
        writer.writeByte(5);
      case OrderStatusEnum.unknown:
        writer.writeByte(6);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderStatusEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CartItemAdapter extends TypeAdapter<CartItem> {
  @override
  final typeId = 9;

  @override
  CartItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItem(
      product: fields[0] as Product,
      quantity: (fields[1] as num).toInt(),
      notes: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CartItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.product)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
