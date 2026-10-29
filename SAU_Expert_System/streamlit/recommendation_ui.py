"""Transparent Prolog-powered programme recommendation UI (no ML)."""
import streamlit as st
from html import escape

INTERESTS = {
    'Artificial Intelligence': 'ai', 'Programming': 'programming',
    'Cybersecurity': 'cybersecurity', 'Computer Science': 'computer_science',
    'Mathematics': 'mathematics', 'Data Science': 'data_science',
    'Research': 'research', 'Science': 'science',
    'Business': 'business', 'Management': 'management',
}
BACKGROUNDS = {
    'Class 12': {'PCM (Physics, Chemistry, Mathematics)': 'pcm',
                 'Other': 'other'},
    'Bachelor degree': {'BTech/BE Computer Science': 'btech_cse',
                        'Computer Science degree': 'computer_science',
                        'CS degree with Mathematics': 'cs_with_math',
                        'Mathematics background': 'mathematics',
                        'Other / unsure': 'other'},
}

def render_recommender(prolog):
    st.subheader('🎯 Course Recommendation Agent')
    st.caption('Rule-based recommendations, not admission probability or an offer of admission.')
    with st.form('recommendation_form'):
        qualification_label = st.selectbox('Highest completed qualification', list(BACKGROUNDS), key='course_qualification')
        background_label = st.selectbox('Subjects / degree background', list(BACKGROUNDS[qualification_label]), key='course_background')
        marks = st.number_input('Aggregate marks (%)', min_value=0.0, max_value=100.0, value=75.0, step=0.5, key='course_marks')
        interest_label = st.selectbox('Area of interest', list(INTERESTS), key='course_interest')
        submitted = st.form_submit_button('Recommend courses')
    if not submitted:
        return
    if prolog is None:
        st.error('Prolog is not available. Install SWI-Prolog and restart the app.')
        return
    level = 'class12' if qualification_label == 'Class 12' else 'bachelor'
    background = BACKGROUNDS[qualification_label][background_label]
    interest = INTERESTS[interest_label]
    goal = f'recommendation_candidate({level},{marks:.2f},{background},{interest},Id,Score,Status)'
    try:
        rows = list(prolog.query(goal))
        rows.sort(key=lambda row: int(row['Score']), reverse=True)
        if not rows:
            st.info('No matching programmes in the local recommendation knowledge base.')
            return
        st.markdown('#### Suggested SAU programmes')
        for row in rows:
            identifier = str(row['Id'])
            names = list(prolog.query(f'programme({identifier},Name,_,_,_)', maxresult=1))
            title = str(names[0]['Name']) if names else identifier.replace('_',' ').title()
            score = int(row['Score'])
            status = str(row['Status'])
            if score < 0:
                continue
            st.markdown(
                '<div class="reco-output">'
                f'<div class="reco-title">{escape(title)}</div>'
                f'<div class="reco-score">Relevance score: {score}/100</div>'
                f'<div class="reco-status">{escape(status)}</div>'
                '</div>', unsafe_allow_html=True
            )
        st.warning('These are preliminary matches only. Check official SAU programme eligibility, subject requirements, entrance/direct admission criteria, and current notices before applying. Unknown minimums are not treated as verified eligibility.')
    except Exception as exc:
        st.error('Unable to run Prolog recommendation query.')
        st.code(str(exc))
