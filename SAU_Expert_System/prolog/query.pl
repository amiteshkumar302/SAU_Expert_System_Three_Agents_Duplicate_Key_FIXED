% ============================================================
% SAU EXPERT SYSTEM - QUERY / INFERENCE LAYER
% ============================================================
% The query layer combines NLP results with the knowledge base.
% Python/Streamlit does not contain university answers.
% ============================================================

programme_name(P, Name) :-
    programme(P, Name, _, _, _).

programme_level_name(P, Level) :-
    programme(P, _, Level, _, _).

join_lines([], '').
join_lines([H|T], Text) :-
    atomic_list_concat([H|T], '\n- ', Text).

% ------------------------------------------------------------
% Main question entry point
% ------------------------------------------------------------

answer_question(Text, Answer) :-
    normalize_text(Text, Q),
    ( financial_question(Q) ->
        financial_question_answer(Q, Answer)
    ; faculty_question(Q) ->
        answer_faculty_question(Q, Answer)
    ; domain_question(Q) ->
        answer_domain_question(Q, Answer)
    ;
        Answer = 'I am the SAU University Expert System. I can answer university-related questions about courses, admission, eligibility, fees, PhD, hostel, scholarships, faculty, research areas, subject teachers, SAARC categories, and student services. Please ask a question related to SAU.'
    ).

% Financial questions are routed BEFORE generic programme and faculty questions.
% Normalize and tokenize once; use exact canonical terms to avoid fuzzy false positives.
financial_token(Q, Term) :-
    split_string(Q, " ", "", Words),
    atom_string(Term, Word),
    memberchk(Word, Words).

financial_question(Q) :-
    member(Term, [stipend, scholarship, fellowship, stipends,
                  financialsupport, financialaid, wazifa]),
    financial_token(Q, Term), !.
financial_question(Q) :-
    ( phrase_words(Q, 'financial support')
    ; phrase_words(Q, 'financial aid')
    ; phrase_words(Q, 'monthly payment')
    ; phrase_words(Q, 'monthly amount')
    ), !.

financial_question_answer(Q, Answer) :-
    ( member(Term, [master, mtech, msc, mca, pg, postgraduate]),
      financial_token(Q, Term) ), !,
    master_scholarship_answer(Answer).
financial_question_answer(Q, Answer) :-
    ( member(Term, [phd, doctoral, doctorate]),
      financial_token(Q, Term) ), !,
    phd_stipend_answer(Answer).
financial_question_answer(_, Answer) :-
    format(atom(Answer),
      'SAU financial support (2026-27):\n- PhD Entrance Test Mode: INR 39,000/month (science) or INR 36,000/month (other streams), subject to notified scholarships and merit. Direct Mode: no SAU monthly fellowship under the stated guidelines.\n- Master/PG: no general monthly scholarship is specified on the stored official scholarship page; check the programme-specific notice.\nPlease specify PhD or Master/MTech/MSc/MCA for details.', []).

% ------------------------------------------------------------
% Faculty / subject / research routing
% ------------------------------------------------------------

faculty_question(Q) :-
    faculty_name_in_question(Q), !.
faculty_question(Q) :-
    has_intent_keyword(Q, faculty),
    ( subject_in_question(Q, _) ; research_area_in_question(Q, _) ), !.
faculty_question(Q) :-
    has_intent_keyword(Q, teacher),
    subject_in_question(Q, _), !.
faculty_question(Q) :-
    (word(Q, teach); word(Q, teaches); word(Q, teacher); word(Q, faculty); word(Q, member)),
    ( subject_in_question(Q, _) ; research_area_in_question(Q, _) ), !.

faculty_name_in_question(Q) :-
    faculty(Name, _, _, _, _),
    name_matches_question(Q, Name), !.

name_matches_question(Q, Name) :-
    normalize_text(Name, N),
    phrase_words(Q, N).

subject_in_question(Q, Subject) :-
    subject_alias(_, Subject),
    subject_phrase_matches(Q, Subject), !.

subject_phrase_matches(Q, Subject) :-
    subject_alias(Alias, Subject),
    phrase_words(Q, Alias), !.
