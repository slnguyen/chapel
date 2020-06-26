use cuBLAS;

proc main() {

  const D = {0..2};
  var X: [D] real = [1.5, 2.5, 3.5],
      Y: [D] real = [3.5, 2.5, 1.5];

  var a = 2.5;

  const Yin = Y;
  cu_axpy(X, Y, a);

  for i in 0..2 do
    writeln(Y[i]);
        

}

