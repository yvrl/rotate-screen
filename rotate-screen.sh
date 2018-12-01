#!/bin/bash
# This script rotates the screen and touchscreen input when the XF86RotateWindows button on my thinkpad X230T.  
# Pen input will be added too, i currently don't own the x230T to do so.

TouchscreenDevice='Wacom ISDv4 E6 Finger touch'
screenMatrix=$(xinput --list-props "$TouchscreenDevice" | awk '/Coordinate Transformation Matrix/{print $5$6$7$8$9$10$11$12$NF}')

# Rotation matrix
# ⎡ 1 0 0 ⎤
# ⎜ 0 1 0 ⎥
# ⎣ 0 0 1 ⎦
normal='1 0 0 0 1 0 0 0 1'
normal_float='1.000000,0.000000,0.000000,0.000000,1.000000,0.000000,0.000000,0.000000,1.000000'

#⎡ -1  0 1 ⎤
#⎜  0 -1 1 ⎥
#⎣  0  0 1 ⎦
inverted='-1 0 1 0 -1 1 0 0 1'
inverted_float='-1.000000,0.000000,1.000000,0.000000,-1.000000,1.000000,0.000000,0.000000,1.000000'

# 90° to the left 
# ⎡ 0 -1 1 ⎤
# ⎜ 1  0 0 ⎥
# ⎣ 0  0 1 ⎦
left='0 -1 1 1 0 0 0 0 1'
left_float='0.000000,-1.000000,1.000000,1.000000,0.000000,0.000000,0.000000,0.000000,1.000000'

# 90° to the right
#⎡  0 1 0 ⎤
#⎜ -1 0 1 ⎥
#⎣  0 0 1 ⎦
right='0 1 0 -1 0 1 0 0 1'
right_float='0.000000, 1.000000, 0.000000, -1.000000, 0.000000'
if [ $screenMatrix == $normal_float ] && [ "$1" != "-n" ]
then
  xrandr --output LVDS1 --rotate inverted
  xinput set-prop "$TouchscreenDevice" 'Coordinate Transformation Matrix' $inverted
elif [ $screenMatrix == $inverted_float ] && [ "$1" != "-j" ] && [ "$1" != "-n" ]
then
  xrandr --output LVDS1 --rotate left
  xinput set-prop "$TouchscreenDevice" 'Coordinate Transformation Matrix' $left
elif [ $screenMatrix == $left_float ] && [ "$1" != "-j" ] && [ "$1" != "-n" ]
then
  xrandr --output LVDS1 --rotate right
  xinput set-prop "$TouchscreenDevice" 'Coordinate Transformation Matrix' $right
else
  xrandr --output LVDS1 --rotate normal
  xinput set-prop "$TouchscreenDevice" 'Coordinate Transformation Matrix' $normal
fi
