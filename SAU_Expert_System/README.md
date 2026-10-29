# SAU Student Expert System

A Knowledge Representation and Reasoning chatbot for South Asian University (SAU).

## Architecture

```text
Streamlit UI
    |
    v
Python / PySwip
    |
    v
SWI-Prolog
    |
    +-- nlp.pl          -> symbolic NLP / intent + entity extraction
    +-- query.pl        -> inference and answer generation
    +-- university.pl   -> university facts
    +-- country.pl      -> SAARC/non-SAARC facts
    +-- course.pl       -> programme facts
    +-- admission.pl    -> admission and eligibility rules
    +-- fee.pl          -> fee structure
    +-- hostel.pl       -> hostel policies
    +-- scholarship.pl  -> scholarship rules
    +-- phd.pl          -> PhD rules
    +-- student_services.pl
```

## Important design principle

**No SAU university knowledge is stored in Python.** Python only provides the Streamlit interface and calls Prolog through PySwip.

## Natural-language understanding

`nlp.pl` is intentionally symbolic rather than an LLM. It supports:

- Different sentence structures because questions are interpreted as words/entities rather than by fixed sentence templates.
- Common synonyms such as fee/cost/tuition, admission/apply/eligibility, hostel/accommodation, etc.
- Common spelling errors using edit-distance matching, e.g. `admisson`, `eligibilty`, `tution`, `hostle`.
- English, Hinglish/Hindi and selected common terms from several other languages.
- Programme aliases and abbreviations such as MCA, MBA, MSc CS, MTech CSE, PhD CSE.
- Country aliases such as Indian/India, Nepalese/Nepal, etc.

### Important limitation

A finite Prolog dictionary cannot literally understand every human language. To support **arbitrary languages**, add a multilingual translation/semantic-NLP layer before `nlp.pl`. The university knowledge, policies and reasoning can still remain entirely in Prolog.

## Example questions

```text
What are the SAARC countries?
What is the fee for BTech CSE?
What are BTech eligibility requirements?
what is the tution fee for msc computer science
What is the PhD eligibility?
What are the PhD courses?
I am from Nepal. What is my hostel priority?
nepalese student hostel policy?
MCA admission requirements please
What are the scholarship options?
```

Spelling and sentence order examples:

```text
What is the eligibilty for PhD?
phd cse fee tell me
hostle policy for nepal student
I want admission, what requirment?
```

## Run locally

From the `prolog` directory:

```bat
swipl
```

Then:

```prolog
?- [master].
?- ask("What are the SAARC countries?", A).
?- ask("what is the eligibilty for phd cse", A).
?- ask("hostle policy for nepal student", A).
```

Run Streamlit from the project root:

```bat
streamlit run streamlit\app.py
```

## Scope

The chatbot is deliberately restricted to the SAU university domain. It should answer university-related questions and politely reject unrelated questions instead of inventing an answer.

## Faculty / Subject / Research upgrade

The project now supports:
- Who teaches Machine Learning?
- Who is the teacher of ML?
- Machine Learning teacher kaun hai?
- Who works in Machine Learning?
- Which faculty member works in Computer Vision?
- Who teaches Deep Learning?
- Who teaches Computer Vision?
- Tell me about Amit Shukla.
- Amit Shukla ke bare me batao.

The answer routing distinguishes:
1. Current/recorded subject teacher assignment.
2. Faculty/research expert for a subject.
3. Faculty research area.
4. Faculty profile/details.

Subject-teacher answers put the faculty member(s) on the FIRST LINE, followed by course code and batch/semester details.

Run faculty tests in SWI-Prolog with:
    consult('test_faculty_queries.pl').
    run_faculty_tests.

## New: Rule-based Course Recommendation Agent
Open the **Course Recommendation Agent** tab in Streamlit. Enter your qualification,
background, aggregate percentage and academic interest. Prolog uses
`prolog/recommendation.pl` to return ranked SAU programme suggestions.

This is a **screening and interest matching tool**, NOT an admission probability
predictor. Stored 65%/55% thresholds apply only to the specifically listed
programmes from the existing admission knowledge base. Other programmes use
`unknown` and must be checked against official current requirements.
The rules are deliberately conservative about subject prerequisites.

For example, try Class 12 / PCM / 85% / Artificial Intelligence.
The chatbot's existing Prolog faculty and university Q&A functions remain available.

### How to run
Install SWI-Prolog, then `pip install -r requirements.txt` and
`streamlit run streamlit/app.py` from the project root.

## Scholarship question spelling fixes
Financial questions now route before generic faculty/other question handling.
The Prolog NLP normalizer canonicalizes frequent misspellings of scholarship,
stipend, fellowship, PhD, master's, and eligibility, with basic Hinglish aliases.
Run the examples in TEST_SCHOLARSHIP_SPELLING_FIX.txt. No online updates are
performed; the financial facts remain those in scholarship.pl (2026-27).
