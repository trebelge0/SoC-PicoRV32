view wave
add wave  /tb_top/clk
add wave  /tb_top/reset
add wave  /tb_top/uut/cpu/next_pc
add wave  /tb_top/uut/cpu/eoi
add wave -recursive /tb_top/uut/cpu/irq*
add wave  /tb_top/uut/gpio_sel
add wave  /tb_top/uut/gpio_ready
add wave  /tb_top/uut/gpio_rdata
add wave  /tb_top/uut/timer_sel
add wave  /tb_top/uut/timer_ready
add wave  /tb_top/uut/timer_inst/mtime
add wave  /tb_top/uut/timer_inst/mtimecmp
add wave  /tb_top/uut/ram_sel
add wave  /tb_top/uut/ram_ready
add wave  /tb_top/uut/mem_addr
add wave  /tb_top/uut/mem_wstrb
add wave  /tb_top/uut/mem_rdata
add wave -recursive /tb_top/*
radix -hexadecimal
run -all