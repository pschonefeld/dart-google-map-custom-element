// Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
// based on: dart-google-maps project https://github.com/a14n/dart-google-maps by Alexandre Ardhuin
// sample site: http://blog.blacksun.photography by Paul Korosi, Peter Schonefeld

import 'dart:async';
import 'package:google_maps/google_maps.dart';
import 'package:polymer/polymer.dart';

@CustomTag('google-map')
class GoogleMap extends PolymerElement {
  
  @published int zoom = 8;

  bool ok = false;
  Completer _mapInitCompleter = new Completer();
  MapOptions _mapOptions;
  GMap _map;

  LatLng _center; 
  num _zoom = 8;

  /// Constructor
  GoogleMap.created():super.created(){

    _zoom = zoom;
    _mapInitCompleter.future.then((_){
     mapInit();
    });
   
  }

  void mapInit() {
    
    _mapOptions = new MapOptions()
       ..zoom = _zoom
       ..center = _center
       ..mapTypeId = MapTypeId.ROADMAP
       ..disableDefaultUI = true
       ;
    
     _map = new GMap(this.shadowRoot.querySelector("#map_canvas"), _mapOptions);
      
     _map.onZoomChanged.listen((_) {
       print("zoom: ${_map.zoom}");
     });    
      
     _map.onCenterChanged.listen((_){
       print("center: ${_map.center}");
     });

  }

  //this works by polling to allow the google maps js to load
  Timer startTimeout([int milliseconds]) {
    var duration = new Duration(milliseconds:milliseconds);
    return new Timer(duration, init);
  }
  
  @override
  void domReady(){
    init();
  }
  
  void setCenter(num lat, num lng){
    if(lat == null || lng == null){
      _map.center = _center;
    }
    else {
      _map.center = new LatLng(lat, lng);
    }
  }

  void init(){
    try {
      _center = new LatLng(-42.01572594352112, 146.51803852031253);
      _mapInitCompleter.complete(null);
    }
    catch(_){
      startTimeout(500);
    }
  }
  
}
