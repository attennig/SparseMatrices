clear all;

TIME = clock;
TIME = TIME(2:end-1);
TIME = strjoin(string(TIME),"_");
PLOTS_FOLDER = "plots";
PATH = PLOTS_FOLDER+"/"+TIME;
mkdir(PATH);

% parameters
types = ["General" "Banded"];
formats = ["COO" "CSR" "Full"; "Diagonal" "Ellpack-Itpack" "Full"];
time_measure_labels = ["Cputime" "Wall-clock time" "Etime"];
variable_labels = ["A" "B" "C=A*B"];
n = 200;
sparsity = [0.1:0.1:0.9];
ntest = 10;

for s = sparsity
    for t = [1 2]
        for f = [1 2 3]
            disp("sparsity: "+ s + " type: " + types(t) + " format: " + formats(t,f));
            for test = [1:ntest]
                % starting time
                tic;
                startingT = clock;
                cpuT = cputime;

                % core algorithm
                A = generateSparseMatrix(s, n, types(t));
                B = generateSparseMatrix(s, n, types(t));
                if formats(t,f) == "Full"
                    C = A*B;
                else
                    AComp = toCompact(A, types(t), formats(t,f));
                    BComp = toCompact(B, types(t), formats(t,f));
                    CComp = AComp.matMulBy(BComp);
                end
                % ending time
                cpu_time(test) = cputime - cpuT;
                e_time(test) = etime(clock, startingT);
                wall_clock(test) = toc;  

                % memory occupation
                if formats(t,f) == "Full"
                    mem_usage_A(test) = whos("A").bytes;
                    mem_usage_B(test) = whos("B").bytes;
                    mem_usage_C(test) = whos("C").bytes;
                else
                    mem_usage_A(test) = whos("AComp").bytes;
                    mem_usage_B(test) = whos("BComp").bytes;
                    mem_usage_C(test) = whos("CComp").bytes;
                end
            end
            
            TIME_MEASURES(find(s==sparsity),1,t,f) = mean(cpu_time);
            TIME_MEASURES(find(s==sparsity),2,t,f) = mean(wall_clock);
            TIME_MEASURES(find(s==sparsity),3,t,f) = mean(e_time); 
            SPACE_MEASURES(find(s==sparsity),1,t,f) = mean(mem_usage_A);
            SPACE_MEASURES(find(s==sparsity),2,t,f) = mean(mem_usage_B);
            SPACE_MEASURES(find(s==sparsity),3,t,f) = mean(mem_usage_C);
        end 
    end
end

% plotting execution time
figure;
for t = [1 2]
    for s = [1 2 3]
        q = s + 3 *(t-1);
        subplot(2,3,q);
        for f = [1 2 3]
            plot(sparsity, TIME_MEASURES(:,s,t,f));
            hold on
        end
        title(types(t) + " - " + time_measure_labels(s));
        l = legend(formats(t,:));
        l.Location = 'northwest';
        xlabel("Sparsity");
        ylabel("Time [s]");
        hold off
    end
end
savefig(PATH+"/random_time.fig");

% plotting space occupation
figure;
for t = [1 2]
    for s = [1 2 3]
        q = s + 4 *(t-1);
        subplot(2,4,q);
        for f = [1 2 3]
            plot(sparsity, SPACE_MEASURES(:,s,t,f));
            hold on
        end
        title(types(t) + " - " + variable_labels(s));
        l = legend(formats(t,:));
        l.Location = 'northwest';
        xlabel("Sparsity");
        ylabel("Memory Space [byte]");
        hold off
    end
    subplot(2,4,q+1);
    for f = [1 2 3]
        plot(sparsity, sum(SPACE_MEASURES(:,:,t,f),2));
        hold on
    end
    title(types(t) + " - Total" );
    l = legend(formats(t,:));
    l.Location = 'northwest';
    xlabel("Sparsity");
    ylabel("Memory Space [byte]");
    hold off
end
savefig(PATH+"/random_space.fig");

