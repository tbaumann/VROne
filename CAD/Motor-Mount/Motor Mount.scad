outer_hole_ring_d = 115;
outer_limit = 136;

difference(){
    linear_extrude(20)
        2d_baseplate();
    inner_bolts(65/2) cylinder(h=6, d=16, center=false); 
}

module inner_bolthole(){
    union(){
        cylinder(h=20, d=10, center=false);
        cylinder(h=6, d=16, center=false);
    }
}

module inner_bolts(radius){
    
      for (i = [1 : 3])
      rotate([0,0,i*(360/3)]) translate([radius,0]) children(0);
}

module 2d_baseplate(){
    radiuses = outer_limit - outer_hole_ring_d;
    difference(){
    hull(){
        translate([outer_hole_ring_d/2,0,0]){ 
            circle(r=radiuses);
        }
        translate([-(outer_hole_ring_d/2),0,0]){ 
            circle(r=radiuses);
        }
    
        translate([0,outer_hole_ring_d/2,0]){ 
            circle(r=radiuses);
        }
        translate([0,-(outer_hole_ring_d/2),0]){ 
            circle(r=radiuses);
        }
    }
    circle(d=45);
    translate([-50,0,0]) square([100,35], center=true);
    
            translate([outer_hole_ring_d/2,0,0]){ 
            circle(d=6);
        }
      
        translate([0,outer_hole_ring_d/2,0]){ 
            circle(d=6);
        }
        translate([0,-(outer_hole_ring_d/2),0]){ 
            circle(d=6);
        }
    inner_bolts(65/2) circle(d=10);
}
}