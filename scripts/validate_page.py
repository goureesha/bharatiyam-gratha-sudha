# -*- coding: utf-8 -*-
"""
Transcription Validator for Bharatheeyam Books — v2
====================================================
Updated to match new rules:
- Section order: Shloka → Bhavartha → Shabdartha → Vyakhyana
- Vyakarana/grammar in Shabdartha brackets is REQUIRED (not banned)
- Shloka header format: ಶ್ಲೋಕ N: (number before colon)

Usage:
    python validate_page.py page_095.txt
    python validate_page.py --dir scratch/prapanchasara_sarasangraha_v1_transcriptions/
"""

import sys
import os
import re
import glob
import argparse


# ============================================================
# ERROR PATTERN DEFINITIONS
# ============================================================

# Boilerplate filler sentences (BANNED in Bhavartha)
BOILERPLATE_PATTERNS = [
    'ಆಧ್ಯಾತ್ಮಿಕ ಸಾಧನೆಯ ಮಾರ್ಗದಲ್ಲಿ ಇದು ಅತ್ಯಂತ ಮಹತ್ವಪೂರ್ಣವಾಗಿದೆ',
    'ಸಾಧಕನ ಆಧ್ಯಾತ್ಮಿಕ ಪ್ರಗತಿಗೆ ಇದು ಅನಿವಾರ್ಯವಾಗಿದೆ',
    'ಈ ರಹಸ್ಯವನ್ನು ಅರಿತ ಸಾಧಕನು ಪರಮ ಸಿದ್ಧಿಯನ್ನು ಪಡೆಯುತ್ತಾನೆ',
    'ತಂತ್ರಶಾಸ್ತ್ರದ ಈ ಅಮೂಲ್ಯ ರಹಸ್ಯವನ್ನು ಗುರುಮುಖೇನ ಮಾತ್ರ ತಿಳಿಯಬೇಕು',
    'ದಿವ್ಯ ಅನುಗ್ರಹವು ಸಾಧಕನಿಗೆ ಲಭಿಸುತ್ತದೆ',
    'ಈ ಮಹಾರಹಸ್ಯವನ್ನು ತಿಳಿದ ಸಾಧಕನು',
    'ಸಾಧಕನ ಸಮಸ್ತ ಇಷ್ಟಾರ್ಥಗಳೂ ಅಡೆತಡೆಯಿಲ್ಲದೆ ಸಿದ್ಧಿಸುತ್ತವೆ',
    'ತಂತ್ರಾಗಮಗಳ ಈ ಪರಮ ರಹಸ್ಯವು',
    'ಈ ವಿದ್ಯೆಯ ಮಹಿಮೆಯು ಅಪಾರವಾಗಿದೆ',
    'ಗುರೂಪದೇಶ ಪರಂಪರೆಯಿಂದ ಮಾತ್ರ ಈ ರಹಸ್ಯವನ್ನು ಪಡೆಯಬಹುದು',
]

# English words that should never appear
ENGLISH_WORDS = [
    r'\bthe\b', r'\band\b', r'\bof\b', r'\bin\b', r'\bis\b',
    r'\bthis\b', r'\bthat\b', r'\bwhich\b', r'\bfor\b', r'\bwith\b',
    r'\bmantra\b', r'\byantra\b', r'\btantra\b', r'\bdeity\b',
    r'\britual\b', r'\bworship\b', r'\betc\b', r'\bi\.e\b', r'\be\.g\b',
    r'\bviz\b', r'\bnote\b', r'\bsee\b', r'\babove\b', r'\bbelow\b',
    r'\bchapter\b', r'\bverse\b', r'\bpage\b', r'\bsection\b',
]

# Devanagari character range (excluding dandas)
# Dandas: U+0964, U+0965 are allowed
DEVANAGARI_RANGE = re.compile(r'[\u0900-\u0963\u0966-\u097F]')

# Markdown patterns
MARKDOWN_BOLD = re.compile(r'\*\*[^*]+\*\*')
MARKDOWN_ITALIC = re.compile(r'(?<!\*)\*(?!\*)[^*]+\*(?!\*)')
MARKDOWN_HEADING = re.compile(r'^#{1,6}\s', re.MULTILINE)

