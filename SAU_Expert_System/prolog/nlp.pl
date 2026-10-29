% ============================================================
% SAU EXPERT SYSTEM - ROBUST SYMBOLIC NLP LAYER
% ============================================================
% This file contains LANGUAGE MAPPINGS only. University facts,
% fees, policies and rules remain in the other Prolog files.
%
% It supports:
%   1. Different sentence structures (bag-of-words)
%   2. Common synonyms
%   3. Common spelling mistakes (edit distance)
%   4. English + common Hindi/Hinglish/Nepali/Bengali/Urdu terms
%   5. Programme and country entity extraction
%
% Important: no finite rule base can literally understand every
% human language. For truly arbitrary languages, add a translation
% layer before this symbolic NLP layer. The reasoning/knowledge
% remains entirely in Prolog.
% ============================================================

normalize_text(Text, Normalized) :-
    ( string(Text) -> S = Text ; atom_string(Text, S) ),
    string_lower(S, Lower),
    split_string(Lower, " ?!.,:;()-_/\\@#$%^&*+=|<>\"'`~[]{}",
                 " \t\n\r", RawTokens),
    exclude(==( ""), RawTokens, Tokens0),
    maplist(clean_token, Tokens0, CleanTokens),
    maplist(canonical_sau_token, CleanTokens, Tokens),
    atomic_list_concat(Tokens, ' ', Normalized).

% Canonical spellings before intent, domain and programme routing.
% Exact token mapping avoids accidental matches inside unrelated words.
canonical_sau_token(Token, Canonical) :-
    atom_string(TokenAtom, Token),
    spelling_alias(TokenAtom, Canonical), !.
canonical_sau_token(Token, Canonical) :-
    scholarship_like_token(Token), !,
    Canonical = scholarship.
canonical_sau_token(Token, Token).

% Small typo tolerance for scholarship, stipend and fellowship terms.
% Keep conservative to avoid turning unrelated questions into finance questions.
scholarship_like_token(Token) :-
    atom_string(Atom, Token),
    atom_length(Atom, Length), Length >= 8,
    ( sub_atom(Atom, 0, 5, _, schol)
    ; sub_atom(Atom, 0, 5, _, scola)
    ; sub_atom(Atom, 0, 5, _, schlo)
    ).

spelling_alias('scolarship', scholarship).
spelling_alias('scolership', scholarship).
spelling_alias('scholorship', scholarship).
spelling_alias('scholarshp', scholarship).
spelling_alias('scholrship', scholarship).
spelling_alias('scholaship', scholarship).
spelling_alias('scholarhip', scholarship).
spelling_alias('scholership', scholarship).
spelling_alias('scolorship', scholarship).
spelling_alias('scholarshipp', scholarship).
spelling_alias('scholarships', scholarship).
spelling_alias('stipand', stipend).
spelling_alias('stipen', stipend).
spelling_alias('stipind', stipend).
spelling_alias('stpend', stipend).
spelling_alias('stipnd', stipend).
spelling_alias('stipands', stipend).
spelling_alias('stipends', stipend).
spelling_alias('scholershipp', scholarship).
spelling_alias('स्कॉलरशिप', scholarship).
spelling_alias('छात्रवृत्ति', scholarship).
spelling_alias('स्टाइपेंड', stipend).
spelling_alias('स्टिपेंड', stipend).
spelling_alias('फेलोशिप', fellowship).
spelling_alias('stipent', stipend).
spelling_alias('stipned', stipend).
spelling_alias('stippend', stipend).
spelling_alias('stiped', stipend).
spelling_alias('stippand', stipend).
spelling_alias('fellowhip', fellowship).
spelling_alias('fellwship', fellowship).
spelling_alias('felloship', fellowship).
spelling_alias('fellowshp', fellowship).
spelling_alias('fellowships', fellowship).
spelling_alias('ph d', phd).
spelling_alias('phd', phd).
spelling_alias('p h d', phd).
spelling_alias('doctral', phd).
spelling_alias('doctrate', phd).
spelling_alias('doctarate', phd).
spelling_alias('master', master).
spelling_alias('masters', master).
spelling_alias('masterss', master).
spelling_alias('mastars', master).
spelling_alias('mastar', master).
spelling_alias('postgraduation', master).
spelling_alias('postgraduate', master).
spelling_alias('mtech', mtech).
spelling_alias('mtec', mtech).
spelling_alias('mteck', mtech).
spelling_alias('msc', msc).
spelling_alias('mca', mca).
spelling_alias('eligiblity', eligibility).
spelling_alias('eligibilty', eligibility).
spelling_alias('eligibality', eligibility).
spelling_alias('elgibility', eligibility).
spelling_alias('kitni', howmuch).
spelling_alias('kitna', howmuch).
spelling_alias('kitne', howmuch).
spelling_alias('milegi', available).
spelling_alias('milti', available).
spelling_alias('milega', available).
spelling_alias('milta', available).
spelling_alias('chatravriti', scholarship).
spelling_alias('chhatravritti', scholarship).
spelling_alias('chatravritti', scholarship).
spelling_alias('scholorships', scholarship).

