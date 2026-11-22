# Anti-Drift Protocol for Transcription

This rule prevents quality degradation during batch transcription.

## THE PROBLEM
When processing many pages in a SINGLE SCRIPT LOOP, the model:
1. Starts well (rules are fresh in context)
2. After 5-10 pages, begins copying its own output patterns instead of the rules
3. Once one mistake appears, it treats the mistake as "correct" and repeats it
4. Quality degrades silently for all remaining pages

## SOLUTION: PER-TURN PROCESSING WITH VALIDATION

### Rule 1: Process ONE page per turn
- In each agent turn, process exactly ONE PDF page
- Write the transcription to page_NNN.txt
- Run the validator on that page
- If PASS: move to the next page on the next turn
- If FAIL: fix and re-validate in the same turn
- This keeps context short and rules fresh

### Rule 2: NEVER use bulk Python loops
- Do NOT use a Python for-loop that processes 10+ pages in one go
- Do NOT use run_workflow with a loop over all pages
- Do NOT accumulate multiple pages of output in one context window
- Each page = one turn = fresh rules from disk

### Rule 3: Validate EVERY page immediately after creation
- After writing page_NNN.txt, IMMEDIATELY run:
  `python scripts/validate_page.py scratch/.../page_NNN.txt`
- If FAILED: fix the errors, re-validate, only save when PASSED
- NEVER skip validation
- NEVER proceed to the next page if the current page failed

### Rule 4: Use ONE good page as format reference
- Before transcribing, read ONE known-good page (e.g., page_110.txt) 
- Use it as the template for format and quality
- Do NOT load multiple old pages into context

### Rule 5: Stop on 3 consecutive validation failures
- If the same error type appears on 3 consecutive pages despite fixes, STOP
- Report the error to the user
- Do NOT continue and hope it fixes itself

### Rule 6: Autonomous long-running operation
- When running via /goal or similar long-running mode:
  - Process one page per turn (the system gives fresh context each turn)
  - The rules files load automatically from .gemini/rules/ each turn
  - Continue until all pages in the range are done
  - Git commit after every 5-10 pages
  - No need for user to type "continue"

### Rule 7: Per-page workflow within a single turn
```
1. Read the PDF page image
2. Classify page type (Type S = shloka, Type V = vyakhyana-only)
3. Write the transcription following all rules
4. Save to page_NNN.txt
5. Run: python scripts/validate_page.py page_NNN.txt
6. If FAIL: read errors, fix the file, re-validate
7. If PASS: report success, proceed to next page
```

## VALIDATION COMMAND
```
# Single page:
python scripts/validate_page.py scratch/prapanchasara_sarasangraha_v1_transcriptions/page_NNN.txt

# All pages in directory:
python scripts/validate_page.py --dir scratch/prapanchasara_sarasangraha_v1_transcriptions/
```
