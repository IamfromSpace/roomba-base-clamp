/* Based on https://www.thingiverse.com/thing:468828 by zeus
 * (https://www.thingiverse.com/zeus/designs) under the Creative Commons -
 * Attribution - Non-Commercial - Share Alike License.
 *
 * This work shares the license of the original.
 */

// roomba dock mount
// some base measures of the original charger:
// overall width: 132mm
// effective upper width: 118.5mm
// effective upper depth: 44mm
// offset to wall: ~8mm

$fn=25;
measured_w=118.5;
measured_d=44;
bracket_h=15;
bracket_gap=50;
charger_d=measured_d;
material_t=3;
bracket_spacing=1.5;
helper_w=measured_w-charger_d+bracket_spacing;

//-------------------------------------------------------------------------


module dock_mount_side(thickness){
  cube([helper_w,thickness,bracket_h],center=true);
}

module gap_side(thickness){
  difference(){
    cube([helper_w,thickness,bracket_h],center=true);
    cube([bracket_gap,thickness,bracket_h],center=true);
  }
}

module clamp(thickness){
  difference(){
    cylinder(h=bracket_h,r=charger_d/2+thickness,center=true);
    union(){
      cylinder(h=bracket_h,r=charger_d/2,center=true);
      translate([0,-charger_d/2-thickness,-bracket_h/2]){
        cube([charger_d/2+thickness,charger_d+thickness,bracket_h]);
      }
    }
  }
}

module roomba_clamp(thickness) {
  dock_mount_side(thickness);

  translate([0,-charger_d-thickness,0]){
    gap_side(thickness);
  }


  translate([-helper_w/2,-charger_d/2-thickness/2,0]){
    clamp(thickness); //left
  }

  translate([helper_w/2,-charger_d/2-thickness/2,0]){
    mirror([1,0,0]){
      clamp(thickness); //right
    }
  }
}

module bar_clamp(length, bar_size, thickness, clamp_depth_ratio) {
  translate([-length/2, 0, 0])
    difference() {
      translate([0, -thickness, bar_size * (1 - clamp_depth_ratio)])
        cube([length, bar_size + $tolerance + 2 * thickness, (bar_size + $tolerance) * clamp_depth_ratio + thickness]);
      cube([length, bar_size + $tolerance, bar_size + $tolerance/2]);
    }
}

module base_to_bar_adapter(
  bar_clamp_length,
  bar_size,
  thickness,
  clamp_depth_ratio,
  bar_clamp_separation,
  plug_clearance_height, // This needs to include the relative depression of the carpet
  flair_clearance
) {
  for (i = [-1,1]) {
    translate([i * (bar_clamp_separation + bar_clamp_length)/2, 0, 0]) {
      translate([-bar_clamp_length/2, -thickness, bar_size])
        cube([bar_clamp_length, bar_size + thickness*2 + $tolerance, plug_clearance_height + bracket_h - bar_size]);
      translate([-bar_clamp_length/2, -flair_clearance - $tolerance, plug_clearance_height])
        cube([bar_clamp_length, flair_clearance + $tolerance, bracket_h]);
      bar_clamp(bar_clamp_length, bar_size, thickness, clamp_depth_ratio);
    }
  }

  translate([0,-thickness/2 - flair_clearance - $tolerance, plug_clearance_height + bracket_h/2])
    roomba_clamp(thickness);
}

base_to_bar_adapter(15, 20.32, 3, 2/3, 30, 36, 7, $tolerance = 0.6);

