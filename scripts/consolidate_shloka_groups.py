import re
import os

kannada_to_ascii = str.maketrans('೦೧೨೩೪೫೬೭೮೯', '0123456789')
ascii_to_kannada = str.maketrans('0123456789', '೦೧೨೩೪೫೬೭೮೯')

def to_int(s):
    if not s:
        return None
    try:
        return int(str(s).translate(kannada_to_ascii).strip())
    except:
        return None

def to_kan(n):
    return str(n).translate(ascii_to_kannada)

def clean_anuvada_text(text):
    if not text:
        return ""
    # Remove leading 'ಅನುವಾದ:' or 'ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:' if present
    text = re.sub(r'^(?:ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:\s*)?(?:ಅನುವಾದ:\s*)?', '', text.strip()).strip()
    
    # Split by page continuation markers
    parts = re.split(r'\[ಪುಟ:\s*[0-9\u0ce6-\u0cef]+\]\s*(?:ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:\s*)?(?:ಅನುವಾದ:\s*)?(?:\(ಹಿಂದಿನ ಪುಟದ ಮುಂದುವರಿಕೆ\)\s*)?', text)
    if len(parts) == 1:
        return parts[0].strip()
    
    cleaned = parts[0].strip()
    for p in parts[1:]:
        p = p.strip()
        if not p:
            continue
        overlap_found = False
        # look for any prefix of p in cleaned to deduplicate overlaps
        for l in range(min(len(p), 200), 20, -1):
            target = p[:l]
            idx = cleaned.rfind(target)
            if idx != -1:
                cleaned = cleaned[:idx] + p
                overlap_found = True
                break
        if not overlap_found:
            cleaned = cleaned + ' ' + p
    return cleaned.strip()

def parse_single_block(raw_block):
    b = raw_block.strip()
    if not b:
        return None
    
    # Detect speaker
    m_speaker = re.search(r'^(?:\[ಪುಟ:[^\]]+\]\s*)?(ಶ್ರೀದೇವ್ಯುವಾಚ|ಶ್ರೀಶಿವ ಉವಾಚ|ಈಶ್ವರ ಉವಾಚ|ಶ್ರೀವಿಷ್ಣುರುವಾಚ|ಶ್ರೀಭೈರವ ಉವಾಚ)', b, re.MULTILINE)
    speaker = m_speaker.group(1).strip() if m_speaker else None
    
    # Detect shloka header
    m_shloka = re.search(r'ಶ್ಲೋಕ\s*([0-9\u0ce6-\u0cef\-–\s]+):', b)
    shloka_header = m_shloka.group(1).strip() if m_shloka else None
    
    # Detect sanskrit
    sanskrit = ""
    if m_shloka and 'ಭಾವಾರ್ಥ:' in b:
        start = m_shloka.end()
        end = b.find('ಭಾವಾರ್ಥ:')
        sanskrit = b[start:end].strip()
        if speaker and sanskrit.startswith(speaker):
            sanskrit = sanskrit[len(speaker):].strip()
    elif m_shloka and 'ಶಬ್ದಾರ್ಥ:' in b:
        start = m_shloka.end()
        end = b.find('ಶಬ್ದಾರ್ಥ:')
        sanskrit = b[start:end].strip()
        if speaker and sanskrit.startswith(speaker):
            sanskrit = sanskrit[len(speaker):].strip()
    elif m_shloka and 'ಅನುವಾದ:' in b:
        start = m_shloka.end()
        end = b.find('ಅನುವಾದ:')
        sanskrit = b[start:end].strip()
        if speaker and sanskrit.startswith(speaker):
            sanskrit = sanskrit[len(speaker):].strip()
            
    # Clean sanskrit from page markers
    sanskrit = re.sub(r'\[ಪುಟ:\s*[0-9\u0ce6-\u0cef]+\]', '', sanskrit).strip()
    
    # Detect bhavartha
    bhavartha = ""
    if 'ಭಾವಾರ್ಥ:' in b:
        start = b.find('ಭಾವಾರ್ಥ:') + len('ಭಾವಾರ್ಥ:')
        end = b.find('ಶಬ್ದಾರ್ಥ:') if 'ಶಬ್ದಾರ್ಥ:' in b else (b.find('ವಿಶೇಷ ವಿವರಣೆ') if 'ವಿಶೇಷ ವಿವರಣೆ' in b else (b.find('ಅನುವಾದ:') if 'ಅನುವಾದ:' in b else len(b)))
        bhavartha = b[start:end].strip()
        # Clean page markers from bhavartha
        bhavartha = re.sub(r'\[ಪುಟ:\s*[0-9\u0ce6-\u0cef]+\]', '', bhavartha).strip()
        
    # Detect shabdartha
    shabdartha = []
    if 'ಶಬ್ದಾರ್ಥ:' in b:
        start = b.find('ಶಬ್ದಾರ್ಥ:') + len('ಶಬ್ದಾರ್ಥ:')
        end = b.find('ವಿಶೇಷ ವಿವರಣೆ') if 'ವಿಶೇಷ ವಿವರಣೆ' in b else (b.find('ಅನುವಾದ:') if 'ಅನುವಾದ:' in b else len(b))
        shab_text = b[start:end].strip()
        for line in shab_text.split('\n'):
            line = line.strip()
            if line.startswith('•'):
                shabdartha.append(line)
            elif line.startswith('- '):
                shabdartha.append('• ' + line[2:].strip())
                
    # Detect anuvada
    anuvada = ""
    has_anu = 'ಅನುವಾದ:' in b
    if has_anu:
        start = b.find('ಅನುವಾದ:') + len('ಅನುವಾದ:')
        anuvada = b[start:].strip()
        
    # Extract shloka range from Anuvada
    anu_range = None
    if has_anu:
        m_range = re.findall(r'॥\s*([0-9\u0ce6-\u0cef]+)\s*[-–]\s*([0-9\u0ce6-\u0cef]+)\s*॥', anuvada)
        if m_range:
            anu_range = (to_int(m_range[-1][0]), to_int(m_range[-1][1]))
        else:
            m_s = re.findall(r'॥\s*([0-9\u0ce6-\u0cef]+)\s*॥', anuvada)
            if m_s:
                v = to_int(m_s[-1])
                anu_range = (v, v)
                
    return {
        'speaker': speaker,
        'shloka_header': shloka_header,
        'sanskrit': sanskrit,
        'bhavartha': bhavartha,
        'shabdartha': shabdartha,
        'anuvada': anuvada,
        'has_anu': has_anu,
        'anu_range': anu_range,
        'raw': b
    }

