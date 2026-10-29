# New advisory agents and optional LLM

Start: `pip install -r requirements.txt` then `streamlit run streamlit/app.py`. Install SWI-Prolog separately; pyswip requires it.

Added tabs:
- Faculty matching: transparent keyword overlap against `faculty_research/2` (not availability verification).
- Explainable course advice: invokes `recommendation_candidate/7` and displays stored rule/profile criteria.
- Goal-based admission advisory: guided form based on the same recommendation rules; not official eligibility.
- Scholarship advisory: guidance based on the stored 2026–27 SAU scheme; verify latest policy.
- Optional Gemini + Prolog: retrieves a Prolog answer and asks Gemini to rephrase it without inventing details. Enter a Gemini API key in the tab or set `GEMINI_API_KEY`. API usage may incur costs.

The original University Chatbot and Course Recommendation Agent are retained. PCB remains absent from the recommendation form. No SQL database or model training required.

Security: do not commit API keys. Questions and the Prolog answer are sent to Google's Gemini service only when a key is provided and the hybrid button is pressed. Do not enter private student records.

Testing: Python source passed compileall; live SWI-Prolog and Gemini end-to-end tests have not been performed in this environment.
