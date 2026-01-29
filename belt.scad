// ===== ПАРАМЕТРЫ =====
square_size     = 15;   // сторона квадрата (мм)
cutout_size     = 6;    // сторона квадратного выреза (мм)

count_x         = 6;    // количество обычных квадратов по X
count_y         = 4;    // количество квадратов по Y

thickness_z     = 0.8  ;    // толщина основной экструзии (мм)

// Круглые вырезы
circle_diameter = 6.25;    // диаметр круглых отверстий (мм)
cylinder_height = 0.25;    // высота цилиндров (мм)
circle_offset   = 4;    // смещение от края квадрата (мм)

// ===== МОДУЛИ =====

// Квадрат с квадратным вырезом
module square_with_cutout() {
    difference() {
        square([square_size, square_size], center=false);

        translate([
            (square_size - cutout_size) / 2,
            (square_size - cutout_size) / 2
        ])
            square([cutout_size, cutout_size], center=false);
    }
}

// Квадрат с 4 круглыми вырезами
module square_with_4_circles() {
    difference() {
        cube([square_size, square_size, thickness_z]);

        for (sx = [circle_offset, square_size - circle_offset])
            for (sy = [circle_offset, square_size - circle_offset])
                translate([sx, sy, 0])
                    cylinder(
                        h = cylinder_height,
                        d = circle_diameter,
                        center = false,
                        $fn = 48
                    );
    }
}

// ===== ОСНОВНАЯ СЕТКА =====
linear_extrude(height = thickness_z)
for (x = [0 : count_x - 1]) {
    for (y = [0 : count_y - 1]) {
        translate([x * square_size, y * square_size])
            square_with_cutout();
    }
}

// ===== ДОПОЛНИТЕЛЬНЫЕ КВАДРАТЫ =====

// Перед первым
for (y = [0 : count_y - 1]) {
    translate([-square_size, y * square_size, 0])
        square_with_4_circles();
}

// После последнего
translate([0,square_size * count_y,thickness_z]) rotate(a=[180,0,0]) for (y = [0 : count_y - 1]) {
    translate([count_x * square_size, y * square_size, 0])
        square_with_4_circles();
}