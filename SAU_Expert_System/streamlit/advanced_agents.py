"""Optional LLM and transparent symbolic advisory agents. No database required."""
import os, json, re, urllib.request
import streamlit as st


def _quote(value):
    return "'" + str(value).replace('\\', '\\\\').replace("'", "''") + "'"


def _query(prolog, goal):
    if prolog is None:
        return []
    try:
        return list(prolog.query(goal))
    except Exception as exc:
        st.error(f"Prolog query failed: {exc}")
        return []


def faculty_agent(prolog):
    st.subheader('🔬 Research Supervisor Matching Agent')
    st.caption('Research-area matches from the existing faculty knowledge base; not a guarantee of supervisor availability.')
    interest = st.text_input('Research interest', placeholder='computer vision, machine learning, HCI...', key='faculty_research_interest')
    if st.button('Find faculty matches', key='faculty_find'):
        if not interest.strip():
            st.warning('Enter a research interest.')
            return
        rows = _query(prolog, 'faculty_research(Name, Area)')
        tokens = set(re.findall(r'[a-z]+', interest.lower())) - {'and', 'in', 'for', 'of', 'the'}
        scored = {}
        for row in rows:
            name, area = str(row['Name']), str(row['Area'])
            words = set(re.findall(r'[a-z]+', area.lower()))
            score = len(tokens & words)
            if score:
                if name not in scored or score > scored[name][0]:
                    scored[name] = (score, area)
        if not scored:
            st.info('No matching faculty research area is recorded in the knowledge base. Try another keyword.')
        for name, (score, area) in sorted(scored.items(), key=lambda kv: (-kv[1][0], kv[0])):
            st.markdown(f'**{name}** — matching recorded research area: **{area}**. Explanation: {score} keyword overlap(s).')
        st.caption('Faculty research areas may change. Verify availability and supervision arrangements with SAU.')