# Separator
SEPARATOR = '----------------------------------------'


def validate_page(filepath):
    """Validate a single page file. Returns (passed, errors_list)."""
    errors = []
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    lines = content.split('\n')
    # Strip \r
    lines = [l.rstrip('\r') for l in lines]
    
    filename = os.path.basename(filepath)
    
    # ----------------------------------------------------------
    # CHECK 1: Page marker
    # ----------------------------------------------------------
    if not lines or not re.match(r'^\[ಪುಟ: [೦-೯]+\]', lines[0]):
        errors.append('MISSING_PAGE_MARKER: First line must be [ಪುಟ: NNN] with Kannada numerals')
    
    # ----------------------------------------------------------
    # CHECK 2: Determine page type
    # ----------------------------------------------------------
    has_shloka = bool(re.search(r'ಶ್ಲೋಕ', content))
    has_shabdartha = bool(re.search(r'ಶಬ್ದಾರ್ಥ:', content))
    has_bhavartha = bool(re.search(r'ಭಾವಾರ್ಥ:', content))
    has_vyakhyana = bool(re.search(r'ವಿಶೇಷ ವಿವರಣೆ', content))
    
    is_shloka_page = has_shloka
    
    # ----------------------------------------------------------
    # CHECK 3: Spurious sections on vyakhyana-only pages
    # ----------------------------------------------------------
    if not is_shloka_page:
        if has_shabdartha:
            errors.append('SPURIOUS_SHABDARTHA: Vyakhyana-only page has Shabdartha section (not allowed)')
        if has_bhavartha:
            errors.append('SPURIOUS_BHAVARTHA: Vyakhyana-only page has Bhavartha section (not allowed)')
    
    # ----------------------------------------------------------
    # CHECK 4: Duplicate Bhavartha
    # ----------------------------------------------------------
    bhavartha_count = len(re.findall(r'ಭಾವಾರ್ಥ:', content))
    shloka_count = len(re.findall(r'ಶ್ಲೋಕ\s*[\d\u0ce6-\u0cef]+(?:[-–][\d\u0ce6-\u0cef]+)?:', content)) or len(re.findall(r'ಶ್ಲೋಕ:', content))
    if bhavartha_count > shloka_count and shloka_count > 0:
        errors.append(f'DUPLICATE_BHAVARTHA: {bhavartha_count} Bhavarthas for {shloka_count} shlokas')
    
    # ----------------------------------------------------------
    # CHECK 5: Shabdartha word-by-word, separator, grammar & completeness
    # ----------------------------------------------------------
    # Every Shabdartha bullet MUST be:
    #   • ಸಂಸ್ಕೃತ-ಶಬ್ದ — ಕನ್ನಡ ಅರ್ಥ (ವ್ಯಾಕರಣ ವಿವರ)
    # - Max 2 space-separated words on LHS (blocks clause compression!)
    # - Uses em-dash (—), NOT '='
    # - Every bullet has its own grammar annotation in (...)
    # - Bullet count per shloka block must cover the Sanskrit words in that block
    GRAMMAR_RE = re.compile(r'\(.*(?:ವಿಭಕ್ತಿ|ಸಮಾಸ|ಲಕಾರ|ವಚನ|ಪುರುಷ|ಅವ್ಯಯ|ಕೃದಂತ|ತದ್ಧಿತ|ವಿಶೇಷಣ|ಲಿಂಗ|ಸಂಖ್ಯಾ|ಸರ್ವನಾಮ|ಧಾತು|ಪ್ರತ್ಯಯ|ಬೀಜ|ಮಂತ್ರ).*\)')
    if is_shloka_page and has_shabdartha:
        in_shabdartha = False
        shabdartha_bullets = 0
        bullets_with_grammar = 0
        compressed_lines = []
        wrong_sep_lines = []
        missing_gram_lines = []
        for i, line in enumerate(lines):
            if 'ಶಬ್ದಾರ್ಥ:' in line:
                in_shabdartha = True
                continue
            if in_shabdartha and (line.startswith('ಭಾವಾರ್ಥ:') or
                                  line.startswith('ಅನುವಾದ:') or
                                  line.startswith('ವಿಶೇಷ ವಿವರಣೆ') or
                                  line == SEPARATOR or
                                  re.match(r'ಶ್ಲೋಕ\s*[\d\u0ce6-\u0cef]+(?:[-–][\d\u0ce6-\u0cef]+)?:', line)):
                in_shabdartha = False
                continue
            if in_shabdartha and line.startswith('•'):
                shabdartha_bullets += 1
                body = line[1:].strip()
                # Check separator (must use —, not =)
                if '—' not in body and '=' in body:
                    wrong_sep_lines.append(i + 1)
                # Extract LHS before — / – / =
                lhs = re.split(r'[—–=]', body, maxsplit=1)[0].strip()
                lhs_words = [w for w in lhs.split() if w]
                if len(lhs_words) > 2:
                    compressed_lines.append((i + 1, len(lhs_words), lhs[:45]))
                # Check grammar annotation on this bullet
                if GRAMMAR_RE.search(line):
                    bullets_with_grammar += 1
                else:
                    missing_gram_lines.append(i + 1)
        
        if shabdartha_bullets > 0 and bullets_with_grammar == 0:
            errors.append(f'MISSING_GRAMMAR: {shabdartha_bullets} Shabdartha bullets but NONE have vyakarana/grammar annotations (REQUIRED)')
        elif missing_gram_lines:
            errors.append(f'MISSING_BULLET_GRAMMAR: {len(missing_gram_lines)} Shabdartha bullet(s) missing grammar brackets (e.g., lines {missing_gram_lines[:5]})')
        if wrong_sep_lines:
            errors.append(f'WRONG_SHABDARTHA_SEPARATOR: {len(wrong_sep_lines)} bullet(s) use "=" instead of "—" (e.g., lines {wrong_sep_lines[:5]})')
        if compressed_lines:
            sample = '; '.join([f'L{ln}({cnt}w: "{txt}")' for ln, cnt, txt in compressed_lines[:3]])
            errors.append(f'COMPRESSED_SHABDARTHA: {len(compressed_lines)} bullet(s) have >2 words on LHS (must be word-by-word): {sample}')

        # Per-block completeness check: bullet count must be >= 85% of shloka Sanskrit words
        blocks = re.split(r'-{20,}', content)
        for b_idx, blk in enumerate(blocks, 1):
            if 'ಶ್ಲೋಕ' not in blk or 'ಶಬ್ದಾರ್ಥ:' not in blk:
                continue
            m_sh = re.search(r'ಶ್ಲೋಕ[^\n]*:\n(.*?)\n\s*ಭಾವಾರ್ಥ:', blk, re.S)
            m_sb = re.search(r'ಶಬ್ದಾರ್ಥ:\n(.*?)(?:\n\s*(?:ಅನುವಾದ:|ವಿಶೇಷ ವಿವರಣೆ|$))', blk, re.S)
            if not m_sh or not m_sb:
                continue
            # Exclude colophon lines ("ಇತಿ ಶ್ರೀಮಹಾಮಾಯಾ...") from shloka word count
            sh_lines = [l for l in m_sh.group(1).splitlines() if not l.strip().startswith('ಇತಿ ಶ್ರೀ')]
            sh_clean = re.sub(r'[।॥೦-೯0-9\(\)]', ' ', ' '.join(sh_lines))
            sh_words = [w for w in sh_clean.split() if len(w) > 0]
            blk_bullets = [l for l in m_sb.group(1).splitlines() if l.strip().startswith('•')]
            min_required = max(1, int(len(sh_words) * 0.85))
            if len(blk_bullets) < min_required:
                errors.append(f'INCOMPLETE_SHABDARTHA: Block #{b_idx} has only {len(blk_bullets)} bullets for {len(sh_words)} shloka words (minimum {min_required})')
    
    # ----------------------------------------------------------
    # CHECK 6: Boilerplate filler in Bhavartha
    # ----------------------------------------------------------
    for pat in BOILERPLATE_PATTERNS:
        if pat in content:
            errors.append(f'BOILERPLATE: Found banned filler: "{pat[:50]}..."')
    
    # ----------------------------------------------------------
    # CHECK 7: English words
    # ----------------------------------------------------------
    # Skip the first line (page marker) and image lines
    for i, line in enumerate(lines):
        if line.startswith('[ಚಿತ್ರ:') or line.startswith('[ಪುಟ:'):
            continue
        if '/' in line and 'assets/' in line:
            continue
        for pat in ENGLISH_WORDS:
            matches = re.findall(pat, line, re.IGNORECASE)
            if matches:
                errors.append(f'ENGLISH_WORD: Line {i+1}: found "{matches[0]}" in: {line.strip()[:60]}...')
                break  # one per line is enough
    
    # ----------------------------------------------------------
    # CHECK 8: Devanagari characters (excluding dandas)
    # ----------------------------------------------------------
    for i, line in enumerate(lines):
        devnag = DEVANAGARI_RANGE.findall(line)
        if devnag:
            errors.append(f'DEVANAGARI: Line {i+1}: found Devanagari char(s): {"".join(devnag[:5])}')
    
    # ----------------------------------------------------------
    # CHECK 9: Markdown formatting
    # ----------------------------------------------------------
    if MARKDOWN_BOLD.search(content):
        errors.append('MARKDOWN_BOLD: Found **bold** markdown formatting')
    if MARKDOWN_ITALIC.search(content):
        errors.append('MARKDOWN_ITALIC: Found *italic* markdown formatting')
    if MARKDOWN_HEADING.search(content):
        errors.append('MARKDOWN_HEADING: Found # heading markdown formatting')
    
    # ----------------------------------------------------------
    # CHECK 10: Double separators
    # ----------------------------------------------------------
    double_sep = re.findall(r'----------------------------------------\s*\n\s*\n\s*----------------------------------------', content)
    if double_sep:
        errors.append(f'DOUBLE_SEPARATOR: Found {len(double_sep)} double separator(s)')
    
    # ----------------------------------------------------------
    # CHECK 11: Ellipsis
    # ----------------------------------------------------------
    if '...' in content or '\u2026' in content:  # \u2026 = …
        errors.append('ELLIPSIS: Found "..." or "…" — may indicate skipped content')
    
    # ----------------------------------------------------------
    # CHECK 12: "ಇತ್ಯಾದಿ" or "ಮುಂತಾದ" used to skip content
    # ----------------------------------------------------------
    skip_phrases = ['ಇತ್ಯಾದಿ', 'ಮುಂತಾದ ಶಬ್ದಗಳು']
    for phrase in skip_phrases:
        in_shabdartha_ctx = False
        for i, line in enumerate(lines):
            if 'ಶಬ್ದಾರ್ಥ:' in line:
                in_shabdartha_ctx = True
            elif line.startswith('ಭಾವಾರ್ಥ:') or line.startswith('ವಿಶೇಷ ವಿವರಣೆ') or line == SEPARATOR:
                in_shabdartha_ctx = False
            if in_shabdartha_ctx and phrase in line:
                errors.append(f'SKIP_PHRASE: Line {i+1}: "{phrase}" in Shabdartha — all words must be listed')
    
    # ----------------------------------------------------------
    # CHECK 13: Bhavartha word count (minimum 100)
    # ----------------------------------------------------------
    if is_shloka_page:
        bhavartha_sections = re.split(r'ಭಾವಾರ್ಥ:', content)
        for idx in range(1, len(bhavartha_sections)):
            section = bhavartha_sections[idx]
            # Find end of bhavartha (next section header or separator)
            end_match = re.search(r'(ಶಬ್ದಾರ್ಥ:|ವಿಶೇಷ ವಿವರಣೆ|\n\s*ಶ್ಲೋಕ|----------------------------------------)', section)
            if end_match:
                section = section[:end_match.start()]
            words = section.split()
            if len(words) < 100:
                errors.append(f'SHORT_BHAVARTHA: Bhavartha #{idx} has only {len(words)} words (minimum 100)')
    
    # ----------------------------------------------------------
    # CHECK 14: Missing Vyakhyana on shloka page (warning only)
    # ----------------------------------------------------------
    # This is a warning, not an error, since some pages may not have commentary
    
    # ----------------------------------------------------------
    # CHECK 15: Section order — NEW: Shloka → Bhavartha → Shabdartha
    # ----------------------------------------------------------
    if is_shloka_page:
        positions = {}
        for i, line in enumerate(lines):
            if re.match(r'ಶ್ಲೋಕ\s*[\d\u0ce6-\u0cef]+(?:[-–][\d\u0ce6-\u0cef]+)?:', line) and 'shloka' not in positions:
                positions['shloka'] = i
            elif 'ಶ್ಲೋಕ:' in line and 'shloka' not in positions:
                positions['shloka'] = i
            if 'ಭಾವಾರ್ಥ:' in line and 'bhavartha' not in positions:
                positions['bhavartha'] = i
            if 'ಶಬ್ದಾರ್ಥ:' in line and 'shabdartha' not in positions:
                positions['shabdartha'] = i
        
        # Shloka must come before Bhavartha
        if 'shloka' in positions and 'bhavartha' in positions:
            if positions['bhavartha'] < positions['shloka']:
                errors.append('ORDER_ERROR: Bhavartha appears before Shloka')
        
        # Bhavartha must come before Shabdartha (NEW ORDER)
        if 'bhavartha' in positions and 'shabdartha' in positions:
            if positions['shabdartha'] < positions['bhavartha']:
                errors.append('ORDER_ERROR: Shabdartha appears before Bhavartha (Bhavartha must come first)')
    
    passed = len(errors) == 0
    return passed, errors


