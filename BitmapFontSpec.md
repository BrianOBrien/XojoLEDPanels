# Bitmap Font Control Spec

Internal LCD character map:

`" 0123456789B_-:."`

## LCD source sheet rule

The LCD PNG strips have 15 source cells across:

1. space
2. 0
3. 1
4. 2
5. 3
6. 4
7. 5
8. 6
9. 7
10. 8
11. 9
12. B
13. _
14. -
15. shared final cell for `:` and `.`

### Shared final cell
- `:` = left half of the last cell
- `.` = right half of the last cell
- both draw at half width
- both advance by half width

## PNG dimensions observed
- LCD08X13.png = 120x13 -> cell 8x13
- LCD09X13.png = 136x13 -> cell 9x13 plus 1 spare pixel in source width
- LCD13X20.png = 195x20 -> cell 13x20
- LCD15X24.png = 225x24 -> cell 15x24
- LCD39X51.png = 585x51 -> cell 39x51
- LCD55X81.png = 825x81 -> cell 55x81
- FNT12X14.png = 1920x14
- FNT18X21.png = 1728x21

## Rendering rule summary
- normal LCD glyphs use full cell crop, full draw width, full advance
- `:` uses left half of final source cell, half draw width, half advance
- `.` uses right half of final source cell, half draw width, half advance