clean_token(Token, Clean) :-
    string_codes(Token, Codes),
    include(is_word_code, Codes, Kept),
    string_codes(Clean, Kept).

is_word_code(C) :- code_type(C, alnum), !.
is_word_code(95).

tokens(Text, Tokens) :-
    normalize_text(Text, Normalized),
    split_string(Normalized, " ", "", Tokens).

contains(Q, Word) :-
    normalize_text(Q, N),
    normalize_text(Word, W),
    sub_atom(N, _, _, _, W).

% ------------------------------------------------------------
% Phrase matching
% ------------------------------------------------------------
% True when all words of Phrase occur consecutively in Q.
% This predicate is required by the programme/entity rules below.
phrase_words(Q, Phrase) :-
    normalize_text(Q, NQ),
    normalize_text(Phrase, NP),
    split_string(NQ, " ", "", QTokens),
    split_string(NP, " ", "", PTokens),
    PTokens \= [],
    phrase_sequence(QTokens, PTokens).

phrase_sequence(QTokens, Pattern) :-
    append(_, Rest, QTokens),
    append(Pattern, _, Rest),
    !.

% ------------------------------------------------------------
% Programme aliases
% ------------------------------------------------------------
programme_alias(btech, btech_cse).
programme_alias(btech_cse, btech_cse).
programme_alias(btech_cse, btech_cse).
programme_alias(mca, mca).
programme_alias(mba, mba).
programme_alias(mtech, mtech_cse).
programme_alias(mtech_cse, mtech_cse).
programme_alias(msc_cs, msc_computer_science).
programme_alias(msc, msc_computer_science).
programme_alias(phd_cse, phd_cse).
programme_alias(phd_cs, phd_cse).
programme_alias(phd, phd_cse).

programme_alias_matches(Q, Programme) :-
    programme_alias(Alias, Programme),
    word(Q, Alias).

% ------------------------------------------------------------
% Spelling-tolerant word matching
% ------------------------------------------------------------

word(Q, Canonical) :-
    tokens(Q, Tokens),
    member(Token, Tokens),
    atom_string(Canonical, CanonicalString),
    ( Token = CanonicalString
    ; fuzzy_token(Token, CanonicalString)
    ).

fuzzy_token(Token, Word) :-
    string_chars(Token, A),
    string_chars(Word, B),
    levenshtein(A, B, Distance),
    allowed_distance(Word, Distance).

allowed_distance(Word, 1) :-
    string_length(Word, L),
    L >= 4.
allowed_distance(Word, 2) :-
    string_length(Word, L),
    L >= 7.

% Small vocabulary words only: suitable for interactive NLP.
levenshtein(A, B, D) :-
    length(B, N),
    numlist(0, N, InitialRow),
    levenshtein_rows(A, B, InitialRow, D).

levenshtein_rows([], _, Row, D) :-
    last(Row, D).
levenshtein_rows([X|Xs], B, Prev, D) :-
    build_distance_row(B, X, Prev, 1, [1], Current),
    levenshtein_rows(Xs, B, Current, D).

build_distance_row([], _, _, _, Acc, Acc).
build_distance_row([Y|Ys], X, Prev, Column, Acc, Row) :-
    nth0(Column, Prev, Up),
    PrevColumn is Column - 1,
    nth0(PrevColumn, Prev, Diagonal),
    last(Acc, Left),
    ( X == Y -> Cost = 0 ; Cost = 1 ),
    Value is min(Up + 1,
                 min(Left + 1, Diagonal + Cost)),
    NextColumn is Column + 1,
    append(Acc, [Value], NextAcc),
    build_distance_row(Ys, X, Prev, NextColumn, NextAcc, Row).

