/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import 'ecommerce.dart';
import 'pigeon.dart';

class ECommerceEvent {
  static const String _SHOW_SCREEN_EVENT = "show_screen_event";
  static const String _SHOW_PRODUCT_CARD_EVENT = "show_product_card_event";
  static const String _SHOW_PRODUCT_DETAILS_EVENT = "show_product_details_event";
  static const String _ADD_CART_ITEM_EVENT = "add_cart_item_event";
  static const String _REMOVE_CART_ITEM_EVENT = "remove_cart_item_event";
  static const String _BEGIN_CHECKOUT_EVENT = "begin_checkout_event";
  static const String _PURCHASE_EVENT = "purchase_event";

  final String _eventType;

  final ECommerceAmount? _amount;
  final ECommerceCartItem? _cartItem;
  final ECommerceOrder? _order;
  final ECommercePrice? _price;
  final ECommerceProduct? _product;
  final ECommerceReferrer? _referrer;
  final ECommerceScreen? _screen;

  ECommerceEvent._(this._eventType, this._amount, this._cartItem, this._order, this._price, this._product,
      this._referrer, this._screen);

  ECommerceEvent._showScreen(ECommerceScreen screen)
      : this._(_SHOW_SCREEN_EVENT, null, null, null, null, null, null, screen);

  ECommerceEvent._showProductCardEvent(ECommerceProduct product, ECommerceScreen screen)
      : this._(_SHOW_PRODUCT_CARD_EVENT, null, null, null, null, product, null, screen);

  ECommerceEvent._showProductDetailsEvent(ECommerceProduct product, ECommerceReferrer? referrer)
      : this._(_SHOW_PRODUCT_DETAILS_EVENT, null, null, null, null, product, referrer, null);

  ECommerceEvent._addCartItemEvent(ECommerceCartItem cartItem)
      : this._(_ADD_CART_ITEM_EVENT, null, cartItem, null, null, null, null, null);

  ECommerceEvent._removeCartItemEvent(ECommerceCartItem cartItem)
      : this._(_REMOVE_CART_ITEM_EVENT, null, cartItem, null, null, null, null, null);

  ECommerceEvent._beginCheckoutEvent(ECommerceOrder order)
      : this._(_BEGIN_CHECKOUT_EVENT, null, null, order, null, null, null, null);

  ECommerceEvent._purchaseEvent(ECommerceOrder order)
      : this._(_PURCHASE_EVENT, null, null, order, null, null, null, null);
}

class ECommerceConstructors {

  ECommerceConstructors._();

  static ECommerceEvent showScreenEvent(ECommerceScreen screen) => ECommerceEvent._showScreen(screen);

  static ECommerceEvent showProductCardEvent(ECommerceProduct product, ECommerceScreen screen) =>
      ECommerceEvent._showProductCardEvent(product, screen);

  static ECommerceEvent showProductDetailsEvent(ECommerceProduct product, ECommerceReferrer? referrer) =>
      ECommerceEvent._showProductDetailsEvent(product, referrer);

  static ECommerceEvent addCartItemEvent(ECommerceCartItem cartItem) => ECommerceEvent._addCartItemEvent(cartItem);

  static ECommerceEvent removeCartItemEvent(ECommerceCartItem cartItem) =>
      ECommerceEvent._removeCartItemEvent(cartItem);

  static ECommerceEvent beginCheckoutEvent(ECommerceOrder order) => ECommerceEvent._beginCheckoutEvent(order);

  static ECommerceEvent purchaseEvent(ECommerceOrder order) => ECommerceEvent._purchaseEvent(order);
}

ECommerceCartItemPigeon _toCartItemPigeon(ECommerceCartItem? cartItem) => (ECommerceCartItemPigeon()
  ..isNull = cartItem == null
  ..product = _toProductPigeon(cartItem?.product)
  ..quantity = cartItem?.quantity.toString()
  ..revenue = _toPricePigeon(cartItem?.revenue)
  ..referrer = _toReferrerPigeon(cartItem?.referrer));

ECommerceScreenPigeon _toScreenPigeon(ECommerceScreen? screen) => (ECommerceScreenPigeon()
  ..isNull = screen == null
  ..name = screen?.name
  ..categoriesPath = screen?.categoriesPath
  ..searchQuery = screen?.searchQuery
  ..payload = screen?.payload);

ECommerceReferrerPigeon _toReferrerPigeon(ECommerceReferrer? referrer) => (ECommerceReferrerPigeon()
  ..isNull = referrer == null
  ..identifier = referrer?.identifier
  ..type = referrer?.type
  ..screen = _toScreenPigeon(referrer?.screen));

ECommerceAmountPigeon _toAmountPigeon(ECommerceAmount? amount) => (ECommerceAmountPigeon()
  ..isNull = amount == null
  ..amount = amount?.amount.toString()
  ..currency = amount?.currency);

ECommercePricePigeon _toPricePigeon(ECommercePrice? price) => (ECommercePricePigeon()
  ..isNull = price == null
  ..fiat = _toAmountPigeon(price?.fiat)
  ..internalComponents = price?.internalComponents?.map((e) => _toAmountPigeon(e)).toList());

ECommerceProductPigeon _toProductPigeon(ECommerceProduct? product) => (ECommerceProductPigeon()
  ..isNull = product == null
  ..sku = product?.sku
  ..name = product?.name
  ..categoriesPath = product?.categoriesPath
  ..payload = product?.payload
  ..actualPrice = _toPricePigeon(product?.actualPrice)
  ..originalPrice = _toPricePigeon(product?.originalPrice)
  ..promocodes = product?.promocodes);

ECommerceOrderPigeon _toOrderPigeon(ECommerceOrder? order) => (ECommerceOrderPigeon()
  ..isNull = order == null
  ..identifier = order?.identifier
  ..items = order?.items.map((e) => _toCartItemPigeon(e)).toList()
  ..payload = order?.payload);

ECommerceEventPigeon convertEcommerce(ECommerceEvent event) => ECommerceEventPigeon()
  ..eventType = event._eventType
  ..amount = _toAmountPigeon(event._amount)
  ..cartItem = _toCartItemPigeon(event._cartItem)
  ..order = _toOrderPigeon(event._order)
  ..price = _toPricePigeon(event._price)
  ..product = _toProductPigeon(event._product)
  ..referrer = _toReferrerPigeon(event._referrer)
  ..screen = _toScreenPigeon(event._screen);
