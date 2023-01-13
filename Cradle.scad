include <Config.inc>
include <Constants.inc>
use <CopyMirror.scad>

$fn = 64;

Cradle();

module Cradle() {
    Loop();
    for(y=[-5,5]) translate([0,y]) Bar();

    copy_mirror(X_AXIS) copy_mirror(Y_AXIS) {
        translate([width/2, depth/5]) Knob();
    }
    copy_mirror(X_AXIS) copy_mirror(Y_AXIS) {
        translate([width/4, depth/2]) Knob();
    }
    
    module Loop() {
        mirror(Z_AXIS) {
            linear_extrude(loop_height_1) Loop2d(loop_thickness_1);
            linear_extrude(loop_height_2) Loop2d(loop_thickness_2);
        }
        
        module Loop2d(thickness = 0.8) {
            difference() {
                offset( thickness/2) BaseShape();
                offset(-thickness/2) BaseShape();
            }
        }
        
        module BaseShape() {
            minkowski() {
                square([
                    width - 2 * radius,
                    depth - 2 * radius
                ], true);
                minkowski() {
                    a = d_factor / 2;
                    scale([a,1-a]) circle(r=radius);
                    scale([1-a,a]) circle(r=radius);
                }
            }
        }
    }
    
    module Bar() {
        mirror(Z_AXIS) {
            linear_extrude(loop_height_1) {
                square([width, loop_thickness_1], true);
            }
            linear_extrude(loop_height_2) {
                square([width, loop_thickness_2], true);
            }
        }
    }
    
    module Knob() {
        cylinder(d=knob_diameter_1, h=knob_height_1);
        translate([0,0,knob_height_1-knob_height_2]) {
            cylinder(d=knob_diameter_2, h=knob_height_2);
        }
    }
}