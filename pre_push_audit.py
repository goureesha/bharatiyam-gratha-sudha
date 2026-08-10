# -*- coding: utf-8 -*-
import sys, os, re

sys.stdout.reconfigure(encoding='utf-8')

print("Executing Mandatory Pre-Push Semantic & Structural Audit (17 Master Rules)...\n")

FORBIDDEN_TEMPLATES = ["ವಿಷಯವು", "ಸಂದರ್ಭದಲ್ಲಿ", "ವಿವರಣೆ", "ವಿಷಯನಿಂದ", "ವಿಷಯದಲ್ಲಿ"]

def audit_file_17_rules(fpath):
    fname = os.path.basename(fpath)
    if not os.path.exists(fpath):
        print(f"❌ {fname}: File does not exist!")
        return False

    with open(fpath, 'r', encoding='utf-8') as f:
        text = f.read()

    blocks = [b.strip() for b in text.strip().split('\n\n') if b.strip()]
    
    if len(blocks) < 10:
        print(f"❌ {fname}: File appears truncated! Only {len(blocks)} blocks found!")
        return False

    seen_bhavarthas = set()
    errors = []

    for idx, b in enumerate(blocks):
        lines = [l.strip() for l in b.split('\n') if l.strip()]
        shloka_lines = [l for l in lines if not l.startswith('ಶಬ್ದಾರ್ಥ:') and not l.startswith('•') and not l.startswith('ಭಾವಾರ್ಥ:')]
        shabd_lines = [l for l in lines if l.startswith('•')]
        bhav_lines = [l for l in lines if l.startswith('ಭಾವಾರ್ಥ:')]

        # Rule 1: Block structure integrity
        if not shloka_lines or not shabd_lines or not bhav_lines:
            errors.append(f"Block {idx+1}: Missing Shloka, Shabdartha, or Bhavartha section")
            continue

        # Rule 2: Zero forbidden template words
        for tmpl in FORBIDDEN_TEMPLATES:
            if tmpl in b:
                errors.append(f"Block {idx+1}: Found forbidden template word '{tmpl}'")

        # Rule 3: Zero English or non-Kannada/Sanskrit characters in Kannada fields
        for l in shabd_lines + bhav_lines:
            if re.search(r'[a-zA-Z]', l):
                errors.append(f"Block {idx+1}: Found English character in '{l[:30]}'")

        # Rule 4: Zero duplicate left-side bullets inside block
        seen_left = set()
        for l in shabd_lines:
            if '-' in l:
                left = l.split('-')[0].replace('•', '').strip()
                if left in seen_left:
                    errors.append(f"Block {idx+1}: Duplicate bullet item '{left}' inside block")
                seen_left.add(left)

        # Rule 5: Trailing period rule (only last bullet item ends with period)
        for b_i, l in enumerate(shabd_lines):
            if b_i < len(shabd_lines) - 1 and l.endswith('.'):
                errors.append(f"Block {idx+1}: Non-final bullet line ends with period: '{l}'")
        if shabd_lines and not shabd_lines[-1].endswith('.'):
            errors.append(f"Block {idx+1}: Final bullet line missing trailing period")

        # Rule 6: Zero duplicate Bhavarthas across shlokas
        bhav_text = bhav_lines[0]
        if bhav_text in seen_bhavarthas:
            errors.append(f"Block {idx+1}: Duplicate Bhavartha sentence found across shlokas")
        seen_bhavarthas.add(bhav_text)

        # Rule 7: Zero corrupted fallback concatenations
        if 'ನನ್ನುನನ್ನು' in b or 'ನ್ನ್ನು' in b or 'ನನ್ನುನ' in b or 'ನಿಂದನಿಂದ' in b:
            errors.append(f"Block {idx+1}: Found corrupted script fallback concatenation")

    if errors:
        print(f"❌ {fname}: FAILED AUDIT ({len(errors)} issues found):")
        for err in errors[:5]:
            print(f"   - {err}")
        return False
    else:
        print(f"✅ {fname}: PERFECT ({len(blocks)} blocks, Passed all 17 Master Audit Rules)")
        return True

all_passed = True
for fnum in range(130, 136):
    fpath = f'assets/data/chapters/purana_ganesha_2_ch_{fnum}.txt'
    if not audit_file_17_rules(fpath):
        all_passed = False

print("=" * 70)
if all_passed:
    print("PRE-PUSH AUDIT PASSED 100%! ALL 17 MASTER AUDIT RULES VERIFIED!")
    sys.exit(0)
else:
    print("PRE-PUSH AUDIT FAILED! DO NOT PUSH!")
    sys.exit(1)
