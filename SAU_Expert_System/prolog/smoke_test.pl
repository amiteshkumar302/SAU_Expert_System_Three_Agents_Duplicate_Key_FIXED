:- consult('master.pl').

run_tests :-
    ask("What are the SAARC countries?", A1), writeln(A1),
    ask("What is the eligibility for PhD?", A2), writeln(A2),
    ask("What is the fee for BTech?", A3), writeln(A3).

:- initialization(run_tests, main).
