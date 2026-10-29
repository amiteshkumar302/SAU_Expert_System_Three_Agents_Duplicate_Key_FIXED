# SAU Expert System — Three Components Only

Tabs: Chatbot, Course Agent, Faculty Agent. Removed Explainable AI, Admission Agent, Scholarship Agent, LLM + Prolog tabs. Scholarship and admission knowledge remains accessible through the Chatbot. PCB is not offered in the Course Agent.

## Fixed
All Streamlit inputs in the three active tabs have explicit unique widget keys. The duplicate `Qualification` selectbox previously came from rendering `explain_agent` inside both Explainable AI and Admission Agent tabs. Both have been removed as requested.

## Run
Install SWI-Prolog, ensure it is available to PySwip, then from the extracted `SAU_Expert_System` folder run:

```
pip install -r requirements.txt
streamlit run streamlit/app.py
```

Python syntax was checked. Full live Streamlit/SWI-Prolog testing was not available in the build environment.
