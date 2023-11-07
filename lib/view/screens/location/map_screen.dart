import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'dart:ui';

class MapScreen extends StatefulWidget {
  final AddressModel address;
  final bool fromRestaurant;
  const MapScreen({Key? key, required this.address, this.fromRestaurant = false}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late LatLng _latLng;
  Set<Marker> _markers = {};
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();

    _latLng = LatLng(double.parse(widget.address.latitude!), double.parse(widget.address.longitude!));
    _setMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'location'.tr),
      body: Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: Stack(children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _latLng, zoom: 17),
              minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              indoorViewEnabled: true,
              markers:_markers,
              onMapCreated: (controller) => _mapController = controller,
            ),
            Positioned(
              left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeLarge,
              child: InkWell(
                onTap: () {
                  if(_mapController != null) {
                    _mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _latLng, zoom: 17)));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).cardColor,
                    boxShadow: [BoxShadow(color: Colors.grey[300]!, spreadRadius: 3, blurRadius: 10)],
                  ),
                  child: widget.fromRestaurant ? Text(
                    widget.address.address!, style: IBMPlexSansArabicMedium,
                  ) : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(children: [

                        Icon(
                          widget.address.addressType == 'home' ? Icons.home_outlined : widget.address.addressType == 'office'
                              ? Icons.work_outline : Icons.location_on,
                          size: 30, color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 10),

                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                            Text(widget.address.addressType!.tr, style: IBMPlexSansArabicRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
                            )),

                            Text(widget.address.address!, style: IBMPlexSansArabicMedium),

                            (widget.address.road != null && widget.address.road!.isNotEmpty) ? Text('${'street_number'.tr}: ${widget.address.road}', style: IBMPlexSansArabicMedium) : const SizedBox.shrink(),
                            (widget.address.house != null && widget.address.house!.isNotEmpty) ? Text('${'house'.tr}: ${widget.address.house}', style: IBMPlexSansArabicMedium) : const SizedBox.shrink(),
                            (widget.address.floor != null && widget.address.floor!.isNotEmpty) ? Text('${'floor'.tr}: ${widget.address.floor}', style: IBMPlexSansArabicMedium) : const SizedBox.shrink(),

                          ]),
                        ),
                      ]),

                      Text('- ${widget.address.contactPersonName}', style: IBMPlexSansArabicMedium.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.fontSizeLarge,
                      )),

                      Text('- ${widget.address.contactPersonNumber}', style: IBMPlexSansArabicRegular),

                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _setMarker() async {
    Uint8List destinationImageData = await convertAssetToUnit8List(
      widget.fromRestaurant ? Images.restaurantMarker : Images.locationMarker, width: 120,
    );

    _markers = <Marker>{};
    _markers.add(Marker(
      markerId: const MarkerId('marker'),
      position: _latLng,
      icon: BitmapDescriptor.fromBytes(destinationImageData),
    ));

    setState(() {});
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }

}
