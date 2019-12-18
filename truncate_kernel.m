function varargout = truncate_kernel(kernel, varargin)

  %% Define options

  % truncates the kernel after the maximum and after the cutoff
  options.Cutoff = 0.05;
  % normalize the kernel after truncating?
  options.Normalize = false;

  % return the options struct if output exists but no input does
  if nargout && ~nargin
    varargout{1} = options;
    return
  end

  % fill out the options struct
  options = corelib.parseNameValueArguments(options, varargin{:});

  %% Find the truncation point

  % the truncation point (the cutoff) has to be after the maximum
  % since we are assuming a unimodal kernel
  % which is to say, is monotonically decreasing after the maximum

  [~, max_index] = max(kernel);
  cutoff_index = max_index - 1 + find(kernel(max_index:end) < options.Cutoff);

  %% Truncate the kernel

  % truncate the kernel
  kernel = kernel(1:cutoff_index);

  % do we renormalize the kernel?
  if options.Normalize
    kernel = kernel / sum(kernel);
  end

  % return the kernel
  varargout{1} = kernel;

end % function
