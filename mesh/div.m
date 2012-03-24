function [D] = div(V,F,X)
  % DIV Compute the numerical divergence at each vertex of a mesh of a vector
  % field defined at each face of a mesh at every face of a triangle mesh.
  %
  % D = div(V,F,X)
  %
  % Inputs:
  %   V  #vertices by 3 list of mesh vertex positions
  %   F  #faces by 3 list of mesh face indices
  %   X  #faces by 3 list of vector field values
  % Outputs:
  %   D  #faces by 3 list of divergence values
  %

  % append with 0s for convenience
  if size(V,2) == 2
    V = [V zeros(size(V,1),1)];
    if size(X,2) == 2
      X = [X zeros(size(X,1),1)];
    end
  end

  % number of domain vertices 
  n = size(V,1);

  assert(size(V,2) == size(X,2));
  assert(size(X,1) == size(F,1));

  % renaming indices of vertices of triangles for convenience
  i1 = F(:,1); i2 = F(:,2); i3 = F(:,3); 
  % #F x 3 matrices of triangle edge vectors, named after opposite vertices
  v23 = V(i3,:) - V(i2,:);  v31 = V(i1,:) - V(i3,:); v12 = V(i2,:) - V(i1,:);

  % The integrated divergence associated with vertex 𝑖 can be written as
  % ∇ · 𝑋 = 1 ∑︁ cot 𝜃1 (𝑒1 · 𝑋𝑗 ) + cot 𝜃2 (𝑒2 · 𝑋𝑗 )

  C = cotangent(V,F);
  D = sparse( ...
    [i1;i2;i3], ...
    1, ...
    [ ...
      C(:,2) .* sum(-v31.*X,2) + C(:,3).*sum(v12.*X,2) ;...
      C(:,3) .* sum(-v12.*X,2) + C(:,1).*sum(v23.*X,2) ;...
      C(:,1) .* sum(-v23.*X,2) + C(:,2).*sum(v31.*X,2) ;...
    ], ...
    n,1);

  D = full(0.5*D);
end
