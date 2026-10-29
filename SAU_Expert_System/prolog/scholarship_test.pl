% Run from the prolog directory:
% swipl -q -s scholarship_test.pl
:- consult('master.pl').

run :-
    ask("it can provide scolarship for mtech student", A1),
    writeln(A1),
    ask("What scholarship is available for PhD CSE?", A2),
    writeln(A2),
    halt.

:- initialization(run, main).
