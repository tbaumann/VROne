outer_hole_radius=149.2/2;
inner_hole_radius=106.4/2;
$fs = 0.01;
width=170.6-2*4;
motor_diameter=223;

d_motor_center_flange=114.3+1; // +1 for tolerance

d_center_hole=40;

swing_arm_width=80;

inch_hole_3_8=9.6;
inch_hole_5_16=9;
d2_inch_hole_3_8=12;
d2_inch_hole_5_16=12;

thickness=10;
motor_thickness=167;

swing_length=465+15;

axle_length=205+30+5;
tyre_diameter=487;
tyre_width=130;
plate_distance=axle_length-60;
motor_tilt=20;


// END variables


// Bottom Plate
baseplate_bottom();

// Top Plate
translate([0,0,plate_distance+thickness]) baseplate_top();

// Lid Not used!

translate([0,0,-90-5-1]) controller_pos() mirror([0,0,1]) controller_lid();




// Crossmember
%linear_extrude(plate_distance+2*thickness)
    crossmember_2d();


// Motor FIXME
%rotate([0,0,motor_tilt]) translate([0,0,plate_distance+thickness-motor_thickness]){
  union(){
    translate([0,0,motor_thickness]) cylinder(h=48,d=19.85);
    union(){

      linear_extrude(motor_thickness) 
        motor();
      // Motor cap
      translate([0,0,motor_thickness - (motor_thickness/2+95/2)])
        linear_extrude(95)
          translate([-(112/2),0]) square([112,148.5]);
    }
  }
}


//Controller
//%translate([0,0,-90/2]) controller_pos() cube([150, 210, 90],center=true);

// Swing axis
%translate([0,0,-(280-(plate_distance+thickness))/2])
  pivot_point()
    cylinder(d=25,h=280);


// Swing arms
/*
%translate([-swing_length+motor_diameter/2-100, -(swing_arm_width/2),0]) 
    cube([swing_length-motor_diameter,swing_arm_width,10]);
*/
difference(){
  translate([-(motor_diameter/2+tyre_diameter/2+20+60), -(swing_arm_width/2),axle_length+thickness]) 
    cube([swing_length-motor_diameter,swing_arm_width,10]);
  translate([0,0,axle_length+thickness])
  linear_extrude(thickness)
    // Axle hole
    hull(){
      wheel_axle_pos() circle(d=15.2);
      wheel_axle_pos() translate([-42,0,0]) circle(d=15.2);
    }
}



// Wheel axle 
%#wheel_axle_pos() 
  cylinder(d=10,h=axle_length+2*thickness);

// Wheel
%wheel_axle_pos()
  cylinder(d=tyre_diameter,h=tyre_width);


//beltdrive
%translate([0,0,axle_length-30])
  wheel_axle_pos()  
    cylinder(d=205,h=30);

%translate([0,0,axle_length-30])
  linear_extrude(30) hull(){
    wheel_axle_pos() circle(d=205);
    circle(d=65);
  }
  


//Suspension point
%#translate([-swing_length,0,0])
  pivot_point_no_ark()
    translate([123,115,0])
      cylinder(d=10,h=axle_length+2*thickness);


// Obstacles
%#pivot_point_no_ark(){
  translate([25/2,0,0]){
  linear_extrude(plate_distance+2*thickness)
    translate([-90,180]) square([90,5]);
  linear_extrude(plate_distance+2*thickness)
    translate([-35/2,180-35/2]) circle(d=35);
  linear_extrude(plate_distance+2*thickness)
    square([5,180]);
  }
  
  rotate([0,0,180])
  linear_extrude(plate_distance+2*thickness)
  intersection(){
  square(170);
  difference(){
    circle(r=170);
    circle(r=157);
  }
}
}

module baseplate_top(){
    baseplate("top");
}
module baseplate_bottom(){
   baseplate("bottom");
}


