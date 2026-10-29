% ============================================================
% QUICK TESTS FOR ROBUST NLP
% ============================================================

run_tests :-
    test("What are the SAARC countries?"),
    test("what is the eligibilty for phd cse"),
    test("phd cse fee tell me"),
    test("hostle policy for nepal student"),
    test("MCA admisson requirment please"),
    test("I want admission and fee for MSc computer science"),
    test("¿Cuál es la tarifa de MBA?"),
    test("मुझे PhD की फीस और योग्यता बताइए"),
    test("What is the weather today?").

test(Q) :-
    ask(Q,A),
    format("~nQ: ~w~nA: ~w~n",[Q,A]).
