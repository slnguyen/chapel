use cuBLAS;

proc main() {

  type t = real(32);
  const D = {0..2};
  var X: [D] t = [1: t, 2: t, 3: t],
      Y: [D] t = [3: t, 2: t, 1: t];

  var a = 2: t;

  const Yin = Y;
  cu_axpy(X, Y, a);

  for i in 0..2 do
    writeln(Y[i]);
        

}

