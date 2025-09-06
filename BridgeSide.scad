include <Config.inc>
use <Utils.scad>

BridgeSide();

module BridgeSideLeft(printable = false) {
    if (printable) {
        BridgeSide();
    } else {
        translate([0, -bridge_width / 2]) {
            rotate(90, [1, 0, 0]) BridgeSide();
        }
    }
}

module BridgeSideRight(printable = false) {
    if (printable) {
        BridgeSide();
    } else {
        translate([0,  bridge_width / 2]) {
            rotate(90, [1, 0, 0]) mirror([0, 0, 1]) BridgeSide();
        }
    }
}

module BridgeSide() {
    GroundClip(bridge_length, 10) {
        translate([0, railling_height]) {
            linear_extrude(top_railling_thickness[0]) {
                Railling(top_railling_thickness[1]);
            }
        }
        translate([0, railling_height * mid_railling_height[0]]) {
            linear_extrude(mid_railling_thickness[0][0]) {
                Railling(mid_railling_thickness[0][1]);
            }
        }
        translate([0, railling_height * mid_railling_height[1]]) {
            linear_extrude(mid_railling_thickness[1][0]) {
                Railling(mid_railling_thickness[1][1]);
            }
        }

        PlaceVerticals() {
            VerticalLong();
            VerticalShort();
        }
    }
    
    module VerticalLong() {
        Vertical(deck_thickness,
            vertical_long_thickness[1], vertical_long_thickness[0]);
    }
    
    module VerticalShort() {
        Vertical(
            -railling_height * mid_railling_height[1]
                + mid_railling_thickness[1][1]/2, 
            vertical_short_thickness[1], vertical_short_thickness[0]);
    }
    
    module Vertical(o1, w, t) {
        linear_extrude(t) {
            translate([-w/2, -o1]) {
                square([w, railling_height + o1]);
            }
        }
    }
}

module Railling(width = 4 * nozzle) {
    copy_mirror([1, 0, 0]) {
        Ramp();
    }
    translate([0, bridge_height]) {
        square(
            [bridge_length - 2 * ramp_length, width],
            center = true
        );
    }
    
    module Ramp() {
        translate([-bridge_length/2, 0]) {
            rotate(atan2(bridge_height, ramp_length))
            translate([0,-width/2]) {
                square([norm([ramp_length, bridge_height]), width]);
            }
        }
        translate([bridge_length/2-ramp_length,bridge_height]) {
            circle(d=width, $fn=64);
        }

    }
}

module PlaceVerticals() {
    n1 = 4;
    n2 = 6;
    m = 4;
    
    translate([-bridge_length/2, 0]) {
        Distribute(ramp_length, bridge_height, n1, m) {
            children(0);
            children(1);
        }
    }
    translate([-bridge_length/2 + ramp_length, bridge_height]) {
        Distribute(bridge_length - 2 * ramp_length, 0, n2, m, true) {
            children(0);
            children(1);
        }
    }
    translate([bridge_length/2, 0]) {
        Distribute(-ramp_length, bridge_height, n1, m) {
            children(0);
            children(1);
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
}