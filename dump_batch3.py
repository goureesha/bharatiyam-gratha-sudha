import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

input_path = r'C:\Users\goure\.gemini\antigravity\brain\fcebfe0c-6765-4c98-b670-f333b885c095\scratch\shiva_kotirudra_ch19_20_batch_3.json'
with open(input_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

with open('batch3_out.txt', 'w', encoding='utf-8') as out:
    for i, item in enumerate(data):
        out.write(f"=== ITEM {i} (Chapter {item.get('chapter')}) ===\n")
        out.write(item['sanskrit'] + "\n\n")

print("Done dumping", len(data), "items.")
