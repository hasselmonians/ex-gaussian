function varargout = truncate_kernel(kernel, varargin)

  %% Define options

  % truncates the kernel after the maximum and after the cutoff
  options.Cutoff = 0.05;
  % normalize the kernel after truncating?
  options.Normalize = false;
  % print textual feedback
  options.Verbosity = false;

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

  [max_value, max_index] = max(kernel);
  cutoff_index = max_index - 1 + find(kernel(max_index:end) < (options.Cutoff * max_value));

  if isempty(cutoff_index)
    cutoff_index = length(kernel);
  end

  % print information about the truncation
  corelib.verb(options.Verbosity, 'ex-gaussian/truncate_kernel', ...
    ['kernel truncated at index ' num2str(cutoff_index) ' (' strlib.oval(100 * cutoff_index / length(kernel)) '%)'])

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
