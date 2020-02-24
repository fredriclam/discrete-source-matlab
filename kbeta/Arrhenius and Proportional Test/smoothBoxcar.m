% Smoothed boxcar function
% Returns vector y = y(x), where x is a vector of nodes.
% The boxcar is of width width and centred at centre.
% The height is unity.
% Spreads out edges by sharing value between nearest nodes.
% Assumes uniform grid, and limits to a discrete delta (i.e., a value at a
% single node) such that the sum (discrete integral) remains equal to width
% times unity.

function y = smoothBoxcar(x,centre,width)

y = nan(size(x));
dx = x(2) - x(1);

leftEdge = centre-width/2;
rightEdge = centre+width/2;

% Cell edges
cellRightEdges = x + dx/2;
cellLeftEdges = x - dx/2;

% For nodes left of leftEdge
y(x < leftEdge) = max(0,min(1, ...
    (rightEdge - cellLeftEdges(x < leftEdge))/dx) - ...
    ((leftEdge - cellLeftEdges(x < leftEdge)) .* ...
    (leftEdge - cellLeftEdges(x < leftEdge) > 0))/dx);

% For nodes right of leftEdge
y(x >= leftEdge) = max(0,min(1, ...
    (rightEdge - cellLeftEdges(x >= leftEdge))/dx) - ...
    ((leftEdge - cellLeftEdges(x >= leftEdge)) .* ...
    (leftEdge - cellLeftEdges(x >= leftEdge) > 0))/dx);
