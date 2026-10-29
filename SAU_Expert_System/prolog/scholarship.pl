% ============================================================
% SAU SCHOLARSHIP / FINANCIAL SUPPORT KNOWLEDGE BASE
% ============================================================

% PhD Entrance Test Mode scholarship/stipend.
phd_entrance_scholarship(science,39000,inr,monthly).
phd_entrance_scholarship(other,36000,inr,monthly).

travel_support(80000,inr,total_phd_tenure).
direct_mode_stipend(false).

scholarship_rule(phd,
 'PhD scholarships through Entrance Test Mode are awarded according to notified faculty/department scholarship numbers and merit').
scholarship_rule(phd,
 'Merit is based on combined performance in the SAU Entrance Test and interview').
scholarship_rule(phd,
 'Direct Mode PhD students do not receive fellowship/stipend under the stated PhD rules').
scholarship_rule(phd,
 'Travel Support of INR 80,000 is available during total PhD tenure, excluding extension, subject to SAU rules').

% Programme-specific scholarship status.
% Do NOT infer PhD scholarships for non-PhD programmes.
programme_scholarship(btech_cse,
 'No programme-specific scholarship rule is stored in the current SAU knowledge base; check the current B.Tech admission notice for available scholarships or fee concessions').
programme_scholarship(dual_btech_mtech_cse,
 'No programme-specific scholarship rule is stored in the current SAU knowledge base; check the current admission notice for available scholarships or fee concessions').
programme_scholarship(btech_math_computing,
 'No programme-specific scholarship rule is stored in the current SAU knowledge base; check the current admission notice for available scholarships or fee concessions').

programme_scholarship(mca,
 'No programme-specific scholarship rule is stored in the current SAU knowledge base; check the current admission notice for available scholarships or fee concessions').
programme_scholarship(msc_computer_science,
 'No programme-specific scholarship rule is stored in the current SAU knowledge base; check the current admission notice for available scholarships or fee concessions').
programme_scholarship(mtech_cse,
 'No programme-specific scholarship/stipend rule is stored in the current SAU knowledge base for MTech CSE. The PhD scholarship rules do not apply to MTech students; check the current MTech admission notice for any scholarship or fee concession').

programme_scholarship(mba,
 'No programme-specific scholarship rule is stored in the current SAU knowledge base; check the current MBA admission notice for available scholarships or fee concessions').

programme_scholarship(Programme, Answer) :-
    programme(Programme, _, doctoral, _, _),
    Answer = 'PhD scholarship rules apply to this programme. Entrance Test Mode scholarship is subject to notified faculty/department scholarship numbers and merit; Direct Mode students do not receive fellowship/stipend under the stated PhD rules'.

scholarship_answer(Programme, Name, Answer) :-
    ( programme_scholarship(Programme, AnswerText) ->
        format(atom(Answer), 'Scholarship / financial support for ~w:\n- ~w', [Name,AnswerText])
    ; programme(Programme, _, doctoral, _, _) ->
        findall(R, scholarship_rule(phd,R), Raw),
        sort(Raw, Rules),
        scholarship_lines(Rules, Text),
        format(atom(Answer), 'Scholarship / financial support for ~w:\n- ~w', [Name,Text])
    ; format(atom(Answer),
        'Scholarship information for ~w: No programme-specific scholarship rule is currently stored in the knowledge base. The PhD scholarship rules do not apply to this non-PhD programme. Check the current SAU admission notice for applicable scholarships or fee concessions.',
        [Name])
    ).

scholarship_lines([], '').
scholarship_lines([H], H).
scholarship_lines([H|T], Text) :-
    scholarship_lines(T, Rest),
    format(atom(Text), '~w\n- ~w', [H,Rest]).


% ============================================================
% 2026-27 SCHOLARSHIP / STIPEND DETAIL (official admissions data)
% ============================================================
financial_info_year('2026-27').
phd_fellowship_amount(science,39000,inr,per_month).
phd_fellowship_amount(other,36000,inr,per_month).
phd_scholarship_mode(entrance_test_mode).
phd_scholarship_selection('Scholarships are for PhD candidates admitted through SAU Entrance Test Mode, limited to the number notified for the respective Faculty/Department').
phd_scholarship_selection('Merit is based on combined performance in the SAU Entrance Test and subsequent interview').
phd_entrance_minimum('At least 50% marks separately in the SAU Entrance Test and interview are required for admission through Entrance Test Mode').
phd_direct_financial_support('Direct Mode PhD students do not receive SAU fellowship/stipend; Direct Mode has a 75% semester-fee concession under the 2026-27 guidelines').
phd_travel_support(80000,inr,total_tenure,'Available to PhD students admitted through Entrance Test Mode or Direct Mode; excludes extension period').
phd_science_stream('Computer Science & Engineering').
phd_science_stream('Biotechnology').
phd_science_stream('Mathematics').
phd_science_stream('Physics').
phd_science_stream('Chemistry').
phd_science_stream('Climate Change').

% No official 2026-27 general Master's scholarship is stated on SAU's scholarship page.
master_scholarship_status('The official SAU Admissions 2026-27 scholarship page currently specifies scholarships for PhD Entrance Test Mode; it does not state a general university scholarship/stipend for Master/PG students. Do not apply the PhD fellowship to Master students. Check the current programme/admission notice for any programme-specific scholarship or fee concession.').

phd_stipend_answer(Answer) :-
    format(atom(Answer),
      'SAU PhD scholarship/fellowship (2026-27):\n- Entrance Test Mode: INR 39,000/month for Science streams and INR 36,000/month for Other streams, subject to the number of scholarships notified for the Faculty/Department.\n- Merit: combined SAU Entrance Test + interview performance.\n- Entrance admission requires at least 50% separately in the Entrance Test and interview.\n- Direct Mode: no SAU fellowship/stipend; 75% semester-fee concession applies under the 2026-27 guidelines.\n- Travel support: INR 80,000 during total PhD tenure for Entrance Test or Direct Mode, excluding extension.\nNote: SAU states the Entrance-mode semester fee is adjusted from the monthly scholarship; always use the current admission notice for the applicable batch.', []).

master_scholarship_answer(Answer) :-
    master_scholarship_status(Status),
    format(atom(Answer),'SAU Master/PG scholarship information (2026-27):\n- ~w',[Status]).
