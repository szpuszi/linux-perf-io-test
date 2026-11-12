# Linux perf IO regression

Wynik natywnego testu: **sukces**.

[Uruchomienie i logi](https://github.com/szpuszi/linux-perf-io-test/actions/runs/43257707229)

| Sprawdzenie | Przed poprawką | Po poprawce |
|---|---|---|
| Samodzielna libapi: odczyt pliku UTF-8 i 0xff | 0 z 4 bajtów | 4 z 4 bajtów |
| Test API IO z signed char | Oczekiwany błąd | Sukces |
| Kompilacja perf i libapi | Sukces | Sukces |

Domyślna kompilacja perf używa -funsigned-char i już unika problemu. Błąd został potwierdzony w samodzielnej libapi z domyślnymi flagami na x86_64. Test regresji ma własne -fsigned-char, żeby globalna flaga perf nie ukrywała błędu.

## Uruchomienie

Workflow działa ręcznie przez Actions → Linux perf IO regression → Run workflow. Wykonuje kompilację i test na serwerze GitHuba. Nie wymaga lokalnej instalacji WSL ani Ubuntu. Jest przeznaczony do publicznego repozytorium i standardowego runnera ubuntu-24.04; prywatne repozytoria są pomijane.

Test pobiera źródła konkretnego commita. Najpierw potwierdza błąd rzeczywistego odczytu przez filename__read_str() w samodzielnej libapi, a następnie sprawdza nowy test regresji w perf. Po zastosowaniu poprawki obie ścieżki muszą działać poprawnie. Wynik perf jest sprawdzany w plikach JUnit XML, ponieważ samo zakończenie polecenia kodem 0 nie wystarcza. Logi jako artefakt są dostępne przez jeden dzień.

## Zakres

Ubuntu 24.04 x86_64, GCC 13.3.0. Test dotyczy biblioteki odczytu. Nie buduje jądra i nie uruchamia pełnego zestawu testów perf. Opcjonalne BPF i generowanie bazy zdarzeń PMU są wyłączone w kompilacji.

Baza: 9d66f26fefacebfeed15de31c1123451a17ff119.

Autor lokalnej poprawki: Wojciech Szpucha <szpuszi@gmail.com>.

Poprawka i testy zostały przygotowane z pomocą Codex. Patch pozostaje bez Signed-off-by i nie został wysłany do opiekunów Linuxa. Przed ewentualnym wysłaniem potrzebny jest przegląd autora i osobiste poświadczenie DCO.

Standardowe runnery GitHub Actions w publicznych repozytoriach są [bezpłatne](https://docs.github.com/en/billing/concepts/product-billing/github-actions).
