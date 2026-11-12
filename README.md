# Linux perf IO regression

Ten zestaw uruchamia kompilację i test na serwerze GitHub Actions. Nie wymaga lokalnej instalacji WSL ani Ubuntu. Został przygotowany do publicznego repozytorium i standardowego runnera ubuntu-24.04. Workflow pomija prywatne repozytoria.

## Uruchomienie

Umieść wszystkie pliki z tego katalogu w publicznym repozytorium GitHub. Zachowaj ścieżkę `.github/workflows/perf-io.yml`. Na domyślnej gałęzi wybierz Actions → Linux perf IO regression → Run workflow.

Test pobierze źródła Linuxa dla konkretnego commita, doda testy regresji i zbuduje perf. Najpierw potwierdzi błąd w oryginalnej funkcji, następnie zastosuje poprawkę i ponownie zbuduje narzędzie. Wyniki zostaną sprawdzone w plikach JUnit XML; samo zakończenie polecenia perf kodem 0 nie wystarcza. Logi będą dostępne przez jeden dzień.

## Zakres

Test dotyczy biblioteki odczytu używanej przez perf. Nie buduje jądra i nie uruchamia pełnego zestawu testów perf. Opcjonalne funkcje BPF oraz generowanie bazy zdarzeń PMU są wyłączone w kompilacji.

Baza: 9d66f26fefacebfeed15de31c1123451a17ff119.

Autor lokalnej poprawki: Wojciech Szpucha <szpuszi@gmail.com>.

Poprawka i testy zostały przygotowane z pomocą Codex. Patch pozostaje bez Signed-off-by i nie został wysłany do opiekunów Linuxa. Po uruchomieniu workflow jego wynik trzeba ocenić przed dodaniem osobistego poświadczenia DCO i ewentualnym wysłaniem patcha.

Wyniki uruchomień są dostępne w zakładce Actions tego repozytorium.

Standardowe runnery GitHub Actions w publicznych repozytoriach są bezpłatne: https://docs.github.com/en/billing/concepts/product-billing/github-actions
