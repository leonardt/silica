def merge():
    data_in0_valid, data_in0, data_in1_valid, data_in1, data_out_ready = yield
    while True:
        push(data_in0, data_in0_valid)

