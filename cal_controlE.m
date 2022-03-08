function controlE = cal_controlE(control,multirotor)
    f_vec = multirotor.allocation_matrix_inv * control;
    controlE = multirotor.allocation_matrix*diag(multirotor.E)*f_vec;
end 