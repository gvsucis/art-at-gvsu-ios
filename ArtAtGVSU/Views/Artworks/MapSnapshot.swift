import SwiftUI
import MapKit

struct MapSnapshot: View {
    var coordinate: CLLocationCoordinate2D

    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        )
    }

    var body: some View {
        Map(
            initialPosition: .region(region),
            interactionModes: []
        ) {
            Marker("", coordinate: coordinate)
        }
        .onTapGesture {
            MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
                .openInMaps(
                    launchOptions: [
                        MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center)
                    ]
            )
        }
    }
}

struct MapSnapshot_Previews: PreviewProvider {
    static var previews: some View {
        MapSnapshot(coordinate: CLLocationCoordinate2D(latitude: 42.962858349348, longitude: -85.886878535968))
    }
}
