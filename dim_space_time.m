clear all;

TIME = clock;
TIME = TIME(2:end-1);
TIME = strjoin(string(TIME),"_");
PLOTS_FOLDER = "plots";
PATH = PLOTS_FOLDER+"/"+TIME;
mkdir(PATH);

% parameters
s = 0.2;
types = ["General" "Banded"];
formats = ["COO" "CSR" "Full"; "Diagonal" "Ellpack-Itpack" "Full"];
time_measure_labels = ["Cputime" "Wall-clock time" "Etime"];
variable_labels = ["A" "B" "C=A*B"];
dims = [25:25:250];
ntest = 10;

for n = dims
    for t = [1 2]
        for f = [1 2 3]
            disp("size: "+ n + " type: " + types(t) + " format: " + formats(t,f));
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
            
            TIME_MEASURES(n/25,1,t,f) = mean(cpu_time);
            TIME_MEASURES(n/25,2,t,f) = mean(wall_clock);
            TIME_MEASURES(n/25,3,t,f) = mean(e_time); 
            SPACE_MEASURES(n/25,1,t,f) = mean(mem_usage_A);
            SPACE_MEASURES(n/25,2,t,f) = mean(mem_usage_B);
            SPACE_MEASURES(n/25,3,t,f) = mean(mem_usage_C);
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
            plot(dims, TIME_MEASURES(:,s,t,f));
            hold on
        end
        title(types(t) + " - " + time_measure_labels(s));
        legend(formats(t,:));
        xlabel("Dimension");
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
            plot(dims, SPACE_MEASURES(:,s,t,f));
            hold on
        end
        title(types(t) + " - " + variable_labels(s));
        legend(formats(t,:));
        xlabel("Dimension");
        ylabel("Memory Space [byte]");
        hold off
    end
    subplot(2,4,q+1);
    for f = [1 2 3]
        plot(dims, sum(SPACE_MEASURES(:,:,t,f),2));
        hold on
    end
    title(types(t) + " - Total" );
    legend(formats(t,:));
    xlabel("Dimension");
    ylabel("Memory Space [byte]");
    hold off
end
savefig(PATH+"/random_space.fig");

