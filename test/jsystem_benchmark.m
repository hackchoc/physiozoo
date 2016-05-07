N = 250;

%% Bench 1: System vs. Jsystem
cmd = 'echo OK > /dev/null';
system_total = 0;
jsystem_total = 0;

for i = 1:N
    t_start = cputime;
    system(cmd);
    system_total = system_total + (cputime - t_start);
end   
for i = 1:N
    t_start = cputime;
    jsystem(cmd);
    jsystem_total = jsystem_total + (cputime - t_start);
end

system_total_ms = system_total / N * 1000;
jsystem_total_ms = jsystem_total / N * 1000;

fprintf('Command: "%s"\n', cmd);
fprintf(' system: %.3f [ms] average\n', system_total_ms);
fprintf('jsystem: %.3f [ms] average\n', jsystem_total_ms);

%% Bench 2: System vs. Jsystem

cmd = '/bin/ls -al';
jsystem_total = 0;
jsystem_noshell_total = 0;

for i = 1:N
    t_start = cputime;
    [~,~] = jsystem(cmd);
    jsystem_total = jsystem_total + (cputime - t_start);
end
for i = 1:N
    t_start = cputime;
    [~,~] = jsystem(cmd, 'noshell');
    jsystem_noshell_total = jsystem_noshell_total + (cputime - t_start);
end

jsystem_total_ms = jsystem_total / N * 1000;
jsystem_noshell_total = jsystem_noshell_total / N * 1000;

fprintf('Command: "%s"\n', cmd);
fprintf('jsystem:           %.3f [ms] average\n', jsystem_total_ms);
fprintf('jsystem (noshell): %.3f [ms] average\n', jsystem_noshell_total);