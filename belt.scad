// ===== ПАРАМЕТРЫ =====

square_size     = 20;   // сторона квадрата (мм)
cutout_size     = 16;    // сторона квадратного выреза (мм)
count_x         = 9;    // количество обычных квадратов по X
count_y         = 2;    // количество квадратов по Y
extrusion_layer = 0.2;   // толщина основной экструзии (мм)
thickness_z     = extrusion_layer*3;

// Круглые вырезы
circle_diameter = 6.25;    // диаметр круглых отверстий (мм)
cylinder_height = 2.4;    // высота цилиндров (мм)
circle_offset   = 4;    // смещение от края квадрата (мм)
layer = extrusion_layer*2; // слой над и под магнитами для их фиксации

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
        cube([square_size, square_size, cylinder_height + 2*layer]);

        for (sx = [circle_offset, square_size - circle_offset])
            for (sy = [circle_offset, square_size - circle_offset])
                translate([sx, sy, 0 + layer])
                    cylinder(
                        h = cylinder_height,
                        d = circle_diameter,
                        center = false,
                        $fn = 50
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
//translate([0,square_size * count_y,thickness_z]) rotate(a=[180,0,0]) for (y = [0 : count_y - 1]) {
for (y = [0 : count_y - 1]) {
    translate([count_x * square_size, y * square_size, 0])
        square_with_4_circles();
}
