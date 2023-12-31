import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;
class InfoView extends StatelessWidget {
  final Restaurant restaurant;
  final RestaurantController restController;
  final double scrollingRate;
  const InfoView({Key? key, required this.restaurant, required this.restController, required this.scrollingRate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
      Row(children: [

        !isDesktop ? Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).primaryColor, width: 0.2),
          ),
          padding: const EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Stack(children: [
              CustomImage(
                image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}/${restaurant.logo}',
                height: 60 - (scrollingRate * 15), width: 60 - (scrollingRate * 15), fit: BoxFit.cover,
              ),
              restController.isRestaurantOpenNow(restaurant.active!, restaurant.schedules) ? const SizedBox() : Positioned(
                left: 0, right: 0, bottom: 0,
                child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusSmall)),
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: Text(
                    'closed_now'.tr, textAlign: TextAlign.center,
                    style: IBMPlexSansArabicRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                  ),
                ),
              ),
            ]),
          ),
        ) : const SizedBox(),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            restaurant.name!, style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeLarge - (scrollingRate * 3), color: Theme.of(context).textTheme.bodyMedium!.color),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(
            restaurant.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
            style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall - (scrollingRate * 2), color: Theme.of(context).disabledColor),
          ),
          SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0),

          Row(children: [
            Text('start_from'.tr, style: IBMPlexSansArabicRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * 2), color: Theme.of(context).disabledColor,
            )),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text(
              PriceConverter.convertPrice(restaurant.minimumOrder), textDirection: TextDirection.rtl,
              style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * 2), color: Theme.of(context).primaryColor),
            ),
          ]),

        ])),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Column(children: [
          GetBuilder<WishListController>(builder: (wishController) {
              bool isWished = wishController.wishRestIdList.contains(restaurant.id);
              return InkWell(
                onTap: () {
                  if(Get.find<AuthController>().isLoggedIn()) {
                    isWished ? wishController.removeFromWishList(restaurant.id, true)
                        : wishController.addToWishList(null, restaurant, true);
                  }else {
                    showCustomSnackBar('you_are_not_logged_in'.tr);
                  }
                },
                child: Icon(
                  isWished ? Icons.favorite : Icons.favorite_border,
                  color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                  size: 24  - (scrollingRate * 4),
                ),
              );
            }),

          const SizedBox(height: Dimensions.paddingSizeSmall),


        ]),
        const SizedBox(width: Dimensions.paddingSizeLarge),

      ]),
      SizedBox(height: Dimensions.paddingSizeLarge - (scrollingRate * (isDesktop ? 2 : Dimensions.paddingSizeLarge))),

      Row(children: [

        Row(children: [
          Icon(Icons.access_time, color: Theme.of(context).primaryColor, size: 18 - (scrollingRate * (isDesktop ? 2 : 18))),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

          Text(restaurant.deliveryTime!, style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * (isDesktop ? 2 : Dimensions.fontSizeExtraSmall)), color: Theme.of(context).textTheme.bodyLarge!.color)),
        ]),
        const Expanded(child: SizedBox()),

        InkWell(
          onTap: () => Get.toNamed(RouteHelper.getMapRoute(
            AddressModel(
              id: restaurant.id, address: restaurant.address, latitude: restaurant.latitude,
              longitude: restaurant.longitude, contactPersonNumber: '', contactPersonName: '', addressType: '',
            ), 'restaurant',
          )),
          child: Row(children: [
            Image.asset(Images.restaurantLocationIcon, height: 18 - (scrollingRate * (isDesktop ? 2 : 18)), width: 18 - (scrollingRate * (isDesktop ? 2 : 18)), color: Theme.of(context).primaryColor),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text('location'.tr, style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * (isDesktop ? 2 : Dimensions.fontSizeSmall)), color: Theme.of(context).textTheme.bodyLarge!.color)),
          ]),
        ),
        const Expanded(child: SizedBox()),

        InkWell(
          onTap: () => Get.toNamed(RouteHelper.getRestaurantReviewRoute(restaurant.id)),
          child: Row(children: [
            Row(children: [
              Icon(Icons.star, color: Theme.of(context).primaryColor, size: 18 - (scrollingRate * (isDesktop ? 2 : 18))),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Text(
                restaurant.avgRating!.toStringAsFixed(1),
                style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * (isDesktop ? 2 : Dimensions.fontSizeExtraSmall)), color: Theme.of(context).textTheme.bodyLarge!.color),
              ),
            ]),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text(
              '${'ratings'.tr} + ${restaurant.ratingCount}',
              style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * (isDesktop ? 2 : Dimensions.fontSizeExtraSmall)), color: Theme.of(context).primaryColor),
            ),
          ]),
        ),

        (restaurant.delivery! && restaurant.freeDelivery!) ? const Expanded(child: SizedBox()) : const SizedBox(),

        (restaurant.delivery! && restaurant.freeDelivery!) ? Row(children: [
          Icon(Icons.money_off, color: Theme.of(context).primaryColor, size: 16 - (scrollingRate * (isDesktop ? 2 : 16))),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Text(
            'free_delivery'.tr,
            style: IBMPlexSansArabicRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * (isDesktop ? 2 : Dimensions.fontSizeExtraSmall)),
              color: Theme.of(context).textTheme.bodyMedium!.color!,
            ),
          ),
        ]) : const SizedBox(),

        const Expanded(child: SizedBox()),

      ]),
    ]);
  }
}