subject_phrase_matches(Q, Subject) :-
    subject_alias(Alias, Subject),
    atom_string(Alias, AliasS),
    word(Q, AliasS), !.

research_area_in_question(Q, Area) :-
    faculty_research(_, Area),
    phrase_words(Q, Area), !.
research_area_in_question(Q, Area) :-
    faculty_research(_, Area),
    atom_string(Area, AreaS),
    word(Q, AreaS), !.

answer_faculty_question(Q, Answer) :-
    faculty_name_in_question(Q),
    !,
    faculty_detail_answer(Q, Answer).
answer_faculty_question(Q, Answer) :-
    has_intent_keyword(Q, teacher),
    subject_in_question(Q, Subject),
    !,
    subject_teacher_answer(Subject, Answer).
answer_faculty_question(Q, Answer) :-
    ( word(Q, teach); word(Q, teaches); word(Q, teacher) ),
    subject_in_question(Q, Subject),
    !,
    subject_teacher_answer(Subject, Answer).
answer_faculty_question(Q, Answer) :-
    ( has_intent_keyword(Q, research); word(Q, works); word(Q, working) ),
    research_area_in_question(Q, Area),
    !,
    research_faculty_answer(Area, Answer).
answer_faculty_question(Q, Answer) :-
    subject_in_question(Q, Subject),
    !,
    subject_faculty_answer(Subject, Answer).
answer_faculty_question(_, 'I found the faculty section, but I could not identify the exact subject or research area. Try: "Who teaches Machine Learning?", "Who works in Machine Learning?", or "Tell me about Amit Shukla?"').

faculty_detail_answer(Q, Answer) :-
    faculty_profile(Name, Designation, Department, Email, Areas, Education, Current),
    name_matches_question(Q, Name),
    !,
    atomic_list_concat(Areas, ', ', AreaText),
    format(atom(Answer),
           'Faculty: ~w\nDesignation: ~w\nDepartment / affiliation: ~w\nEmail: ~w\nResearch areas: ~w\nEducation: ~w\nCurrent / associated institution: ~w.',
           [Name, Designation, Department, Email, AreaText, Education, Current]).
faculty_detail_answer(Q, Answer) :-
    faculty(Name, Designation, Department, Email, Room),
    name_matches_question(Q, Name),
    findall(A, faculty_research(Name, A), RawAreas),
    sort(RawAreas, Areas),
    (Areas = [] -> AreaText = 'Research areas are not stored in the current knowledge base.' ; atomic_list_concat(Areas, ', ', AreaText)),
    format(atom(Answer),
           'Faculty: ~w\nDesignation: ~w\nDepartment: ~w\nEmail: ~w\nRoom: ~w\nResearch areas: ~w.',
           [Name, Designation, Department, Email, Room, AreaText]).

subject_teacher_answer(Subject, Answer) :-
    findall(Name-Code-Sem, subject_teacher(Subject, Code, Name, Sem), Raw),
    sort(Raw, Assignments),
    Assignments \= [],
    teacher_first_line(Subject, Assignments, FirstLine),
    teacher_details(Assignments, Details),
    format(atom(Answer), '~w\n~w', [FirstLine, Details]),
    !.
subject_teacher_answer(Subject, Answer) :-
    findall(Name, subject_expert(Subject, Name), Raw),
    sort(Raw, Experts),
    Experts \= [],
    atomic_list_concat(Experts, ', ', Names),
    format(atom(Answer),
           'No semester-specific teacher assignment is stored for ~w. Faculty/research experts for this subject: ~w.\nPlease use the current SAU LMS/schedule for the active teacher assignment.',
           [Subject, Names]),
    !.
subject_teacher_answer(Subject,
    'I could not verify a teacher assignment for this subject in the current SAU knowledge base.').

teacher_first_line(Subject, [Name-Code-Sem|T], Line) :-
    teacher_first_line_rest(T, Rest),
    (Rest = '' -> format(atom(Line), 'Faculty member(s) for ~w: ~w (~w, ~w).', [Subject, Name, Code, Sem]) ; format(atom(Line), 'Faculty member(s) for ~w: ~w (~w, ~w); ~w.', [Subject, Name, Code, Sem, Rest])).
