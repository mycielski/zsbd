##### Tomasz Mycielski

# Zaawansowane systemy baz danych -- projekt

## Case study: Firma transportowa Eltrans

Eltrans to prężnie działająca firma transportowa, operująca zarówno na rynku krajowym, jak i międzynarodowym. Firma dysponuje zróżnicowaną flotą liczącą około 300 pojazdów, z czego większość stanowią tiry, uzupełnione o samochody osobowe i vany. Eltrans zatrudnia kilkuset pracowników, w większości kierowców, lecz także personel administracyjny, mechaników oraz specjalistów ds. logistyki.

Głównym wyzwaniem dla Eltrans jest efektywne zarządzanie zróżnicowaną flotą pojazdów i licznym personelem. Firma potrzebuje narzędzia do monitorowania wydajności, optymalizacji tras, kontroli kosztów oraz wykrywania nadużyć (fraudów). Dodatkowo, Eltrans chce wzmocnić swoje możliwości analityczne, aby podejmować trafniejsze decyzje biznesowe oparte na danych.

Baza danych, która ma usprawnić działanie firmy, będzie centralnym punktem gromadzenia i analizy informacji o pracownikach, pojazdach (z uwzględnieniem ich typów), trasach i historycznym stanie pojazdów podczas całego cyklu ich eksploatacji. Dzięki niej, Eltrans będzie w stanie:
- Analizować pracę kierowców
- Monitorować wykorzystanie pojazdów
- Analizować opłacalność poszczególnych tras i zleceń, z uwzględnieniem specyfiki różnych typów pojazdów
- Generować raporty i analizy wspierające podejmowanie decyzji strategicznych
- Wykrywać nadużycia, których dopuszczają się pracownicy firmy

Wdrożenie tego systemu pozwoli Eltrans na zwiększenie efektywności operacyjnej, redukcję kosztów oraz poprawę jakości świadczonych usług. To z kolei przełoży się na wzmocnienie pozycji firmy na konkurencyjnym rynku transportowym, umożliwiając jej lepsze wykorzystanie zróżnicowanej floty pojazdów i efektywniejsze zarządzanie zasobami ludzkimi, oraz oczywiście zwiększenie zysków.

## RDBMS

Na potrzeby tego projektu do zarządzania relacyjną bazą danych wykorzystany zostanie system **PostgreSQL**. Używałem tego systemu już wcześniej i nie miałem z nim problemu. Postgres ma ogromną społeczność, więc nawet jeśli napotkam jakiś problem, to na pewno szybko znajdę jego rozwiązanie w internecie. Korzystanie z Postgresa jest darmowe (open source), a instalacja jest dziecinnie prosta. Korzystam z `helm` ([chart od Bitnami](https://bitnami.com/stack/postgresql/helm)) do utworzenia instancji Postgresa na moim lokalnym klastrze `minikube`.

Screenshoty z działającego Postgresa:

![Działająca instancja Postgres](case_study/psql.png)
![Pod z Postgresem](case_study/postgres_pod.png)

## Projekt bazy danych

### ERD

[![](https://mermaid.ink/img/pako:eNp9ksGOgyAQhl-FzLl9AW-mkqxJ291otycvs4rVVMQAtjHquy9IWZs2WU7w55v55wdGyEXBIAAmoxovEnnWErNOSfzldmf6Ee_21MthvKeJO6Shl6MkPnv1QMP0O6EHejw5YRcmkW91jD4NtlqQWWy3YvJ9SUAy0HhlLbnXusrghZwmP85CFrK-_YO6qZ7An8Fib2O-tF5nKKXga4WN61GbyXIdDoqUQnr7Z8al9d0U6RrMGUHt2fV23itqpXqmVm8XhUyTua3xz70STbFAsAHOJMe6MC852hJjWjHOMljio7xabDYc9lqkQ5tDoGXPNiBFf6kgKLFR5tR3BWr2-AkPdf4Fgmqj0g?type=png)](https://mermaid.live/edit#pako:eNp9ksGOgyAQhl-FzLl9AW-mkqxJ291otycvs4rVVMQAtjHquy9IWZs2WU7w55v55wdGyEXBIAAmoxovEnnWErNOSfzldmf6Ee_21MthvKeJO6Shl6MkPnv1QMP0O6EHejw5YRcmkW91jD4NtlqQWWy3YvJ9SUAy0HhlLbnXusrghZwmP85CFrK-_YO6qZ7An8Fib2O-tF5nKKXga4WN61GbyXIdDoqUQnr7Z8al9d0U6RrMGUHt2fV23itqpXqmVm8XhUyTua3xz70STbFAsAHOJMe6MC852hJjWjHOMljio7xabDYc9lqkQ5tDoGXPNiBFf6kgKLFR5tR3BWr2-AkPdf4Fgmqj0g)

### Schemat logiczny

[![](case_study/baza-erd.png)
