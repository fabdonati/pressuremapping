function val = gradV(Im,i,j,k,dx,stencil)

val = [ colvec(d_dx(Im,i,j,k,dx(1),stencil)) ... 
        colvec(d_dy(Im,i,j,k,dx(2),stencil)) ...
        colvec(d_dz(Im,i,j,k,dx(3),stencil)) ];