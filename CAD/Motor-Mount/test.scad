radius = .25;
difference() {
    cube([1, 1, 1], center=true);
    cylinder(h=1.1, r=radius, center=true, $fn=100);
}

color(BLACK)
translate([0, 0, .51])
circle_center(radius=radius, size=DIM_HOLE_CENTER,
    line_width=DIM_LINE_WIDTH);