def validate_directory(dirpath):
    """Validate all page_*.txt files in a directory."""
    pattern = os.path.join(dirpath, 'page_*.txt')
    files = sorted(glob.glob(pattern))
    
    if not files:
        print(f'No page_*.txt files found in {dirpath}')
        return
    
    total = len(files)
    passed_count = 0
    failed_count = 0
    all_errors = {}
    error_summary = {}
    
    for filepath in files:
        passed, errors = validate_page(filepath)
        fname = os.path.basename(filepath)
        if passed:
            passed_count += 1
        else:
            failed_count += 1
            all_errors[fname] = errors
            for e in errors:
                etype = e.split(':')[0]
                error_summary[etype] = error_summary.get(etype, 0) + 1
    
    # Print results
    print(f'\n{"="*60}')
    print(f'VALIDATION REPORT')
    print(f'{"="*60}')
    print(f'Directory: {dirpath}')
    print(f'Files checked: {total}')
    print(f'PASSED: {passed_count}')
    print(f'FAILED: {failed_count}')
    
    if error_summary:
        print(f'\n{"─"*60}')
        print(f'ERROR SUMMARY BY TYPE:')
        print(f'{"─"*60}')
        for etype, count in sorted(error_summary.items(), key=lambda x: -x[1]):
            print(f'  {etype}: {count}')
    
    if all_errors:
        print(f'\n{"─"*60}')
        print(f'DETAILS BY FILE:')
        print(f'{"─"*60}')
        for fname, errors in sorted(all_errors.items()):
            print(f'\n  {fname}:')
            for e in errors:
                print(f'    - {e}')
    
    print(f'\n{"="*60}')
    if failed_count == 0:
        print('ALL FILES PASSED')
    else:
        print(f'{failed_count}/{total} FILES HAVE ERRORS')
    print(f'{"="*60}\n')
    
    return failed_count == 0


def main():
    parser = argparse.ArgumentParser(description='Validate transcription page files')
    parser.add_argument('file', nargs='?', help='Single file to validate')
    parser.add_argument('--dir', help='Directory to validate all page_*.txt files')
    args = parser.parse_args()
    
    if args.dir:
        success = validate_directory(args.dir)
        sys.exit(0 if success else 1)
    elif args.file:
        passed, errors = validate_page(args.file)
        if passed:
            print(f'PASSED: {args.file}')
        else:
            print(f'FAILED: {args.file}')
            for e in errors:
                print(f'  - {e}')
        sys.exit(0 if passed else 1)
    else:
        parser.print_help()
        sys.exit(1)


if __name__ == '__main__':
    main()
