use <BridgeSide.scad>
use <BridgeDeck.scad>
use <Pier.scad>

Bridge();

module Bridge() {
    BridgeSideLeft();
    BridgeSideRight();
    BridgeDeck();
    PierFront();
    PierBack();
}
