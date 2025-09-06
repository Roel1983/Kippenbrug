include <Config.inc>
use <Utils.scad>
use <BridgeSide.scad>

BridgeDeck(printable = true);

module BridgeDeck(printable = false) {
    if (!printable) {
        rotate(90, [1,0,0]) BridgeDeck(true);
    } else {
        GroundClip(bridge_length, bridge_width) {
            translate([0,-deck_thickness/2]) {
                render() difference() {
                    linear_extrude(bridge_width, center = true, convexity=3) {
                        union() {
                            Railling(deck_thickness);
                            copy_mirror([1,0]) for(f = [0.05:0.1:1.0]) {
                                translate([
                                    -bridge_length/2 + ramp_length * f,
                                    bridge_height * f
                                ]) square(deck_thickness);
                            }
                        }
                    }
                    copy_mirror([0,0,1])
                    translate([0,0,bridge_width/deck_thickness - .5]) {
                        linear_extrude(bridge_width/2, convexity=3) {
                            difference() {
                                Railling(deck_thickness - 2 * nozzle);
                                PlaceVerticals() {
                                    square([1.4,2], true);
                                    Empty();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}