def merge_group(group_blocks):
    # Multiple blocks or single block
    speaker = None
    sanskrit_parts = []
    bhavartha_parts = []
    all_shabdartha = []
    anuvada_parts = []
    shloka_nums = []
    
    for pb in group_blocks:
        if pb['speaker'] and not speaker:
            speaker = pb['speaker']
            
        if pb['shloka_header']:
            header = pb['shloka_header']
            if '-' in header or '–' in header:
                hp = re.split(r'[-–]', header)
                s_int, e_int = to_int(hp[0]), to_int(hp[1])
                if s_int: shloka_nums.append(s_int)
                if e_int: shloka_nums.append(e_int)
            else:
                val = to_int(header)
                if val: shloka_nums.append(val)
                
        if pb['sanskrit']:
            sanskrit_parts.append(pb['sanskrit'])
            
        if pb['bhavartha']:
            bhavartha_parts.append(pb['bhavartha'])
            
        for item in pb['shabdartha']:
            if item not in all_shabdartha:
                all_shabdartha.append(item)
                
        if pb['has_anu'] and pb['anuvada']:
            anuvada_parts.append(pb['anuvada'])

    combined_sanskrit = '\n'.join(sanskrit_parts).strip()
    
    # Extract actual verse numbers from Sanskrit text
    verse_nums = [to_int(x) for x in re.findall(r'॥\s*([0-9\u0ce6-\u0cef]+)\s*॥', combined_sanskrit) if to_int(x) is not None]

    # Look at anu_range of the last block with Anuvada as fallback
    last_anu_range = None
    for pb in reversed(group_blocks):
        if pb['has_anu'] and pb['anu_range']:
            last_anu_range = pb['anu_range']
            break

    if verse_nums:
        start_shloka = min(verse_nums)
        end_shloka = max(verse_nums)
    elif shloka_nums:
        start_shloka = min(shloka_nums)
        end_shloka = max(shloka_nums)
    elif last_anu_range and last_anu_range[0] and last_anu_range[1]:
        start_shloka = last_anu_range[0]
        end_shloka = last_anu_range[1]
    else:
        start_shloka, end_shloka = 1, 1

    if start_shloka == end_shloka:
        header_str = f"ಶ್ಲೋಕ {to_kan(start_shloka)}:"
    else:
        header_str = f"ಶ್ಲೋಕ {to_kan(start_shloka)}-{to_kan(end_shloka)}:"
        
    speaker_prefix = (speaker + '\n\n') if speaker else ""
    
    # Combined bhavartha
    combined_bhavartha = '\n\n'.join(bhavartha_parts).strip()
    
    # Combined shabdartha
    combined_shabdartha = '\n'.join(all_shabdartha).strip()
    
    # Combined Anuvada
    raw_anu = '\n\n'.join(anuvada_parts)
    combined_anuvada = clean_anuvada_text(raw_anu)
    
    # Make sure Anuvada ends with ॥ range ॥
    range_marker = f"॥ {to_kan(start_shloka)}-{to_kan(end_shloka)} ॥" if start_shloka != end_shloka else f"॥ {to_kan(start_shloka)} ॥"
    if not re.search(r'॥\s*[0-9\u0ce6-\u0cef\-–\s]+\s*॥\s*$', combined_anuvada):
        # append range marker if missing at end
        combined_anuvada = f"{combined_anuvada} {range_marker}"
        
    result_parts = [f"{speaker_prefix}{header_str}\n{combined_sanskrit}"]
    if combined_bhavartha:
        result_parts.append(f"ಭಾವಾರ್ಥ:\n{combined_bhavartha}")
    if combined_shabdartha:
        result_parts.append(f"ಶಬ್ದಾರ್ಥ:\n{combined_shabdartha}")
    if combined_anuvada:
        result_parts.append(f"ಅನುವಾದ:\n{combined_anuvada}")
        
    return '\n\n'.join(result_parts)

