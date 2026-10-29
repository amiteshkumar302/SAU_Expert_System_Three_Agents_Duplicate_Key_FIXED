import os
import streamlit as st
from pyswip import Prolog
from recommendation_ui import render_recommender
from advanced_agents import faculty_agent

st.set_page_config(
    page_title="SAU Student Assistant",
    page_icon="🎓",
    layout="wide",
    initial_sidebar_state="collapsed",
)

BASE = os.path.dirname(os.path.abspath(__file__))
PROLOG_DIR = os.path.abspath(os.path.join(BASE, "..", "prolog"))

st.markdown("""
<style>
.stApp {
    background:
        radial-gradient(circle at 10% 10%, rgba(99,102,241,.13), transparent 28%),
        radial-gradient(circle at 90% 10%, rgba(14,165,233,.12), transparent 25%),
        linear-gradient(135deg,#f8fafc 0%,#eef2ff 50%,#f8fafc 100%);
}
#MainMenu, footer {visibility:hidden;}
header {background:transparent !important;}
.block-container {max-width:1050px;padding-top:2rem;padding-bottom:7rem;}
.hero{text-align:center;padding:1rem 1rem .7rem;}
.logo{width:76px;height:76px;margin:auto auto 14px;border-radius:24px;
display:flex;align-items:center;justify-content:center;font-size:38px;
background:linear-gradient(135deg,#4f46e5,#0ea5e9);
box-shadow:0 14px 35px rgba(79,70,229,.25);}
.hero h1{margin:0;font-size:2.3rem;font-weight:800;letter-spacing:-1px;color:#172033;}
.hero p{margin:.5rem auto 0;color:#64748b;max-width:700px;}
.status{width:max-content;margin:16px auto 24px;padding:7px 13px;border-radius:999px;
background:rgba(255,255,255,.8);border:1px solid rgba(148,163,184,.25);
color:#475569;font-size:.84rem;}
.dot{display:inline-block;width:8px;height:8px;border-radius:50%;background:#22c55e;
margin-right:7px;box-shadow:0 0 0 4px rgba(34,197,94,.12);}
.cards{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;margin:10px 0 26px;}
.card{background:rgba(255,255,255,.78);border:1px solid rgba(148,163,184,.18);
border-radius:18px;padding:18px;box-shadow:0 10px 30px rgba(15,23,42,.06);}
.card-icon{font-size:1.35rem;margin-bottom:7px}.card-title{font-weight:700;color:#1e293b}
.card-text{color:#64748b;font-size:.86rem;line-height:1.45;margin-top:4px;}
[data-testid="stChatMessage"]{background:rgba(255,255,255,.88)!important;
border:1px solid rgba(148,163,184,.18);border-radius:20px;
box-shadow:0 10px 28px rgba(15,23,42,.06);margin:10px 0;padding:7px 12px;}
[data-testid="stChatMessage"] p,
[data-testid="stChatMessage"] span,
[data-testid="stChatMessage"] div {
    color:#172033 !important;
    -webkit-text-fill-color:#172033 !important;
    opacity:1 !important;
}
[data-testid="stChatInput"] > div{border-radius:18px!important;
border:1px solid rgba(99,102,241,.25)!important;
box-shadow:0 12px 35px rgba(15,23,42,.10)!important;background:#fff!important;}
[data-testid="stChatInput"] textarea{font-size:1rem!important;color:#172033!important;
-webkit-text-fill-color:#172033!important;caret-color:#4f46e5!important;
background:#fff!important;opacity:1!important;}
[data-testid="stChatInput"] textarea::placeholder{color:#64748b!important;opacity:1!important;}
.footer{text-align:center;color:#94a3b8;font-size:.78rem;margin-top:28px;}
@media(max-width:760px){.cards{grid-template-columns:1fr}.hero h1{font-size:1.85rem}}

/* STATIC DARK-TEXT ACCESSIBLE THEME — NO HOVER COLOUR CHANGES */
:root {color-scheme:light;}
.stApp, [data-testid="stAppViewContainer"], [data-testid="stMain"] {background:#eef3f9!important;color:#14283f!important;}
.stApp .block-container {color:#14283f!important;}
.hero h1,.hero h1:hover,.hero p,.hero p:hover,.card-title,.card-title:hover,.card-text,.card-text:hover,.status,.status:hover,.footer,.footer:hover {color:#14283f!important;opacity:1!important;text-shadow:none!important;}
.card,.card:hover,.status,.status:hover {background:#fff!important;border:2px solid #a4b7ca!important;box-shadow:none!important;filter:none!important;transform:none!important;}
[data-testid="stChatMessage"],[data-testid="stChatMessage"]:hover {background:#fff!important;border:2px solid #a4b7ca!important;box-shadow:none!important;opacity:1!important;filter:none!important;transform:none!important;}
[data-testid="stChatMessage"] :is(p,span,div,li,strong,em,a),[data-testid="stChatMessage"]:hover :is(p,span,div,li,strong,em,a) {color:#10253b!important;-webkit-text-fill-color:#10253b!important;opacity:1!important;text-shadow:none!important;}
[data-testid="stMarkdownContainer"] :is(p,h1,h2,h3,h4,li,strong,em),[data-testid="stMarkdownContainer"]:hover :is(p,h1,h2,h3,h4,li,strong,em),[data-testid="stCaptionContainer"] p,[data-testid="stCaptionContainer"]:hover p {color:#14283f!important;-webkit-text-fill-color:#14283f!important;opacity:1!important;text-shadow:none!important;}
[data-testid="stTabs"] button[role="tab"],[data-testid="stTabs"] button[role="tab"]:hover {background:#fff!important;color:#123653!important;border:2px solid #9fb7d1!important;opacity:1!important;box-shadow:none!important;}
[data-testid="stTabs"] button[role="tab"] p,[data-testid="stTabs"] button[role="tab"]:hover p {color:#123653!important;-webkit-text-fill-color:#123653!important;}
[data-testid="stTabs"] button[role="tab"][aria-selected="true"],[data-testid="stTabs"] button[role="tab"][aria-selected="true"]:hover {background:#075985!important;color:#fff!important;border-color:#075985!important;}
[data-testid="stTabs"] button[role="tab"][aria-selected="true"] p,[data-testid="stTabs"] button[role="tab"][aria-selected="true"]:hover p {color:#fff!important;-webkit-text-fill-color:#fff!important;}
[data-testid="stForm"],[data-testid="stForm"]:hover {background:#fff!important;border:2px solid #a4b7ca!important;box-shadow:none!important;opacity:1!important;}
[data-baseweb="select"]>div,[data-baseweb="select"]>div:hover,[data-baseweb="input"]>div,[data-baseweb="input"]>div:hover,[data-testid="stChatInput"]>div,[data-testid="stChatInput"]>div:hover {background:#fff!important;border-color:#91a9c2!important;box-shadow:none!important;}
[data-baseweb="select"] :is(span,input,div),[data-baseweb="select"]:hover :is(span,input,div),[data-baseweb="input"] input,[data-baseweb="input"] input:hover,[data-testid="stChatInput"] textarea,[data-testid="stChatInput"] textarea:hover {color:#10253b!important;-webkit-text-fill-color:#10253b!important;opacity:1!important;}
[data-testid="stFormSubmitButton"] button,[data-testid="stFormSubmitButton"] button:hover,.stButton button,.stButton button:hover {background:#075985!important;color:#fff!important;border:2px solid #075985!important;box-shadow:none!important;filter:none!important;}
[data-testid="stFormSubmitButton"] button p,[data-testid="stFormSubmitButton"] button:hover p,.stButton button p,.stButton button:hover p {color:#fff!important;-webkit-text-fill-color:#fff!important;}
.reco-output,.reco-output:hover {background:#fff!important;color:#10253b!important;border:2px solid #7896b4!important;border-left:7px solid #075985!important;border-radius:12px!important;padding:18px 20px!important;margin:12px 0!important;box-shadow:none!important;text-shadow:none!important;filter:none!important;opacity:1!important;transform:none!important;}
.reco-output .reco-title,.reco-output:hover .reco-title {font-size:1.12rem!important;font-weight:800!important;color:#10253b!important;-webkit-text-fill-color:#10253b!important;opacity:1!important;}
.reco-output .reco-score,.reco-output:hover .reco-score {font-weight:800!important;color:#155e35!important;-webkit-text-fill-color:#155e35!important;opacity:1!important;}
.reco-output .reco-status,.reco-output:hover .reco-status {color:#263b52!important;-webkit-text-fill-color:#263b52!important;opacity:1!important;font-weight:500!important;}
[data-testid="stAlert"],[data-testid="stAlert"]:hover {background:#e1edfa!important;border:1px solid #7896b4!important;box-shadow:none!important;opacity:1!important;}
[data-testid="stAlert"] :is(p,div,span),[data-testid="stAlert"]:hover :is(p,div,span) {color:#10253b!important;-webkit-text-fill-color:#10253b!important;}

</style>
""", unsafe_allow_html=True)

