view wave
delete wave *
add wave -recursive /tb_top/*
radix -hexadecimal
run -all
wave zoom full