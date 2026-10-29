FIX: The previous spelling_alias/2 expected Prolog atoms, but the tokenizer emitted strings. As a result, typo normalization could silently fail. canonical_sau_token now converts strings to atoms before alias lookup. Financial question routing is prioritized and uses canonical exact tokens, avoiding unrelated fuzzy matches.

Test in SWI-Prolog:
  cd prolog
  swipl -q -s master.pl
  ?- ask("PHD STIPAND KITNA HAI?", Answer).
  ?- ask("MTech scolarship milegi?", Answer).

To run the UI from project root:
  pip install -r requirements.txt
  streamlit run streamlit/app.py

This is a static 2026-27 KB: confirm the latest SAU scholarship policies before making financial decisions.
