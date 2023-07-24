import SwiftUI
import MapKit

struct MapSnapshot: View {
    var coordinate: CLLocationCoordinate2D
    
    @State private var region = MKCoordinateRegion()

    var body: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: .init(),
            annotationItems: [Annotation(coordinate: coordinate)]
        ) { annotation in
            MapPin(coordinate: annotation.coordinate)
        }
        .onTapGesture {
            MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
                .openInMaps(
                    launchOptions: [
                        MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center)
                    ]
            )
        }
        .onAppear {
            setRegion(coordinate)
        }
    }

    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        )
    }
}

struct Annotation: Identifiable {
    var id = UUID()

    let coordinate: CLLocationCoordinate2D
}

struct MapSnapshot_Previews: PreviewProvider {
    static var previews: some View {
        MapSnapshot(coordinate: CLLocationCoordinate2D(latitude: 42.962858349348, longitude: -85.886878535968))
    }
}
