function y = frameAssembler(frames, overlap)
%FRAMEASSEMBLER Window and overlap-add grain frames with weight correction.
    [N, numFrames] = size(frames);
    if N < 2 || numFrames < 1 || overlap < 1 || ...
            overlap ~= floor(overlap) || mod(N, overlap) ~= 0
        error('Provide at least one frame and a valid overlap divisor.');
    end
    hop = N / overlap;
    win = hann(N, 'periodic');
    y = zeros((numFrames - 1) * hop + N, 1);
    weights = zeros(size(y));
    for k = 1:numFrames
        indices = (k - 1) * hop + (1:N);
        y(indices) = y(indices) + frames(:, k) .* win;
        weights(indices) = weights(indices) + win;
    end
    valid = weights > eps;
    y(valid) = y(valid) ./ weights(valid);
end