@st.cache_resource(show_spinner=False)
def load_prolog():
    p = Prolog()
    master = os.path.join(PROLOG_DIR, "master.pl")
    # Consult using an absolute path so the working directory is irrelevant.
    p.consult(master)
    # Verify that the public chatbot predicate is actually available.
    list(p.query("current_predicate(ask/2)", maxresult=1))
    return p

try:
    prolog = load_prolog()
    prolog_status = True
    prolog_error = ""
except Exception as e:
    prolog = None
    prolog_status = False
    prolog_error = repr(e)

if "messages" not in st.session_state:
    st.session_state.messages = []

st.markdown("""
<div class="hero">
  <div class="logo">🎓</div>
  <h1>SAU Student Assistant</h1>
  <p>Ask about South Asian University admission, programmes, fees,
  scholarships, hostel, PhD and student services.</p>
</div>
""", unsafe_allow_html=True)

if prolog_status:
    st.markdown('<div class="status"><span class="dot"></span>Prolog Knowledge Base Online</div>',
                unsafe_allow_html=True)
else:
    st.error("Prolog Knowledge Base could not be loaded. See the terminal error below.")
    st.code(prolog_error)

st.markdown("""
<div class="cards">
  <div class="card"><div class="card-icon">📚</div>
    <div class="card-title">Admission & Courses</div>
    <div class="card-text">Eligibility, programmes and admission information.</div>
  </div>
  <div class="card"><div class="card-icon">💳</div>
    <div class="card-title">Fees & Scholarships</div>
    <div class="card-text">Programme fees and financial-support information.</div>
  </div>
  <div class="card"><div class="card-icon">🏠</div>
    <div class="card-title">Hostel & Services</div>
    <div class="card-text">Hostel policies and student services.</div>
  </div>
</div>
""", unsafe_allow_html=True)

