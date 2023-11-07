import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/screens/location/widget/serach_location_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickMapDialog extends StatefulWidget {
  final bool fromSignUp;
  final bool fromAddAddress;
  final bool canRoute;
  final String? route;
  final GoogleMapController? googleMapController;
  final Function(AddressModel address)? onPicked;
  const PickMapDialog({Key? key,
    required this.fromSignUp, required this.fromAddAddress, required this.canRoute,
    required this.route, this.googleMapController, this.onPicked,
  }) : super(key: key);

  @override
  State<PickMapDialog> createState() => _PickMapDialogState();
}

class _PickMapDialogState extends State<PickMapDialog> {
  GoogleMapController? _mapController;
  CameraPosition? _cameraPosition;
  late LatLng _initialPosition;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.fromAddAddress) {
      Get.find<LocationController>().setPickData();
    }
    _initialPosition = LatLng(
      double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
      double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        height: ResponsiveHelper.isDesktop(context) ? 600 : null,
        width: ResponsiveHelper.isDesktop(context) ? 600 : Dimensions.webMaxWidth,
        decoration: context.width > 700 ? BoxDecoration(
          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ) : null,

        child: GetBuilder<LocationController>(builder: (locationController) {

          return ResponsiveHelper.isDesktop(context) ?
          Padding(
            padding: const  EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.clear),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Text('type_your_address_here_to_pick_form_map'.tr, style: IBMPlexSansArabicBold),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                SearchLocationWidget(mapController: _mapController, pickedAddress: locationController.pickAddress, isEnabled: true, fromDialog: true),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                SizedBox(
                  height: 350,
                  child:  Stack(children: [
                    ClipRRect(
                      borderRadius:BorderRadius.circular(Dimensions.radiusDefault),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: widget.fromAddAddress ? LatLng(locationController.position.latitude, locationController.position.longitude)
                              : _initialPosition,
                          zoom: 16,
                        ),
                        minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                        myLocationButtonEnabled: false,
                        onMapCreated: (GoogleMapController mapController) {
                          _mapController = mapController;
                          if(!widget.fromAddAddress) {
                            Get.find<LocationController>().getCurrentLocation(false, mapController: mapController);
                          }
                        },
                        scrollGesturesEnabled: !Get.isDialogOpen!,
                        zoomControlsEnabled: false,
                        onCameraMove: (CameraPosition cameraPosition) {
                          _cameraPosition = cameraPosition;
                        },
                        onCameraMoveStarted: () {
                          locationController.disableButton();
                        },
                        onCameraIdle: () {
                          Get.find<LocationController>().updatePosition(_cameraPosition, false);
                        },
                      ),
                    ),

                    Center(child: !locationController.loading ? Image.asset(Images.pickMarker, height: 50, width: 50)
                        : const CircularProgressIndicator()),

                    Positioned(
                      bottom: 30, right: Dimensions.paddingSizeLarge,
                      child: FloatingActionButton(
                        mini: true, backgroundColor: Theme.of(context).cardColor,
                        onPressed: () => Get.find<LocationController>().checkPermission(() {
                          Get.find<LocationController>().getCurrentLocation(false, mapController: _mapController);
                        }),
                        child: Icon(Icons.my_location, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                CustomButton(
                  isBold: false,
                  radius: Dimensions.radiusSmall,
                  buttonText: locationController.inZone ? widget.fromAddAddress ? 'pick_address'.tr : 'pick_location'.tr
                      : 'service_not_available_in_this_area'.tr,
                  isLoading: locationController.isLoading,
                  onPressed: locationController.isLoading ? (){} : (locationController.buttonDisabled || locationController.loading) ? null : () {
                    if(locationController.pickPosition.latitude != 0 && locationController.pickAddress!.isNotEmpty) {
                      if(widget.onPicked != null) {
                        AddressModel address = AddressModel(
                          latitude: locationController.pickPosition.latitude.toString(),
                          longitude: locationController.pickPosition.longitude.toString(),
                          addressType: 'others', address: locationController.pickAddress,
                          contactPersonName: locationController.getUserAddress()!.contactPersonName,
                          contactPersonNumber: locationController.getUserAddress()!.contactPersonNumber,
                        );
                        widget.onPicked!(address);
                        Get.back();
                      }else if(widget.fromAddAddress) {
                        if(widget.googleMapController != null) {
                          widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                            locationController.pickPosition.latitude, locationController.pickPosition.longitude,
                          ), zoom: 16)));
                          locationController.setAddAddressData();
                        }
                        Get.back();
                      }else {
                        AddressModel address = AddressModel(
                          latitude: locationController.pickPosition.latitude.toString(),
                          longitude: locationController.pickPosition.longitude.toString(),
                          addressType: 'others', address: locationController.pickAddress,
                        );
                        locationController.saveAddressAndNavigate(
                          address, widget.fromSignUp, widget.route, widget.canRoute, ResponsiveHelper.isDesktop(context),
                        );
                      }
                    }else {
                      showCustomSnackBar('pick_an_address'.tr);
                    }
                  },
                ),

              ],
            ),
          ):
          Stack(children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.fromAddAddress ? LatLng(locationController.position.latitude, locationController.position.longitude)
                    : _initialPosition,
                zoom: 16,
              ),
              minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController mapController) {
                _mapController = mapController;
                if(!widget.fromAddAddress) {
                  Get.find<LocationController>().getCurrentLocation(false, mapController: mapController);
                }
              },
              scrollGesturesEnabled: !Get.isDialogOpen!,
              zoomControlsEnabled: false,
              onCameraMove: (CameraPosition cameraPosition) {
                _cameraPosition = cameraPosition;
              },
              onCameraMoveStarted: () {
                locationController.disableButton();
              },
              onCameraIdle: () {
                Get.find<LocationController>().updatePosition(_cameraPosition, false);
              },
            ),

            Center(child: !locationController.loading ? Image.asset(Images.pickMarker, height: 50, width: 50)
                : const CircularProgressIndicator()),

            Positioned(
              top: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
              child: SearchLocationWidget(mapController: _mapController, pickedAddress: locationController.pickAddress, isEnabled: null),
            ),

            Positioned(
              bottom: 80, right: Dimensions.paddingSizeLarge,
              child: FloatingActionButton(
                mini: true, backgroundColor: Theme.of(context).cardColor,
                onPressed: () => Get.find<LocationController>().checkPermission(() {
                  Get.find<LocationController>().getCurrentLocation(false, mapController: _mapController);
                }),
                child: Icon(Icons.my_location, color: Theme.of(context).primaryColor),
              ),
            ),

            Positioned(
              bottom: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge,
              child: CustomButton(
                buttonText: locationController.inZone ? widget.fromAddAddress ? 'pick_address'.tr : 'pick_location'.tr
                    : 'service_not_available_in_this_area'.tr,
                isLoading: locationController.isLoading,
                onPressed: locationController.isLoading ? (){} : (locationController.buttonDisabled || locationController.loading) ? null : () {
                  if(locationController.pickPosition.latitude != 0 && locationController.pickAddress!.isNotEmpty) {
                    if(widget.onPicked != null) {
                      AddressModel address = AddressModel(
                        latitude: locationController.pickPosition.latitude.toString(),
                        longitude: locationController.pickPosition.longitude.toString(),
                        addressType: 'others', address: locationController.pickAddress,
                        contactPersonName: locationController.getUserAddress()!.contactPersonName,
                        contactPersonNumber: locationController.getUserAddress()!.contactPersonNumber,
                      );
                      widget.onPicked!(address);
                      Get.back();
                    }else if(widget.fromAddAddress) {
                      if(widget.googleMapController != null) {
                        widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                          locationController.pickPosition.latitude, locationController.pickPosition.longitude,
                        ), zoom: 16)));
                        locationController.setAddAddressData();
                      }
                      Get.back();
                    }else {
                      AddressModel address = AddressModel(
                        latitude: locationController.pickPosition.latitude.toString(),
                        longitude: locationController.pickPosition.longitude.toString(),
                        addressType: 'others', address: locationController.pickAddress,
                      );
                      locationController.saveAddressAndNavigate(
                        address, widget.fromSignUp, widget.route, widget.canRoute, ResponsiveHelper.isDesktop(context),
                      );
                    }
                  }else {
                    showCustomSnackBar('pick_an_address'.tr);
                  }
                },
              ),
            ),
          ]);

        }),
      ),
    );
  }
}