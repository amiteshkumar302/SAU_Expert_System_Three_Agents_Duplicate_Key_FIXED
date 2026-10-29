% Course recommendation knowledge and transparent rules.
% Thresholds here are advisory screening values drawn from existing admission.pl
% for the specified programmes; never represent an admission probability.
% programme_profile(Id, Qualification, MinPercent, RequiredSubjects, Interests).
programme_profile(btech_cse, class12, 65, pcm, [ai,programming,cybersecurity,computer_science]).
programme_profile(dual_btech_mtech_cse, class12, 65, pcm, [ai,programming,computer_science]).
programme_profile(btech_math_computing, class12, 65, pcm, [mathematics,ai,data_science]).
% For programmes without verified numeric criteria, do not invent a threshold.
programme_profile(integrated_bs_ms, class12, unknown, science, [science,research,mathematics]).
programme_profile(integrated_bba_mba, class12, unknown, any, [business,management]).
programme_profile(mca, bachelor, 55, mathematics, [programming,computer_science,ai]).
programme_profile(msc_computer_science, bachelor, 55, cs_relevant, [computer_science,ai,programming,research]).
programme_profile(msc_applied_math, bachelor, 55, mathematics, [mathematics,data_science,research]).
programme_profile(mtech_cse, bachelor, 55, engineering_cs, [computer_science,ai,cybersecurity,research]).
programme_profile(ms_business_analytics_ai, bachelor, unknown, any, [ai,data_science,business]).
programme_profile(mba, bachelor, unknown, any, [business,management]).

% subject match: unknown profile is NOT equivalent to eligibility.
subject_fit(any, _).
subject_fit(pcm, pcm).
subject_fit(pcm, science_pcm).
subject_fit(science, pcm).
subject_fit(science, science_pcm).
subject_fit(mathematics, mathematics).
subject_fit(mathematics, pcm).
subject_fit(mathematics, cs_with_math).
subject_fit(cs_relevant, computer_science).
subject_fit(cs_relevant, cs_with_math).
subject_fit(engineering_cs, btech_cse).
subject_fit(engineering_cs, computer_science_engineering).

% A missing subject match is flagged for review, not treated as rejection.
recommendation_candidate(Qualification, Marks, Background, Interest, Id, Score, Status) :-
    number(Marks), Marks >= 0, Marks =< 100,
    programme_profile(Id, Qualification, Minimum, Requirement, Interests),
    ( Minimum == unknown -> MarkStatus = 'Minimum marks need official verification', MarkPoints = 0
    ; Marks >= Minimum -> MarkStatus = 'Meets indicative marks threshold', MarkPoints = 20
    ; MarkStatus = 'Below stored minimum marks threshold', MarkPoints = -50
    ),
    ( subject_fit(Requirement, Background) -> SubjectStatus = 'Background matches stored requirement', SubjectPoints = 20
    ; SubjectStatus = 'Subject/degree requirement needs checking', SubjectPoints = 0
    ),
    ( member(Interest, Interests) -> InterestPoints = 60 ; InterestPoints = 0 ),
    Score is InterestPoints + MarkPoints + SubjectPoints,
    format(atom(Status), '~w; ~w. Official admission tests and full eligibility still need checking.', [MarkStatus, SubjectStatus]).