# Only three independent tabs. Streamlit evaluates all tabs on every rerun,
# so each input widget must have a unique key across the whole page.
tab_chat, tab_recommend, tab_faculty = st.tabs(['💬 Chatbot', '🎯 Course Agent', '🔬 Faculty Agent'])

with tab_faculty:
    faculty_agent(prolog)

with tab_recommend:
    render_recommender(prolog)

with tab_chat:
    st.caption('Ask about SAU courses, eligibility, fees, faculty, and research areas.')

with tab_chat:
    for message in st.session_state.messages:
        with st.chat_message(message["role"], avatar="👤" if message["role"] == "user" else "🎓"):
            st.markdown(message["content"])

    q = st.chat_input("Ask your SAU question in your language…", key="sau_chat_question")

    if q and q.strip():
        question = q.strip()

        # Show the user's question immediately in the chat history.
        st.session_state.messages.append({"role": "user", "content": question})

        if prolog is None:
            answer = "The Prolog knowledge base is not loaded. Please check SWI-Prolog and the terminal error."
        else:
            try:
                # Pass the question as a Prolog STRING, not by Python-side variable binding.
                # This is safe for spaces, quotes, apostrophes, punctuation and Unicode.
                escaped = (question
                           .replace("\\", "\\\\")
                           .replace('"', '\\"')
                           .replace("\r", " ")
                           .replace("\n", " "))
                goal = f'ask("{escaped}", Answer)'
                results = list(prolog.query(goal, maxresult=1))

                if results and "Answer" in results[0]:
                    answer = str(results[0]["Answer"])
                    if not answer.strip():
                        answer = "I could not find a suitable answer in the SAU knowledge base."
                else:
                    answer = (
                        "I could not identify that SAU question. "
                        "Please ask about admission, courses, eligibility, fees, "
                        "hostel, scholarships, PhD, SAARC countries or student services."
                    )
            except Exception as e:
                print("PROLOG QUERY ERROR:", repr(e))
                answer = (
                    "I could not process that question. Please try again with a "
                    "SAU-related question."
                )

        st.session_state.messages.append({"role": "assistant", "content": answer})
        st.rerun()

    if st.session_state.messages:
        if st.button("Clear chat"):
            st.session_state.messages = []
            st.rerun()

st.markdown(
    '<div class="footer">SAU Expert System • Symbolic AI • Prolog Knowledge Representation</div>',
    unsafe_allow_html=True
)
