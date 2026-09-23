function [frames, numFrames] = audioFrames(x, N, overlap)
%AUDIOFRAMES Split mono audio into zero-padded, overlapping frames.
% overlap is a divisor: 2 gives 50% overlap, 4 gives 75% overlap.
    if ~isvector(x) || isempty(x) || N < 2 || N ~= floor(N) || ...
            overlap < 1 || overlap ~= floor(overlap) || ...
            mod(N, overlap) ~= 0
        error('Provide nonempty mono audio and integer N/overlap with overlap dividing N.');
    end
    x = x(:);
    hop = N / overlap;
    numFrames = max(1, ceil((numel(x) - N) / hop) + 1);
    frames = zeros(N, numFrames);
    for k = 1:numFrames
        first = (k - 1) * hop + 1;
        last = min(first + N - 1, numel(x));
        frames(1:last-first+1, k) = x(first:last);
    end
end
