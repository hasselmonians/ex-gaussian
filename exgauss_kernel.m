% create an exgaussian kernel
%
% Arguments:
%   x: vector of the kernel support
%     should range from 0 to bandwidth in units of time steps
%   params
%     alpha, mu, sigma, tau
%   notch
%     if true, replaces the first value of the kernel with 0, for cross-validation

function k = exgauss_kernel(x, params, notch)

  % compute the (unnormalized) pdf
  k = exgauss_pdf(x, params(2), params(3), params(4));

  if ~exist('notch', 'var') || ~notch
    % do nothing
  else
    % notch the kernel at t = 0
    k(1) = 0;
  end

    % normalize and scale by alpha
    k = params(1) * k / sum(k);

end % function