module baseplate(side){
  difference(){
    linear_extrude(thickness) difference(){
      union(){
        hull(){
          //Motor outline
          rotate([0,0,motor_tilt]) motor();
          
          // swing pivot meat
          pivot_point()
            translate([-35/2+2,0])
              square(35, center=true);
          
          // Crossmember corner and reference surface
          crossmember_2d();
 
          // Swing attachment nubsi
        translate([-(motor_diameter/2+40), -(swing_arm_width/2)]) 
            square([60,swing_arm_width]);
          
        }

        // Swing arms
        if(side=="bottom"){
          translate([-(motor_diameter/2+tyre_diameter/2+20+60), -(swing_arm_width/2)]) 
              square([motor_diameter/2+tyre_diameter/2+20+60,swing_arm_width]);
        }else{
          translate([-(motor_diameter/2+tyre_diameter/2-205/2), -(swing_arm_width/2)]) 
              square([motor_diameter/2+tyre_diameter/2-205/2,swing_arm_width]);
        }
        
        // Controller box
        if(side == "bottom"){  
          controller_pos()
              offset(12) square([150, 210],center=true);
        }
      }
  
      // Center hole
      if(side == "top"){
        circle(d=d_center_hole);
          rotate([0,0,255]) 
            translate([0,-d_center_hole/2,0]) 
              square([motor_diameter/2+25/2+20, d_center_hole]);
        }
        //crossmember_2d();
        translate([-motor_diameter/2-20-50, motor_diameter/2-25])
          square([50+25,25]);
        
        // Axle hole
        hull(){
          wheel_axle_pos() circle(d=15.2);
          wheel_axle_pos() translate([-42,0,0]) circle(d=15.2);
        }
        wheel_axle_pos() translate([21+15/2,0,0]) circle(d=15);

      } // End of extrusion
      
      
    // Bolt holes
    if(side == "top"){
      rotate([0,0,motor_tilt])boltholes(outer_hole_radius) 
        screw(d=inch_hole_3_8, d2=15, l=18+5);
        rotate([0,0,motor_tilt+45]) boltholes(inner_hole_radius) 
          screw(d=inch_hole_5_16, d2=15, l=15+5);
    }
    
    // Swing arm pivot
    #pivot_point()
      cylinder(d=25,h=thickness+1);
    
    // Make sure it's a semicircle
    pivot_point()
      translate([0,-25/2,0])
        cube([25,25, thickness+1]);
    
    
    // Center flange
    if(side=="top"){
      cylinder(d=d_motor_center_flange,h=3.3);
    }

    // Controller screw holes
    if(side=="bottom"){
    controller_pos(){
      controller_box_cutouts();
      translate([
        150/2-6.5,
        210/2-6.5,
        0]
      ) #cylinder(d=5,h=thickness+1);
      translate([
        -(150/2-6.5),
        210/2-6.5,
        0]
      )#cylinder(d=5,h=thickness+1);
      translate([
        150/2-6.5,
        -(210/2-6.5),
        0]
      )#cylinder(d=5,h=thickness+1);
      translate([
        -(150/2-6.5),
        -(210/2-6.5),
        0]
      )#cylinder(d=5,h=thickness+1);
      }
    }
      
  }
}


module screw(d,d2=12,pocket=5,l=20){
  cap_h=pocket+2;
  union(){
    translate([0,0,thickness-pocket]) cylinder(d=d2, h=cap_h);
    translate([0,0,thickness-l])   cylinder(d=d, h=l);

  }
}

module motor() {
    intersection(){
        square([204,300], center=true);
        circle(d=223);
    }
}

module boltholes(radius) {
   for (i = [1 : 4])
      rotate([0,0,i*90]) translate([radius,0]) children(0);
}

module crossmember_2d(){
  translate([-motor_diameter/2-20,motor_diameter/2-25])
   square(25);
}

module pivot_point(){
  rotate([0,0,-25])
    translate([motor_diameter/2+25/2,0])
      children();
}

module controller_lid(){
  difference(){
    linear_extrude(5){
      offset(12) 
        square([150, 210], center=true);
    }
    controller_box_cutouts();
  }
}

module controller_box_cutouts(){
  linear_extrude(3)
    difference(){
      offset(delta=9) 
        square([150, 210], center=true);
      square([150, 210], center=true);
    }
// Fixme m6 thread
        translate([
          150/2+4,
          210/2+4,
          0]
        ) #cylinder(d=6,h=thickness);
        translate([
          -(150/2+4),
          210/2+4,
          0]
        )#cylinder(d=6,h=thickness);
        translate([
          150/2+4,
          -(210/2+4),
          0]
        )#cylinder(d=6,h=thickness);
        translate([
          -(150/2+4),
          -(210/2+4),
          0]
        )#cylinder(d=6,h=thickness);
}

module pivot_point_no_ark(){
  translate([204/2+25/2+3,-60])
    children();
}
module controller_pos(){
  translate([-45,-0.5,0])
    rotate([0,0,90])
      children();
}

module wheel_axle_pos(){
  translate([-(motor_diameter/2+tyre_diameter/2+20),0,0])
    children();
}