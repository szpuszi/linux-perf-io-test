import sys
import xml.etree.ElementTree as ET

phase, filename, exit_status = sys.argv[1:]
if phase not in ('before', 'after'):
    raise SystemExit('Unknown test phase')
if int(exit_status) != 0:
    raise SystemExit(f'perf test harness exited with {exit_status}')
cases = ET.parse(filename).getroot().findall('.//testcase')
if len(cases) != 1:
    raise SystemExit(f'Expected one test case, found {len(cases)}')
case = cases[0]
if 'api io' not in (case.get('name', '') + ' ' + case.get('classname', '')).lower():
    raise SystemExit('The expected API IO test did not run')
if case.find('skipped') is not None or case.find('error') is not None:
    raise SystemExit('The API IO test was skipped or had an error')
failure = case.find('failure')
if phase == 'before':
    if failure is None:
        raise SystemExit('The original function unexpectedly passed')
    failure_text = ''.join(failure.itertext())
    if '-128 != 128' not in failure_text or '-1 != 255' not in failure_text:
        raise SystemExit('The failure does not demonstrate the expected byte conversion bug')
    print('PASS: the original function fails for high-bit bytes as expected')
else:
    if failure is not None:
        raise SystemExit('The fixed function still fails the regression test')
    print('PASS: the fixed function passes the regression test')
