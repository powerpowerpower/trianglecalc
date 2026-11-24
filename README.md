# OpenSCAD Triangle Generator

A standalone OpenSCAD module for generating and solving 2D triangles from arbitrary combinations of sides and angles (SSS, SAA/ASA, SAS, and SSA).

## Notation

* **`a`, `b`, `c`** — side lengths (`a = BC`, `b = AC`, `c = AB`)
* **`A`, `B`, `C`** — opposite angles in degrees
* **`calc`** — boolean flag (`false` by default). When set to `true`, enables solver mode and prints all valid SSA/SAS solutions to the console via `echo()`.

## Usage

```openscad
include <path/to/triangle.scad>;

triangle(a=0, b=0, c=0, A=0, B=0, C=0, calc=false);
```

### Basic Generation (3 Parameters)

Pass any 3 valid arguments (SSS, SAS, ASA/AAS, or SSA):

```openscad
// Equilateral triangle (SSS)
triangle(4, 4, 4);

// Two sides and included angle (SAS)
triangle(a=10, b=15, C=45);

// One side and two angles (ASA)
triangle(b=20, A=30, C=60);
```

### Solver Mode (`calc=true`)

When given at least two sides and one angle, `calc=true` finds all valid SSA and SAS triangles and outputs their parameters (sides, angles, medians, altitudes, bisectors, inradius, circumradius, and area) to the OpenSCAD console:

```openscad
// Finds 5 valid triangles: acA, abA, bcB, and two bcC solutions
triangle(a=20, b=5, c=4, A=4, B=70, C=30, calc=true);

// Finds 3 valid triangles: bcB and two bcC solutions
triangle(20, 5, 4, 0, 70, 30, true);

// Finds 2 valid triangles: both bcC solutions
triangle(20, 5, 4, 0, 0, 30, true);
```

> **Note:** SSS and AAS combinations produce at most one unique triangle, while AAA has infinitely many perimeters, so `calc=true` specifically resolves two-sides-and-an-angle (SSA / SAS) cases. For ambiguous SSA cases with 2 solutions, the module draws the triangle with the smaller perimeter and prints the second solution in the console.

## Geometry & Input Behavior

* **Coordinate Placement:** Triangles are always generated in the positive `(x, y) >= 0` quadrant for predictable `mirror()` operations, with side **`b`** aligned along the **Y-axis** to simplify `rotate_extrude()`.
* **Input Sanitization:** Non-numeric values (`""`, `undef`, `nan`, `inf`, empty vectors `[]`) are safely treated as `0` (undefined), and negative numbers are converted to `abs()`.
  ```openscad
  // Equivalent to triangle(4, 4, 4);
  triangle(4, 4, 4, "", 1/0, [[[]]], []);
  ```
* **Formula Reference:** A collection of trigonometric formulas for sides, angles, medians, altitudes, bisectors, and radii is included near the end of `triangle.scad`.

## License

Public Domain (`Kivi Reactoplast`, 2021).
