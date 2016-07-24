//
//  annview.swift
//  pokevision
//
//  Created by Hanghang Zhang on 7/24/16.
//  Copyright © 2016 Hanghang Zhang. All rights reserved.
//

import Foundation
import MapKit

extension ViewController: MKMapViewDelegate {
    
    //
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        
        
        
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        
        
        anView!.image = UIImage(named:annotation.title!! + ".png")
        
        return anView
        //return nil
    }
}