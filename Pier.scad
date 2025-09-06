include <Config.inc>
use <Utils.scad>

Pier();

module PierFront(printable = false) {
    if (printable) {
        Pier();
    } else {
        translate([bridge_length / 2 - ramp_length - 5,0 ]) {
            rotate(90) rotate(90, [1,0,0]) Pier();
        }
    }
}
module PierBack(printable = false) {
    if (printable) {
        Pier();
    } else {
        mirror([1,0,0]) {
            translate([bridge_length / 2 - ramp_length - 5,0 ]) {
                rotate(90) rotate(90, [1,0,0]) Pier();
            }
        }
    }
}
module Pier() {
    bottom_bridge_height = bridge_height - deck_thickness;
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
}