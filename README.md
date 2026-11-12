# libapi I/O regression

Regression tests for high-bit bytes being mistaken for EOF when `char` is signed.

- Builds standalone `libapi` and `perf` on Ubuntu 24.04.
- Confirms the original code fails and the fix passes.
- Runs manually under **Actions → Linux perf IO regression → Run workflow**.

Default `perf` uses `-funsigned-char`; the regression covers standalone `libapi` and a signed-char test build.

[Passing test run](https://github.com/szpuszi/linux-perf-io-test/actions/runs/43257707229) · [Patch](perf-io.patch)

Patch metadata was updated after testing; the source changes are unchanged.
