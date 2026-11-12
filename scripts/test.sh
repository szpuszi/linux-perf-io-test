set -euo pipefail

ROOT="$(pwd)"
SOURCE="$ROOT/linux-source"
PATCH="$ROOT/perf-io.patch"
LOGS="$ROOT/logs"
BASE=9d66f26fefacebfeed15de31c1123451a17ff119

mkdir -p "$SOURCE" "$LOGS"
git -C "$SOURCE" init -q
git -C "$SOURCE" -c protocol.version=2 fetch --depth=1 https://github.com/torvalds/linux.git "$BASE"
git -C "$SOURCE" checkout --detach FETCH_HEAD
test "$(git -C "$SOURCE" rev-parse HEAD)" = "$BASE"
git -C "$SOURCE" -c protocol.version=2 fetch --depth=1 --filter=blob:none https://github.com/torvalds/linux.git e95770af4c4a280fab2080529d30452a7628d45d
git -C "$SOURCE" rev-parse HEAD > "$LOGS/base.txt"
sha256sum "$PATCH" > "$LOGS/patch-sha256.txt"
gcc --version > "$LOGS/compiler.txt"
uname -a > "$LOGS/platform.txt"
git -C "$SOURCE" apply --check "$PATCH"
(cd "$SOURCE"; perl scripts/checkpatch.pl --no-tree --no-signoff --strict "$PATCH") 2>&1 | tee "$LOGS/checkpatch.log"
git -C "$SOURCE" apply --include=tools/perf/tests/api-io.c "$PATCH"

make -C "$SOURCE/tools/perf" -j2 NO_JEVENTS=1 NO_LIBBPF=1 2>&1 | tee "$LOGS/build-before.log"
"$SOURCE/tools/perf/perf" test list "Test api io" 2>&1 | tee "$LOGS/test-list.log"
grep -q 'Test api io' "$LOGS/test-list.log"
set +e
"$SOURCE/tools/perf/perf" test -v --junit="$LOGS/before.xml" "Test api io" > "$LOGS/test-before.log" 2>&1
before_status=$?
set -e
cat "$LOGS/test-before.log"
python3 "$ROOT/scripts/check_results.py" before "$LOGS/before.xml" "$before_status"

git -C "$SOURCE" apply --include=tools/lib/api/io.h "$PATCH"
git -C "$SOURCE" diff --check
make -C "$SOURCE/tools/perf" -j2 NO_JEVENTS=1 NO_LIBBPF=1 2>&1 | tee "$LOGS/build-after.log"
set +e
"$SOURCE/tools/perf/perf" test -v --junit="$LOGS/after.xml" "Test api io" > "$LOGS/test-after.log" 2>&1
after_status=$?
set -e
cat "$LOGS/test-after.log"
python3 "$ROOT/scripts/check_results.py" after "$LOGS/after.xml" "$after_status"

printf '| Check | Result |\n|---|---|\n| Original function with regression tests | Expected failure confirmed |\n| Fixed function with regression tests | Passed |\n| checkpatch without DCO sign-off | Passed |\n\nBase: `%s`\n\nThe patch remains unsigned and has not been submitted upstream.\n' "$BASE" >> "$GITHUB_STEP_SUMMARY"
