//
//  TourMapView.swift
//  ArtAtGVSU
//
//  Created by jocmp on 6/27/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit

struct TourMapView: UIViewRepresentable {
    @Binding var pins: [TourAnnotation]
    @Binding var selectedPin: TourAnnotation?

    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedPin: $selectedPin)
    }

    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if  uiView.annotations.isEmpty {
            uiView.showAnnotations(pins, animated: false)
        }
    
        if let selectedPin = selectedPin {
            uiView.selectAnnotation(selectedPin, animated: false)
            uiView.setRegion(MKCoordinateRegion(center: selectedPin.coordinate, latitudinalMeters: 150, longitudinalMeters: 150), animated: true)
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        @Binding var selectedPin: TourAnnotation?

        init(selectedPin: Binding<TourAnnotation?>) {
            _selectedPin = selectedPin
        }

        func mapView(_ mapView: MKMapView,
                     didSelect view: MKAnnotationView) {
            guard let pin = view.annotation as? TourAnnotation else {
                return
            }
                                
            DispatchQueue.main.async {
                self.selectedPin = pin
            }
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "TourAnnotation"

            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                view.annotation = annotation
                return view
            } else {
                let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                
                let button = UIButton(type: .detailDisclosure)
                view.rightCalloutAccessoryView = button
                
                return view
            }
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            let pin = view.annotation as! TourAnnotation

            mapView.presentArtwork(pin.tourStop.artworkID)
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            guard (view.annotation as? TourAnnotation) != nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.selectedPin = nil
            }
        }
    }
}

private extension UIView {
    func presentArtwork(_ artworkID: String) {
        let controller = ArtworkDetailController()
        controller.artworkID = artworkID
        
        self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    private var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}