% ------------------------------------------------------------
% INTENT VOCABULARY
% ------------------------------------------------------------


% Additional common multilingual words.
intent_keyword(admission, 'admisión').
intent_keyword(admission, 'matrícula').
intent_keyword(admission, 'admission').
intent_keyword(admission, 'admission').
intent_keyword(admission, 'प्रवेश').
intent_keyword(admission, 'ভর্তি').
intent_keyword(admission, 'प्रवेश').
intent_keyword(fee, 'frais').
intent_keyword(fee, 'tarifa').
intent_keyword(fee, 'matrícula').
intent_keyword(fee, 'शुल्क').
intent_keyword(fee, 'फीस').
intent_keyword(fee, 'ভর্তি').
intent_keyword(hostel, 'logement').
intent_keyword(hostel, 'alojamiento').
intent_keyword(hostel, '宿舍').
intent_keyword(hostel, 'छात्रावास').
intent_keyword(scholarship, 'bourse').
intent_keyword(scholarship, 'beca').
intent_keyword(scholarship, 'منحة').
intent_keyword(scholarship, 'छात्रवृत्ति').
intent_keyword(course, 'curso').
intent_keyword(course, 'programme').
intent_keyword(course, 'curso').
intent_keyword(course, 'पाठ्यक्रम').
intent_keyword(phd, 'doctorado').
intent_keyword(phd, 'دكتوراه').
intent_keyword(phd, 'पीएचडी').

intent_keyword(admission, admission).
intent_keyword(admission, admissions).
intent_keyword(admission, apply).
intent_keyword(admission, application).
intent_keyword(admission, applications).
intent_keyword(admission, entrance).
intent_keyword(admission, eligibility).
intent_keyword(admission, eligible).
intent_keyword(admission, requirement).
intent_keyword(admission, requirements).
intent_keyword(admission, criteria).
intent_keyword(admission, qualify).
intent_keyword(admission, process).
intent_keyword(admission, procedure).

intent_keyword(admission, dakhila).
intent_keyword(admission, daakhila).
intent_keyword(admission, pravesh).
intent_keyword(admission, yogyata).
intent_keyword(admission, patrata).
intent_keyword(admission, avedan).
intent_keyword(admission, दाखिला).
intent_keyword(admission, प्रवेश).
intent_keyword(admission, योग्यता).

intent_keyword(fee, fee).
intent_keyword(fee, fees).
intent_keyword(fee, cost).
intent_keyword(fee, tuition).
intent_keyword(fee, charges).
intent_keyword(fee, payment).
intent_keyword(fee, amount).
intent_keyword(fee, price).
intent_keyword(fee, शुल्क).
intent_keyword(fee, फीस).
intent_keyword(fee, kharcha).
intent_keyword(fee, kharch).

intent_keyword(hostel, hostel).
intent_keyword(hostel, accommodation).
intent_keyword(hostel, residence).
intent_keyword(hostel, room).
intent_keyword(hostel, lodging).
intent_keyword(hostel, आवास).
intent_keyword(hostel, छात्रावास).

intent_keyword(scholarship, scholarship).
intent_keyword(scholarship, scholarships).
intent_keyword(scholarship, stipend).
intent_keyword(scholarship, fellowship).
intent_keyword(scholarship, financial).
intent_keyword(scholarship, छात्रवृत्ति).

intent_keyword(course, course).
intent_keyword(course, courses).
intent_keyword(course, programme).
intent_keyword(course, programmes).
intent_keyword(course, program).
intent_keyword(course, programs).
intent_keyword(course, degree).
intent_keyword(course, study).
intent_keyword(course, subject).
intent_keyword(course, पाठ्यक्रम).
intent_keyword(course, कोर्स).

intent_keyword(phd, phd).
intent_keyword(phd, doctorate).
intent_keyword(phd, doctoral).
intent_keyword(phd, research).
intent_keyword(phd, coursework).
intent_keyword(phd, residency).
intent_keyword(phd, tenure).

