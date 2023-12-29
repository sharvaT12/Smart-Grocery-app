import 'package:geolocator/geolocator.dart';
import 'package:smart_grocery_app/grocery.dart';
import 'package:smart_grocery_app/models/grocery_api.dart';
import 'package:test/test.dart';

void main() {
  group('Google Places API endpoint', () {
    test('places is not empty', () async {
      Position position = Position(
          longitude: -87.64909562987724,
          latitude: 41.87283273018325,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0);
      var apiKey = "AIzaSyA45yS-b6EQN-ITlNoOhUOScRmyk1P0V9Q";
      final NearbyPlacesResponse nearbyPlacesResponse =
          await getNearbyGroceryStores(position, "300000", apiKey);
      expect(nearbyPlacesResponse.status, "OK");
    });
  });
}
