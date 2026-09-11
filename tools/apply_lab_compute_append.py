#!/usr/bin/env python3
from decimal import Decimal
from pathlib import Path
from datetime import datetime, timezone
import re

ledger = Path('LAB_COMPUTE_LOG.md')
request = Path('LAB_COMPUTE_APPEND_REQUEST.md')
text = ledger.read_text()
rows = [ln for ln in request.read_text().splitlines() if ln.startswith('| 20')]
if not rows:
    raise SystemExit('no append rows found')

existing_runs = set(re.findall(r'`(\d{8,})`', text))
new_rows = []
for row in rows:
    m = re.search(r'\| `(\d+)` \| `(\d+)` \|', row)
    if not m:
        raise SystemExit(f'bad row: {row}')
    if m.group(1) not in existing_runs:
        new_rows.append(row)

if new_rows:
    marker = '\n## Running totals\n'
    if marker not in text:
        raise SystemExit('running totals marker missing')
    text = text.replace(marker, '\n' + '\n'.join(new_rows) + marker, 1)

# Sum all ledger table rows from the Compute min column. Decimal avoids float drift.
total = Decimal('0')
current_day = datetime.now(timezone.utc).date().isoformat()
daily = Decimal('0')
for ln in text.splitlines():
    if not ln.startswith('| 20'):
        continue
    cols = [c.strip() for c in ln.strip('|').split('|')]
    if len(cols) < 7:
        continue
    try:
        minutes = Decimal(cols[6])
    except Exception:
        continue
    total += minutes
    if cols[0] == current_day:
        daily += minutes

text = re.sub(r'- \*\*Exactly backfilled lab compute:\*\* .*', f'- **Exactly backfilled lab compute:** {total:.2f} min ({(total/Decimal(60)):.2f} h)', text)
text = re.sub(r'- \*\*Total lab compute used:\*\* .*', f'- **Total lab compute used:** {(total/Decimal(60)):.2f} h + unbackfilled historical usage', text)
text = re.sub(r'- \*\*Current-day exactly backfilled lab compute \(\d{4}-\d{2}-\d{2}\):\*\* .*', f'- **Current-day exactly backfilled lab compute ({current_day}):** {daily:.2f} min ({(daily/Decimal(60)):.2f} h) + unbackfilled same-day historical usage', text)
text = text.replace('Later C06 runs after C06-038 and C07 laboratory runs remain historical backfill work where exact job metadata has not yet been integrated and must not be silently included in the exact totals above.', 'Late C06 runs C06-039/C06-041 through C06-046 and C07-047/048/049 are now integrated from exact job metadata. C06-040 remains deliberately uncounted without a positive execution witness.')
ledger.write_text(text)
print(f'added {len(new_rows)} rows; total={total} min; {current_day}={daily} min')