teacher_first_line_rest([], '').
teacher_first_line_rest([Name-Code-Sem|T], Text) :-
    teacher_first_line_rest(T, Rest),
    (Rest = '' -> format(atom(Text), '~w (~w, ~w)', [Name, Code, Sem]) ; format(atom(Text), '~w (~w, ~w); ~w', [Name, Code, Sem, Rest])).

teacher_details([], '').
teacher_details(Assignments, Details) :-
    teacher_detail_lines(Assignments, Lines),
    atomic_list_concat(Lines, '\n- ', Details).
teacher_detail_lines([], []).
teacher_detail_lines([Name-Code-Sem|T], [Line|Rest]) :-
    format(atom(Line), 'Teacher: ~w | Course code: ~w | Batch / semester: ~w', [Name, Code, Sem]),
    teacher_detail_lines(T, Rest).

research_faculty_answer(Area, Answer) :-
    findall(Name, faculty_research(Name, Area), Raw),
    sort(Raw, Names),
    Names \= [],
    atomic_list_concat(Names, ', ', NameText),
    format(atom(Answer), 'Faculty member(s) working in ~w: ~w.\nResearch area: ~w.', [Area, NameText, Area]),
    !.
research_faculty_answer(Area, 'No faculty research mapping for this area is stored in the current knowledge base.').

subject_faculty_answer(Subject, Answer) :-
    findall(Name, subject_expert(Subject, Name), Raw),
    sort(Raw, Names),
    Names \= [],
    atomic_list_concat(Names, ', ', NameText),
    format(atom(Answer), 'Faculty member(s) associated with ~w: ~w.\nThese are subject/research experts, not necessarily the current course teachers.', [Subject, NameText]),
    !.

domain_question(Q) :-
    ( intent_candidate(Q,_)
    ; programme_from_text(Q,_)
    ; country_from_text(Q,_)
    ; word(Q, sau)
    ; word(Q, university)
    ),
    !.

answer_domain_question(Q, Answer) :-
    programme_from_text(Q, Programme),
    !,
    answer_programme_question(Q, Programme, Answer).

answer_domain_question(Q, Answer) :-
    % If the user explicitly asks for a list of courses/programmes,
    % answer that request before generic level/eligibility routing.
    explicit_course_list_request(Q),
    !,
    course_list_for_question(Q, Answer).

answer_domain_question(Q, Answer) :-
    programme_from_text(Q, Programme),
    !,
    answer_programme_question(Q, Programme, Answer).

answer_domain_question(Q, Answer) :-
    level_from_text(Q, Level),
    !,
    answer_level_question(Q, Level, Answer).

answer_domain_question(Q, Answer) :-
    intent_candidate(Q, Intent),
    !,
    answer_intent(Intent, Answer).

answer_domain_question(Q, Answer) :-
    country_from_text(Q, Country),
    !,
    country_answer(Country, Answer).

answer_domain_question(_, 'I understand that this is about SAU, but I could not identify the exact information requested. Try asking about a course, admission, eligibility, fee, hostel, scholarship, PhD or SAARC country.').

% ------------------------------------------------------------
% Course-list routing
% ------------------------------------------------------------

explicit_course_list_request(Q) :-
    ( word(Q, course)
    ; word(Q, courses)
    ; word(Q, programme)
    ; word(Q, programmes)
    ; word(Q, program)
    ; word(Q, programs)
    ),
    ( word(Q, list)
    ; word(Q, available)
    ; word(Q, offer)
    ; word(Q, offered)
    ; word(Q, study)
    ; word(Q, degree)
    ; word(Q, degrees)
    ),
    !.

course_list_for_question(Q, Answer) :-
    ( level_from_text(Q, Level) ->
        course_list_for_level(Level, Answer)
    ;
        answer_intent(list_courses, Answer)
    ).

course_list_for_level(master, Answer) :-
    findall(Name, programme(_,Name,postgraduate,_,_), Raw),
    sort(Raw, Names),
    atomic_list_concat(Names, '\n- ', Text),
    format(atom(Answer),
           'SAU Master / Postgraduate programmes currently stored in the knowledge base:\n- ~w',
           [Text]).

