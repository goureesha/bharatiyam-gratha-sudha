import json
import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

output_path = r'C:\Users\goure\.gemini\antigravity\brain\fcebfe0c-6765-4c98-b670-f333b885c095\scratch\translated_shiva_vayaviya_ch23_24_batch_1.json'

with open(output_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

print(f"Total translated items: {len(data)}")

allowed_pattern = re.compile(r'^[ \u0C80-\u0CFF0-9.,;:!?()\-"\'•/\\।॥\u200c\u200d\n\r]*$')

all_valid = True
for idx, item in enumerate(data):
    s_ok = allowed_pattern.match(item['shabdartha']) is not None
    b_ok = allowed_pattern.match(item['bhavartha']) is not None
    eq_free = ('=' not in item['shabdartha']) and ('=' not in item['bhavartha'])
    
    if not (s_ok and b_ok and eq_free):
        print(f"Item {idx} failed: s_ok={s_ok}, b_ok={b_ok}, eq_free={eq_free}")
        all_valid = False

if all_valid:
    print("ALL 27 ITEMS ARE PERFECTLY VALIDATED AND CLEAN!")