def normalize_content_separators(content):
    # Ensure separator before new page shloka if not present
    normalized = re.sub(
        r'([^\-\n][^\n]*\n+)(\[ಪುಟ:\s*[0-9\u0ce6-\u0cef]+\]\s*(?:(?:ಶ್ರೀ[^\n]+ಉವಾಚ|ಈಶ್ವರ ಉವಾಚ|ಶ್ರೀವಿಷ್ಣುರುವಾಚ|ಶ್ರೀಭೈರವ ಉವಾಚ)\s*\n\s*)?ಶ್ಲೋಕ\s*[0-9\u0ce6-\u0cef\-–\s]+:)',
        r'\1----------------------------------------\n\n\2',
        content
    )
    return normalized

def consolidate_chapter_text(content):
    content = normalize_content_separators(content)
    blocks = content.split('----------------------------------------')
    
    # Identify preamble (everything before the first shloka block)
    preamble = ""
    first_shloka_idx = 0
    for idx, b in enumerate(blocks):
        if 'ಶ್ಲೋಕ' in b:
            first_shloka_idx = idx
            break
            
    if first_shloka_idx > 0:
        preamble = '----------------------------------------'.join(blocks[:first_shloka_idx]).strip()
    elif 'ಶ್ಲೋಕ' not in blocks[0]:
        preamble = blocks[0].strip()
        first_shloka_idx = 1
    else:
        # Check if block 0 has preamble lines before 'ಶ್ಲೋಕ'
        m = re.search(r'ಶ್ಲೋಕ', blocks[0])
        if m:
            preamble = blocks[0][:m.start()].strip()
            blocks[0] = blocks[0][m.start():]
            first_shloka_idx = 0

    # Parse all blocks from first_shloka_idx onwards
    parsed_blocks = []
    for b in blocks[first_shloka_idx:]:
        pb = parse_single_block(b)
        if pb:
            parsed_blocks.append(pb)
            
    # Group contiguous blocks
    # A group can only close if:
    # 1. current_acc contains at least one block with sanskrit
    # 2. current block has Anuvada (has_anu == True)
    # 3. the NEXT block has sanskrit (or there is no next block), meaning next block is NOT a continuation
    groups = []
    current_acc = []
    
    for idx, pb in enumerate(parsed_blocks):
        current_acc.append(pb)
        
        has_sanskrit = any(b['sanskrit'] for b in current_acc)
        next_has_sanskrit = (idx + 1 < len(parsed_blocks) and bool(parsed_blocks[idx + 1]['sanskrit']))
        is_last = (idx + 1 == len(parsed_blocks))
        
        if has_sanskrit and pb['has_anu'] and (next_has_sanskrit or is_last):
            groups.append(list(current_acc))
            current_acc = []
            
    if current_acc:
        # If there are leftovers, append to the last group if it has no sanskrit, or add as new group
        has_sanskrit = any(b['sanskrit'] for b in current_acc)
        if not has_sanskrit and groups:
            groups[-1].extend(current_acc)
        else:
            groups.append(list(current_acc))
        
    # Merge each group
    consolidated_blocks = []
    for g in groups:
        c_block = merge_group(g)
        consolidated_blocks.append(c_block)
        
    # Reassemble chapter
    sep = "\n\n----------------------------------------\n\n"
    final_output = ""
    if preamble:
        final_output = preamble + sep
    final_output += sep.join(consolidated_blocks) + "\n"
    
    return final_output, len(blocks), len(consolidated_blocks)

if __name__ == '__main__':
    import sys
    prakashas = [9, 10, 11, 12, 13, 14]
    if len(sys.argv) > 1:
        prakashas = [int(x) for x in sys.argv[1:]]
        
    for p in prakashas:
        path = f'assets/data/chapters/grantha_meru_tantram_vol2_prakasha_{p}.txt'
        if not os.path.exists(path):
            print(f'File not found: {path}')
            continue
        print(f'Processing Prakasha {p} ({path})...')
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        out_text, orig_len, cons_len = consolidate_chapter_text(content)
        with open(path, 'w', encoding='utf-8') as f:
            f.write(out_text)
            
        print(f'Done Prakasha {p}: {orig_len} original blocks -> {cons_len} consolidated blocks')