course_list_for_level(bachelor, Answer) :-
    findall(Name, programme(_,Name,undergraduate,_,_), Raw),
    sort(Raw, Names),
    atomic_list_concat(Names, '\n- ', Text),
    format(atom(Answer),
           'SAU Bachelor / Undergraduate programmes currently stored in the knowledge base:\n- ~w',
           [Text]).

course_list_for_level(phd, Answer) :-
    answer_intent(list_phd, Answer).

% ------------------------------------------------------------
% Programme-specific questions
% ------------------------------------------------------------

answer_programme_question(Q, Programme, Answer) :-
    programme_name(Programme, Name),
    programme_level_name(Programme, Level),
    requested_topics(Q, Topics),
    programme_answer_topics(Topics, Programme, Name, Level, RawParts),
    sort(RawParts, Parts),
    Parts \= [],
    atomic_list_concat(Parts, '\n\n', Answer),
    !.

answer_programme_question(_, Programme, Answer) :-
    programme_name(Programme, Name),
    programme_level_name(Programme, Level),
    format(atom(Answer),
           '~w is a ~w programme at SAU. You can ask about its eligibility, admission process, fee, duration, scholarship or hostel.', [Name,Level]).

requested_topics(Q, Topics) :-
    findall(T, requested_topic(Q,T), Raw),
    sort(Raw, Topics).

requested_topic(Q, admission) :-
    has_intent_keyword(Q, admission).
requested_topic(Q, fee) :-
    has_intent_keyword(Q, fee).
requested_topic(Q, hostel) :-
    has_intent_keyword(Q, hostel).
requested_topic(Q, scholarship) :-
    has_intent_keyword(Q, scholarship).
requested_topic(Q, phd) :-
    word(Q, phd).
requested_topic(Q, course) :-
    has_intent_keyword(Q, course).

programme_answer_topics([], _, _, _, []).
programme_answer_topics([admission|T], P, N, L, [A|R]) :-
    admission_programme_answer(P,N,L,A),
    programme_answer_topics(T,P,N,L,R).
programme_answer_topics([fee|T], P, N, L, [A|R]) :-
    fee_programme_answer(P,N,A),
    programme_answer_topics(T,P,N,L,R).
programme_answer_topics([hostel|T], P, N, L, [A|R]) :-
    hostel_programme_answer(N,A),
    programme_answer_topics(T,P,N,L,R).
programme_answer_topics([scholarship|T], P, N, L, [A|R]) :-
    scholarship_programme_answer(N,A),
    programme_answer_topics(T,P,N,L,R).
programme_answer_topics([phd|T], P, N, L, [A|R]) :-
    phd_programme_answer(P,N,A),
    programme_answer_topics(T,P,N,L,R).
programme_answer_topics([course|T], P, N, L, [A|R]) :-
    format(atom(A),'Programme: ~w\nLevel: ~w.',[N,L]),
    programme_answer_topics(T,P,N,L,R).

% ------------------------------------------------------------
% Admission
% ------------------------------------------------------------

admission_programme_answer(Programme, Name, _, Answer) :-
    all_requirements(Programme, Requirements),
    all_admission_modes(Programme, Modes),
    ( Requirements = [] ->
        ReqText = 'Programme-specific eligibility should be checked in the current SAU admission notice.'
    ;
        join_lines(Requirements, ReqText)
    ),
    atomic_list_concat(Modes, ', ', ModeText),
    format(atom(Answer),
           'Admission / eligibility for ~w:\n- ~w\nAdmission modes: ~w.',
           [Name,ReqText,ModeText]).

% ------------------------------------------------------------
% Fees
% ------------------------------------------------------------

fee_programme_answer(Programme, Name, Answer) :-
    ( semester_fee(Programme, Fee, Currency) ->
        format(atom(Answer),
               'Fee for ~w: ~w ~w per semester for the 2026-27 structure. General applicable fees may include Registration USD 20, Admission USD 200, Security Deposit USD 200 and Student Aid Fund USD 10 per semester. Check the current fee notice before payment.',
               [Name,Currency,Fee])
    ;
        format(atom(Answer),
               'A programme-specific semester fee is not available in the knowledge base for ~w. Please check the current SAU fee notice.',
               [Name])
    ).