% Faculty / subject / research vocabulary
intent_keyword(faculty, faculty).
intent_keyword(faculty, faculties).
intent_keyword(faculty, professor).
intent_keyword(faculty, professor).
intent_keyword(faculty, teacher).
intent_keyword(faculty, teachers).
intent_keyword(faculty, member).
intent_keyword(faculty, members).
intent_keyword(faculty, faculty_member).
intent_keyword(faculty, prof).
intent_keyword(faculty, अध्यापक).
intent_keyword(faculty, शिक्षक).
intent_keyword(faculty, शिक्षक).
intent_keyword(faculty, faculty).

intent_keyword(research, research).
intent_keyword(research, researcher).
intent_keyword(research, research_area).
intent_keyword(research, research_areas).
intent_keyword(research, area).
intent_keyword(research, areas).
intent_keyword(research, field).
intent_keyword(research, fields).
intent_keyword(research, works).
intent_keyword(research, working).
intent_keyword(research, kaam).
intent_keyword(research, अनुसंधान).

intent_keyword(teacher, teach).
intent_keyword(teacher, teaches).
intent_keyword(teacher, taught).
intent_keyword(teacher, instructor).
intent_keyword(teacher, subject_teacher).
intent_keyword(teacher, teacher).
intent_keyword(teacher, padhata).
intent_keyword(teacher, padhate).
intent_keyword(teacher, padhati).
intent_keyword(teacher, padate).
intent_keyword(teacher, पढ़ाते).
intent_keyword(teacher, पढ़ाता).
intent_keyword(teacher, कौन).

intent_keyword(university, university).
intent_keyword(university, sau).
intent_keyword(university, location).
intent_keyword(university, address).
intent_keyword(university, campus).
intent_keyword(university, कहाँ).
intent_keyword(university, स्थान).

intent_keyword(saarc, saarc).
intent_keyword(saarc, saar).
intent_keyword(saarc, member).
intent_keyword(saarc, members).
intent_keyword(saarc, country).
intent_keyword(saarc, countries).
intent_keyword(saarc, देश).

intent_keyword(student_services, library).
intent_keyword(student_services, transport).
intent_keyword(student_services, medical).
intent_keyword(student_services, cafeteria).
intent_keyword(student_services, service).
intent_keyword(student_services, services).
intent_keyword(student_services, student).

% ------------------------------------------------------------
% INTENT DETECTION
% ------------------------------------------------------------

understand(Text, Intent) :-
    normalize_text(Text, Q),
    intent(Q, Intent),
    !.

intent(Q, list_saarc) :-
    ( word(Q, saarc) ; word(Q, saar) ),
    ( word(Q, country)
    ; word(Q, countries)
    ; word(Q, member)
    ; word(Q, members)
    ; word(Q, देश)
    ),
    !.

intent(Q, list_phd) :-
    word(Q, phd),
    ( word(Q, course)
    ; word(Q, courses)
    ; word(Q, programme)
    ; word(Q, program)
    ),
    !.

intent(Q, hostel_info) :-
    has_intent_keyword(Q, hostel),
    !.

intent(Q, phd_stipend_info) :-
    has_intent_keyword(Q, scholarship),
    word(Q, phd), !.
intent(Q, master_scholarship_info) :-
    has_intent_keyword(Q, scholarship),
    (word(Q, master); word(Q, masters); word(Q, mtech); word(Q, msc); word(Q, mca); word(Q, pg)), !.
intent(Q, scholarship_info) :-
    has_intent_keyword(Q, scholarship),
    !.

intent(Q, fee_general) :-
    has_intent_keyword(Q, fee),
    !.

intent(Q, admission_info) :-
    has_intent_keyword(Q, admission),
    !.

intent(Q, university_info) :-
    ( word(Q, university)
    ; word(Q, location)
    ; word(Q, address)
    ; phrase_words(Q, 'where is sau')
    ),
    !.

intent(Q, phd_info) :-
    word(Q, phd),
    !.

intent(Q, list_courses) :-
    has_intent_keyword(Q, course),
    !.

intent(Q, student_services_info) :-
    has_intent_keyword(Q, student_services),
    !.

has_intent_keyword(Q, Intent) :-
    intent_keyword(Intent, Keyword),
    word(Q, Keyword),
    !.

% ------------------------------------------------------------
% PROGRAMME ENTITY EXTRACTION
% ------------------------------------------------------------

