bridge_length = 220.0;
pier_offset   =  -7.5;
bridge_width  = 11.0;

ramp_length = 60.0;
ramp_height = 25.0;

nozzle = 0.4;

railling_height = 11.0;

*Side();
*Deck();
*Guide();
!Pier();

translate([0, -bridge_width/2]) {
    rotate(90, [1, 0, 0]) Side();
}
translate([0,  bridge_width/2]) {
    rotate(90, [1, 0, 0]) mirror([0, 0, 1]) Side();
}

rotate(90, [1,0,0]) Deck();
rotate(180) rotate(90, [1,0,0]) Deck();

color("green") rotate(90, [1,0,0]) Guide();

copy_mirror([1,0,0]) {
    translate([bridge_length/2-ramp_length - 5,0 ]) {
        rotate(90) rotate(90, [1,0,0]) Pier();
    }
}

module TopBeam() {
    difference() {
        beam_thickness = 6 * nozzle;
        translate([0, -beam_thickness / 2 + 2 * nozzle]) {
            square([bridge_width + 2 * 2*nozzle, beam_thickness], true);
        }
        translate([0, beam_thickness / 2]) {
            square([bridge_width, beam_thickness], true);
        }
    }
}

module Pier() {
    bottom_bridge_height = ramp_height - deck_thickness;
    linear_extrude(1.5) {
        translate([0, bottom_bridge_height]) TopBeam();
        copy_mirror([1,0,0]) PierBeam();
    }
    linear_extrude(1.3) BraceBeam();

    module BraceBeam() {
        beam_thickness = 6 * nozzle;
        translate([-.7, bottom_bridge_height/2]) rotate(60)
        square([bridge_width * 1.3, beam_thickness], true);
    }

    module PierBeam() {
        intersection() {
            angle = 5;
            translate([bridge_width/2 - 1.5, bottom_bridge_height]) {
                rotate(180 + angle) {
                    beam_thickness = 6 * nozzle;
                    square([beam_thickness, 
                        (bottom_bridge_height - pier_offset) / cos(angle)]);
                }
            }
            translate([0, pier_offset]) {
                square([bridge_width, bottom_bridge_height - pier_offset]);
            }
        }
    }
}

module Guide() {
    GroundClip() {
        translate([0,-1]) {
            linear_extrude(1, center = true) {
                Railling(2*nozzle);
            }
        }
    }
} 
deck_thickness = 2;
module Deck() {
    GroundClip() {
        translate([0,-1]) {
            render() difference() {
                linear_extrude(bridge_width/2) {
                    Railling(deck_thickness);
                }
                translate([0,0,bridge_width/deck_thickness - .5]) {
                    linear_extrude(bridge_width/2) {
                        difference() {
                            Railling(deck_thickness - 2 * nozzle);
                            PlaceVerticals() {
                                square([1.4,2], true);
                                Empty();
                            }
                        }
                    }
                }
                linear_extrude(.7) Railling(2*nozzle + .05);
            }
        }
    }
}

module Empty() {}

module Side() {
    GroundClip() {
        translate([0, railling_height]) {
            linear_extrude(4 * nozzle) Railling(4 * nozzle);
        }
        translate([0, railling_height * (6/8)]) {
            linear_extrude(.5) Railling(nozzle * 2);
        }
        translate([0, railling_height * (1.5/8)]) {
            linear_extrude(.3) Railling(nozzle * 2);
        }

        linear_extrude(.7) {
            PlaceVerticals() {
                Vertical(2, 0.5, 3 * nozzle);
                Vertical(-1.7, 0.5, 2 * nozzle);
            }
        }

    }
}

module Vertical(o1, o2, w) {
    translate([-w/2, -o1])
    square([w, railling_height + o1 + o2]);
}


module PlaceVerticals() {
    n1 = 4;
    n2 = 6;
    m = 4;
    
    translate([-bridge_length/2, 0]) {
        Distribute(ramp_length, ramp_height, n1, m) {
            children(0);
            children(1);
        }
    }
    translate([-bridge_length/2 + ramp_length, ramp_height]) {
        Distribute(bridge_length - 2 * ramp_length, 0, n2, m, true) {
            children(0);
            children(1);
        }
    }
    translate([bridge_length/2, 0]) {
        Distribute(-ramp_length, ramp_height, n1, m) {
            children(0);
            children(1);
        }
    }
}

module Distribute(length, height, n, m, exclude_start_end=false) {
    t = n * (m + 1);
    o = exclude_start_end ? 1 : 0;
    for (i = [o:t-o]) {
        translate([length * i / t, height * i / t]) {
            if (i % (m + 1) == 0) {
                children(0);
            } else {
                children(1);
            }
        }
    }
}


module Railling(width = 4 * nozzle) {
    copy_mirror([1, 0, 0]) {
        Ramp();
    }
    translate([0, ramp_height]) {
        square(
            [bridge_length - 2 * ramp_length, width],
            center = true
        );
    }
    
    module Ramp() {
        translate([-bridge_length/2, 0]) {
            rotate(atan2(ramp_height, ramp_length))
            translate([0,-width/2]) {
                square([norm([ramp_length, ramp_height]), width]);
            }
        }
        translate([bridge_length/2-ramp_length,ramp_height]) {
            circle(d=width, $fn=64);
        }

    }
}

module GroundClip() {
    difference() {
        children();
        translate([0, -5]) {
            cube(
                [bridge_length + 10, 10, 2*bridge_width],
                true
            );
        }
    }
}

module copy_mirror(vec) {
    children();
    mirror(vec) children();
}