outer_hole_ring_d = 115;
inner_hole_ring_d = 65;
inner_hole_bore = 10;
outer_hole_bore = 8;

chamfer_distance = 136;

stock_xy = 100;
stock_z  = 20;

include <dimlines.scad>

projection(cut = false){

difference(){
    intersection(){
        rotate(45) cube([stock_xy,stock_xy, stock_z], center=true);
        cube([chamfer_distance,chamfer_distance,,stock_z], center=true);
    }
    // Center hole
    translate([0,0,-11]) cylinder(h=stock_z+10, d=30, $fn=100);

    // Outer holes
    along_radius(outer_hole_ring_d/2,4) cylinder(h=stock_z+1, d=outer_hole_bore, center=true, $fn=100);

    // Inner holes
    along_radius(inner_hole_ring_d/2,3) cylinder(h=stock_z+1, d=inner_hole_bore, center=true, $fn=100);


}
    color("Black") translate([0,0,stock_z/2 + 0.1])union(){
        
    //center
    circle_center(radius=30, size=60,  line_width=DIM_LINE_WIDTH);

    //outer
    along_radius(outer_hole_ring_d/2,4)
    circle_center(radius=outer_hole_bore/2, size=10,  line_width=DIM_LINE_WIDTH);

    //inner
    along_radius(inner_hole_ring_d/2,3)
    circle_center(radius=inner_hole_bore/2, size=10,  line_width=DIM_LINE_WIDTH);
    }
}
module along_radius(radius, times){
    
      for (i = [1 : times])
      rotate([0,0,i*(360/times)]) translate([radius,0]) children(0);
}
