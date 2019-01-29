hole_radius=149.2/2;
$fs = 0.01;
width=170.6-2*4;


difference(){
    union(){
        intersection(){
            square([204,300], center=true);
            circle(d=223);
        }
        translate([-(112/2),0]) square([112,148.5]);
    }
    circle(d=4);
    translate([hole_radius,0]) circle(d=4);
    translate([0,hole_radius]) circle(d=4);
    translate([-hole_radius,0]) circle(d=4);
    translate([0,-hole_radius]) circle(d=4);
}


translate([110, 0]) square([50, width]);
translate([170, 0]) square([50, width]);
translate([230, 0]) square([50, width]);
translate([290, 0]) square([50, width]);
