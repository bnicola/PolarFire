project compileall
vsim -gui work.scheduler -t ns
restart -f
view structure
view wave

add wave -noupdate -divider {Scheduler}
add wave -noupdate -expand  -group Scheduler
add wave -noupdate -group Scheduler -radix hex {clk}
add wave -noupdate -group Scheduler -radix hex {rst_n}
add wave -noupdate -group Scheduler -radix hex {write}
add wave -noupdate -group Scheduler -radix hex {read}
add wave -noupdate -group Scheduler -radix hex {value}
add wave -noupdate -group Scheduler -radix hex {writepointer}
add wave -noupdate -group Scheduler -radix hex {writepointer_cnt}
add wave -noupdate -group Scheduler -radix hex {sched_regs}
add wave -noupdate -group Scheduler -radix dec {internal_counter}
add wave -noupdate -group Scheduler -radix dec {current_time}
add wave -noupdate -group Scheduler -radix hex {triger_reg}
add wave -noupdate -group Scheduler -radix hex {trigger}
 
restart -f
view structure
view signals
view wave
 
force -freeze sim:/clk 1 0, 0 {5 ns} -r 10

force -freeze sim:/rst_n 0 0
force -freeze sim:/rst_n 1 10

force -freeze sim:/write  1 340
force -freeze sim:/write  0 350
force -freeze sim:/value  10#100 340
force -freeze sim:/value  10#0 350

force -freeze sim:/write  1 380
force -freeze sim:/write  0 390
force -freeze sim:/value  10#150 380
force -freeze sim:/value  10#0 390

force -freeze sim:/write  1 1900
force -freeze sim:/write  0 1910
force -freeze sim:/value  10#200 1900
force -freeze sim:/value  10#0 1910

force -freeze sim:/read  1 2100
force -freeze sim:/read  0 2110

force -freeze sim:/write  1 2500
force -freeze sim:/write  0 2510
force -freeze sim:/value  10#250 2500
force -freeze sim:/value  10#0 2510

force -freeze sim:/write  1 2780
force -freeze sim:/write  0 2790
#1 millisecond
force -freeze sim:/value  10#100_000 2780
force -freeze sim:/value  10#0 2790
   
WaveRestoreZoom {0 ns} {1000 ns}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {130 ns}
configure wave -namecolwidth 312
configure wave -valuecolwidth 140
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2    
#Run for 130 ns
run 2000000
