function [adve, advIm] = compute_advective_2d( V, N, B, dx, stencil, rho)

Nx = size(V,2); Ny = size(V,3);
dS = dx(1) * dx(2); % Pixel area
adve = 0; advIm = zeros(Nx,Ny);

% Looping over the image and computing advective components ...
for j = 2:Ny-1
  if(max(B(:,j)) < 0.5) % checking for any contributions to the sum
    continue
  end
  for i = 2:Nx-1
    advIm(i,j) = 0.5 * rho * dS * B(i,j) * dot(mean2d(V,i,j,stencil),mean2d(V,i,j,stencil)) * dot(mean2d(V,i,j,stencil),N);
    adve = adve + advIm(i,j);
  end
end
