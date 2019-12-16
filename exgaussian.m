function [p, equation_used] = exgaussian(x, mu, sigma, lambda)

  % produces a normalized exponentially-modified gaussian kernel
  % https://en.wikipedia.org/wiki/Exponentially_modified_Gaussian_distribution

  % computing this function is difficult due to arithmetic overflow
  % Delley 1985 and Kalambet et al. 2011 provides better ways of computing the function
  % https://pubs.acs.org/doi/abs/10.1021/ac00279a094
  % https://onlinelibrary.wiley.com/doi/abs/10.1002/cem.1343

  %% Arguments:
  %   x: the bandwidth of the kernel, as integral values
  %     if x is a scalar, the support of the distribution is 1:x
  %       and x is called the bandwidth
  %     if x is a vector, it is taken as-is
  %   mu, sigma, and lambda are three parameters of the kernel
  %% Outputs:
  %   p is the kernel as a 1 x n vector

  %% Parameters
  % which functional form should be used is determined by the value
  % of the function z

  equation_used = 0;

  tau = 1 / lambda;

  for ii = 1:length(x)
    z = 1 / sqrt(2) * (sigma/tau - (x(ii) - mu)/sigma);

    if z < 0
      % use the first formula
      equation_used = 1;
      p(ii) = sigma/tau * sqrt(pi/2) * exp(1/2 * (sigma/tau).^2 - (x(ii) - mu)/tau) .* erfc(z);
    elseif z > 6.71e3
      % use the third formula
      equation_used = 3;
      p(ii) = exp(-1/2 * ((x(ii) - mu)/sigma) .^ 2) ./ (1 + (x(ii) - mu) * tau/sigma.^2);
    else
      % use the second formula
      equation_used = 2;
      p(ii) = exp(-1/2 * ((x(ii) - mu)/sigma).^2) .* sigma / tau * sqrt(pi/2) .* exp(z.^2) .* erfc(z);
    end

  end

  % assert(all(rem(x, 1) == 0), 'x must be comprised of integer values')
  %
  % if isscalar(x)
  %   x = 1:x;
  % end
  %
  % if nargin == 1
  %   mu = 1;
  %   sigma = 1;
  %   lambda = 1;
  % end
  %
  % % precompute some values
  % a = lambda / 2;
  % b = lambda * sigma * sigma;
  %
  % p = a * exp(a * (2*mu + b - 2*x)) .* erfc((mu + b - x) / (sqrt(2) * sigma));

end
