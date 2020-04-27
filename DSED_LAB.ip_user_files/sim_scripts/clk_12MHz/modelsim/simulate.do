onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.clk_12MHz xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {clk_12MHz.udo}

run -all

quit -force