programme_from_text(Q, btech_cse) :-
    ( word(Q, btech) ; phrase_words(Q, 'b tech') ),
    ( word(Q, cse) ; phrase_words(Q, 'computer science') ),
    !.

programme_from_text(Q, btech_math_computing) :-
    word(Q, btech),
    word(Q, mathematics),
    word(Q, computing),
    !.

programme_from_text(Q, dual_btech_mtech_cse) :-
    word(Q, dual),
    word(Q, btech),
    word(Q, mtech),
    !.

programme_from_text(Q, mca) :-
    word(Q, mca),
    !.

programme_from_text(Q, msc_computer_science) :-
    word(Q, msc),
    ( word(Q, cse) ; phrase_words(Q, 'computer science') ),
    !.

programme_from_text(Q, mtech_cse) :-
    word(Q, mtech),
    ( word(Q, cse) ; phrase_words(Q, 'computer science') ),
    !.

programme_from_text(Q, mba) :-
    word(Q, mba),
    !.

programme_from_text(Q, phd_cse) :-
    word(Q, phd),
    ( word(Q, cse)
    ; phrase_words(Q, 'computer science')
    ; phrase_words(Q, 'computer engineering')
    ),
    !.

programme_from_text(Q, phd_economics) :-
    word(Q, phd),
    word(Q, economics),
    !.

programme_from_text(Q, phd_international_relations) :-
    word(Q, phd),
    phrase_words(Q, 'international relations'),
    !.

programme_from_text(Q, Programme) :-
    programme_alias_matches(Q, Programme),
    !.

programme_from_text(Q, Programme) :-
    programme(Programme, Name, _, _, _),
    normalize_text(Name, NormalName),
    phrase_words(Q, NormalName),
    !.

level_from_text(Q, master) :-
    ( word(Q, master)
    ; word(Q, masters)
    ; word(Q, postgraduate)
    ),
    !.

level_from_text(Q, bachelor) :-
    ( word(Q, bachelor)
    ; word(Q, bachelors)
    ; word(Q, undergraduate)
    ; word(Q, btech)
    ),
    !.

level_from_text(Q, phd) :-
    ( word(Q, phd)
    ; word(Q, doctorate)
    ; word(Q, doctoral)
    ),
    !.

% ------------------------------------------------------------
% COUNTRY ENTITY EXTRACTION
% ------------------------------------------------------------

country_alias(india, india).
country_alias(india, indian).
country_alias(nepal, nepal).
country_alias(nepal, nepalese).
country_alias(bangladesh, bangladesh).
country_alias(bangladesh, bangladeshi).
country_alias(bhutan, bhutan).
country_alias(bhutan, bhutanese).
country_alias(pakistan, pakistan).
country_alias(pakistan, pakistani).
country_alias(sri_lanka, sri_lanka).
country_alias(sri_lanka, srilanka).
country_alias(afghanistan, afghanistan).
country_alias(afghanistan, afghan).
country_alias(maldives, maldives).
country_alias(usa, usa).
country_alias(usa, america).
country_alias(usa, united_states).
country_alias(uk, uk).
country_alias(uk, united_kingdom).
country_alias(canada, canada).
country_alias(australia, australia).
country_alias(germany, germany).
country_alias(france, france).
country_alias(japan, japan).
country_alias(china, china).
country_alias(south_korea, south_korea).
country_alias(singapore, singapore).
country_alias(malaysia, malaysia).
country_alias(uae, uae).
country_alias(saudi_arabia, saudi_arabia).

country_from_text(Q, Country) :-
    country_alias(Country, Alias),
    alias_in_question(Q, Alias),
    !.

alias_in_question(Q, Alias) :-
    word(Q, Alias).
alias_in_question(Q, Alias) :-
    atom_chars(Alias, Chars),
    member('_', Chars),
    atomic_list_concat(Parts, '_', Alias),
    forall(member(Part, Parts), word(Q, Part)).

% Extra English/Hinglish spellings for scholarship/stipend questions.
intent_keyword(scholarship, scolarship).
intent_keyword(scholarship, scholorship).
intent_keyword(scholarship, stipand).
intent_keyword(scholarship, stipend).
intent_keyword(scholarship, fellowhip).
intent_keyword(scholarship, financialsupport).
intent_keyword(scholarship, wazifa).
