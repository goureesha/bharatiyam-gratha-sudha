import os
import json
import sys

# Configure stdout to use UTF-8
sys.stdout.reconfigure(encoding='utf-8')

data_file = r"d:\bharatheeyam books\assets\data\scriptures_data.json"
backup_file = r"d:\bharatheeyam books\assets\data\scriptures_data.json.bak"
log_file = r"C:\Users\goure\.gemini\antigravity\brain\9dd96f49-1b5d-49be-9d15-005bfbd79edd\scratch\cleanup_report.txt"

footer_keywords = [
    'ಸನ್ಸ್ಕ್ರಿತ್', 'sanskrit', 'cheerful', 'chihla', 'dhocuments', 'documents', 'ಓರ್ಗ್', 'org', 'cಓಂ', 'com', 
    'ಚೀರ್ಫುಲ್', 'ಚೀರ್ಫ಼ುಲ್', 'ದೋತ್', 'ಗ್ಮೈಲ್', 'gmail', 'gopal', 'upadhyay', 'ಗೋಪಲ್', 'ಉಪಧ್ಯಯ್',
    'ಳಸ್ತ್ ಉಪ್ದತೇದ್', 'pಲೇಅಸೇ', 'please', 'ಸೇಂದ್', 'send', 'cಓರ್ರೇc', 'corrections',
    'ಎನ್cಓ', 'ಪ್ರೂಫ಼', 'cಓಂತಿ', 'ಎದಿತೇ', 'ಅವೈಲ', 'ಅರ್ಚಿವೇ', 'ಹ್ತ್ತ್ಪ್', 'http'
]

def clean_content(content):
    if not content:
        return "", [], []
        
    lines = content.split('\n')
    
    # 1. Clean headers (lines at the top starting with # or = or empty)
    header_lines = []
    content_start_idx = 0
    for i, line in enumerate(lines):
        stripped = line.strip()
        if not stripped:
            header_lines.append(line)
            continue
        if stripped.startswith('#') or stripped.startswith('='):
            header_lines.append(line)
        else:
            content_start_idx = i
            break
            
    # If all lines are headers
    if content_start_idx >= len(lines):
        return "", [l for l in header_lines if l.strip()], []

    # 2. Clean footers (lines from the bottom matching keywords or empty)
    footer_lines = []
    content_end_idx = len(lines)
    for i in range(len(lines) - 1, content_start_idx - 1, -1):
        line = lines[i]
        stripped = line.strip()
        if not stripped:
            footer_lines.append(line)
            continue
            
        stripped_lower = stripped.lower()
        is_metadata = False
        for kw in footer_keywords:
            if kw in stripped_lower:
                is_metadata = True
                break
                
        if is_metadata:
            footer_lines.append(line)
        else:
            content_end_idx = i + 1
            break
            
    headers_removed = [l for l in header_lines if l.strip()]
    footers_removed = [l for l in reversed(footer_lines) if l.strip()]
    
    cleaned_lines = lines[content_start_idx:content_end_idx]
    cleaned_content = '\n'.join(cleaned_lines)
    
    return cleaned_content, headers_removed, footers_removed

def main():
    print(f"Loading {data_file}...")
    if not os.path.exists(data_file):
        print(f"Error: {data_file} not found!")
        return
        
    with open(data_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    # Create a backup first
    print(f"Creating backup at {backup_file}...")
    with open(backup_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        
    report = []
    modified_books_count = 0
    modified_chapters_count = 0
    
    def process_content_field(item, is_chapter=False, parent_title=None):
        nonlocal modified_books_count, modified_chapters_count
        content = item.get("content", "")
        if not content:
            return
            
        cleaned, headers, footers = clean_content(content)
        if headers or footers:
            item["content"] = cleaned
            if is_chapter:
                modified_chapters_count += 1
                desc = f"Chapter: {item.get('title')} ({item.get('id')}) of Book: {parent_title}"
            else:
                modified_books_count += 1
                desc = f"Book: {item.get('title')} ({item.get('id')})"
                
            report.append(f"Cleaned {desc}:")
            if headers:
                report.append("  Headers removed:")
                for h in headers:
                    report.append(f"    {h!r}")
            if footers:
                report.append("  Footers removed:")
                for f_line in footers:
                    report.append(f"    {f_line!r}")
            report.append("-" * 60)

    # Process all books and chapters
    for item in data:
        if "content" in item:
            process_content_field(item)
        if "chapters" in item and isinstance(item["chapters"], list):
            for ch in item["chapters"]:
                process_content_field(ch, is_chapter=True, parent_title=item.get("title"))

    # Write cleaned data back to the file
    print(f"Saving cleaned data to {data_file}...")
    with open(data_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        
    # Write report
    report_text = f"CLEANUP REPORT\n"
    report_text += f"Total books cleaned: {modified_books_count}\n"
    report_text += f"Total chapters cleaned: {modified_chapters_count}\n"
    report_text += "="*60 + "\n"
    report_text += "\n".join(report)
    
    with open(log_file, 'w', encoding='utf-8') as f:
        f.write(report_text)
        
    print(f"Cleanup finished! Report written to {log_file}")
    print(f"Modified: {modified_books_count} books, {modified_chapters_count} chapters.")

if __name__ == "__main__":
    main()
