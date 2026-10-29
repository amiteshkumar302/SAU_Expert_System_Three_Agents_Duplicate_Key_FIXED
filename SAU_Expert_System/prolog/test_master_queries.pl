% Run with:
% swipl -q -s master.pl -s test_master_queries.pl -g run_tests -t halt

run_tests :-
    ask('What master courses are available?', A1), writeln(A1),
    nl,
    ask('What is the eligibility for all master programmes?', A2), writeln(A2),
    nl,
    ask('What is the eligibility for MCA?', A3), writeln(A3),
    nl,
    ask('What is the eligibility for MTech CSE?', A4), writeln(A4).
