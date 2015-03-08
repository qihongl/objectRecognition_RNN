function d = dsum( varargin )
%DSUM compute the direct sum.
% Build a matrix with the specified matrices on the main diagonal.
% by: Peter J. Acklam

    % the number of input args 
    nargsin = nargin;

    % Calculate the size of the output matrix.
    rows = 0; cols = 0;
    for k = 1:nargsin
        [ r, c, d ] = size( varargin{k} );
        if d > 1
            error( 'Matrices can not have higher dimesion than 2' );
        end
        rows = rows + r;
        cols = cols + c;
    end

    % construct the direct sum matrix 
    d = zeros( rows, cols );
    i = 0; j = 0;
    for k = 1:nargsin
        [ r, c ] = size( varargin{k} );
        d( i+1:i+r , j+1:j+c ) = varargin{k};
        i = i + r;
        j = j + c;
    end
    
end % end of def. of dsum