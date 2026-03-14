function [a, g, b, c, A, B, C, D, H_ntf] = getCIFBparams(order, OSR, opt, structure)
% getDSMparams  Extract DSM coefficients + state-space for ANY order and ANY structure.
%
% Usage:
%   [a,g,b,c,A,B,C,D,H] = getDSMparams(order, OSR, opt, structure)
%
% Inputs:
%   order     = DSM order (1, 2, 3, ...)
%   OSR       = Oversampling Ratio
%   opt       = Optimization flag (0 = none, 1 = optimized zeros)
%   structure = 'CIFB', 'CIFF', 'CRFB', or 'CRFF'
%
% Outputs:
%   a,g,b,c = DSM loop-filter coefficients
%   A,B,C,D = State-space matrices
%   H_ntf   = Synthetized NTF
%
% Works with all versions of Schreier's Delta-Sigma Toolbox.

    %% --- Validate structure name ---
    structure = upper(structure);
    valid_structures = {'CIFB','CIFF','CRFB','CRFF'};
    if ~ismember(structure, valid_structures)
        error('Structure must be one of: CIFB, CIFF, CRFB, CRFF');
    end

    %% --- 1. Synthesize NTF ---
    H_ntf = synthesizeNTF(order, OSR, opt);

    %% --- 2. Extract coefficients for the chosen structure ---
    [a, g, b, c] = realizeNTF(H_ntf, structure);

    %% --- 3. Build ABCD matrix (works everywhere) ---
    ABCD = stuffABCD(a, g, b, c, structure);

    %% --- 4. Extract state-space matrices ---
    A = ABCD(1:order, 1:order);
    B = ABCD(1:order, order+1);
    C = ABCD(order+1, 1:order);
    D = ABCD(order+1, order+1);

    %% --- 5. Print results ---
    fprintf('\n=== %s %d-order DSM Parameters ===\n', structure, order);
    fprintf('a = ['); fprintf('%g ', a); fprintf(']\n');
    fprintf('b = ['); fprintf('%g ', b); fprintf(']\n');
    fprintf('g = ['); fprintf('%g ', g); fprintf(']\n');
    fprintf('c = ['); fprintf('%g ', c); fprintf(']\n\n');

end