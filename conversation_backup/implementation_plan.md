# Implementation Plan - Shloka-by-Shloka Translation of Paramatmikopanishat

This plan details the process for restructuring and translating all 98 chapters of *Paramatmikopanishat* to have individual, shloka-by-shloka translations. Each verse (shloka) and prose commentary block will have its own **ಶಬ್ದಾರ್ಥ:** (word-by-word meaning) and **ಭಾವಾರ್ಥ:** (overall meaning) interleaved directly underneath it, matching the style of *Annapurna Upanishad*.

## Proposed Changes

We will modify all 98 files of *Paramatmikopanishat* in `assets/data/chapters/`:
- From [upanishad_paramatmikopanishat_ch_1.txt](file:///d:/bharatheeyam%20books/assets/data/chapters/upanishad_paramatmikopanishat_ch_1.txt) to [upanishad_paramatmikopanishat_ch_98.txt](file:///d:/bharatheeyam%20books/assets/data/chapters/upanishad_paramatmikopanishat_ch_98.txt)

### Execution Strategy

Since there are 98 chapters, we will divide the work into 7 batches of approximately 14 chapters each:
- **Batch A:** Chapters 1–14
- **Batch B:** Chapters 15–28
- **Batch C:** Chapters 29–42
- **Batch D:** Chapters 43–56
- **Batch E:** Chapters 57–70
- **Batch F:** Chapters 71–84
- **Batch G:** Chapters 85–98

We will define a specialized `translation-agent` subagent to process each batch. For each chapter:
1. Parse the existing file to separate it into distinct Sanskrit text blocks (each ending with `॥` or representing a separate quote/commentary paragraph).
2. For each block, generate:
   - **ಶಬ್ದಾರ್ಥ:** listing 3–7 key words/compounds and their direct meanings in Kannada.
   - **ಭಾವಾರ್ಥ:** a clear, grammatical, and rich Kannada translation of the block.
3. Rewrite the file by interleaving these blocks directly under their respective Sanskrit text blocks.
4. Clean and verify that 0 Latin, English, Devanagari, or other foreign characters are present.

## Verification Plan

### Automated Tests
- **Block Count Check:** A scratch script `verify_paramatmika_shlokas.py` will be run after each batch to verify that the number of `ಶಬ್ದಾರ್ಥ:` and `ಭಾವಾರ್ಥ:` blocks matches the number of shlokas/sections in each modified file.
- **Character Check:** Check for any non-permitted characters (Latin/English/Devanagari) in the modified files.
- **Git Diff Review:** Check the git diff of edited files to ensure correct formatting and content.

### Manual Verification
- Review the Kannada translations in a few sample chapters (e.g., Chapter 1, Chapter 51, Chapter 94) to confirm they are accurate, rich, and follow the exact *Annapurna Upanishad* style.
