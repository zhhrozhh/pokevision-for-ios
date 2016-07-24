//
//  ViewController.swift
//  pokevision
//
//  Created by Hanghang Zhang on 7/23/16.
//  Copyright © 2016 Hanghang Zhang. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController,CLLocationManagerDelegate {
    var coreLocationManager = CLLocationManager()
    var locationManager:LocationManager!
    var lati=0.0
    var longi=0.0
    var res = NSData()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate=self
        coreLocationManager.delegate = self
        locationManager = LocationManager.sharedInstance
        getLocation()
    }

    func getLocation(){
        locationManager.startUpdatingLocationWithCompletionHandler{(latitude,longitude,status,verboseMessage,error)->() in
            self.displayLocation(CLLocation(latitude:latitude,longitude:longitude))
        }
    }
    func displayLocation(location:CLLocation){
        lati = location.coordinate.latitude
        longi = location.coordinate.longitude
        mapView.setRegion(MKCoordinateRegion(center:CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude),span:MKCoordinateSpanMake(0.05,0.05)),animated:true)
        let locationPinCoord = CLLocationCoordinate2D(latitude:location.coordinate.latitude,longitude: location.coordinate.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationPinCoord
        annotation.title = "0"
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation],animated:true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var sa: UILabel!
    @IBAction func updateLoc(sender: UIButton) {
        getLocation()
        
    }
    var pokeAnn : [MKAnnotation] = []
    @IBAction func scan(sender: UIButton) {
        let url = NSURL(string: "https://pokevision.com/map/data/"+String(lati)+"/"+String(longi))
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            self.res = data!
        }
        task.resume()
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(self.res, options: .AllowFragments)
            self.mapView.removeAnnotations(self.pokeAnn)
            if (String(json["status"]).rangeOfString("success") != nil){
                let pokelist = Array(arrayLiteral: json["pokemon"]!)[0]
                let numOfPokemon = pokelist!.count
                self.sa.text = String(numOfPokemon)+" pokemons nearby"
                self.pokeAnn = []
                for pokemon in pokelist as! [AnyObject]{
                    let pokeId = pokemon["pokemonId"] as! Int
                    let pokelat = pokemon["latitude"] as! Double
                    let pokelon = pokemon["longitude"] as! Double
                    print([pokeId,pokelat,pokelon])
                    let ann = MKPointAnnotation()
                    ann.coordinate = CLLocationCoordinate2D(latitude: pokelat,longitude: pokelon)
                    ann.title = String(pokeId)
                    ann.subtitle = "poke"
                    mapView.addAnnotation(ann)
                    self.pokeAnn.append(ann)
                }
                mapView.showAnnotations(self.pokeAnn,animated:true)
            }
        }catch{
            print("error")
        }
 
    }
    @IBAction func debug(sender: UIButton) {
        print(NSString(data:self.res,encoding: NSUTF8StringEncoding)!)
        print([lati,longi])
    }
}

