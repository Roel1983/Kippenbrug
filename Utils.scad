module GroundClip(
    length,
    width,
    thickness = 10,
    extra = 10
) {
    difference() {
        children();
        translate([0, -thickness / 2]) {
            cube([length + extra, thickness, 2 * width],
                true
            );
        }
    }
}

module copy_mirror(vec) {
    children();
    mirror(vec) children();
}

module Empty() {
}
