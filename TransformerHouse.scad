include <Config.inc>
include <Constants.inc>
use     <CopyMirror.scad>

$fn = 64;

TransformerHouse();

module TransformerHouse() {
    TrafoWithBlades();
    Top();
    
    module TrafoWithBlades() {
        TrafoBody();
        copy_mirror(Y_AXIS) {
            translate([0, trafo_depth/2]) {
                rotate(90, Z_AXIS) Blades(6);
            }
        }

        copy_mirror(X_AXIS) {
            for(i=[-1:1]) translate([0,i*blade_pitch2]) {
                translate([trafo_width/2, 0]) {
                    Blades(3);
                }
            }
        }

        copy_mirror(X_AXIS) copy_mirror(Y_AXIS) {
            translate([
                trafo_width/2 - trafo_radius,
                trafo_depth/2 - trafo_radius]
            ) {
                rotate(45) translate([trafo_radius,0]) Blade();
            }
        }
        
        module TrafoBody() {
            linear_extrude(trafo_height) minkowski() {
                square([
                    trafo_width  - 2 * trafo_radius,
                    trafo_depth - 2 * trafo_radius
                ], true);
                circle(r=trafo_radius);
            }
        }
        
        module Blades(n) {
            for(i=[-(n-1)/2:(n-1)/2]) {
                translate([0, i*blade_pitch]) Blade();
            }
        }
        
        module Blade() {
            translate([0,0,blade_position]) { 
                rotate(90, X_AXIS) {
                    linear_extrude(blade_thickness, center=true) hull() {
                        translate([0, blade_radius]) {
                            circle(r=blade_radius);
                        }
                        translate([0, blade_height - blade_radius]) {
                            circle(r=blade_radius);
                        }
                    }
                }
            }
        }
    }
    
    module Top() {
        for(p=[[2,-9], [2, -4.5],[2.5,2], [2.5, 7]]) translate(p) {
            Bultje();
        }

        for(p=[[-2.5,-6],[-2,1], [-2, 9]]) translate(p) {
            rotate(180) Bultje();
        }

        translate([trafo_width/3,trafo_depth/4, trafo_height]) {
            cube([0.8, trafo_width/1.5, 3], center=true);
        }
        translate([-trafo_width/3,trafo_depth/4, trafo_height]) {
            cube([0.8, trafo_width/1.5, 3], center=true);
        }
        
        module Bultje() {
            translate([0,0,trafo_height - 2.5]) {
                rotate(15, Y_AXIS) {
                    cylinder(d1=5, d2=3, h=5);
                    translate([0,0,5]) sphere(d=2);
                }
            }
        }
    }
}