% ------------------------------------------------------------
% Hostel
% ------------------------------------------------------------

hostel_programme_answer(Name, Answer) :-
    hostel_rule(distance,D),
    hostel_rule(priority,P),
    hostel_rule(allocation,A),
    format(atom(Answer),
           'Hostel information relevant to ~w:\n- ~w\n- ~w\n- ~w\nHostel admission is subject to eligibility, merit and availability.',
           [Name,D,P,A]).

% ------------------------------------------------------------
% Scholarship
% ------------------------------------------------------------

scholarship_programme_answer(Programme, Name, Answer) :-
    scholarship_answer(Programme, Name, Answer).

% ------------------------------------------------------------
% PhD
% ------------------------------------------------------------

phd_programme_answer(_, Name, Answer) :-
    phd_tenure(T),
    phd_coursework(C),
    phd_south_asia_course(S),
    phd_residency(R),
    format(atom(Answer),
           'PhD information for ~w:\n- Tenure: ~w\n- Coursework: ~w\n- Required course: ~w\n- Residency: ~w',
           [Name,T,C,S,R]).


% ------------------------------------------------------------
% Level-wide questions
% ------------------------------------------------------------

answer_level_question(Q, bachelor, Answer) :-
    level_requested_topic(Q, Topic),
    !,
    level_topic_answer(bachelor, Topic, Answer).

answer_level_question(Q, master, Answer) :-
    level_requested_topic(Q, Topic),
    !,
    level_topic_answer(master, Topic, Answer).

answer_level_question(Q, phd, Answer) :-
    level_requested_topic(Q, Topic),
    !,
    level_topic_answer(phd, Topic, Answer).

answer_level_question(_, Level, Answer) :-
    findall(Name,
            (programme(_,Name,Level,_,_)),
            Names),
    atomic_list_concat(Names, '\n- ', Text),
    format(atom(Answer), 'SAU ~w programmes:\n- ~w', [Level,Text]).

% IMPORTANT: eligibility must be checked BEFORE the generic admission
% vocabulary because "eligibility" is also an admission synonym.
level_requested_topic(Q, eligibility) :-
    (word(Q,eligibility);word(Q,eligible);word(Q,requirement);word(Q,requirements);word(Q,criteria)),
    !.
level_requested_topic(Q, fee) :- has_intent_keyword(Q,fee).
level_requested_topic(Q, admission) :- has_intent_keyword(Q,admission).
level_requested_topic(Q, hostel) :- has_intent_keyword(Q,hostel).
level_requested_topic(Q, scholarship) :- has_intent_keyword(Q,scholarship).
level_requested_topic(Q, course) :- has_intent_keyword(Q,course).

level_topic_answer(master, eligibility, Answer) :-
    % Return EVERY postgraduate programme exactly once.
    findall(Name-Reqs,
            ( programme(P,Name,postgraduate,_,_),
              findall(R, master_eligibility(P,R), RawReqs),
              sort(RawReqs, Reqs)
            ),
            RawItems),
    sort(RawItems, Items),
    master_eligibility_text(Items, Text),
    format(atom(Answer),
           'Eligibility requirements for ALL SAU Master / Postgraduate programmes:
- ~w',
           [Text]).

level_topic_answer(Level, eligibility, Answer) :-
    findall(Name-Reqs,
            level_requirements(Level,Name,Reqs),
            RawItems),
    sort(RawItems, Items),
    level_items_text(Items,Text),
    format(atom(Answer),'Eligibility requirements for SAU ~w programmes:
- ~w',
           [Level,Text]).

master_eligibility_text([], '').
master_eligibility_text([Name-Reqs], Text) :-
    atomic_list_concat(Reqs, '; ', ReqText),
    format(atom(Text), '~w: ~w', [Name, ReqText]).
