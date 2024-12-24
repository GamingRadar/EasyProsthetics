// Prosthetic Hand Model

// Adjustable Parameters
 // Thickness of the palm in mm
palm_width = 110; // Palm width in mm

base_circumference = 120; // Circumference of the forearm base in mm
wrist_to_base_dist = 150; // Distance from wrist to forearm base in mm

// Finger Lengths (in mm)
thumb_length = 50;
index_length = 60;
middle_length = 65;
ring_length = 60;
pinky_length = 45;

// Finger Circumferences (in mm)
thumb_circumference = 30;
index_circumference = 25;
middle_circumference = 25;
ring_circumference = 25;
pinky_circumference = 20;

// Segment Ratios for Fingers
segment_ratios = [0.4, 0.35, 0.25]; // Ratios of base, mid, and tip segments

// Helper: Rounded Segment
module rounded_segment(length, radius) {
    translate([0, 0, -radius])
        minkowski() {
            cylinder(h = length, r = radius);
            sphere(r = radius);
        }
}

// Helper: Full Finger
module finger(length, circumference, x_offset, y_offset, angle=0) {
    segment_lengths = [
        length * segment_ratios[0],
        length * segment_ratios[1],
        length * segment_ratios[2]
    ];
    segment_radii = [
        circumference / (2 * PI),
        (circumference / (2 * PI)) * 0.85,
        (circumference / (2 * PI)) * 0.7
    ];

    translate([x_offset, y_offset, 0]) {
        rotate([0, 0, angle]) {
            // Base segment
            rounded_segment(segment_lengths[0], segment_radii[0]);

            // Mid segment
            translate([0, 0, segment_lengths[0] + 15])
                rounded_segment(segment_lengths[1], segment_radii[1]);

            // Tip segment
            translate([0, 0, segment_lengths[1] + 55])
                rounded_segment(segment_lengths[2], segment_radii[2]);
        }
    }
}
// Palm with Curved Connection
module palm() {
    difference() {
        // Main Palm (flattened horizontally, slice-like)
        scale([1, ((base_circumference/100)*42) / palm_width, 1])  // Flatten in the horizontal direction
            sphere(r = palm_width / 2);

        // Hollow for Wrist Connection
        translate([0, 0, 0])
            cylinder(h =10, r = base_circumference / (2 * PI) + 5, center = false);
    }
}


// Wrist Base
module wrist_base() {
    radius = base_circumference / (2 * PI);
    difference() {
        cylinder(h = wrist_to_base_dist, r = radius);
        translate([0, 0, -1]) cylinder(h = wrist_to_base_dist + 2, r = radius - 5);
    }
}

// Full Hand Model
module prosthetic_hand() {
    // Wrist Base
    wrist_base();

    // Palm
    translate([0, 0, wrist_to_base_dist])
        palm();

    // Fingers
    finger(thumb_length, thumb_circumference, -30, 15);  // Thumb
    finger(index_length, index_circumference, -20, 45);  // Index
    finger(middle_length, middle_circumference, 0, 55);  // Middle
    finger(ring_length, ring_circumference, 20, 45);     // Ring
    finger(pinky_length, pinky_circumference, 30, 15);   // Pinky
}

// Render the Prosthetic Hand
prosthetic_hand();

