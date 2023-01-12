
$fn = 64;

width    = 27.0;
depth    = 37.0;
d_factor = 0.4;
radius   = 8.0;

loop_thickness_1 = 0.8;
loop_thickness_2 = 1.5;
loop_height_1    = 1.5;
loop_height_2    = 0.5;

knob_height_1    = 2.7;
knob_height_2    = 1.3;
knob_diameter_1  = 2.4;
knob_diameter_2  = 4.0;

trafo_width      = 16.2;
trafo_depth      = 26.2;
trafo_radius     =  3.5;
trafo_height     = 31.6;

blade_radius     =  5.0;
blade_position   =  3.0;
blade_height     = 27.7;
blade_thickness  =  0.8;
blade_pitch      =  2.0;
blade_pitch2     =  7.0;

X_AXIS = [1,0,0];
Y_AXIS = [0,1,0];
Z_AXIS = [0,0,1];

piece1();
trafo();

module trafo() {
    trafo_with_blades();
    
    for(p=[[2,-9], [2, -4.5],[2.5,2], [2.5, 7]]) translate(p) {
        bultje();
    }

    for(p=[[-2.5,-6],[-2,1], [-2, 9]]) translate(p) {
        rotate(180) bultje();
    }

    translate([trafo_width/3,trafo_depth/4, trafo_height]) {
        cube([0.8, trafo_width/1.5, 3], center=true);
    }
    translate([-trafo_width/3,trafo_depth/4, trafo_height]) {
        cube([0.8, trafo_width/1.5, 3], center=true);
    }
}

module bultje() {
    translate([0,0,trafo_height - 2.5]) {
        rotate(15, Y_AXIS) {
            cylinder(d1=5, d2=3, h=5);
            translate([0,0,5]) sphere(d=2);
        }
    }
}

module trafo_with_blades() {
    trafo_body();
    copy_mirror(Y_AXIS) {
        translate([0, trafo_depth/2]) {
            rotate(90, Z_AXIS) blades(6);
        }
    }

    copy_mirror(X_AXIS) {
        for(i=[-1:1]) translate([0,i*blade_pitch2]) {
            translate([trafo_width/2, 0]) {
                blades(3);
            }
        }
    }

    copy_mirror(X_AXIS) copy_mirror(Y_AXIS) {
        translate([
            trafo_width/2 - trafo_radius,
            trafo_depth/2 - trafo_radius]
        ) {
            rotate(45) translate([trafo_radius,0]) blade();
        }
    }
}

module blades(n) {
    for(i=[-(n-1)/2:(n-1)/2]) {
        translate([0, i*blade_pitch]) blade();
    }
}

module blade() {
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

module trafo_body() {
    linear_extrude(trafo_height) minkowski() {
        square([
            trafo_width  - 2 * trafo_radius,
            trafo_depth - 2 * trafo_radius
        ], true);
        circle(r=trafo_radius);
    }
}

module piece1() {
    loop();
    for(y=[-5,5]) translate([0,y]) bar();

    copy_mirror(X_AXIS) copy_mirror(Y_AXIS) {
        translate([width/2, depth/5]) knob();
    }
    copy_mirror(X_AXIS) copy_mirror(Y_AXIS) {
        translate([width/4, depth/2]) knob();
    }
}

module copy_mirror(vec=undef) {
    children();
    mirror(vec) children();
}

module knob() {
    cylinder(d=knob_diameter_1, h=knob_height_1);
    translate([0,0,knob_height_1-knob_height_2]) {
        cylinder(d=knob_diameter_2, h=knob_height_2);
    }
}

module bar() {
    mirror(Z_AXIS) {
        linear_extrude(loop_height_1) {
            square([width, loop_thickness_1], true);
        }
        linear_extrude(loop_height_2) {
            square([width, loop_thickness_2], true);
        }
    }
}

module loop() {
    mirror(Z_AXIS) {
        linear_extrude(loop_height_1) loop_2d(loop_thickness_1);
        linear_extrude(loop_height_2) loop_2d(loop_thickness_2);
    }
}

module loop_2d(thickness = 0.8) {
    difference() {
        offset( thickness/2) base_shape();
        offset(-thickness/2) base_shape();
    }
}

module base_shape() {
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