master_eligibility_text([Name-Reqs|T], Text) :-
    atomic_list_concat(Reqs, '; ', ReqText),
    master_eligibility_text(T, Rest),
    format(atom(Text), '~w: ~w
- ~w', [Name, ReqText, Rest]).

level_topic_answer(Level, admission, Answer) :-
    findall(Name-Modes,
            (programme(P,Name,Level,_,_),
             all_admission_modes(P,Modes)),
            Items),
    level_items_text(Items,Text),
    format(atom(Answer),'Admission modes for SAU ~w programmes:\n- ~w',
           [Level,Text]).

level_topic_answer(Level, fee, Answer) :-
    findall(Name-Fee,
            (programme(P,Name,Level,_,_),
             semester_fee(P,Fee,usd)),
            Items),
    level_fee_items_text(Items,Text),
    format(atom(Answer),'Semester fees for SAU ~w programmes (2026-27):\n- ~w',
           [Level,Text]).

level_topic_answer(Level, course, Answer) :-
    findall(Name,
            programme(_,Name,Level,_,_),
            Names),
    atomic_list_concat(Names,'\n- ',Text),
    format(atom(Answer),'SAU ~w programmes:\n- ~w',[Level,Text]).

level_topic_answer(Level, hostel, Answer) :-
    hostel_rule(distance,D),
    hostel_rule(priority,P),
    hostel_rule(allocation,A),
    format(atom(Answer),
           'Hostel policy relevant to SAU ~w students:\n- ~w\n- ~w\n- ~w',
           [Level,D,P,A]).

level_topic_answer(phd, scholarship, Answer) :- phd_stipend_answer(Answer).
level_topic_answer(master, scholarship, Answer) :- master_scholarship_answer(Answer).
level_topic_answer(postgraduate, scholarship, Answer) :- master_scholarship_answer(Answer).
level_topic_answer(Level, scholarship, Answer) :-
    format(atom(Answer),'Financial support for SAU ~w students: check the current programme-specific admission notice for scholarships or fee concessions.',[Level]).

level_requirements(Level,Name,Reqs) :-
    programme(P,Name,Level,_,_),
    all_requirements(P,Reqs).

level_items_text([], '').
level_items_text([Name-Items], Text) :-
    atomic_list_concat(Items,'; ',ReqText),
    format(atom(Text),'~w: ~w',[Name,ReqText]).
level_items_text([Name-Items|T], Text) :-
    atomic_list_concat(Items,'; ',ReqText),
    level_items_text(T,Rest),
    format(atom(Text),'~w: ~w\n- ~w',[Name,ReqText,Rest]).

level_fee_items_text([],'').
level_fee_items_text([Name-Fee],Text) :-
    format(atom(Text),'~w: USD ~w per semester',[Name,Fee]).
level_fee_items_text([Name-Fee|T],Text) :-
    format(atom(Head),'~w: USD ~w per semester',[Name,Fee]),
    level_fee_items_text(T,Rest),
    format(atom(Text),'~w\n- ~w',[Head,Rest]).

% ------------------------------------------------------------
% Generic intent answers
% ------------------------------------------------------------

answer_intent(list_saarc, A) :-
    list_saarc_countries(L),
    atomic_list_concat(L, ', ', Names),
    format(atom(A), 'SAARC member countries: ~w.', [Names]).

answer_intent(list_courses, A) :-
    all_programmes(L),
    atomic_list_concat(L, '\n- ', Text),
    format(atom(A), 'SAU programmes:\n- ~w', [Text]).

answer_intent(list_phd, A) :-
    phd_programmes(L),
    atomic_list_concat(L, '\n- ', Text),
    format(atom(A), 'SAU PhD programmes:\n- ~w', [Text]).

answer_intent(university_info, A) :-
    university(name,N),
    university(location,L),
    university(address,Ad),
    university(website,W),
    format(atom(A),
           'University: ~w\nLocation: ~w\nAddress: ~w\nWebsite: ~w',
           [N,L,Ad,W]).

answer_intent(hostel_info, A) :-
    hostel_rule(distance,D),
    hostel_rule(priority,P),
    hostel_rule(allocation,Al),
    hostel_rule(registration_minimum,M),
    hostel_rule(provisional,Pr),
    format(atom(A),
           'Hostel policy:\n- ~w\n- ~w\n- ~w\n- ~w\n- ~w',
           [D,P,Al,M,Pr]).

answer_intent(phd_stipend_info, A) :- phd_stipend_answer(A).
answer_intent(master_scholarship_info, A) :- master_scholarship_answer(A).

answer_intent(scholarship_info, A) :-
    findall(R, scholarship_rule(phd,R), Raw),
    sort(Raw, Rules),
    scholarship_lines(Rules, Text),
    format(atom(A), 'Financial support information:\n- ~w', [Text]).

answer_intent(phd_info, A) :-
    phd_tenure(T),
    phd_coursework(C),
    phd_south_asia_course(S),
    phd_residency(R),
    format(atom(A),
           'PhD information:\n- Tenure: ~w\n- Coursework: ~w\n- Required course: ~w\n- Residency: ~w',
           [T,C,S,R]).

answer_intent(admission_info, A) :-
    format(atom(A),
           'SAU admission has programme-specific eligibility and admission routes. Ask a specific question such as "BTech eligibility", "MCA admission", "PhD requirements", or "admission for students from Nepal".').

answer_intent(fee_general, A) :-
    general_fee(registration,R,usd,one_time,RNote),
    general_fee(admission,Ad,usd,one_time,AdNote),
    general_fee(security_deposit,S,usd,one_time,SNote),
    general_fee(student_aid_fund,F,usd,per_semester,FNote),
    format(atom(A),
           'General 2026-27 fees:\n- Registration: USD ~w (~w)\n- Admission: USD ~w (~w)\n- Security deposit: USD ~w (~w)\n- Student Aid Fund: USD ~w per semester (~w)\n- Programme and hostel fees are additional where applicable.',
           [R,RNote,Ad,AdNote,S,SNote,F,FNote]).

answer_intent(student_services_info, A) :-
    findall(S-Desc,service(S,Desc),Pairs),
    services_text(Pairs,Text),
    format(atom(A),'SAU student services:\n- ~w',[Text]).

services_text([], '').
services_text([S-D], Text) :-
    format(atom(Text),'~w: ~w',[S,D]).
services_text([S-D|T], Text) :-
    services_text(T,Rest),
    format(atom(Text),'~w: ~w\n- ~w',[S,D,Rest]).

% ------------------------------------------------------------
% Country answers
% ------------------------------------------------------------

country_answer(Country, Answer) :-
    country_type(Country,Type),
    student_category(Country,Category),
    ( hostel_priority(Country,Priority) -> true ; Priority = normal ),
    format(atom(Answer),
           '~w is classified as ~w in the SAU knowledge base. Student category: ~w. Hostel priority category: ~w.',
           [Country,Type,Category,Priority]).

% ------------------------------------------------------------
% Candidate intent detection for domain restriction.
% Unlike understand/2, this intentionally returns multiple matches.
% ------------------------------------------------------------

intent_candidate(Q, faculty_info) :-
    (has_intent_keyword(Q,faculty);has_intent_keyword(Q,teacher);has_intent_keyword(Q,research)),
    !.
intent_candidate(Q, list_saarc) :-
    (word(Q,saarc);word(Q,saar)),
    (word(Q,country);word(Q,countries);word(Q,member);word(Q,members)).
intent_candidate(Q, list_phd) :-
    word(Q,phd),
    (word(Q,course);word(Q,courses);word(Q,programme);word(Q,program)).
intent_candidate(Q, hostel_info) :-
    has_intent_keyword(Q,hostel).
intent_candidate(Q, scholarship_info) :-
    has_intent_keyword(Q,scholarship).
intent_candidate(Q, fee_general) :-
    has_intent_keyword(Q,fee).
intent_candidate(Q, admission_info) :-
    has_intent_keyword(Q,admission).
intent_candidate(Q, university_info) :-
    (word(Q,university);word(Q,location);word(Q,address)).
intent_candidate(Q, phd_info) :-
    word(Q,phd).
intent_candidate(Q, list_courses) :-
    has_intent_keyword(Q,course).
intent_candidate(Q, student_services_info) :-
    has_intent_keyword(Q,student_services).

has_intent_keyword(Q, Intent) :-
    intent_keyword(Intent, Keyword),
    word(Q, Keyword),
    !.
