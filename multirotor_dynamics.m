classdef multirotor_dynamics
    properties
        % simulation time
        dt = 0.01;
        sim_t = 10;
        t
        iter
        % parameters
        m
        J
        d
        c_tau
        g = 9.81;
        allocation_matrix
        allocation_matrix_inv
        % unit vector
        e1 = [1; 0; 0];
        e2 = [0; 1; 0];
        e3 = [0; 0; 1];
        % states
        x
        v
        a
        R
        W
        dW
        % errors
        ex
        ev
        eR
        eW
        % control input
        force_moment
        rotor_thrust
        % fault control input
        fault_force_moment
        fault_rotor_thrust
        % efficiency
        E = [1;1;1;1]
    end
    methods
        function dX = dynamics(obj, t, X, F)
            dX = zeros(18, 1);
            R_now = reshape(X(7:15), 3, 3);
            W_now = X(16:18);
            f = F(1);
            M = F(2:4);
            
            dx = X(4:6);
            dv = obj.g*obj.e3 - (f/obj.m)*R_now*obj.e3;
            dR = R_now*hat_map(W_now);
            dW = obj.J\(-vec_cross(W_now, obj.J*W_now) + M);
            
            dX(1:3) = dx;
            dX(4:6) = dv;
            dX(7:15) = reshape(dR, 9, 1);
            dX(16:18) = dW;
        end
    end
    methods (Static)
        function force = forceE(multirotor,E,i)
            f_M= multirotor.allocation_matrix*diag(E)*multirotor.rotor_thrust(:,i);
            force = f_M(1);
        end
        function moment = momentE(multirotor,E,i)
            f_M= multirotor.allocation_matrix*diag(E)*multirotor.rotor_thrust(:,i);
            moment = f_M(2:4);
        end
    end
end
