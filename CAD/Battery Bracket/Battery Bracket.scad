batt_length=275;
batt_space=50;

rail_hight=5;
union(){
  square([batt_length * 2 + batt_space, rail_hight]);
  translate([batt_length, rail_hight])
    square([batt_space, 20]);
}