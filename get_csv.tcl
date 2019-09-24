run_hw_ila [get_hw_ilas -of_objects [get_hw_devices xc7a35t_0] -filter {CELL_NAME=~"u_ila_0"}]
wait_on_hw_ila [get_hw_ilas -of_objects [get_hw_devices xc7a35t_0] -filter {CELL_NAME=~"u_ila_0"}]
write_hw_ila_data -csv_file [get_property DIRECTORY [current_project]]/trace.csv [upload_hw_ila_data hw_ila_1]