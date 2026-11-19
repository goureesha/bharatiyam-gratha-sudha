import json
import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

input_path = r'C:\Users\goure\.gemini\antigravity\brain\fcebfe0c-6765-4c98-b670-f333b885c095\scratch\shiva_vayaviya_ch23_24_batch_1.json'
output_path = r'C:\Users\goure\.gemini\antigravity\brain\fcebfe0c-6765-4c98-b670-f333b885c095\scratch\translated_shiva_vayaviya_ch23_24_batch_1.json'

with open(input_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

print(f"Total items: {len(data)}")
for idx, item in enumerate(data):
    print(f"--- ITEM {idx} (Chapter {item.get('chapter')}) ---")
    print(item['sanskrit'])
