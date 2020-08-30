//
//  MapViewExtension.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import MapKit

extension MKMapView {
    
    /// Resets the map view to show the entire world.
    func reset() {
        let worldRegion = MKCoordinateRegion(.world)
        region = worldRegion
    }
}
