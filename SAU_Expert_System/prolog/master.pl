:- consult('university.pl').
:- consult('country.pl').
:- consult('course.pl').
:- consult('admission.pl').
:- consult('fee.pl').
:- consult('hostel.pl').
:- consult('scholarship.pl').
:- consult('student_services.pl').
:- consult('phd.pl').
:- consult('faculty.pl').
:- consult('recommendation.pl').
:- consult('nlp.pl').
:- consult('query.pl').

start :- writeln('SAU Prolog Knowledge Base loaded successfully.').
ask(Text, Answer) :- answer_question(Text, Answer).
