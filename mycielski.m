clear all 

TIME = clock;
TIME = TIME(2:end-1);
TIME = strjoin(string(TIME),"_");
PLOTS_FOLDER = "plots";
PATH = PLOTS_FOLDER+"/"+TIME;
mkdir(PATH);

INPUT_PATH = "Mycielski/";

I = [2:1:15];

for i = I
    disp(i);
    M = load(INPUT_PATH+"mycielskian"+i+".mat").Problem.A;
    MCOO = COO(height(M));
    MCOO = MCOO.Compact(M);
    MCSR = CSR(height(M));
    MCSR = MCSR.Compact(M);
    X(i-1) = height(M);
    S(i-1) = nnz(M)/height(M)^2;
    Y1(i-1) = whos("MCOO").bytes;
    Y2(i-1) = whos("MCSR").bytes;
    Y3(i-1) = 8*height(M)^2; 
end
figure;
plot(X,[Y1;Y2;Y3]);
legend(["COO" "CSR" "Full"]);
title("Mycielski - Dimension vs Space");
xlabel("Dimension");
ylabel("Space [byte]");
savefig(PATH+"/mycielski_dim_space.fig");
figure;
plot(S,[Y1;Y2;Y3]);
legend(["COO" "CSR" "Full"]);
title("Mycielski - Sparsity vs Space");
xlabel("Sparsity");
ylabel("Space [byte]");
savefig(PATH+"/mycielski_sparsity_space.fig");
